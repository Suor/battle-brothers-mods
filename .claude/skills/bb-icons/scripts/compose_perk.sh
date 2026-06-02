#!/usr/bin/env bash
# Compose a 56x56 ROUND perk/trait icon from a clean SUBJECT cut-out (generated on solid #00d000)
# laid ON TOP of a canonical blank frame. The frame is composited from a real game blank (default the
# AC perk blank), so the rim + the transparent area OUTSIDE the rim stay PIXEL-IDENTICAL to vanilla —
# we never redraw the rim (codex-drawn rims come out wrong; redrawing leaves grey junk around the disc).
#
#   layers: blank frame  ->  [soft glow]  ->  subject (clipped per MODE)
#
# MODES:
#   clip  (default) — subject hard-clipped to the disc circle (radius DISCR). NOTHING crosses the rim
#                     (e.g. a sickle handle is cut at the border). Safest, frame stays pristine.
#   over            — subject clipped to a circle slightly WIDER than the rim (radius DISCR+OVER) so
#                     chosen parts (ears, leaf tips) spill a little over the rim, nothing to corners.
#
# For a TRAIT icon, pass the trait blank as the 3rd arg (assets/blank_trait_1_ac.png or _2).
#
# Usage: compose_perk.sh <subject.png> <out_base> [frame.png]
#   env: MODE=clip|over (default clip), HEAD=subject %% of icon (default 78), YOFF=px,
#        DISCR=disc radius (default 24), OVER=extra radius for 'over' (default 3),
#        GLOW=0|1 (default 1) soft halo under the subject, GLOWC=glow colour (default #b9a06a),
#        GLOWR=blur sigma (default 4), GLOWA=peak opacity %% (default 30),
#        USM/SHP/SAT/CON = sharpen/colour knobs (see the skill's "Sharpness" notes).
set -euo pipefail
D="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IN="${1:?subject png}"; OUT="${2:?out base}"
FRAME="${3:-$D/assets/blank_passive_ac.png}"
SIZE=56; FUZZ="${FUZZ:-22%}"
MODE="${MODE:-clip}"; HEAD="${HEAD:-78}"; YOFF="${YOFF:-0}"
DISCR="${DISCR:-24}"; OVER="${OVER:-3}"
GLOW="${GLOW:-1}"; GLOWC="${GLOWC:-#b9a06a}"
# DISCGLOW = a warm radial light on the whole disc (like vanilla perks, whose disc is dark at the top
# and warmly lit lower-centre) — this is what makes the glow actually NOTICEABLE, not just a thin halo
# hugging the subject. DGC = its colour, DGA = peak opacity %. Set DISCGLOW=0 to disable.
# (The glow is CLIPPED to the centred disc, so it must stay centred — shifting the clipped layer
# would push its circle past the rim and spill outside it.)
DISCGLOW="${DISCGLOW:-1}"; DGC="${DGC:-#5a4326}"; DGA="${DGA:-55}"
USM="${USM:-1.5x1.2+1.6+0}"; SHP="${SHP:-0x0.8}"; SAT="${SAT:-100}"; CON="${CON:-0}"
CADJ=(-modulate "100,$SAT"); [[ "$CON" != "0" ]] && CADJ+=(-sigmoidal-contrast "${CON}x50%")
PNG8=(-depth 8 -define png:color-type=6 -define png:bit-depth=8)
C=$(awk "BEGIN{print ($SIZE-1)/2}")
RP=$(awk "BEGIN{print $C-$DISCR}")
ORP=$(awk "BEGIN{r=$DISCR+$OVER; if(r>$C-1)r=$C-1; print $C-r}")
mkdir -p "$(dirname "$OUT")"; tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# 1) Key green -> trim -> scale + sharpen -> place at offset.
W=$(magick identify -format "%w" "$IN"); H=$(magick identify -format "%h" "$IN")
magick "$IN" -alpha set -fuzz "$FUZZ" -fill none \
  -draw "alpha 0,0 floodfill" -draw "alpha $((W-1)),0 floodfill" \
  -draw "alpha 0,$((H-1)) floodfill" -draw "alpha $((W-1)),$((H-1)) floodfill" "$tmp/k.png"
