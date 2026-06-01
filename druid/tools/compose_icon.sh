#!/usr/bin/env bash
# Compose a 56x56 round icon from a clean SUBJECT cut-out (on solid #00d000) onto a FRAME, with two
# clipping modes and an optional soft glow behind the subject.
#
#   layers: disc/frame  ->  [glow]  ->  subject (clipped per MODE)
#
# MODES:
#   clip  (default) — subject hard-clipped to the disc circle (radius DISCR). NOTHING crosses the
#                     rim (e.g. a sickle handle gets cut at the border). Safest, frame stays pristine.
#   over            — subject clipped to a circle slightly WIDER than the rim (radius DISCR+OVER), so
#                     chosen parts (apex ears, leaf tips) spill a little over the rim but nothing
#                     strays to the corners.
#
# The FRAME is composited from a canonical file (default the gold background frame). The frame goes
# UNDER the subject in 'over' mode (so the subject overlaps the rim) and the subject is clipped to
# the disc in 'clip' mode then laid over the frame.
#
# Usage: tools/compose_icon.sh <subject.png> <out_base> [frame.png]
#   env: MODE=clip|over (default clip), HEAD=subject %% (default 78), YOFF=px,
#        DISCR=disc radius (default 24), OVER=extra radius for 'over' (default 3),
#        GLOW=0|1 (default 1) soft light halo under the subject, GLOWC=glow colour (default #b9a06a),
#        USM/SHP/SAT/CON sharpen/colour knobs.
set -euo pipefail
IN="${1:?subject png}"; OUT="${2:?out base}"
FRAME="${3:-/home/suor/projects/bbm/mods/druid/gfx/druid/_refs/background_template.png}"
SIZE=56; FUZZ="${FUZZ:-22%}"
MODE="${MODE:-clip}"; HEAD="${HEAD:-78}"; YOFF="${YOFF:-0}"
DISCR="${DISCR:-24}"; OVER="${OVER:-3}"
GLOW="${GLOW:-1}"; GLOWC="${GLOWC:-#b9a06a}"
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

# 3) Optional soft glow: a faint light halo, the subject's silhouette blurred WIDE and kept dim, so
#    it only lifts the subject off the dark disc near its edges (like vanilla bg icons) — not a fill.
#    GLOWR = blur sigma (default 4), GLOWA = peak opacity %% (default 30).
GLOWR="${GLOWR:-4}"; GLOWA="${GLOWA:-30}"
GLOWF=$(awk "BEGIN{printf \"%.3f\", $GLOWA/100}")
if [[ "$GLOW" == "1" ]]; then
  magick "$tmp/subj.png" -channel A -separate +channel \
    -blur 0x${GLOWR} -evaluate multiply "$GLOWF" "$tmp/glowmask.png"
  magick -size "${SIZE}x${SIZE}" "xc:${GLOWC}" "$tmp/glowmask.png" -alpha off -compose copyopacity -composite \
    \( -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$RP" \) -alpha set -compose dstin -composite \
    "$tmp/glow.png"
fi

# 4) Layer: frame -> [glow over disc only] -> subject.
magick "$FRAME" -resize "${SIZE}x${SIZE}" "$tmp/frame.png"
if [[ "$GLOW" == "1" ]]; then
  magick "$tmp/frame.png" "$tmp/glow.png" -gravity center -compose over -composite \
    "$tmp/subj.png" -gravity center -compose over -composite "${PNG8[@]}" "${OUT}.png"
else
  magick "$tmp/frame.png" "$tmp/subj.png" -gravity center -compose over -composite "${PNG8[@]}" "${OUT}.png"
fi
magick "${OUT}.png" -modulate 100,0 "${PNG8[@]}" "${OUT}_sw.png"
echo "wrote ${OUT}.png (+_sw) mode=$MODE glow=$GLOW"
