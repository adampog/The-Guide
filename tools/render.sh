#!/usr/bin/env bash
# Render tools/art/*.html to backgrounds/*.png at 3440x1440 with headless Chromium.
# Usage: tools/render.sh [name ...]   (names without .html; default: all)
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
W=${W:-3440} H=${H:-1440}
names=("$@")
[[ ${#names[@]} -eq 0 ]] && for f in "$root"/tools/art/*.html; do names+=("$(basename "$f" .html)"); done
for n in "${names[@]}"; do
  chromium --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --virtual-time-budget=5000 --window-size="$W,$H" \
    --screenshot="$root/backgrounds/$n.png" "file://$root/tools/art/$n.html" >/dev/null 2>&1
  echo "rendered backgrounds/$n.png"
done