# also globally key interior green pockets the corner floodfill can't reach
magick "$tmp/k.png" -fuzz "$FUZZ" -transparent '#00d000' -trim +repage "$tmp/subj_full.png"
sz=$(( SIZE * HEAD / 100 ))
magick "$tmp/subj_full.png" -resize "${sz}x${sz}" -unsharp "$USM" -sharpen "$SHP" "${CADJ[@]}" "$tmp/ss.png"
magick -size "${SIZE}x${SIZE}" xc:none "$tmp/ss.png" -gravity center -geometry "+0+${YOFF}" \
  -compose over -composite "$tmp/subj_pos.png"

# 2) Clip the subject per mode.
if [[ "$MODE" == "over" ]]; then CLIPR="$ORP"; else CLIPR="$RP"; fi
magick "$tmp/subj_pos.png" \( -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$CLIPR" \) \
  -alpha set -compose dstin -composite "$tmp/subj.png"

# 3a) Disc glow: a warm radial light filling the disc (vanilla perks are lit this way). Feathered, so
#     no hard concentric edge inside the rim. This is the main, NOTICEABLE glow.
if [[ "$DISCGLOW" == "1" ]]; then
  DGF=$(awk "BEGIN{printf \"%.3f\", $DGA/100}")
  # Clip the radial glow to the disc with dstin (keeps the glow only where the circle mask is opaque).
  # NB: do NOT use "-alpha off -compose copyopacity" here — with the mask's alpha disabled it reads as
  # fully opaque everywhere and the glow spills past the rim.
  magick -size "${SIZE}x${SIZE}" "radial-gradient:${DGC}-none" \
    \( -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$RP" -blur 0x0.7 \) \
    -alpha set -compose dstin -composite \
    -channel A -evaluate multiply "$DGF" +channel "$tmp/discglow.png"
fi

# 3b) Optional subject halo: the subject's silhouette blurred WIDE and dim, lifting its edges off the
#     disc (on top of the disc glow).
GLOWR="${GLOWR:-4}"; GLOWA="${GLOWA:-40}"
GLOWF=$(awk "BEGIN{printf \"%.3f\", $GLOWA/100}")
if [[ "$GLOW" == "1" ]]; then
  magick "$tmp/subj.png" -channel A -separate +channel \
    -blur 0x${GLOWR} -evaluate multiply "$GLOWF" "$tmp/glowmask.png"
  magick -size "${SIZE}x${SIZE}" "xc:${GLOWC}" "$tmp/glowmask.png" -alpha off -compose copyopacity -composite \
    \( -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$RP" \) -alpha set -compose dstin -composite \
    "$tmp/glow.png"
fi

# 4) Layer: frame -> [disc glow] -> [subject halo] -> subject.
magick "$FRAME" -resize "${SIZE}x${SIZE}" "$tmp/frame.png"
cp "$tmp/frame.png" "$tmp/base.png"
[[ "$DISCGLOW" == "1" ]] && magick "$tmp/base.png" "$tmp/discglow.png" -gravity center -compose over -composite "$tmp/base.png"
[[ "$GLOW" == "1" ]] && magick "$tmp/base.png" "$tmp/glow.png" -gravity center -compose over -composite "$tmp/base.png"
magick "$tmp/base.png" "$tmp/subj.png" -gravity center -compose over -composite "${PNG8[@]}" "${OUT}.png"
# Disabled (_sw): plain grayscale at FULL brightness like vanilla _sw icons (desaturated, NOT dimmed).
magick "${OUT}.png" -modulate 100,0 "${PNG8[@]}" "${OUT}_sw.png"
echo "wrote ${OUT}.png (+_sw) mode=$MODE glow=$GLOW frame=$(basename "$FRAME")"
