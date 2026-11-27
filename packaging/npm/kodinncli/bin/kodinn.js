#!/usr/bin/env node
// Kodinn Agent (KodinnCli) launcher for npm.
// The binaries are large (one self-contained build per platform), so they are not inside this package: on the first
// run the build for this platform is downloaded from www.digitalsolutions.it, checked against the SHA-256 shipped
// in builds.json, unpacked into ~/.kodinncli/versions/<version>/ and run from there. Later runs start it directly.
"use strict";
const fs = require("fs");
const os = require("os");
const path = require("path");
const https = require("https");
const http = require("http");
const crypto = require("crypto");
const { spawnSync } = require("child_process");

const manifest = require(path.join(__dirname, "..", "builds.json"));
const key = `${process.platform}-${process.arch}`;
const build = manifest.builds[key];
if (!build) {
  console.error(`kodinncli: no build for ${key}. Available: ${Object.keys(manifest.builds).join(", ")}`);
  process.exit(1);
}

const home = process.env.KODINNCLI_HOME || path.join(os.homedir(), ".kodinncli");
const dir = path.join(home, "versions", manifest.version);
const exe = path.join(dir, build.folder, build.exe);

function download(url, file, redirects = 5) {
  return new Promise((resolve, reject) => {
    (url.startsWith("https:") ? https : http).get(url, { headers: { "User-Agent": "kodinncli-npm" } }, (res) => {
      if ([301, 302, 303, 307, 308].includes(res.statusCode) && res.headers.location && redirects > 0) {
        res.resume();
        return resolve(download(new URL(res.headers.location, url).toString(), file, redirects - 1));
      }
      if (res.statusCode !== 200) { res.resume(); return reject(new Error(`HTTP ${res.statusCode} for ${url}`)); }
      const total = Number(res.headers["content-length"]) || 0;
      let got = 0, shown = -1;
      const out = fs.createWriteStream(file);
      res.on("data", (chunk) => {
        got += chunk.length;
        if (total && process.stderr.isTTY) {
          const pct = Math.floor((got / total) * 100);
          if (pct !== shown) { shown = pct; process.stderr.write(`\rkodinncli: downloading ${manifest.version} for ${key}… ${pct}%`); }
        }
      });
      res.pipe(out);
      out.on("finish", () => { if (process.stderr.isTTY) process.stderr.write("\n"); out.close(resolve); });
      out.on("error", reject);
    }).on("error", reject);
  });
}

// FALLBACK: Node ships its own CA list, so behind a proxy that re-signs TLS ("self-signed certificate in certificate chain")
// it fails where the OS works. curl.exe / PowerShell use the system trust store. The SHA-256 is still verified afterwards.
function downloadWithSystemTool(url, file) {
  const attempts = [];
  if (process.platform === "win32") {
    const winCurl = path.join(process.env.SystemRoot || "C:\\Windows", "System32", "curl.exe");
    if (fs.existsSync(winCurl)) attempts.push([winCurl, ["-fL", "--retry", "2", "-o", file, url]]);
    attempts.push(["powershell", ["-NoProfile", "-Command",
      `$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -UseBasicParsing -Uri '${url}' -OutFile '${file.replace(/'/g, "''")}'`]]);
  } else {
    attempts.push(["curl", ["-fL", "--retry", "2", "-o", file, url]]);
    attempts.push(["wget", ["-O", file, url]]);
  }
  for (const [cmd, args] of attempts) {
    const r = spawnSync(cmd, args, { stdio: "inherit" });
    if (!r.error && r.status === 0 && fs.existsSync(file)) return true;
  }
  return false;
}

// Every place the same archive can come from, in order: the site, then the GitHub release of the public repository.
function sources() {
  const list = [build.url];
  const home_ = manifest.homepage || require(path.join(__dirname, "..", "package.json")).homepage || "";
  const m = /github\.com\/([^/]+\/[^/.]+)/.exec(home_);
  // The release tag was created by hand as "v.0.9.5" once; publish_all.sh uses "v0.9.7". Both are tried.
  if (m) for (const tag of [`v${manifest.version}`, `v.${manifest.version}`])
    list.push(`https://github.com/${m[1]}/releases/download/${tag}/${path.basename(new URL(build.url).pathname)}`);
  return list;
}

