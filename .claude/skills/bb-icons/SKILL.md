---
name: bb-icons
description: |
  Generate Battle Brothers 56x56 mod icons — perks, traits, backgrounds (origins), and active skills —
  by AI-generating a subject with codex and compositing it onto a canonical game frame.
  TRIGGER when: making/redoing an icon for a BB mod (perk/trait/background/active), turning a sprite or
  codex generation into a finished icon, or fixing an icon's frame/border/sharpness.
  SKIP: code-only changes, translations, non-icon art.
---

# Battle Brothers icon pipeline

Every BB icon is **a subject composited onto a canonical game frame**, downscaled to 56×56. We never
redraw the rim/frame — we lay the subject on top of (or clipped inside) a real game blank, so the
rim and the area outside it stay pixel-identical to vanilla. Two stages:

1. **Generate the subject** (codex image gen, on flat chroma-green `#00d000`, no frame) — or reuse a
   game sprite / an existing generation.
2. **Composite** it onto the right frame with the matching script in `scripts/`.

All scripts are self-contained: they resolve their frame assets from `assets/` next to them, write
`<out>.png` + a desaturated `<out>_sw.png` (the disabled/greyed icon), and force 8-bit RGBA.

## Icon types → script + frame

| Icon | Shape | Script | Frame (in `assets/`) |
|------|-------|--------|----------------------|
| Perk | round | `compose_perk.sh` | `blank_passive_ac.png` |
| Trait | round | `compose_perk.sh … assets/blank_trait_1_ac.png` | `blank_trait_1_ac.png` or `_2` |
| Active skill | **square** | `compose_active.sh` | `blank_active_ac.png` |
| Background (origin) | round, gold rim | `compose_background.sh` | `background_template.png` |

`compose_perk_overlay.sh` is a perk variant that takes a **body** + an **overlay** cut-out (e.g. soil
mound body + clean leaves overlay) when one layer must stay inside the rim and the other's tips spill
over it. `reframe.sh` rescues a generation that already has a baked (wrong) frame.

**A perk that grants an active needs BOTH** a round perk icon and a square active icon.

## Stage 1 — generate the subject with codex

Codex can generate and edit images (it has an image skill). Drive it non-interactively, the way
`/ask-bros` does — put the whole instruction in a prompt file and pass reference images with `-i`:

```bash
codex exec --sandbox workspace-write "$(cat prompt.txt)" -i ref1.png ref2.png
# iterate on the same gen:  codex exec resume --last --sandbox workspace-write "$(cat fix.txt)" -i ...
```

Prompt rules that worked (see `references/codex_prompts.md` for full templates):
- Tell it to **SAVE a PNG to an absolute path** and print/report nothing else; "Do not modify any
  other files."
- For a **fresh subject**: render it on a **solid flat `#00d000`** background, **no frame, no disc,
  no shadow, no vignette**, filling most of the canvas, compact within the central ~80% so nothing
  important reaches the corners (it gets clipped to a disc later). Ask for 512×512.
- Attach 1–3 **reference images** (vanilla `base/data_001/gfx/ui/perks/perk_*.png`, legends/reforged
  art) and say which aspects to copy: *style, palette, lighting, composition, shape* — and what must
  stay different (the subject).
- Bold, readable silhouette at tiny size; muted/desaturated earthy oil-paint palette, warm rim light.
- To **cut a subject out** of an existing icon, ask for the subject ONLY on `#00d000` (or fully
  transparent), preserving original pixels/position, eroding ~1px to kill the antialiased fringe.
- **Reuse the good base.** When redoing an icon, feed codex the *same* good generation and only fix
  the frame/background/sharpness — don't regenerate from scratch and get something wildly different.

## Stage 2 — composite

```bash
S="$CLAUDE_SKILL_DIR/scripts"   # the harness sets CLAUDE_SKILL_DIR to this skill's dir — no path math

# Perk (hard-clip — nothing crosses the rim):
"$S/compose_perk.sh" subject.png gfx/<mod>/perk_foo

# Perk, let ears/leaf-tips spill a little over the rim:
MODE=over OVER=3 HEAD=82 "$S/compose_perk.sh" subject.png gfx/<mod>/perk_foo

# Trait:
"$S/compose_perk.sh" subject.png gfx/<mod>/trait_foo "$CLAUDE_SKILL_DIR/assets/blank_trait_1_ac.png"

# Active (square, art fills the panel):
SQ=0.6 "$S/compose_active.sh" framed_gen.png gfx/<mod>/active_foo

# Background / origin:
SUBJ=78 "$S/compose_background.sh" subject.png gfx/<mod>/background_foo
```

