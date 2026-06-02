#!/usr/bin/env bash
# SQUARE active-skill icon pipeline. Unlike the round perk icons (subject on a disc inside a rim),
# vanilla active icons FILL the whole square: the art bleeds to the frame edge, corners included.
# (A round subject dropped into a square is NOT a proper active icon — the art must fill the panel.)
#
# Input is a codex gen that has a baked ROUND frame on flat green. The FRAME (blank_active_ac.png) is a
# dark panel with a silvery metal border. Layering, bottom-up:
#   1. the frame panel (dark interior + metal border)
#   2. the art, fitted to the interior so it never reaches the border
#   3. the metal RING (the frame with its interior cut out) ON TOP, so the silver border stays crisp
#      and fully visible no matter how dark the art's own edges are.
#   key green -> trim -> crop CENTRE SQUARE out of round art (drops round frame) -> scale to interior
#   -> sharpen -> panel + art + ring.
#
# Usage: compose_active.sh <framed_art.png> <out_base> [frame.png]
#   env: SQ     = centre-square side as fraction of the trimmed art (default 0.60; smaller = more
#                 zoom, less of the round frame creeps in)
#        BORDER = metal-border width in px (default 3 = the frame's border); art fits inside it
#        YOFF   = vertical offset px, + = down (default 0)
#        USM/SHP/SAT/CON = sharpen/colour knobs
set -euo pipefail
D="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IN="${1:?framed art}"; OUT="${2:?out base}"
FRAME="${3:-$D/assets/blank_active_ac.png}"
SIZE=56; FUZZ=22%
# FIT modes:
#   fill (default) — crop the centre square out of the art and scale it to FILL the panel, bleeding to
#                    the border. Right for textural subjects (a beast head, bark) where edges can crop.
#   fit            — scale the WHOLE subject to fit inside the panel with a small margin, nothing
#                    cropped. Right for a compact SYMBOL (e.g. rotation arrows) that must stay intact.
FIT="${FIT:-fill}"; PAD="${PAD:-2}"   # PAD = margin px inside the border, fit mode only
SQ="${SQ:-0.60}"; BORDER="${BORDER:-3}"; YOFF="${YOFF:-0}"
USM="${USM:-1.5x1.2+1.6+0}"; SHP="${SHP:-0x0.8}"; SAT="${SAT:-100}"; CON="${CON:-0}"
CADJ=(-modulate "100,$SAT"); [[ "$CON" != "0" ]] && CADJ+=(-sigmoidal-contrast "${CON}x50%")
PNG8=(-depth 8 -define png:color-type=6 -define png:bit-depth=8)
mkdir -p "$(dirname "$OUT")"; tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# 1) Key the green, trim to the framed art.
W=$(magick identify -format "%w" "$IN"); H=$(magick identify -format "%h" "$IN")
magick "$IN" -alpha set -fuzz "$FUZZ" -fill none \
  -draw "alpha 0,0 floodfill" -draw "alpha $((W-1)),0 floodfill" \
  -draw "alpha 0,$((H-1)) floodfill" -draw "alpha $((W-1)),$((H-1)) floodfill" "$tmp/k.png"
# also globally key interior green pockets the corner floodfill can't reach.
magick "$tmp/k.png" -fuzz "$FUZZ" -transparent '#00d000' -trim +repage "$tmp/t.png"

# 2) Prepare the art per FIT mode.
inner=$(( SIZE - 2 * BORDER ))
if [[ "$FIT" == "fit" ]]; then
  # FIT WHOLE subject inside the panel (longest side = inner - 2*PAD), nothing cropped.
  box=$(( inner - 2 * PAD ))
  magick "$tmp/t.png" -resize "${box}x${box}" -background none -gravity center -extent "${inner}x${inner}" \
    -unsharp "$USM" -sharpen "$SHP" "${CADJ[@]}" "$tmp/fill.png"
else
  # FILL: crop the centre square out of the art, then scale to fill the panel (bleeds to the border).
  A=$(magick identify -format "%w" "$tmp/t.png"); B=$(magick identify -format "%h" "$tmp/t.png")
  N=$(( A > B ? A : B ))
  magick "$tmp/t.png" -background none -gravity center -extent "${N}x${N}" "$tmp/sq.png"
  side=$(awk "BEGIN{printf \"%d\", $SQ*$N}")
  magick "$tmp/sq.png" -gravity center -crop "${side}x${side}+0+0" +repage "$tmp/crop.png"
  magick "$tmp/crop.png" -resize "${inner}x${inner}^" -gravity center -extent "${inner}x${inner}" \
    -unsharp "$USM" -sharpen "$SHP" "${CADJ[@]}" "$tmp/fill.png"
fi
magick -size "${SIZE}x${SIZE}" xc:none "$tmp/fill.png" \
  -gravity center -geometry "+0+${YOFF}" -compose over -composite "$tmp/art.png"

# 4) Build the metal RING: the frame with its interior punched out, so only the silver border remains.
magick "$FRAME" -resize "${SIZE}x${SIZE}" \
  \( -size "${SIZE}x${SIZE}" xc:none -fill black \
     -draw "rectangle ${BORDER},${BORDER} $((SIZE-1-BORDER)),$((SIZE-1-BORDER))" \) \
  -alpha set -compose dstout -composite "$tmp/ring.png"

# 5) Compose bottom-up: frame panel -> art (clipped to interior) -> metal ring on top.
magick \( "$FRAME" -resize "${SIZE}x${SIZE}" \) "$tmp/art.png" -gravity center -compose over -composite \
  "$tmp/ring.png" -gravity center -compose over -composite "${PNG8[@]}" "${OUT}.png"
# Disabled (_sw): plain grayscale at full brightness like vanilla active _sw icons.
magick "${OUT}.png" -modulate 100,0 "${PNG8[@]}" "${OUT}_sw.png"
echo "wrote ${OUT}.png and ${OUT}_sw.png (${SIZE}x${SIZE})"
