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

function sha256(file) {
  const h = crypto.createHash("sha256");
  h.update(fs.readFileSync(file));
  return h.digest("hex");
}

async function install() {
  fs.mkdirSync(dir, { recursive: true });
  const archive = path.join(dir, path.basename(new URL(build.url).pathname));
  console.error(`kodinncli: first run of ${manifest.version} — fetching the ${key} build from digitalsolutions.it`);
  await download(build.url, archive);
  const got = sha256(archive);
  if (got !== build.sha256) {
    fs.rmSync(archive, { force: true });
    throw new Error(`checksum mismatch for ${path.basename(archive)} (expected ${build.sha256}, got ${got})`);
  }
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
}

(async () => {
  try {
    if (!fs.existsSync(exe)) await install();
  } catch (e) {
    console.error(`kodinncli: ${e.message}`);
    console.error(`kodinncli: download it by hand from ${build.url}`);
    process.exit(1);
  }
  // TELLS THE APP IT WAS INSTALLED BY NPM, so its updater runs `npm install -g kodinncli@latest`.
  const env = { ...process.env, KODINNCLI_INSTALLED_BY: "npm" };
  const r = spawnSync(exe, process.argv.slice(2), { stdio: "inherit", env });
  process.exit(r.status === null ? 1 : r.status);
})();
