#!/usr/bin/env bash
# Compose a Battle Brothers 56x56 perk icon from a clean SUBJECT cut-out generated on a solid
# GREEN background (no circle, no frame). Three separate layers, like the game:
#
#   dark disc  (bottom)  ->  clean rim  (middle)  ->  subject cut-out ON TOP
#
# The subject sits on top, so it overlaps the rim with its ears AND chin; the rim shows through
# the gaps of the silhouette. Nothing but the subject's own pixels are drawn (background keyed
# out), so no fur/disc ever spills past the rim. Only the subject is sharpened; the rim stays clean.
# Outputs enabled <name>.png and desaturated <name>_sw.png.
#
# Usage: tools/icon_postprocess.sh <subject_art.png> <out_basename> [rim.png]
#   env: HEAD=subject size as % of icon (default 100), FUZZ=green tolerance
set -euo pipefail

IN="${1:?subject art png}"; OUT="${2:?out basename}"; RIM="${3:-}"
SIZE=56
HEAD="${HEAD:-96}"    # subject longest side as % of the icon
DISCR="${DISCR:-24}"  # dark-disc radius == rim INNER radius, so the disc never pokes past the rim ring
YOFF="${YOFF:-0}"     # vertical offset of the subject in px, + = down (default 0 = centred)
FUZZ=22%
C=$(awk "BEGIN{print ($SIZE-1)/2}")
RP=$(awk "BEGIN{print $C-$DISCR}")   # a point on the disc circle (for -draw)
USM="${USM:-1.5x1.0+1.4+0}"   # unsharp-mask amount (env-overridable)
SHP="${SHP:-0x0.5}"           # extra -sharpen sigma
SAT="${SAT:-100}"             # saturation % (100 = unchanged)
CON="${CON:-0}"               # sigmoidal contrast strength (0 = off)
SHARPEN=(-unsharp "$USM" -sharpen "$SHP")
CADJ=(-modulate "100,$SAT")
[[ "$CON" != "0" ]] && CADJ+=(-sigmoidal-contrast "${CON}x50%")

mkdir -p "$(dirname "$OUT")"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

W=$(magick identify -format "%w" "$IN"); H=$(magick identify -format "%h" "$IN")

# 1) Key the green, trim to the subject -> clean cut-out.
magick "$IN" -alpha set -fuzz "$FUZZ" -fill none \
  -draw "alpha 0,0 floodfill" -draw "alpha $((W-1)),0 floodfill" \
  -draw "alpha 0,$((H-1)) floodfill" -draw "alpha $((W-1)),$((H-1)) floodfill" \
  "$tmp/keyed.png"
magick "$tmp/keyed.png" -trim +repage "$tmp/subj_full.png"

# 2) Subject scaled + sharpened, centred on the canvas.
sz=$(( SIZE * HEAD / 100 ))
magick "$tmp/subj_full.png" -resize "${sz}x${sz}" "${SHARPEN[@]}" "${CADJ[@]}" "$tmp/subj_s.png"
magick -size "${SIZE}x${SIZE}" xc:none "$tmp/subj_s.png" \
  -gravity center -geometry "+0+${YOFF}" -compose over -composite "$tmp/subj.png"

# 3) Dark disc, a little SMALLER than the rim (radius DISCR) so the rim fully covers its edge
#    and no disc ever shows past the rim. Tune size with the DISCR env var.
magick -size "${SIZE}x${SIZE}" radial-gradient:'#3b342c'-'#0b0a08' \
  \( -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$RP" \) \
  -alpha off -compose copyopacity -composite "$tmp/disc.png"

# 4) Disc -> rim -> subject on top.
if [[ -n "$RIM" ]]; then
  magick "$tmp/disc.png" \( "$RIM" -resize "${SIZE}x${SIZE}" \) \
    -gravity center -compose over -composite "$tmp/dr.png"
else
  cp "$tmp/disc.png" "$tmp/dr.png"
fi
magick "$tmp/dr.png" "$tmp/subj.png" -gravity center -compose over -composite "${OUT}.png"

# 6) Disabled (_sw): desaturate + dim.
magick "${OUT}.png" -modulate 72,14 -brightness-contrast -10x-4 "${OUT}_sw.png"

echo "wrote ${OUT}.png and ${OUT}_sw.png (${SIZE}x${SIZE})"
