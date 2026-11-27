#!/usr/bin/env bash
# Kodinn Agent (KodinnCli) uninstaller for Linux and macOS: removes what install.sh put in place.
#
#   curl -fsSL https://raw.githubusercontent.com/francescopaolopassaro/kodinn-agent/main/uninstall.sh | bash
#
# Removes ~/.kodinncli/app, the `kodinn` and `KodinnCli` links in ~/.local/bin (only when they point there) and the
# desktop entry. Your configuration and sessions (~/.config/KodinnCli) are left alone.
set -u
APP_DIR="${KODINNCLI_HOME:-$HOME/.kodinncli}/app"
BIN_DIR="${KODINNCLI_BIN_DIR:-$HOME/.local/bin}"

for name in KodinnCli kodinn; do
  link="$BIN_DIR/$name"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$APP_DIR/KodinnCli" ]; then rm -f "$link"; echo "removed $link"; fi
done
rm -f "$HOME/.local/share/applications/kodinncli.desktop" "$HOME/.local/share/icons/kodinn.png"
if [ -d "$APP_DIR" ]; then rm -rf "$APP_DIR"; echo "removed $APP_DIR"; else echo "nothing at $APP_DIR"; fi
echo "Kodinn Agent removed. Configuration kept: ~/.config/KodinnCli (delete it by hand to remove it too)."
