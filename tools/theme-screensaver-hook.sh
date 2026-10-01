#!/usr/bin/env bash
# Omarchy theme-set hook: give themes their own screensaver.
#
# Omarchy's screensaver text is a single global file
# (~/.config/omarchy/branding/screensaver.txt) that theme changes don't touch.
# This hook swaps it when the theme changes:
#   - Switching to a theme that ships a screensaver.txt: save your own screensaver
#     (the first time only) and use the theme's instead.
#   - Switching to a theme without one: put your own screensaver back.
#
# Install it once with:
#   omarchy hook install theme-set ~/.config/omarchy/themes/the-guide/tools/theme-screensaver-hook.sh
#
# Omarchy passes the new theme's slug (e.g. "the-guide") as $1.
set -euo pipefail

theme=${1:?theme slug expected as the first argument}
branding="$HOME/.config/omarchy/branding"
current="$branding/screensaver.txt"
saved="$branding/screensaver.user.txt" # your own screensaver while a theme's is in use
marker="$branding/screensaver.theme"   # exists only while a theme's screensaver is in use

theme_screensaver="$(omarchy-theme-dir "$theme")/screensaver.txt"

if [[ -f $theme_screensaver ]]; then
  # No marker means the current file is your own, so keep a copy before replacing it.
  if [[ ! -f $marker && -f $current ]]; then
    cp "$current" "$saved"
  fi
  cp "$theme_screensaver" "$current"
  echo "$theme" >"$marker"
elif [[ -f $marker ]]; then
  # Leaving a theme that had its own screensaver: restore yours.
  if [[ -f $saved ]]; then
    cp "$saved" "$current"
  fi
  rm -f "$marker"
fi
