# Elite Few (Master Bros) — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/665 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/665?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Hardened: negotiating contract pay leads to an empty dialog, soft lock — open
- Source: `discord_search.jsonl` msgs 1509702330881147011 (2026-05-28) and 1460221863920668756 (2026-01-12), Reforged "Hardened" thread
- Setup: Reforged + Hardened + Elite Few 2.5.0.
- Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:55-77` — `markInScreen` wraps `setScreen` in anonymous
  `concat_call` functions. Hardened's `contract.setScreen` hook (`3rdparty/Hardened/mod_hardened/hooks/contracts/contract.nut:75`)
  checks `::Hardened.getFunctionCaller() != "processInput"` and otherwise forces `_restartIfAlreadyActive = false`; behind
  Elite Few's wrapper the caller is never `processInput`, so re-entering the same negotiation screen doesn't restart it. The wrapper also drops `setScreen`'s return value. Strong hypothesis, not tested.
- Repro (engine-agnostic): hook `contracts/contract.setScreen` innermost with a probe recording `getstackinfos(2).func`;
  call `contract.processInput(option)` that calls `setScreen` → assert the recorded caller is `processInput`. With Hardened: negotiate twice on the same screen, assert `ActiveScreen` has options.

### 2. Exception inside an event/contract screen leaves every later bro rolled as an "event bro" — not user-reported as such, open (from code + logs)
- Source: logs show `inEventOrContract = True` in frames when other mods throw inside `setScreen`
  (`logs/Reforged/1374197549677936663/log.html`, `logs/Legends/1383870213740695573/log.html`); possibly related to
  Nexus post https://www.nexusmods.com/battlebrothers/mods/665?tab=posts&jump_to_comment=147597215 (Legends 19: "brothers get master trait and full stat")
- Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:74-77` — `inEventOrContract = true; call.super(); inEventOrContract = false;` without try/finally.
- Repro: set `eventAll = true`; fire an event whose `start()` throws (a mock); then generate town recruits → assert none got `trait.master` because of `eventAll` (i.e. `inEventOrContract` is false again).

