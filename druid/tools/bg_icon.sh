#!/usr/bin/env bash
# Compose a BACKGROUND (origin) icon the way vanilla ones look: a single object on a softly lit disc,
# inside the game's standard gold rim. The base (rim + flat #111 disc) is the game's actual
# background_template.png, so the rim matches the game EXACTLY (codex-drawn rims come out too thin,
# and a median of vanilla icons blurs the ring a pixel thinner than the original).
#
# Layering, bottom-up:
#   1. template       (vanilla gold rim + flat dark disc) — used ONCE, so its anti-aliased outer
#                      edge is never doubled (compositing it twice darkened the pixels outside the rim)
#   2. warm glow       a soft radial lift in the disc centre, clipped to the disc interior
#   3. subject cut-out (green keyed, trimmed, scaled, sharpened), clipped to the disc interior so it
#                      never touches the gold ring — no second rim layer needed
#
# Usage: tools/bg_icon.sh <subject_art.png> <out_basename>
#   env: SUBJ = subject size as % of icon (default 80), YOFF = vertical offset px (+=down, default 0)
#        GLOW = 0 to disable the centre glow (default on)
#        USM/SHP/SAT/CON = sharpen/colour knobs (same as the other tools)
set -euo pipefail
IN="${1:?subject art}"; OUT="${2:?out base}"
SIZE=56; FUZZ=22%
SUBJ="${SUBJ:-80}"; YOFF="${YOFF:-0}"; GLOW="${GLOW:-1}"
USM="${USM:-1.5x1.2+1.6+0}"; SHP="${SHP:-0x0.8}"; SAT="${SAT:-100}"; CON="${CON:-0}"
# The game's real background frame: thick gold rim + flat dark disc, interior ~52x52+2+2.
TEMPLATE="${TEMPLATE:-/home/suor/projects/bbm/mods/druid/gfx/druid/_refs/background_template.png}"
# Disc interior radius: the dark disc spans radius ~23.5 (gold ring is outside that). Glow + subject
# are clipped to this so they stay strictly inside the ring and never spill onto / past the gold.
DISCR="${DISCR:-23}"
CADJ=(-modulate "100,$SAT"); [[ "$CON" != "0" ]] && CADJ+=(-sigmoidal-contrast "${CON}x50%")
PNG8=(-depth 8 -define png:color-type=6 -define png:bit-depth=8)
C=$(awk "BEGIN{print ($SIZE-1)/2}")
RP=$(awk "BEGIN{print $C-$DISCR}")

mkdir -p "$(dirname "$OUT")"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# Clean copy of the template (strips a broken iCCP profile some vanilla PNGs carry). This is the base.
magick "$TEMPLATE" -strip -resize "${SIZE}x${SIZE}" "$tmp/bg.png" 2>/dev/null

# Interior mask: a filled circle the size of the dark disc. Glow + subject are masked to this.
magick -size "${SIZE}x${SIZE}" xc:none -fill white -draw "circle $C,$C $C,$RP" "$tmp/disc_mask.png"

# 1) Warm radial glow lifting the disc centre, clipped to the interior, laid over the template.
if [[ "$GLOW" != "0" ]]; then
  magick -size "${SIZE}x${SIZE}" radial-gradient:'#2e2a24'-'none' \
    "$tmp/disc_mask.png" -alpha off -compose copyopacity -composite "$tmp/glow.png"
  magick "$tmp/bg.png" "$tmp/glow.png" -gravity center -compose over -composite "$tmp/bg.png"
fi

# 2) Subject: key green, trim, scale, sharpen, offset, then clip to the disc interior.
W=$(magick identify -format "%w" "$IN"); H=$(magick identify -format "%h" "$IN")
magick "$IN" -alpha set -fuzz "$FUZZ" -fill none \
  -draw "alpha 0,0 floodfill" -draw "alpha $((W-1)),0 floodfill" \
  -draw "alpha 0,$((H-1)) floodfill" -draw "alpha $((W-1)),$((H-1)) floodfill" "$tmp/k.png"
magick "$tmp/k.png" -trim +repage "$tmp/t.png"
sz=$(( SIZE * SUBJ / 100 ))
magick "$tmp/t.png" -resize "${sz}x${sz}" -unsharp "$USM" -sharpen "$SHP" "${CADJ[@]}" "$tmp/subj_s.png"
magick -size "${SIZE}x${SIZE}" xc:none "$tmp/subj_s.png" \
  -gravity center -geometry "+0+${YOFF}" -compose over -composite \
  "$tmp/disc_mask.png" -compose dstin -composite "$tmp/subj.png"

# Compose: template(+glow) -> subject. No top rim layer — subject is clipped inside the ring.
magick "$tmp/bg.png" "$tmp/subj.png" -gravity center -compose over -composite "${PNG8[@]}" "${OUT}.png"
magick "${OUT}.png" -modulate 100,0 "${PNG8[@]}" "${OUT}_sw.png"
echo "wrote ${OUT}.png and ${OUT}_sw.png (${SIZE}x${SIZE})"
