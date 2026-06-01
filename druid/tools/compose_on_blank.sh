#!/usr/bin/env bash
# Compose a round perk icon ON TOP of a canonical blank frame (AC's blank_passive_ac.png) without
# ever redrawing the frame — so the rim + outside-rim transparency stay pixel-identical to vanilla
# perks and no grey junk can appear around the disc. Layers, bottom-up:
#   1. BLANK frame as-is (dark disc + metal rim + transparent outside)
#   2. BODY art (e.g. soil + plant) clipped to the disc circle (never past the rim)
#   3. OVERLAY cut-out (e.g. clean leaves) on top, clipped to a circle a little WIDER than the rim
#      so its tips spill over the rim like apex ears, but nothing strays to the icon corners.
# Final alpha is forced to (blank ∪ overlay-in-clip): outside the rim only legit overlay tips show.
#
# Usage: compose_on_blank.sh <body_art.png> <overlay_cut.png> <out_base> [blank.png]
#   env: BODY = body size % of icon (default 100), BX/BY = body offset px
#        OVR  = overlay size % of icon (default = BODY), OX/OY = overlay offset px
#        DISCR= disc radius for the body clip (default 24), OVER = extra radius for overlay (default 3)
#        USM/SHP/SAT/CON = sharpen/colour knobs
set -euo pipefail
BODY_IN="${1:?body art}"; OVR_IN="${2:?overlay cut}"; OUT="${3:?out base}"
BLANK="${4:-/home/suor/projects/bbm/3rdparty/AC/gfx/blank_passive_ac.png}"
SIZE=56
BODY="${BODY:-100}"; OVR="${OVR:-$BODY}"
BX="${BX:-0}"; BY="${BY:-0}"; OX="${OX:-0}"; OY="${OY:-0}"
DISCR="${DISCR:-24}"; OVER="${OVER:-3}"
USM="${USM:-1.5x1.2+1.6+0}"; SHP="${SHP:-0x0.8}"; SAT="${SAT:-100}"; CON="${CON:-0}"
CADJ=(-modulate "100,$SAT"); [[ "$CON" != "0" ]] && CADJ+=(-sigmoidal-contrast "${CON}x50%")
PNG8=(-depth 8 -define png:color-type=6 -define png:bit-depth=8)
C=$(awk "BEGIN{print ($SIZE-1)/2}")
RP=$(awk "BEGIN{print $C-$DISCR}")
ORP=$(awk "BEGIN{r=$DISCR+$OVER; if(r>$C-1)r=$C-1; print $C-r}")
mkdir -p "$(dirname "$OUT")"; tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# body: scale + sharpen, offset, clip to disc circle (radius DISCR).
bsz=$(( SIZE * BODY / 100 ))
magick "$BODY_IN" -resize "${bsz}x${bsz}" -unsharp "$USM" -sharpen "$SHP" "${CADJ[@]}" "$tmp/bs.png"
magick -size "${SIZE}x${SIZE}" xc:none "$tmp/bs.png" -gravity center -geometry "+${BX}+${BY}" -compose over -composite "$tmp/bpos.png"
magick "$tmp/bpos.png" \( -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$RP" \) \
  -alpha set -compose dstin -composite "$tmp/body.png"

# overlay: scale + sharpen, offset, clip to slightly-wider circle (tips over rim, no corner stray).
osz=$(( SIZE * OVR / 100 ))
magick "$OVR_IN" -resize "${osz}x${osz}" -unsharp "$USM" -sharpen "$SHP" "${CADJ[@]}" "$tmp/os.png"
magick -size "${SIZE}x${SIZE}" xc:none "$tmp/os.png" -gravity center -geometry "+${OX}+${OY}" -compose over -composite "$tmp/opos.png"
magick "$tmp/opos.png" \( -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$ORP" \) \
  -alpha set -compose dstin -composite "$tmp/ovr.png"

# layer: blank (as-is) -> body -> overlay.
magick \( "$BLANK" -resize "${SIZE}x${SIZE}" \) "$tmp/body.png" -gravity center -compose over -composite \
  "$tmp/ovr.png" -gravity center -compose over -composite "${PNG8[@]}" "${OUT}.png"
magick "${OUT}.png" -modulate 100,0 "${PNG8[@]}" "${OUT}_sw.png"
echo "wrote ${OUT}.png (+_sw)"
