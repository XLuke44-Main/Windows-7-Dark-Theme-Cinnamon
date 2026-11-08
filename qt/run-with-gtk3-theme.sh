#!/usr/bin/env bash
set -Eeuo pipefail

if (($# == 0)); then
  printf 'Usage: %s <qt-application> [arguments...]\n' "${0##*/}" >&2
  exit 2
fi

# Apply only to this process tree; do not alter the user's global Qt settings.
exec env \
  GTK_THEME="Windows-7-Theme-Cinnamon-AMOLED-Black" \
  QT_QPA_PLATFORMTHEME="gtk3" \
  "$@"
