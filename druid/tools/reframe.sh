#!/usr/bin/env bash
# Re-frame an icon that was generated WITH a baked codex frame: strip that frame off and put the
# project's standard rim on instead, so it matches the rest. Keeps the approved art + its interior.
#
#   key green -> trim -> crop to the inner circle (drops the baked frame) -> fit to the disc area
#   -> sharpen (v3) -> overlay the rim. Same disc radius (24) / rim as the wolf pipeline.
#
# Usage: tools/reframe.sh <framed_art.png> <out_basename> <rim.png>
#   env: INNER = inner-crop radius as fraction of the framed circle (default 0.82)
set -euo pipefail
IN="${1:?framed art}"; OUT="${2:?out base}"; RIM="${3:?rim png}"
SIZE=56; DISC=50; FUZZ=22%; INNER="${INNER:-0.82}"
mkdir -p "$(dirname "$OUT")"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

W=$(magick identify -format "%w" "$IN"); H=$(magick identify -format "%h" "$IN")
magick "$IN" -alpha set -fuzz "$FUZZ" -fill none \
  -draw "alpha 0,0 floodfill" -draw "alpha $((W-1)),0 floodfill" \
  -draw "alpha 0,$((H-1)) floodfill" -draw "alpha $((W-1)),$((H-1)) floodfill" "$tmp/k.png"
magick "$tmp/k.png" -trim +repage "$tmp/t.png"
A=$(magick identify -format "%w" "$tmp/t.png"); B=$(magick identify -format "%h" "$tmp/t.png")
N=$(( A > B ? A : B ))
magick "$tmp/t.png" -background none -gravity center -extent "${N}x${N}" "$tmp/sq.png"

C=$(awk "BEGIN{print ($N-1)/2}")
RP=$(awk "BEGIN{print $C-$INNER*$N/2}")
# mask to the inner circle (drop the baked frame), then TRIM to that circle's bbox so it fills
# the disc area (otherwise the subject shrinks and leaves a gap to the rim).
magick "$tmp/sq.png" \( -size "${N}x${N}" xc:none -fill white -draw "circle $C,$C $C,$RP" \) \
  -alpha set -compose dstin -composite -trim +repage "$tmp/inner.png"

# size the disc so its edge tucks UNDER the rim ring (no gap, no double border).
USM="${USM:-1.5x1.0+1.4+0}"; SHP="${SHP:-0x0.5}"; SAT="${SAT:-100}"; CON="${CON:-0}"
CADJ=(-modulate "100,$SAT"); [[ "$CON" != "0" ]] && CADJ+=(-sigmoidal-contrast "${CON}x50%")
magick "$tmp/inner.png" -resize "${DISC}x${DISC}" -unsharp "$USM" -sharpen "$SHP" "${CADJ[@]}" \
  -background none -gravity center -extent "${SIZE}x${SIZE}" "$tmp/subj.png"
# Force 8-bit RGBA: the game engine (WebCore) can't read 16-bit PNGs, which IM would
# otherwise inherit from 16-bit source brushes.
PNG8=(-depth 8 -define png:color-type=6 -define png:bit-depth=8)
magick "$tmp/subj.png" \( "$RIM" -resize "${SIZE}x${SIZE}" \) -gravity center -compose over -composite "${PNG8[@]}" "${OUT}.png"
# Disabled (_sw): plain grayscale at full brightness like vanilla perk _sw icons.
magick "${OUT}.png" -modulate 100,0 "${PNG8[@]}" "${OUT}_sw.png"
echo "wrote ${OUT}.png and ${OUT}_sw.png"
