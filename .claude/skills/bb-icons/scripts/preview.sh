#!/usr/bin/env bash
# Build a side-by-side preview of finished icon(s) so you can EYEBALL them before showing the user
# (and before installing): each icon is rendered zoomed (point-filter, 4x) next to its actual game
# size (56px), on a dark panel. Pass one or more icons; an old/reference icon can be passed too so
# you compare new-vs-old at a glance. ALWAYS look at this yourself first.
#
# Usage: preview.sh <out_preview.png> <icon1.png> [icon2.png ...]
set -euo pipefail
OUT="${1:?out preview png}"; shift
[[ $# -ge 1 ]] || { echo "need at least one icon" >&2; exit 1; }
BG='#1b1714'; tiles=()
for ic in "$@"; do
  tiles+=( \( "$ic" -filter point -resize 224x224 -background "$BG" -gravity center -extent 256x256 \) )
  tiles+=( \( "$ic" -background "$BG" -gravity center -extent 96x256 \) )
done
magick "${tiles[@]}" +append -bordercolor '#6b5a3a' -border 2 -strip -depth 8 png24:"$OUT"
echo "view: $OUT"
