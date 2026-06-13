#!/usr/bin/env bash
# Sample colours FROM a reference image instead of eyeballing a hex value. When you need to match a
# colour from vanilla art (a disc glow, a tint), pull the actual numbers — do not guess `#a82a18` and
# discover three rounds later that the real colour was a purer/deeper red. See SKILL.md.
#
# Modes:
#   sample_color.sh <img.png>                  -> top palette colours (most-frequent first), as hex + rgb
#   sample_color.sh <img.png> x,y [x,y ...]    -> exact pixel colour(s) at the given coordinates
#   N=12 sample_color.sh <img.png>             -> palette reduced to N colours (default 12)
set -euo pipefail
IMG="${1:?image png}"; shift || true
if (( $# )); then
  for xy in "$@"; do
    printf '%s = %s\n' "$xy" "$(magick "$IMG" -format "%[pixel:p{${xy}}]" info:)"
  done
else
  N="${N:-12}"
  # frequency-sorted palette; print count, hex, rgba for each colour
  magick "$IMG" -alpha off -colors "$N" -depth 8 -format "%c" histogram:info: \
    | sed -E 's/^[[:space:]]+//' \
    | sort -rn \
    | sed -E 's/.*(#[0-9A-Fa-f]{6,8}).*(srgba?\([0-9., ]+\)).*/\1  \2/'
fi
