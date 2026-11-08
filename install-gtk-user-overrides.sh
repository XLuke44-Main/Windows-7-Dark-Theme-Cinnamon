#!/usr/bin/env bash
set -Eeuo pipefail

THEME_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

install_overlay() {
  local version="$1" source="$2" target_dir="$3" import_name="$4"
  local css_file="$target_dir/$import_name"
  local settings="$target_dir/gtk.css"
  local import_line="@import url(\"$import_name\");"
  local tmp

  if [[ ! -r "$source" ]]; then
    printf 'Missing overlay: %s\n' "$source" >&2
    exit 1
  fi
  mkdir -p "$target_dir"
  install -m 644 "$source" "$css_file"

  if [[ -f "$settings" ]] && grep -Fqx "$import_line" "$settings"; then
    printf '%s override already imported in %s\n' "$version" "$settings"
    return
  fi

  tmp="$(mktemp "$target_dir/.gtk.css.win7-amoled.XXXXXX")"
  if [[ -f "$settings" ]]; then
    # CSS @import statements must precede qualified rules. Insert after the
    # existing charset/import preamble, so this last import wins at USER level.
    awk -v import_line="$import_line" '
      BEGIN { inserted = 0 }
      {
        if (!inserted && $0 ~ /^[[:space:]]*@charset([[:space:]]|$)/) { print; next }
        if (!inserted && $0 ~ /^[[:space:]]*@import([[:space:]]|$)/) { print; next }
        if (!inserted) { print import_line; inserted = 1 }
        print
      }
      END { if (!inserted) print import_line }
    ' "$settings" > "$tmp"
  else
    printf '%s\n' "$import_line" > "$tmp"
  fi

  # Preserve an existing symlink target (some distros link GTK config files).
  if [[ -L "$settings" ]]; then
    cat "$tmp" > "$settings"
    rm -f "$tmp"
  else
    chmod 644 "$tmp"
    mv -f "$tmp" "$settings"
  fi
  printf 'Installed %s USER-priority override in %s\n' "$version" "$settings"
}

install_overlay 'GTK 3' "$THEME_DIR/extra/gtk-overrides/windows-7-amoled-gtk3-user.css" "$CONFIG_HOME/gtk-3.0" 'windows-7-amoled-gtk3-user.css'
install_overlay 'GTK 4' "$THEME_DIR/extra/gtk-overrides/windows-7-amoled-gtk4-user.css" "$CONFIG_HOME/gtk-4.0" 'windows-7-amoled-gtk4-user.css'

printf '\nDone. Fully close and reopen GTK applications.\n'
printf 'For upstream Libadwaita apps also run ./install-libadwaita.sh from this theme folder.\n'
printf 'Flatpak apps may need filesystem permission to read the host GTK user CSS.\n'
