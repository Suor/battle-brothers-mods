# Events and Ambitions Delayed Fix — headless game-scenario tests

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/events_delayed_fix/tales/tale_*.nut    # 4 tests, 2 launches, ~9 s
```

- `tale_core.nut` — 20 days at speed 16, events answered by the autoplay: which events fired (an event
  sets `CooldownUntil` when fired). With the mod 5 distinct events, `tale_baseline_events.nut` without it 6
  (seed `bbtest-battle`): no difference the test can tell, so it only asserts that events fire and
  that nothing errors in the `selectEvent` generator wrapper.
- `tale_smoke.nut` — boot, AI battle, days, save/load.

Not covered: the pre-1.5.1 branch (vanilla here is 1.5.2), event timing statistics.
