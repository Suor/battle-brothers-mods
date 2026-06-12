#!/usr/bin/env bash
# Dev-only: build brushes/druid_beast.brush + gfx/druid_beast.png from Fantasy Brothers' "Baku"
# sprites, so Beastform's look ships with the druid mod and needs no Fantasy Brothers at runtime.
# Sprite IDs are renamed (druid_beast_*) to avoid colliding with Fantasy Brothers' entity_xx brush.
# Not part of SOURCES - run by hand when the asset set changes. Requires wine + ../../3rdparty.
set -euo pipefail
cd "$(dirname "$0")"

FANTASY_BRUSH=../../3rdparty/fantasy/brushes/entity_xx.brush
BBRUSHER=../../3rdparty/bbrusher.exe
WORK=$(mktemp -d)
SRC="$WORK/unpack"
IN="$WORK/in"
mkdir -p "$IN"

# 1. Unpack Fantasy Brothers' atlas to get the source PNGs.
wine "$BBRUSHER" unpack "$FANTASY_BRUSH" "$SRC" >/dev/null 2>&1 || true
W="$SRC/witch"

# 2. Copy the needed PNGs under druid_beast_* names and write a metadata.xml subset.
cp "$W/bust_naked_body_7873.png"        "$IN/druid_beast_body_01.png"
cp "$W/bust_naked_body_7873_dead.png"   "$IN/druid_beast_body_01_dead.png"
cp "$W/bust_naked_body_7870_injured.png" "$IN/druid_beast_body_01_injured.png"
cp "$W/bust_naked_body_7874.png"        "$IN/druid_beast_body_02.png"
cp "$W/bust_naked_body_7873_dead.png"   "$IN/druid_beast_body_02_dead.png"
cp "$W/bust_naked_body_7870_injured.png" "$IN/druid_beast_body_02_injured.png"
cp "$W/bust_head_7880.png"              "$IN/druid_beast_head_01.png"
cp "$W/bust_head_7880_dead.png"         "$IN/druid_beast_head_01_dead.png"
cp "$W/bust_head_7881.png"              "$IN/druid_beast_head_02.png"
cp "$W/bust_head_7880_dead.png"         "$IN/druid_beast_head_02_dead.png"
cp "$W/bust_head_7882.png"              "$IN/druid_beast_head_03.png"
cp "$W/bust_head_7880_dead.png"         "$IN/druid_beast_head_03_dead.png"
for n in 01 02 03 04 05; do
    cp "$W/hair_beast_$n.png"           "$IN/druid_beast_hair_$n.png"
    cp "$W/hair_beast_01_dead.png"      "$IN/druid_beast_hair_${n}_dead.png"
done

