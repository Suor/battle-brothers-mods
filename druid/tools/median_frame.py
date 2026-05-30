#!/usr/bin/env python3
"""Extract the common frame shared by many icons via a per-pixel median.

The art differs from icon to icon, so it averages/cancels; the frame is the same in all of
them, so it survives the median crisply.

Usage: median_frame.py <out.png> <icon1.png> <icon2.png> ...
"""
import sys
import numpy as np
from PIL import Image

out = sys.argv[1]
paths = sys.argv[2:]
arrs = [np.array(Image.open(p).convert("RGBA").resize((56, 56))) for p in paths]
stack = np.stack(arrs).astype(np.float32)
med = np.median(stack, axis=0).astype(np.uint8)
Image.fromarray(med, "RGBA").save(out)
print(f"median of {len(paths)} icons -> {out}")
