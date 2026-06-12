#!/usr/bin/env bash
# Shared glow presets for the BB icon composers (sourced by compose_perk.sh / compose_background.sh).
#
# A "glow" is a soft radial light in the disc CENTRE that fades to the near-black rim — vanilla discs
# carry one, and it differs by icon type (measured from real game art):
#   background  bright grey centre glow (origin discs)
#   perk        faint warm disc lift (most perks are dark with a subtle warm centre)
#   trait       even fainter warm lift
#   mastery     bright blue burst (all vanilla weapon masteries use the blue perk_10 icon)
#   none        flat solid dark disc (also: 0 | off | solid)
#
# glow_preset NAME sets GLOW_COLOR (radial peak colour) and GLOW_POWER (alpha multiplier, 0 = off),
# WITHOUT clobbering values the caller already exported — so GLOW_COLOR/GLOW_POWER override the preset.
# Usage:  source "$D/scripts/_glow.sh";  GLOW="${GLOW:-perk}";  glow_preset "$GLOW"
glow_preset() {
  local c p
  case "$1" in
    0|none|off|solid) c=''; p=0 ;;
    background) c='#8a847e'; p=1.0 ;;
    perk)       c='#5a4326'; p=0.55 ;;
    trait)      c='#5a4326'; p=0.45 ;;
    mastery)    c='#4f78a0'; p=1.0 ;;
    *) echo "glow_preset: unknown GLOW '$1' (background|perk|trait|mastery|none)" >&2; return 2 ;;
  esac
  GLOW_COLOR="${GLOW_COLOR:-$c}"; GLOW_POWER="${GLOW_POWER:-$p}"
}
