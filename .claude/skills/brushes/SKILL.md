---
name: brushes
description: |
  Extract from and build Battle Brothers `.brush` sprite-sheet files with bbrusher (the engine's
  atlas tool). A `.brush` is an XML manifest pointing at a packed `gfx/<name>.png` atlas; sprites are
  referenced at runtime by id via `setBrush("sprite_id")` / `getSprite(...).setBrush(...)`.
  TRIGGER when: vendoring sprites from another mod/the base game into your own brush, building a new
  `.brush` + atlas PNG, inspecting/extracting sprites from an existing `.brush`, or wiring a custom
  body/head/hair/socket look (e.g. a Beastform transformation).
  SKIP: ordinary `gfx/*.png` icons that are not part of a sprite sheet (use the `bb-icons` skill),
  code-only changes, translations.
---

# Battle Brothers brush pipeline

A **brush** is the engine's sprite-atlas format. Two files always travel together:

- `brushes/<name>.brush` — an XML manifest: a `<brush>` root plus one `<sprite>` per image, each
  carrying the sprite **id** and its geometry (size, bounding box, draw offsets).
- `gfx/<name>.png` — the packed atlas the manifest references via its `name="gfx/<name>.png"` attr.

At runtime sprites are addressed **by id**, never by filename:

```squirrel
body.setBrush("druid_beast_body_01");                 // swap a layer's sprite
_actor.getSprite("hair").setBrush("druid_beast_hair_03");
_actor.getSprite("injury_body").setBrush(body.getBrush().Name + "_injured");
```

So a sprite id is a global key in the engine's brush table. **When vendoring sprites out of another
brush, rename the ids** (e.g. `bust_naked_body_7873` → `druid_beast_body_01`) so your atlas doesn't
collide with the source mod's brush if both load.

## Tooling: bbrusher via wine

`bbrusher.exe` lives at `../../3rdparty/bbrusher.exe` (relative to a mod dir, i.e.
`~/projects/bbm/3rdparty/bbrusher.exe`). It's a .NET exe; **mono is not installed — run it under
`wine`**. wine spews `libEGL`/`pci id`/`fixme` noise to stderr; filter it:

```bash
wine ../../3rdparty/bbrusher.exe <cmd> ... 2>&1 \
  | grep -v "libEGL\|pci id\|fixme\|dri2 screen\|^$"
```

Two subcommands:

```
bbrusher unpack [--gfxPath <dir>] <file.brush> [<outputDir>]
bbrusher pack   [--gfxPath <dir>] <file.brush> <inputDir>
```

- **unpack** explodes the atlas into individual PNGs + a `metadata.xml` describing each sprite. PNGs
  land in a subdir named after the brush's internal group (e.g. `witch/`).
- **pack** reads `<inputDir>/metadata.xml`, packs every referenced PNG into a fresh atlas, and writes
  the `.brush` manifest. (Help text says "sprites.xml" but the real, working filename — the one unpack
  emits and pack reads — is **`metadata.xml`**.)
- `--gfxPath` sets where the atlas PNG is read from / written to. **Omitted, it defaults to the parent
  of the dir holding the `.brush` file.** So `pack brushes/foo.brush <in>` with a manifest declaring
  `name="gfx/foo.png"` writes the atlas to `<modroot>/gfx/foo.png` — exactly the standard mod layout.

## Extracting sprites from an existing brush

To find sprites and their exact geometry (so a vendored subset renders identically):

```bash
wine ../../3rdparty/bbrusher.exe unpack \
  ../../3rdparty/fantasy/brushes/entity_xx.brush /tmp/xx_unpack 2>&1 \
  | grep -v "libEGL\|pci id\|fixme\|dri2 screen\|^$"

ls /tmp/xx_unpack/witch/ | grep -iE "bust_naked_body|hair_beast"   # the PNGs
grep -iE "hair_beast_0|bust_head_788" /tmp/xx_unpack/metadata.xml   # their <sprite> lines
```

The `metadata.xml` `<sprite>` lines are the gold here — **copy their exact attributes**
(`width/height`, `left/right/top/bottom`, `offsetX/offsetY`, `ic`, and the `f/f1/f2` flags on `_dead`
variants) into your own manifest. Those numbers are the sprite's bounding box and draw anchors; guess
them and the sprite sits wrong. Only change `id` (rename to avoid collisions) and `img` (your new
filename).

## Building your own brush

`scripts/build_brush.sh` is a documented, parametrised template of the real build that produced
`druid/brushes/druid_beast.brush`. The shape of every brush build is the same three steps:

1. **Unpack the source** brush to get its PNGs + correct per-sprite metadata.
2. **Stage an input dir**: copy the PNGs you want under your new names, and write a `metadata.xml`
   whose `<brush name="gfx/<yourname>.png" version="17" b1="2" b5="0">` lists one `<sprite>` per PNG —
   ids renamed, geometry copied verbatim from step 1.
3. **Pack** the input dir into `brushes/<yourname>.brush`; the atlas auto-lands at `gfx/<yourname>.png`.

Worked example — the druid Beastform look — lives at `druid/build_beast_brush.sh` (kept in the mod as
the canonical, runnable reference). Read it alongside this skill.

### Manifest format (`metadata.xml`)

```xml
<brush name="gfx/druid_beast.png" version="17" b1="2" b5="0">
  <sprite id="druid_beast_body_01" offsetY="35" ic="FF4D7193"
          width="104" height="142" img="druid_beast_body_01.png"
          left="-42" right="40" top="-49" bottom="9" />
  <sprite id="druid_beast_body_01_dead" offsetX="6" offsetY="10" ic="FF374D74"
          width="131" height="114" img="druid_beast_body_01_dead.png"
          left="-65" right="66" top="-57" bottom="53" />
  <!-- _dead variants of heads/hair also carry f="64F6" f1="-15" f2="-15" -->
</brush>
```

- `name` — output atlas path, relative to `--gfxPath` (or its default). Keep it `gfx/<name>.png`.
- `version="17" b1="2" b5="0"` — brush-format constants; copy as-is.
- per `<sprite>`: `id` (runtime key, **rename when vendoring**), `img` (PNG filename in the input dir),
  and the geometry block copied from the source's unpacked metadata.

### Conventions for actor-look sprites

Bust layers come in id triples the engine looks up by suffix — keep all three per body:

- `<base>` — the normal sprite
- `<base>_dead` — corpse variant (different bounding box; `_dead` heads/hair add the `f/f1/f2` flags)
- `<base>_injured` — bloodied variant (`setBrush(getBrush().Name + "_injured")`)

## Shipping it

- Add `brushes` to the mod's `SOURCES` in its `Makefile` (the `.brush` ships; the atlas is under
  `gfx`, already a source dir). Example: `SOURCES = brushes gfx druid scripts ui`.
- The build script itself is **dev-only — do not add it to SOURCES.** Run it by hand when the asset
  set changes; commit the resulting `.brush` + `gfx/*.png`.
- Verify a built brush round-trips: `bbrusher unpack brushes/<name>.brush /tmp/verify` and check your
  ids/PNGs are present.
- See `[[backup-before-redo]]`: snapshot the existing `.brush` + atlas before re-running a build, since
  pack overwrites both in place.
