#!/usr/bin/env bash
# Build a LABELLED comparison sheet — candidates and/or a reference, side by side, each tile captioned.
# This exists so labels are NEVER misaligned: it uses `-set label` (which captions the image already in
# memory). Do NOT hand-write montages with `-label 'X'` after the image — in ImageMagick `-label` is a
# SETTING that attaches to the NEXT image read, so every caption lands under the WRONG (next) tile. That
# off-by-one silently mislabels the sheet and you (or the user) then judge against the wrong picture.
#
# Always put the REFERENCE first (e.g. the vanilla icon you're matching) so you compare against it, and
# include prior rejected attempts when iterating — see SKILL.md "validate before presenting".
#
# Usage: cmp_sheet.sh <out.png> <label1> <img1> [<label2> <img2> ...]
#   env: SCALE=tile px (default 220, point-filtered for crisp pixels), BG=panel colour (#222),
#        FILL=text colour (#ddd), PT=label point size (14), TITLE=optional sheet title.
set -euo pipefail
OUT="${1:?out png}"; shift
(( $# >= 2 && $# % 2 == 0 )) || { echo "need <out> then label/img PAIRS (even count); got $# args" >&2; exit 2; }
SCALE="${SCALE:-220}"; BG="${BG:-#222}"; FILL="${FILL:-#ddd}"; PT="${PT:-14}"
tiles=(); n=0
while (( $# )); do
  label="$1"; img="$2"; shift 2
  [[ -f "$img" ]] || { echo "cmp_sheet: missing image '$img' (for label '$label')" >&2; exit 1; }
  # -set label applies to THIS image (already loaded) — the correct, alignment-safe way.
  tiles+=( \( "$img" -resize "${SCALE}x${SCALE}" -filter point -set label "$label" \) )
  n=$((n+1))
done
title=(); [[ -n "${TITLE:-}" ]] && title=(-title "$TITLE")
magick montage "${tiles[@]}" -tile "${n}x1" -geometry +6+6 \
  -background "$BG" -fill "$FILL" -pointsize "$PT" "${title[@]}" "$OUT"
echo "wrote $OUT ($n tiles)"
