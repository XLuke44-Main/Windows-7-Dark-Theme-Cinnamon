#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/Windows-7-Aero-AMOLED-Black.colors"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DEST_DIR="$DATA_HOME/color-schemes"
DEST="$DEST_DIR/Windows-7-Aero-AMOLED-Black.colors"

if [[ ! -r "$SOURCE" ]]; then
  printf 'Color scheme not found: %s\n' "$SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
install -m 644 "$SOURCE" "$DEST"
printf 'Installed KDE color scheme:\n  %s\n' "$DEST"
printf 'Select "Windows 7 Aero AMOLED Black" in System Settings → Appearance → Colors.\n'