async function fetchArchive(archive) {
  const errors = [];
  for (const url of sources()) {
    try { await download(url, archive); if (sha256(archive) === build.sha256) return; fs.rmSync(archive, { force: true }); errors.push(`${url}: checksum mismatch`); continue; }
    catch (e) { errors.push(`${url}: ${e.message}`); }
    console.error(`kodinncli: ${errors[errors.length - 1]} — retrying with the system downloader`);
    fs.rmSync(archive, { force: true });
    if (downloadWithSystemTool(url, archive)) {
      if (sha256(archive) === build.sha256) return;
      fs.rmSync(archive, { force: true }); errors.push(`${url}: checksum mismatch`);
    }
  }
  throw new Error(errors.join("; "));
}

function sha256(file) {
  const h = crypto.createHash("sha256");
  h.update(fs.readFileSync(file));
  return h.digest("hex");
}

async function install() {
  fs.mkdirSync(dir, { recursive: true });
  const archive = path.join(dir, path.basename(new URL(build.url).pathname));
  console.error(`kodinncli: first run of ${manifest.version} — fetching the ${key} build from digitalsolutions.it`);
  await fetchArchive(archive);
  // WINDOWS: its own bsdtar (System32\tar.exe) opens .zip — a "tar" earlier on PATH is often Git's GNU tar, which
  // cannot, and reads "C:" as a remote host. PowerShell's Expand-Archive is the fallback.
  let ok = false;
  if (process.platform === "win32") {
    const winTar = path.join(process.env.SystemRoot || "C:\\Windows", "System32", "tar.exe");
    if (fs.existsSync(winTar)) ok = spawnSync(winTar, ["-xf", archive, "-C", dir], { stdio: "inherit" }).status === 0;
    if (!ok) ok = spawnSync("powershell", ["-NoProfile", "-Command",
      `Expand-Archive -LiteralPath '${archive.replace(/'/g, "''")}' -DestinationPath '${dir.replace(/'/g, "''")}' -Force`],
      { stdio: "inherit" }).status === 0;
  } else {
    ok = spawnSync("tar", ["-xzf", archive, "-C", dir], { stdio: "inherit" }).status === 0;
  }
  if (!ok) throw new Error("could not unpack " + archive);
  fs.rmSync(archive, { force: true });
  if (process.platform !== "win32") fs.chmodSync(exe, 0o755);
  pruneOldVersions();
}

// UPGRADE: `npm install -g kodinncli@latest` brings a new launcher; its first run unpacks the new build, and here the
// builds of earlier versions are removed so ~/.kodinncli does not grow by ~100 MB per release.
function pruneOldVersions() {
  try {
    const root = path.join(home, "versions");
    for (const v of fs.readdirSync(root)) if (v !== manifest.version) fs.rmSync(path.join(root, v), { recursive: true, force: true });
  } catch { /* best effort */ }
}

// UNINSTALL: `kodinncli --purge-downloads` (run before `npm uninstall -g kodinncli`) deletes the downloaded builds.
if (process.argv[2] === "--purge-downloads") {
  fs.rmSync(path.join(home, "versions"), { recursive: true, force: true });
  console.error(`kodinncli: removed ${path.join(home, "versions")}. Your settings are untouched; now run: npm uninstall -g kodinncli`);
  process.exit(0);
}

(async () => {
  try {
    if (!fs.existsSync(exe)) await install();
  } catch (e) {
    try { if (!fs.existsSync(exe)) fs.rmSync(dir, { recursive: true, force: true }); } catch { /* best effort */ }
    console.error(`kodinncli: ${e.message}`);
    console.error(`kodinncli: download it by hand from ${sources().join(" or ")}`);
    process.exit(1);
  }
  // TELLS THE APP IT WAS INSTALLED BY NPM, so its updater runs `npm install -g kodinncli@latest`.
  const env = { ...process.env, KODINNCLI_INSTALLED_BY: "npm" };
  const r = spawnSync(exe, process.argv.slice(2), { stdio: "inherit", env });
  process.exit(r.status === null ? 1 : r.status);
})();
