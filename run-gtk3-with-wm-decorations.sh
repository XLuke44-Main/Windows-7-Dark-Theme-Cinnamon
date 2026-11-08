#!/usr/bin/env bash
# Disable GTK 3's *default* client-side decorations for this process only.
# Apps which set a custom titlebar widget still use CSD, by GTK design.
set -Eeuo pipefail
if [[ $# -lt 1 ]]; then
  printf 'Usage: %s application [arguments...]\n' "$0" >&2
  exit 2
fi
export GTK_CSD=0
exec "$@"