Common env knobs (all scripts): `HEAD`/`SUBJ`/`SQ` = subject size, `YOFF` = vertical nudge,
`DISCR` = disc radius, and the **sharpen/colour** knobs below.

### Sharpness / contrast — tune via env, do NOT edit the scripts
Pass these as env vars per icon instead of editing scripts each time:
`USM` (unsharp), `SHP` (extra `-sharpen` sigma), `SAT` (saturation %), `CON` (sigmoidal contrast, 0=off).
The strong, crisp preset ("s3") used for most subjects is:
```bash
USM=1.5x1.2+1.6+0 SHP=0x0.8
```

## Stage 3 — verify, then look yourself

**Look at the result before showing the user or installing.** Build a preview and open it:

```bash
"$S/preview.sh" gfx/<mod>/_gen/_prev.png gfx/<mod>/perk_foo.png   # add old_icon.png to compare new-vs-old
```

Mechanical checks:
```bash
"$S/check_border.py" gfx/<mod>/perk_foo.png                 # rim/outside match the blank?
"$S/check_border.py" gfx/<mod>/perk_foo.png --max-spill 0   # hard-clip: zero spill
"$S/check_disc.py" rim.png disc.png                         # disc neither pokes past rim nor leaves a gap
```
`check_border` heuristic: most rim-ring + outside-rim pixels must equal the blank frame; only a few
may differ where a subject deliberately crosses the rim (`over` mode). In `clip` mode spill must be ~0.

## Hard-won rules (from real sessions — don't relearn these)

- **Never redraw the rim/frame.** Compose onto the real game blank. Codex-drawn rims are too thin;
  hand-drawn discs leave grey junk around the circle and a border that doesn't match vanilla.
- **Never overwrite an existing/vetted icon** with something unvetted. Write to a new name or to a
  scratch dir, show the user, install only once approved.
- **BACK UP BEFORE REDOING.** When re-rendering or fixing an icon, FIRST snapshot the current `out/`
  to `bak/<timestamp>/` — never clobber the previous version in place. A tuning pass can break what
  worked (a glow change can spill past the rim); without a backup the prior good version is gone.
- **Workspace layout** (per mod, under `gfx/<mod>/_gen/<batch>/`, never `/tmp`):
  - `out/` — FINAL icons **and** their previews (`_*_preview.png`). This is what the user reviews.
  - `wip/` — intermediate: codex subjects, prompt `.txt`, logs, comparison sheets, `ref/` vanilla refs.
  - `bak/<timestamp>/` — snapshots of `out/` taken before each re-render.
- **Perks/effects are circles; actives are squares.** A round subject dropped into a square is NOT a
  proper active icon — active art fills the whole panel and bleeds to the metal border.
- **Disabled `_sw` icons are the colour icon DESATURATED at full brightness, not dimmed** (`-modulate
  100,0`). Non-selected perks looked "way darker than usual" when dimmed — vanilla just desaturates.
- **8-bit RGBA on the final write.** The game engine (WebCore) can't read 16-bit PNGs, and source
  brushes are often 16-bit. The scripts force `-depth 8 -define png:color-type=6`.
- **Background subjects depict the concept (an object/emblem), never a head/face** — it's a small
  icon. Vanilla origin discs are not solid black; they carry a soft grey centre glow.
- **Determine geometry from existing vanilla icons** rather than guessing; compare against real
  `base/data_001/gfx/ui/...` art and the reference images in `assets/`.
- **Stay on the task.** Don't apply unrelated code fixes or pull stale TODOs from old handoffs while
  doing icons.

## Files
- `scripts/` — the pipeline (compose_*, reframe, preview, check_*, median_frame).
- `assets/` — canonical game frames: perk/trait/active blanks (from AC) + the vanilla background
  template. These are the source of truth for rims; the scripts default to them.
- `references/codex_prompts.md` — full, copy-pasteable codex prompt templates.
