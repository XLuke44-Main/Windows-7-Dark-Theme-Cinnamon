#!/usr/bin/env bash
set -Eeuo pipefail
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

remove_overlay() {
  local target_dir="$1" import_name="$2"
  local settings="$target_dir/gtk.css"
  local import_line="@import url(\"$import_name\");"
  local tmp
  if [[ -f "$settings" ]] && grep -Fqx "$import_line" "$settings"; then
    tmp="$(mktemp "$target_dir/.gtk.css.win7-amoled-remove.XXXXXX")"
    grep -Fvx "$import_line" "$settings" > "$tmp" || true
    if [[ -L "$settings" ]]; then
      cat "$tmp" > "$settings"
      rm -f "$tmp"
    else
      chmod 644 "$tmp"
      mv -f "$tmp" "$settings"
    fi
    printf 'Removed import from %s\n' "$settings"
  fi
  rm -f "$target_dir/$import_name"
}

remove_overlay "$CONFIG_HOME/gtk-3.0" 'windows-7-amoled-gtk3-user.css'
remove_overlay "$CONFIG_HOME/gtk-4.0" 'windows-7-amoled-gtk4-user.css'
printf '\nRemoved only the theme-specific GTK user overrides.\n'
printf 'The separate Libadwaita bridge is managed by ./uninstall-libadwaita.sh.\n'
