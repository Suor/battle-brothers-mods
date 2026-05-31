#!/usr/bin/env bash
# Convenience wrapper: render the "pack" (egg clutch) perk icon at a given size/offset
# and build a framed preview so the finished icon (with its thin rim) is easy to eyeball.
#
# Usage: pack_preview.sh [HEAD] [YOFF] [SUBJECT]
#   HEAD    subject size as % of icon (default 96)
#   YOFF    vertical offset, + = down (default 2)
#   SUBJECT source art (default = game spider-egg nest sprite)
#
# Output:
#   gfx/druid/_gen/eggs.png          (+ _sw)  the icon at game size (56px)
#   gfx/druid/_gen/_eggs_preview.png  framed preview (zoomed + actual size), 8-bit
set -euo pipefail
D="$(cd "$(dirname "$0")/.." && pwd)"

HEAD=${1:-96}
YOFF=${2:-2}
SUBJECT=${3:-/home/suor/projects/bbm/base/unpacked_brushes/entity_4/entity/beasts/nest_01.png}
RIM="$D/gfx/druid/_gen/rim_c.png"
OUT="$D/gfx/druid/_gen/eggs"

HEAD=$HEAD YOFF=$YOFF USM=1.5x1.2+1.6+0 SHP=0x0.8 \
  bash "$D/tools/icon_postprocess.sh" "$SUBJECT" "$OUT" "$RIM" >/dev/null

# Framed preview: zoomed icon (left) + actual game-size icon (right) on a dark panel.
magick \
  \( "$OUT.png" -filter point -resize 224x224 -background '#1b1714' -gravity center -extent 256x256 \) \
  \( "$OUT.png" -background '#1b1714' -gravity center -extent 96x256 \) \
  +append -bordercolor '#6b5a3a' -border 2 \
  -strip -depth 8 png24:"$D/gfx/druid/_gen/_eggs_preview.png"

echo "icon : $OUT.png  (HEAD=$HEAD YOFF=$YOFF rim=rim_c)"
echo "view : $D/gfx/druid/_gen/_eggs_preview.png"
