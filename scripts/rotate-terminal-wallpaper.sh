#!/usr/bin/env bash
# Rotates the backgroundImage of the "Archy" Windows Terminal profile through
# the official Omarchy wallpaper set in Pictures/sashomarchy. Called from
# config/bash/.bashrc on every new interactive shell (i.e. every new terminal).
set -euo pipefail

WIN_USER="${SASHOMARCHY_WIN_USER:-Bastani}"
WALLPAPER_DIR="/mnt/c/Users/${WIN_USER}/Pictures/sashomarchy"
SETTINGS="/mnt/c/Users/${WIN_USER}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/sashomarchy"
STATE_FILE="$STATE_DIR/terminal-wallpaper-current"
PROFILE_NAME="${SASHOMARCHY_TERMINAL_PROFILE:-Archy}"

mkdir -p "$STATE_DIR"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "sashomarchy: wallpaper dir not found: $WALLPAPER_DIR" >&2
  exit 1
fi
if [[ ! -f "$SETTINGS" ]]; then
  echo "sashomarchy: Windows Terminal settings.json not found: $SETTINGS" >&2
  exit 1
fi

# Official Omarchy cpunk theme wallpapers only (the set the theme ships with,
# also mirrored in ~/.config/omarchy/themes/cpunk/backgrounds/). Everything
# else in this folder (custom cyberpunk extras, right-pane masked artwork,
# random hash-named images) is deliberately excluded.
OFFICIAL_WALLPAPERS=(
  Arcyx.png
  Bxry2.png
  Cryox3.png
  Draxo.png
)

WALLPAPERS=()
for f in "${OFFICIAL_WALLPAPERS[@]}"; do
  [[ -f "$WALLPAPER_DIR/$f" ]] && WALLPAPERS+=("$f")
done

if (( ${#WALLPAPERS[@]} == 0 )); then
  echo "sashomarchy: no candidate wallpapers found in $WALLPAPER_DIR" >&2
  exit 1
fi

current=""
[[ -f "$STATE_FILE" ]] && current=$(<"$STATE_FILE")

next=""
for i in "${!WALLPAPERS[@]}"; do
  if [[ "${WALLPAPERS[$i]}" == "$current" ]]; then
    next="${WALLPAPERS[$(( (i + 1) % ${#WALLPAPERS[@]} ))]}"
    break
  fi
done
[[ -z "$next" ]] && next="${WALLPAPERS[0]}"

WALLPAPER_DIR="$WALLPAPER_DIR" SETTINGS="$SETTINGS" PROFILE_NAME="$PROFILE_NAME" NEXT="$next" WIN_USER="$WIN_USER" \
python3 - <<'PYEOF'
import json
import os

settings_path = os.environ["SETTINGS"]
profile_name = os.environ["PROFILE_NAME"]
next_file = os.environ["NEXT"]
win_user = os.environ["WIN_USER"]

win_path = f"C:\\Users\\{win_user}\\Pictures\\sashomarchy\\{next_file}"

with open(settings_path, "r", encoding="utf-8") as f:
    data = json.load(f)

profiles = data.get("profiles", {}).get("list", [])
match = next((p for p in profiles if p.get("name") == profile_name), None)
if match is None:
    raise SystemExit(f"sashomarchy: profile '{profile_name}' not found in {settings_path}")

match["backgroundImage"] = win_path

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=4)
    f.write("\n")

print(f"sashomarchy: set {profile_name} backgroundImage -> {win_path}")
PYEOF

echo "$next" > "$STATE_FILE"
