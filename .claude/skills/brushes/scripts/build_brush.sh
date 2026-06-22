#!/usr/bin/env bash
# TEMPLATE — build a <name>.brush + gfx/<name>.png by vendoring sprites out of an existing brush.
# Copy this into your mod, adapt the marked sections, and run by hand (it is dev-only, not a SOURCE).
# Requires wine + ~/projects/bbm/3rdparty/bbrusher.exe. See ../SKILL.md for the why behind each step.
#
# The canonical, fully-worked instance of this template is druid/build_beast_brush.sh.
set -euo pipefail
cd "$(dirname "$0")"            # run from the mod dir; adjust if you keep the script elsewhere

# --- adapt these ------------------------------------------------------------
NAME=my_brush                                              # output: brushes/$NAME.brush + gfx/$NAME.png
SOURCE_BRUSH=../../3rdparty/fantasy/brushes/entity_xx.brush  # brush to vendor sprites from
BBRUSHER=../../3rdparty/bbrusher.exe
# ----------------------------------------------------------------------------

WORK=$(mktemp -d)
SRC="$WORK/unpack"            # where the source brush is exploded
IN="$WORK/in"                 # staging dir we pack from (PNGs + metadata.xml)
mkdir -p "$IN"

shh() { grep -v "libEGL\|pci id\|fixme\|dri2 screen\|^$" || true; }   # silence wine noise

# 1. Unpack the source brush to get its PNGs + the metadata.xml with correct geometry.
wine "$BBRUSHER" unpack "$SOURCE_BRUSH" "$SRC" 2>&1 | shh
SUB="$SRC/witch"             # source PNGs live in a group subdir; check `ls "$SRC"` for its name

# 2. Copy the PNGs you want under NEW (renamed) ids, into the staging dir.
#    Rename to avoid colliding with the source brush's sprite ids at runtime.
cp "$SUB/bust_naked_body_7873.png"      "$IN/${NAME}_body_01.png"
cp "$SUB/bust_naked_body_7873_dead.png" "$IN/${NAME}_body_01_dead.png"
# ... copy the rest of your sprite set the same way ...

# 3. Write metadata.xml. ONE <sprite> per PNG above. Copy width/height/left/right/top/bottom/offset*/ic
#    (and f/f1/f2 on _dead variants) VERBATIM from the matching lines in "$SRC/metadata.xml" —
#    only id (renamed) and img (your filename) change. `name` is the output atlas path.
cat > "$IN/metadata.xml" <<XML
<brush name="gfx/${NAME}.png" version="17" b1="2" b5="0">
  <sprite id="${NAME}_body_01" offsetY="35" ic="FF4D7193" width="104" height="142" img="${NAME}_body_01.png" left="-42" right="40" top="-49" bottom="9" />
  <sprite id="${NAME}_body_01_dead" offsetX="6" offsetY="10" ic="FF374D74" width="131" height="114" img="${NAME}_body_01_dead.png" left="-65" right="66" top="-57" bottom="53" />
  <!-- ... one line per PNG, geometry copied from $SRC/metadata.xml ... -->
</brush>
XML

# 4. Pack. With no --gfxPath, the atlas lands at the parent-of-brushes/ + the manifest's name,
#    i.e. gfx/$NAME.png — the standard mod layout.
mkdir -p brushes
wine "$BBRUSHER" pack "brushes/${NAME}.brush" "$IN" 2>&1 | shh
echo "Built brushes/${NAME}.brush + gfx/${NAME}.png"

# 5. (optional) verify round-trip: wine "$BBRUSHER" unpack brushes/${NAME}.brush /tmp/verify_${NAME}
rm -rf "$WORK"
