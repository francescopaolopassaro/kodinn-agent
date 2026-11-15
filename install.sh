#!/usr/bin/env bash
# Kodinn Agent (KodinnCli) installer for Linux and macOS.
#
#   curl -fsSL https://raw.githubusercontent.com/francescopaolopassaro/kodinn-agent/main/install.sh | bash
#
# Reads latest.json from www.digitalsolutions.it (GitHub as fallback), downloads the package for this system, checks
# its SHA-256, unpacks it into ~/.kodinncli/app and links `kodinn` and `KodinnCli` into ~/.local/bin.
# KODINNCLI_VERSION=x.y.z installs a given version; KODINNCLI_BIN_DIR changes where the commands are linked.
set -euo pipefail

LATEST_URLS=(
  ${KODINNCLI_LATEST_URL:+"$KODINNCLI_LATEST_URL"}
  "https://www.digitalsolutions.it/downloads/kodinncli/latest.json"
  "https://raw.githubusercontent.com/francescopaolopassaro/kodinn-agent/main/latest.json"
)
APP_DIR="${KODINNCLI_HOME:-$HOME/.kodinncli}/app"
BIN_DIR="${KODINNCLI_BIN_DIR:-$HOME/.local/bin}"

say()  { printf '\033[1;36m%s\033[0m\n' "$*"; }
fail() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || fail "$1 is required"; }
need curl; need tar

case "$(uname -s)" in
  Linux)  os=linux ;;
  Darwin) os=osx ;;
  *) fail "unsupported system $(uname -s) — on Windows use install.ps1" ;;
esac
case "$(uname -m)" in
  x86_64|amd64) arch=x64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) fail "unsupported architecture $(uname -m)" ;;
esac
rid="$os-$arch"
[ "$rid" = "osx-x64" ] || [ "$rid" = "osx-arm64" ] || [ "$rid" = "linux-x64" ] || [ "$rid" = "linux-arm64" ] || fail "no build for $rid"

json=""
for u in "${LATEST_URLS[@]}"; do
  if json=$(curl -fsSL "$u" 2>/dev/null) && [ -n "$json" ]; then break; fi
done
[ -n "$json" ] || fail "could not read latest.json"

# latest.json is written by the release script with one key per line, so plain text tools read it.
version=$(printf '%s\n' "$json" | sed -n 's/^  "version": "\(.*\)",$/\1/p' | head -1)
block=$(printf '%s\n' "$json" | awk -v rid="\"$rid\": {" 'index($0, rid){f=1} f{print} f&&/^    }/{exit}')
url=$(printf '%s\n' "$block" | sed -n 's/.*"url": "\(.*\)",*$/\1/p' | head -1)
sha=$(printf '%s\n' "$block" | sed -n 's/.*"sha256": "\(.*\)",*$/\1/p' | head -1)
folder=$(printf '%s\n' "$block" | sed -n 's/.*"folder": "\(.*\)",*$/\1/p' | head -1)
if [ -n "${KODINNCLI_VERSION:-}" ] && [ "$KODINNCLI_VERSION" != "$version" ]; then
  url="${url//$version/$KODINNCLI_VERSION}"; folder="${folder//$version/$KODINNCLI_VERSION}"; sha=""; version="$KODINNCLI_VERSION"
fi
[ -n "$url" ] || fail "no $rid package in latest.json"

say "Kodinn Agent $version for $rid"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
archive="$tmp/kodinncli.tar.gz"
curl -fL --progress-bar "$url" -o "$archive" || fail "download failed: $url"

if [ -n "$sha" ]; then
  if command -v sha256sum >/dev/null 2>&1; then got=$(sha256sum "$archive" | cut -d' ' -f1)
  else got=$(shasum -a 256 "$archive" | cut -d' ' -f1); fi
  [ "$got" = "$sha" ] || fail "checksum mismatch (expected $sha, got $got)"
  say "checksum ok"
fi

tar -xzf "$archive" -C "$tmp"
rm -rf "$APP_DIR"; mkdir -p "$APP_DIR"
cp -R "$tmp/$folder/." "$APP_DIR/"
chmod +x "$APP_DIR/KodinnCli"
# macOS: a downloaded binary carries the quarantine flag; the install is the user's own choice.
[ "$os" = "osx" ] && xattr -dr com.apple.quarantine "$APP_DIR" 2>/dev/null || true

mkdir -p "$BIN_DIR"
ln -sf "$APP_DIR/KodinnCli" "$BIN_DIR/KodinnCli"
ln -sf "$APP_DIR/KodinnCli" "$BIN_DIR/kodinn"

# Linux desktop entry and icon, when the package carries them.
if [ "$os" = "linux" ] && [ -f "$APP_DIR/kodinncli.desktop" ]; then
  mkdir -p "$HOME/.local/share/applications" "$HOME/.local/share/icons"
  cp "$APP_DIR/kodinn.png" "$HOME/.local/share/icons/kodinn.png" 2>/dev/null || true
  sed "s|^Exec=.*|Exec=$APP_DIR/KodinnCli|" "$APP_DIR/kodinncli.desktop" > "$HOME/.local/share/applications/kodinncli.desktop" || true
fi

say "Installed into $APP_DIR"
case ":$PATH:" in
  *":$BIN_DIR:"*) say "Run: kodinn" ;;
  *) say "Add $BIN_DIR to your PATH, then run: kodinn"
     echo "    echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.bashrc   # or ~/.zshrc" ;;
esac
