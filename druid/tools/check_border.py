#!/usr/bin/env python3
"""Verify a 56x56 perk icon keeps the canonical frame's rim/outside intact.

Heuristic (per the icon spec): the rim ring + the area OUTSIDE the disc must match the blank frame
(blank_passive_ac.png) almost everywhere. A few pixels may differ where a subject (apex ears, leaf
tips) deliberately spills over the rim — but that must be a small minority, and in HARD-CLIP mode it
must be ~zero.

Two checks:
  1. RIM RING  (r in [RIM_LO, RIM_HI]): fraction of pixels whose RGBA ~= blank's must be >= --rim-min.
  2. OUTSIDE   (r > OUT_R): pixels that are opaque in the icon but transparent in blank = "spill".
     Reported as count; --max-spill caps it (0 for hard-clip mode).

Exit 0 if all thresholds pass, else 1. Prints a short report.
"""
import sys, argparse
import numpy as np
from PIL import Image

BLANK = "/home/suor/projects/bbm/3rdparty/AC/gfx/blank_passive_ac.png"
RIM_LO, RIM_HI = 24.0, 27.5   # rim ring radius band (from alpha profile of the blank frame)
OUT_R = 27.5                  # beyond this = outside the rim
TOL = 24                      # per-channel RGBA tolerance for "same pixel"

def load(path):
    return np.asarray(Image.open(path).convert("RGBA"), dtype=np.int16)

def radii(h, w):
    cy, cx = (h-1)/2, (w-1)/2
    yy, xx = np.mgrid[0:h, 0:w]
    return np.sqrt((xx-cx)**2 + (yy-cy)**2)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("icon")
    ap.add_argument("--blank", default=BLANK)
    ap.add_argument("--rim-min", type=float, default=0.90,
                    help="min fraction of rim-ring pixels that must match the blank frame")
    ap.add_argument("--max-spill", type=int, default=40,
                    help="max #opaque pixels allowed outside the rim (0 = hard-clip)")
    a = ap.parse_args()

    icon = load(a.icon); blank = load(a.blank)
    if icon.shape != blank.shape:
        print(f"FAIL size {icon.shape} != blank {blank.shape}"); return 1
    h, w, _ = icon.shape
    r = radii(h, w)

    # 1) rim ring match
    ring = (r >= RIM_LO) & (r <= RIM_HI)
    diff = np.abs(icon - blank).max(axis=2)        # max channel diff per pixel
    same = diff <= TOL
    rim_match = same[ring].mean() if ring.any() else 1.0

    # 2) outside-rim spill: opaque in icon, transparent in blank
    outside = r > OUT_R
    icon_op = icon[:, :, 3] > 30
    blank_tr = blank[:, :, 3] <= 30
    spill = int((outside & icon_op & blank_tr).sum())

    ok_rim = rim_match >= a.rim_min
    ok_spill = spill <= a.max_spill
    status = "OK" if (ok_rim and ok_spill) else "FAIL"
    print(f"{status}  rim_match={rim_match*100:.1f}% (min {a.rim_min*100:.0f}%)  "
          f"outside_spill={spill}px (max {a.max_spill})  [{a.icon}]")
    return 0 if (ok_rim and ok_spill) else 1

if __name__ == "__main__":
    sys.exit(main())
