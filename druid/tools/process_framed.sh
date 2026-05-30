#!/usr/bin/env bash
# Finish a subject that was generated WITH its own baked frame on a green background:
# key the green, trim to the frame, downscale to 56, sharpen (v3), emit enabled + _sw.
# (No extra disc/rim — the art already carries its frame.)
#
# Usage: tools/process_framed.sh <art.png> <out_basename>
set -euo pipefail
IN="${1:?art png}"; OUT="${2:?out basename}"; SIZE=56; FUZZ=22%
mkdir -p "$(dirname "$OUT")"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

W=$(magick identify -format "%w" "$IN"); H=$(magick identify -format "%h" "$IN")
magick "$IN" -alpha set -fuzz "$FUZZ" -fill none \
  -draw "alpha 0,0 floodfill" -draw "alpha $((W-1)),0 floodfill" \
  -draw "alpha 0,$((H-1)) floodfill" -draw "alpha $((W-1)),$((H-1)) floodfill" "$tmp/k.png"
magick "$tmp/k.png" -trim +repage -resize "${SIZE}x${SIZE}" \
  -unsharp 1.5x1.0+1.4+0 -sharpen 0x0.5 "${OUT}.png"
magick "${OUT}.png" -modulate 72,14 -brightness-contrast -10x-4 "${OUT}_sw.png"
echo "wrote ${OUT}.png and ${OUT}_sw.png"
