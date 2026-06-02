#!/usr/bin/env python3
"""Mechanically verify a disc sits perfectly inside a rim.

Checks, from the alpha channels alone:
  - POKE: disc pixels that fall OUTSIDE the rim's outer edge (disc sticking out past the rim).
  - GAP:  transparent pixels enclosed by the rim that the disc does NOT cover (a hole/ring
          between the disc and the rim).

Usage: check_disc.py <rim.png> <disc.png>
Exit code 0 if clean (no poke, no gap), 1 otherwise.
"""
import sys
from collections import deque
import numpy as np
from PIL import Image

THRESH = 128  # alpha considered "opaque"


def alpha(path):
    return np.array(Image.open(path).convert("RGBA"))[:, :, 3]


def flood_outside(rim_mask):
    """Pixels reachable from the border through NON-rim cells (the area outside the rim)."""
    h, w = rim_mask.shape
    out = np.zeros((h, w), bool)
    q = deque()
    for x in range(w):
        for y in (0, h - 1):
            if not rim_mask[y, x] and not out[y, x]:
                out[y, x] = True; q.append((y, x))
    for y in range(h):
        for x in (0, w - 1):
            if not rim_mask[y, x] and not out[y, x]:
                out[y, x] = True; q.append((y, x))
    while q:
        y, x = q.popleft()
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ny, nx = y + dy, x + dx
            if 0 <= ny < h and 0 <= nx < w and not out[ny, nx] and not rim_mask[ny, nx]:
                out[ny, nx] = True; q.append((ny, nx))
    return out


def main():
    rim = alpha(sys.argv[1]) >= THRESH
    disc = alpha(sys.argv[2]) >= THRESH

    outside = flood_outside(rim)
    inside = ~outside                 # rim ring + enclosed hole
    hole = inside & ~rim              # enclosed transparent area
    poke = disc & outside             # disc past the rim
    gap = hole & ~disc                # enclosed transparent not covered by disc

    np_ = int(poke.sum()); ng = int(gap.sum())
    print(f"{sys.argv[2]}: poke(out past rim)={np_}px  gap(uncovered hole)={ng}px", end="  ")
    if np_ == 0 and ng == 0:
        print("=> OK")
        return 0
    print("=> FAIL")
    return 1


if __name__ == "__main__":
    sys.exit(main())
