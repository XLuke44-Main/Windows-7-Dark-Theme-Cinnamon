#!/usr/bin/env bash
# Disable Qt Wayland's client-side decoration helper for this process only.
# Use only with Qt apps using the Wayland QPA plugin and a compositor that
# supplies server-side decorations.
set -Eeuo pipefail
if [[ $# -lt 1 ]]; then
  printf 'Usage: %s application [arguments...]\n' "$0" >&2
  exit 2
fi
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
exec "$@"
