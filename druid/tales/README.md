# Proper Druid — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. `DR-KB<n>` = `KNOWN_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/druid/tales/tale_*.nut       # 10 tests, 3 launches, ~20 s
```

All pass: KB1 doesn't reproduce here (see `FOUND_BUGS.md`).

- `tale_smoke.nut` + `tale_known_bugs.nut` — vanilla + frameworks, `fresh=1`. A druid joins the company and
  summons in the first player turn (`::Tales.scripted`); the company ends its turns for two rounds
  while the beast is watched. Once for the beast the dice give (a Wolf), once per beast type the
  wilds can send (wolf, direwolf, direwolf_high, spider, schrat_small, hyena, hyena_high, serpent,
  forced through `::Const.Druid.Biomes`), each in its own battle.
- `tale_smoke_reforged.nut` + `tale_known_bugs_reforged.nut` — the same under Reforged 0.9.3; both `known_bugs` files
  run `lib/kb1_body.nut`.
- `tale_origin.nut` — the Druids origin: the Bear and the Wolf, a battle won at once (no AI fight: the Bear can die
  in one), save/load.

Packed and `--isolate` agree (checked 2026-11-12).

Not covered: the UI, sprite looks beyond the flip flag (`isFlippedHorizontally`, an engine
native), Beastform/Entangle/Regrowth mechanics, XBE/Starting Perks by Background interplay (KB2).