### 3. Endless loading on Reforged while rolling a master for `MSU_dummy_player_character` — open, unclear (workaround: select mode "none")
- Source: `discord_search.jsonl` msg 1391784028390035586 (Reforged #technical-help, 2025-07-07)
- Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:178-200` (`buildAttributes` wrap runs `rollMaster` and adds `master_trait` to MSU's dummy player).
- Repro: Reforged + MSU; with selectMode "all", trigger MSU's dummy player creation (main menu → new campaign) → assert it finishes and the dummy has no `trait.master`.

### 4. SSU: city view / recruit list doesn't open — unclear, no reply
- Source: https://discord.com/channels/547043336465154049/1179715231803514910/1339048585873985588 (2025-02-12)

## Fixed

### 5. Legends 19.0: elite bros get only 1 talent / odd stats — probably fixed in 2.5.0 (Legends 19 support, 2025-04-28); unverified
- Source: Nexus posts https://www.nexusmods.com/battlebrothers/mods/665?tab=posts&jump_to_comment=147750068, ...=147597215

### 6. Tutorial contract not completing (return to village) — fixed in 2.4.1
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/665?tab=posts&jump_to_comment=131992190; https://discord.com/channels/547043336465154049/1179715231803514910/1216358460325888030
- Repro (regression): tutorial scenario, finish the first fight, enter the village → assert the contract advances to the next screen.

### 7. "Exclude dubious traits" ignored for event bros (Double Tongued) — fixed in 2.4.1
- Source: https://discord.com/channels/547043336465154049/1179715231803514910/1230523083971100725, ...1195757016749191349

## Not bugs / feature requests (skipped)

Kingsguard event broken (Nexus bug 760647, actually Starting Perks by Background, see background_perks #2), Clever Recruiter errors passing through Elite Few's wrapper (`logs/Legends/1370364408278286408/`), master bros' wage giving them away (changed in 2.5.0).

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 reproduced with a stub of Hardened's `setScreen` hook (caller seen as `acall`); #2
  reproduced; #3 partly (no endless loading, but MSU's dummy player gets `trait.master`); #6 not
  tested; #4 #5 SSU/Legends. New: EF1 (master strength bonus doubles after a load).

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 8. Clever Recruiter + Elite Few: `No overload matching this argument list found` while generating recruits — other mod's bug (Clever Recruiter patches `Math.rand`; Enduriel said he'd fix it on his side), still reported in 2025
- Sources: BB Modding https://discord.com/channels/965324395851694140/965324396317278240/1257622395435352074 (Enduriel,
  2024-07-02: CR "switcheroos rand", EF wraps `buildAttributes`, master roll → `actor.setDirty` → `::Math.rand() + ::Math.rand()`
  breaks under CR; depends on queue order; author: "This is why I shy away from patching Math.rand()"); BB Modding
  https://discord.com/channels/965324395851694140/1222072028417364059/1278620446576873513 (2024-08-29, filed as "Bro
  Studio + CR", logs show Elite Few); Legends https://discord.com/channels/547043336465154049/1179715231803514910/1370681997558681720
  (2025-05-10, "been around for a while"; existing skipped log `logs/Legends/1370364408278286408/`);
  https://discord.com/channels/547043336465154049/616566479306883073/1416051379604160532 (2025-09-12, "tell hackflow master bros is incompatible with clever recruiter").
- Logs: `discord_logs/bbmodding_1278620446576873513_log_46.html`, `discord_logs/bbmodding_1278620446576873513_log-329.html` (Legends):
  ```
  Script Error: No overload matching this argument list found
    at -> scripts/!mods_preload/mod_clever_recruiter.nut : 43      (_a = NOT_A_NUMBER, _b = NOT_A_NUMBER)
    at setDirty -> scripts/entity/tactical/actor.nut : 457
    at onUpdateInjuryLayer -> scripts/entity/tactical/player.nut : 815
    ...
    at -> scripts/!mods_preload/z_elite_few.nut : 177              (master = True)
    at concat_call -> scripts/!mods_preload/z_elite_few.nut : 58
    at -> clever_recruiter/world_state.nut : 10
  ```
- Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:178-200` (`buildAttributes` wrap adds `trait.master`
  while CR's temp player is being built, which triggers `setDirty` inside CR's patched rand). EF-side mitigation: add
  the master trait without `setDirty` side effects, or skip rolling for CR's temp player.
- Repro: only with Clever Recruiter available: Legends/vanilla, `selectMode = "all"`, refresh a town's recruits through
  CR's `world_state` hook; assert no script error and recruits generated.

### 9. Legends 18 + PTR: new campaign fails, `wrong number of parameters` in the `fillTalentValues` wrapper — unclear (EF 2.4.0; a helper said EF works with PTR+SSU; no author reply)
- Source: https://discord.com/channels/547043336465154049/1206361038258438205/1206361038258438205 (Legends help,
  2024-02-11, "every time I start a new world"); https://discord.com/channels/547043336465154049/1206361038258438205/1206391669554155582
  ("Elite Few error. Remove mod"). Log `discord_logs/legends_1206361038258438205_log.html` (also lacks Modern Hooks).
  ```
  Script Error: wrong number of parameters
    at concat_call -> scripts/!mods_preload/z_elite_few.nut : 58
    at -> scripts/!mods_preload/z_elite_few.nut : 116            (_num = 3, _force = False)
    at concat_call -> scripts/!mods_preload/z_elite_few.nut : 58
    at -> mod_ptr/hooks/entity/tactical/player.nut : 113
    at onSpawnAssets -> scripts/scenarios/world/rangers_scenario.nut : 44
  ```
- Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:117-118` (`fillTalentValues` wrapper → `call.super()`
  forwards the caller's args to the wrapped function via `concat_call`, lines 55-58); the wrapped (PTR/Legends 18)
  function rejects the arg count. Not reproducible without PTR; Legends 18 is obsolete.
- Repro: stub `player.fillTalentValues(_num)` with one parameter, call it through EF's wrapper as `fillTalentValues(3)`
  and `fillTalentValues(3, false)`; assert no error and that the stub got the same args the caller passed.

### 10. Legends/SSU-reworked bad traits still allowed on master bros (Deathwish with −3 MDef per surrounding enemy) — open (author: "might be fixed in the mod too, just need to detect Legends and add to the list")
- Source: https://discord.com/channels/547043336465154049/1179715231803514910/1197433918941560842 and
  .../1197479626272952330 (frederikn0912 + hackflow, 2024-01-18; Legends + SSU). Double Tongued from the same report
  was made dubious in 2.4.1 (#7).
- Suspected code: `elite_few/scripts/skills/traits/master_trait.nut:14-50` (Excluded) and `:52-69` (dubious) list no
  `trait.deathwish` / `trait.legend_deathwish`.
- Repro: Legends stub where `trait.deathwish` has a negative effect; roll 500 master bros; assert none gets Deathwish
  (or that the list is chosen per Legends presence).

### Extends existing

- **#1 (Hardened negotiation soft lock)** — Discord links for the `discord_search.jsonl` sources: Darxo reproduced it
  (https://discord.com/channels/1006908336991645757/1138845062969704509/1460237401640275988, 2026-01-12) and again
  (https://discord.com/channels/1006908336991645757/1138845062969704509/1509951256125243582, 2026-05-29: "already got
  reported… couldn't make sense of the passage"); Darxo 2026-08-23: "only aware of a compatibility issue with Elite Few and
  Hardened in those negotiation screens" (https://discord.com/channels/1006908336991645757/1283857645492502549/1541115185232744480).
- **#3 (endless loading, MSU dummy player)** — the report thread:
  https://discord.com/channels/1006908336991645757/1283857645492502549/1391784088117182474 and
  https://discord.com/channels/1006908336991645757/1283857645492502549/1391799341701922848 (2025-07-07, "disabling the rolling
  for elite brothers in mod settings fixed it"; another user with EF has no issue).

### Skipped

- "elite few appears in all errors" (user retracted: another error,
  https://discord.com/channels/547043336465154049/1179715231803514910/1226615116024516778); freeze starting a fight with
  Specialist Rework (`discord_logs/legends_1273234913545551954_log.html`: `calculateSpecialistBonus` in
  `specialist_skills_hooks`, not EF); Reforged seed freeze (`discord_logs/reforged_1285467978229354498_log.html`: `tnf_revisedNamedItems`,
  `mod_rpgr_raids`); Legends logs `legends_1371869457802199111_log.html`, `legends_1395739707823886396_log.html` (EF only in
  the mod list); "increase master chance over time", wrong mod name on the Legends compat list (feature/questions).

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. #8 (Clever Recruiter) — CR 2.1.6's bug, fixed in CR 2.1.8 (the CR 2.1.6 tests are removed). Not
   reproduced in vanilla with CR 2.1.6; the
   path needs Legends' `setHitpointsPct` → `setDirty`. Mechanism confirmed: any zero-argument `Math.rand()`
   under CR's swap throws the users' `No overload matching this argument list found`.
2. Not feasible headless (Legends/SSU/Hardened/PTR not available): #9, #10.
3. Real Hardened 1.26.3 / Reforged 0.9.3 / Crock Pot 0.10.6 / Legends 19.4.23 / Clever Recruiter 2.1.8 (2026-11-12):
   #1 reproduced with the real Hardened (`hardened_bugs_elite_few`, control `hardened_real_control_ef` passes); #10
   reproduced (39/600 masters get Deathwish, −3 MDef under Legends); #5, #9 not reproduced on Legends 19.4; #8 not
   reproduced with CR 2.1.8 (fixed on CR's side); #4 not feasible (SSU). New EF2: CR 2.1.8 runs `buildAttributes`
   twice, so Elite Few rolls masters twice (vanilla).