cat > "$IN/metadata.xml" <<'XML'
<brush name="gfx/druid_beast.png" version="17" b1="2" b5="0">
  <sprite id="druid_beast_body_01" offsetY="35" ic="FF4D7193" width="104" height="142" img="druid_beast_body_01.png" left="-42" right="40" top="-49" bottom="9" />
  <sprite id="druid_beast_body_01_dead" offsetX="6" offsetY="10" ic="FF374D74" width="131" height="114" img="druid_beast_body_01_dead.png" left="-65" right="66" top="-57" bottom="53" />
  <sprite id="druid_beast_body_01_injured" offsetY="35" ic="FF0E0E55" width="104" height="142" img="druid_beast_body_01_injured.png" left="-41" right="39" top="-50" bottom="10" />
  <sprite id="druid_beast_body_02" offsetY="35" ic="FF4D7200" width="104" height="142" img="druid_beast_body_02.png" left="-42" right="40" top="-50" bottom="10" />
  <sprite id="druid_beast_body_02_dead" offsetX="6" offsetY="10" ic="FF4D7201" width="131" height="114" img="druid_beast_body_02_dead.png" left="-65" right="66" top="-57" bottom="53" />
  <sprite id="druid_beast_body_02_injured" offsetY="35" ic="FF4D7204" width="104" height="142" img="druid_beast_body_02_injured.png" left="-41" right="39" top="-50" bottom="10" />
  <sprite id="druid_beast_head_01" offsetY="35" ic="FF5E81D0" width="104" height="142" img="druid_beast_head_01.png" left="-26" right="34" top="-23" bottom="51" />
  <sprite id="druid_beast_head_01_dead" offsetX="6" offsetY="10" f="64F6" f1="-15" f2="-15" ic="FF5675A0" width="131" height="125" img="druid_beast_head_01_dead.png" left="-45" right="15" top="-57" bottom="1" />
  <sprite id="druid_beast_head_02" offsetY="35" ic="FF5E81D1" width="104" height="142" img="druid_beast_head_02.png" left="-26" right="34" top="-23" bottom="51" />
  <sprite id="druid_beast_head_02_dead" offsetX="6" offsetY="10" f="64F6" f1="-15" f2="-15" ic="FF5675A1" width="131" height="125" img="druid_beast_head_02_dead.png" left="-45" right="15" top="-57" bottom="1" />
  <sprite id="druid_beast_head_03" offsetY="35" ic="FF5E81D2" width="104" height="142" img="druid_beast_head_03.png" left="-26" right="34" top="-23" bottom="51" />
  <sprite id="druid_beast_head_03_dead" offsetX="6" offsetY="10" f="64F6" f1="-15" f2="-15" ic="FF5675A2" width="131" height="125" img="druid_beast_head_03_dead.png" left="-45" right="15" top="-57" bottom="1" />
  <sprite id="druid_beast_hair_01" offsetY="35" ic="FF1F3770" width="104" height="142" img="druid_beast_hair_01.png" left="-36" right="42" top="-10" bottom="54" />
  <sprite id="druid_beast_hair_01_dead" offsetX="6" offsetY="10" f="64F2" f1="-15" f2="-15" ic="FF293E51" width="131" height="125" img="druid_beast_hair_01_dead.png" left="-50" right="16" top="-61" bottom="9" />
  <sprite id="druid_beast_hair_02" offsetY="35" ic="FF1F3771" width="104" height="142" img="druid_beast_hair_02.png" left="-36" right="42" top="-10" bottom="54" />
  <sprite id="druid_beast_hair_02_dead" offsetX="6" offsetY="10" f="64F2" f1="-15" f2="-15" ic="FF293E52" width="131" height="125" img="druid_beast_hair_02_dead.png" left="-50" right="16" top="-61" bottom="9" />
  <sprite id="druid_beast_hair_03" offsetY="35" ic="FF1F3772" width="104" height="142" img="druid_beast_hair_03.png" left="-26" right="34" top="-23" bottom="51" />
  <sprite id="druid_beast_hair_03_dead" offsetX="6" offsetY="10" f="64F2" f1="-15" f2="-15" ic="FF293E53" width="131" height="125" img="druid_beast_hair_03_dead.png" left="-50" right="16" top="-61" bottom="9" />
  <sprite id="druid_beast_hair_04" offsetY="35" ic="FF1F3773" width="104" height="142" img="druid_beast_hair_04.png" left="-27" right="45" top="-15" bottom="51" />
  <sprite id="druid_beast_hair_04_dead" offsetX="6" offsetY="10" f="64F2" f1="-15" f2="-15" ic="FF293E54" width="131" height="125" img="druid_beast_hair_04_dead.png" left="-50" right="16" top="-61" bottom="9" />
  <sprite id="druid_beast_hair_05" offsetY="35" ic="FF1F3774" width="104" height="142" img="druid_beast_hair_05.png" left="-27" right="45" top="-15" bottom="51" />
  <sprite id="druid_beast_hair_05_dead" offsetX="6" offsetY="10" f="64F2" f1="-15" f2="-15" ic="FF293E55" width="131" height="125" img="druid_beast_hair_05_dead.png" left="-50" right="16" top="-61" bottom="9" />
</brush>
XML

# 3. Pack into brushes/druid_beast.brush; the atlas lands at gfx/druid_beast.png (parent of brushes/).
mkdir -p brushes
wine "$BBRUSHER" pack brushes/druid_beast.brush "$IN" >/dev/null 2>&1
echo "Built brushes/druid_beast.brush + gfx/druid_beast.png"
rm -rf "$WORK"
