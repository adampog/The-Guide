#!/usr/bin/env bash
# Render the wallpaper sources in tools/art/*.html to backgrounds/*.png with headless Chromium.
#
# Usage: tools/render.sh [name ...]
#   With no arguments every wallpaper is rendered; otherwise give names without
#   ".html", e.g. tools/render.sh 3-babel-fish. Override the size with W= and H=.
#
# The pages load Google Fonts, so this needs a network connection. Wallpapers 5 and 6
# are large after rendering; see the README for the command used to compress them.
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
W=${W:-3440}
H=${H:-1440}

# Default to every file in tools/art/ when no names are given.
names=("$@")
if [[ ${#names[@]} -eq 0 ]]; then
  for f in "$root"/tools/art/*.html; do
    names+=("$(basename "$f" .html)")
  done
fi

for n in "${names[@]}"; do
  # --virtual-time-budget gives web fonts and any page scripts time to finish before the screenshot.
  chromium --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --virtual-time-budget=5000 --window-size="$W,$H" \
    --screenshot="$root/backgrounds/$n.png" "file://$root/tools/art/$n.html" >/dev/null 2>&1
  echo "rendered backgrounds/$n.png"
done
