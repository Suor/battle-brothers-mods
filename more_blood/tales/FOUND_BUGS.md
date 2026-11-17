# More Blood — bugs found by the scenario tests

## MB1. Overwrites Events Delayed Fix's `::EventsFix` global — low

- Test: `core::MB1: More Blood leaves ::EventsFix to Events Delayed Fix` → `expected "mod_events_delayed_fix", got "mod_more_blood"`.
- Cause: `more_blood/scripts/!mods_preload/mod_more_blood.nut:1` — `local mod = ::EventsFix <- {...}`,
  copied from events_delayed_fix. Nothing reads `::EventsFix` now (both use the local), so no
  visible effect yet; any code or mod looking up `::EventsFix` gets More Blood's table.
