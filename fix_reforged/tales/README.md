# Fix Reforged — headless game-scenario tests

`tale_smoke_reforged.nut` (Reforged 0.9.3): errors in every background's `create()`, FR1, see `FOUND_BUGS.md`. The mod needs
Reforged, so there is no vanilla smoke.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py ../mods/fix_reforged/tales/tale_smoke_reforged.nut    # 1 passed, 1 failed, errors at the campaign start
```
