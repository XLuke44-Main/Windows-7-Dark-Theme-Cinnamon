#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
GTK4_DIR="$CONFIG_HOME/gtk-4.0"
GTK4_CSS="$GTK4_DIR/gtk.css"
BRIDGE_CSS="$GTK4_DIR/windows-7-aero-amoled-libadwaita.css"
IMPORT_LINE='@import url("windows-7-aero-amoled-libadwaita.css");'

if [[ -f "$GTK4_CSS" ]] && grep -Fqx "$IMPORT_LINE" "$GTK4_CSS"; then
  TMP_FILE="$(mktemp "$GTK4_DIR/.gtk.css.win7-amoled-remove.XXXXXX")"
  awk -v import_line="$IMPORT_LINE" '$0 != import_line { print }' "$GTK4_CSS" > "$TMP_FILE"
  if [[ -L "$GTK4_CSS" ]]; then
    cat "$TMP_FILE" > "$GTK4_CSS"
    rm -f "$TMP_FILE"
  else
    chmod 644 "$TMP_FILE"
    mv -f "$TMP_FILE" "$GTK4_CSS"
  fi
  printf 'Removed Libadwaita bridge import from %s\n' "$GTK4_CSS"
else
  printf 'No Windows 7 Aero AMOLED import line found in %s\n' "$GTK4_CSS"
fi

rm -f "$BRIDGE_CSS"
printf 'Removed Windows 7 Aero AMOLED Libadwaita stylesheet.\n'
printf 'All other GTK4 user CSS and configuration files were left untouched.\n'
