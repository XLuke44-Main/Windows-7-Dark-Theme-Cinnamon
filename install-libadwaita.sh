#!/usr/bin/env bash
set -Eeuo pipefail

THEME_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_CSS="$THEME_DIR/extra/libadwaita/windows-7-aero-amoled.css"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
GTK4_DIR="$CONFIG_HOME/gtk-4.0"
GTK4_CSS="$GTK4_DIR/gtk.css"
BRIDGE_CSS="$GTK4_DIR/windows-7-aero-amoled-libadwaita.css"
IMPORT_LINE='@import url("windows-7-aero-amoled-libadwaita.css");'

if [[ ! -r "$SOURCE_CSS" ]]; then
  printf 'Theme stylesheet not found: %s\n' "$SOURCE_CSS" >&2
  exit 1
fi

mkdir -p "$GTK4_DIR"

# The bridge filename is theme-specific so unrelated user CSS/assets are untouched.
install -m 644 "$SOURCE_CSS" "$BRIDGE_CSS"

# Prepend a single import so it is parsed before ordinary CSS rules.
# Preserve an existing @charset declaration as the first line when present.
if [[ -f "$GTK4_CSS" ]] && grep -Fqx "$IMPORT_LINE" "$GTK4_CSS"; then
  printf 'Libadwaita bridge is already imported in %s\n' "$GTK4_CSS"
else
  TMP_FILE="$(mktemp "$GTK4_DIR/.gtk.css.win7-amoled.XXXXXX")"
  if [[ -f "$GTK4_CSS" ]]; then
    FIRST_LINE="$(head -n 1 "$GTK4_CSS" || true)"
    if [[ "$FIRST_LINE" == @charset* ]]; then
      {
        head -n 1 "$GTK4_CSS"
        printf '%s\n' "$IMPORT_LINE"
        tail -n +2 "$GTK4_CSS"
      } > "$TMP_FILE"
    else
      {
        printf '%s\n' "$IMPORT_LINE"
        cat "$GTK4_CSS"
      } > "$TMP_FILE"
    fi
  else
    printf '%s\n' "$IMPORT_LINE" > "$TMP_FILE"
  fi

  # Write through an existing symlink rather than replacing the symlink itself.
  if [[ -L "$GTK4_CSS" ]]; then
    cat "$TMP_FILE" > "$GTK4_CSS"
    rm -f "$TMP_FILE"
  else
    chmod 644 "$TMP_FILE"
    mv -f "$TMP_FILE" "$GTK4_CSS"
  fi
  printf 'Added Libadwaita bridge import to %s\n' "$GTK4_CSS"
fi

printf '\nInstalled Windows 7 Aero AMOLED Libadwaita styling.\n'
printf 'Close and reopen GTK 4 / Libadwaita applications to reload the palette.\n'
printf 'Existing GTK4 user CSS was preserved; only one import line was added.\n'
