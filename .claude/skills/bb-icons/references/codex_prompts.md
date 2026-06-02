# Codex prompt templates

Drive codex non-interactively. Write the prompt to a file, then:

```bash
codex exec --sandbox workspace-write "$(cat prompt.txt)" -i ref1.png ref2.png
# follow-up edit on the same generation:
codex exec resume --last --sandbox workspace-write "$(cat fix.txt)" -i prev.png ref1.png
```

`-i <img>` attaches a reference/input image. List several after `-i`. Save outputs into the mod's
`gfx/<mod>/_gen/` (never `/tmp`). Below are templates that produced usable art.

---

## A. Fresh subject for a round perk/background (on chroma-green)

```
Generate a single game icon image and SAVE it as a PNG to this absolute path:
<ABS>/gfx/<mod>/_gen/<name>.png

Open and look at these existing images as STYLE references:
- <ABS>/base/data_001/gfx/ui/perks/perk_09.png  (BB vanilla perk icon: dark circular metal badge,
  muted palette, overall size and shape)
- <ref2.png>  (a subject centered inside that kind of badge)

Match their style: painterly, muted/desaturated earthy palette, soft top-down lighting, set inside a
dark circular emblem, no text/letters/numbers.

Subject: <DESCRIBE THE SUBJECT — e.g. a snarling grey direwolf head, three-quarter view, yellow eyes>,
centered.

Render the subject on a SOLID flat chroma-green background of exactly #00d000 — NO frame, NO disc, NO
shadow, NO vignette. Keep it COMPACT within the central ~80% so nothing important reaches the corners
(it will be clipped to a round disc later). Strong readable silhouette at tiny size: bold shapes,
thick strokes, high contrast.

Output a square PNG, 512x512. Do not modify any other files. When finished, print the saved file path.
```

Notes that mattered: "THICK, CRUDE, HEAVY … not elegant" fixed a too-thin subject. "bold shapes,
high contrast" keeps it readable at 56px. Always say where to save and "do not modify other files".

## B. Cut a subject out of an existing icon (isolate art)

```
Narrow image task (use your image-editing skill). I only need a CLEAN CUT-OUT of <THE SUBJECT>,
nothing else — no frame, no disc, no compositing.

Input (attached): <src.png> — <describe: art of X inside a round metal frame on flat green>.

Produce: <THE SUBJECT> ONLY, as a tight cut-out on a FULLY TRANSPARENT background.
- Remove the metal frame, the dark disc, <the soil/mound/etc.>, and the background completely.
- Keep ONLY <the subject>, with clean single edges (no halo, no leftover green fringe, no frame arc).
  Erode ~1px if needed to kill the antialiased fringe.
- Preserve the subject's original pixels, position and size on a 1024x1024 transparent canvas. Do NOT
  restyle or repaint it.

Save to: <ABS>/gfx/<mod>/_gen/<name>_cut.png
Report the bounding box of the subject in the saved image.
```

(Variant: instead of transparent, ask for the cut-out on solid flat `#00d000` — then it feeds the
compose_*.sh green-key directly.)

## C. Square active-skill subject

```
Battle Brothers mod icon art. Generate ONE subject only — <THE THING> — as a frameless cut-out on a
solid flat chroma-green (#00d000) background, filling most of the canvas.

- Bold, crude, readable silhouette; muted earthy desaturated oil-paint palette with warm rim light.
- This will FILL a SQUARE icon panel (active skills bleed to the edges), so it's fine for the art to
  reach near the canvas edges — but keep the key shapes centered.
- No frame, no disc, no text, no drop shadow, no vignette — just the subject on solid #00d000.

Save a 512x512 master to: <ABS>/gfx/<mod>/_gen/<name>_big.png
```

## D. Let codex composite onto the blank (alternative to our scripts)

Codex can also do the whole compose itself if you hand it the cut-out and the blank frame. It tends
to leave a slight grey halo / a not-quite-matching border, so PREFER our `compose_*.sh`. If you do
try it, verify the border afterwards with `scripts/check_border.py` and watch for a "double bevel"
around the subject (ask codex to flatten it if it appears).
