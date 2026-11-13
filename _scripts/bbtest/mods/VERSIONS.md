# Third-party mod zips in `mods/`

Fetched 2026-11-12 (newest releases on that day), unchanged except where noted. `gh_assets/<id>-…` = copied from
`~/projects/bbm/service/sources/gh_assets/` (GitHub release assets, sizes checked against the release);
`nexus/…` = from `~/projects/bbm/service/sources/nexus/`. This dir is the first source of the runner's mod store (README, "Mods"); hand facts in `registry.toml`.

## Current (2026-11-12)

| File | Mod, version | Released | Source |
| --- | --- | --- | --- |
| `mod_modern_hooks-0.7.0.zip` | Modern Hooks 0.7.0 | 2026-11-01 | GitHub MSUTeam/Modern-Hooks, gh_assets/697639322 |
| `mod_msu-1.9.0.zip` | MSU 1.9.0 | 2026-06-23 | GitHub MSUTeam/MSU, gh_assets/455267380 |
| `mod_reforged_core-0.9.3.zip` | Reforged 0.9.3 (newest non-dev; `dev-latest` is 0.9.4-dev.15) | 2026-08-28 | GitHub Battle-Modders/mod-reforged, gh_assets/533281931 |
| `mod_reforged_assets-0.1.4.zip` | Reforged assets 0.1.4 (still newest) | 2026-06-28 | Nexus 765 (was already here) |
| `mod_modular_vanilla-0.9.1.zip` | Modular Vanilla 0.9.1 | 2026-07-03 | GitHub Battle-Modders, gh_assets/464995842 |
| `mod_nested_tooltips-0.5.4.zip` | Nested Tooltips 0.5.4 | 2026-11-01 | GitHub MSUTeam, gh_assets/697122398 |
| `mod_dynamic_perks-0.5.1.zip` | Dynamic Perks 0.5.1 | 2025-12-11 | GitHub Battle-Modders, gh_assets/327128422 |
| `mod_dynamic_spawns-0.6.0.zip` | Dynamic Spawns 0.6.0 | 2026-04-01 | GitHub Battle-Modders, gh_assets/386375151 |
| `mod_item_tables-0.1.3.zip` | Item Tables 0.1.3 | 2025-02-19 | GitHub Battle-Modders, gh_assets/230545375 |
| `mod_stack_based_skills-0.5.3.zip` | Stack Based Skills 0.5.3 | 2025-11-30 | GitHub Battle-Modders, gh_assets/322584125 |
| `mod_unified_perk_descriptions-0.1.2.zip` | Unified Perk Descriptions (`mod_upd`) 0.1.2 | 2024-08-14 | GitHub Battle-Modders, gh_assets/185808186 |
| `mod_hardened-1.26.3.zip` | Hardened 1.26.3 (needs Reforged ≥ 0.9.0, Dynamic Spawns ≥ 0.5.0) | 2026-11-05 | GitHub Darxo/Hardened, gh_assets/711483206 |
| `mod_crock_pot-0.10.6.zip` | Crock Pot 0.10.6 (needs Reforged) | 2026-10-04 | GitHub Darxo/Crock_Pot, gh_assets/610336434 |
| `mod_clever_recruiter-2.1.8.zip` | Clever Recruiter 2.1.8 | 2026-11-01 | GitHub Enduriel/BB-Clever-Recruiter, gh_assets/698259474 |
| `mod_Black_Pyramid-1.4.4_eng.zip` | Black Pyramid 1.4.4 eng (MAIN file; bundles Undead Curse 0.31.0, Reforged Rogues 1.7.0, …; needs Reforged + the original mod_hooks API) | 2026-11-03 | Nexus 986 file 8378, `nexus/mod_Black_Pyramid_1.4.4_eng 986 1.4.4 2026-11-03T11-03Z gbtfQMMbB.zip` |
| `mod_legends-19.4.23.zip` | Legends 19.4.23 "Bandits & Greenskins" (needs vanilla 1.5.2-3…<1.5.3, MSU ≥ 1.9.0; ships its own mod_hooks) | 2026-11-10 | GitHub Battle-Brothers-Legends/Legends-public release asset (downloaded) |
| `mod_legends-assets-19.4.23.zip` | Legends assets 19.4.23 (358 MB) | 2026-11-10 | same release (downloaded) |
| `mod_stronghold-2.18.1.zip` | Stronghold 2.18.1 (old `::mods_*` API) | 2026-05-03 | GitHub TaroEld/mod_stronghold, gh_assets/411267216 (asset named `mod_stronghold.zip`) |
| `mod_sellswords_updated_8.5.2.zip` | Sellswords Updated (SSU) 8.5.2 — newest, does NOT boot on Legends 19.4 (see below) | 2025-11-15 | GitHub EmoUsedHM01/Sellswords-Updated, gh_assets/316771847 |
| `mod_nggh_magic_concept_3.0.0-beta.90a-unstable.zip` | NgGH Magic Origins 3.0.0-beta.90 — newest, does NOT boot on Legends 19.4 | 2026-02-25 | GitHub NgGH707/NgGH-Magic-Origins-Mod, gh_assets/362531932 |
| `mod_Davkul_Rising_Rf_Hd_compat-0.4.zip` | Davkul Rising RF/HD compat 0.4 (Black Pyramid's page) | 2026-11-09 | Nexus 986, `service/sources/nexus/` |
| `mod_career_stats-1.0.2.zip` | Career Stats 1.0.2 (newest; for Fun Facts KB8) | — | Nexus 569, `service/sources/nexus/` |
| `mod_Legacy-2.13.zip` | Legacy 2.13 (bundles `mod_legacy_perma_hook` 1.1.9; for perma's bridge report) | — | Nexus 972 file 8336, `service/sources/nexus/` |
| `mod_sato_balance-2.3.1.zip` | Sato's Balance Mod 2.3.1 (for hackflows_perks HP-KB2) | — | GitHub release asset, `service/sources/gh_assets/489788522-sato_balance_2.3.1.zip` |

Not fetched:

- **PTR** (LordMidas' Legends Perk Tree Rework): last release 2021 (v1.0.0, no assets), for Legends 15/16; PTR for
  vanilla became Reforged. Nothing current exists.
- **SSU / NgGH for current Legends**: none exists. Legends 19.3+ is for vanilla 1.5.2 (`vanilla(>=1.5.2-3)`); the
  Legends versions SSU 8.5.2 and NgGH beta.90 were made for (19.2.27 of 2025-11-15, 19.2.47 of 2026-02-23) require
  `vanilla(<1.5.2)`, so they don't run on the installed game. Legends' Discord thread title says "Sellswords
  Updated (SSU) (incompat since 19.3)". On 19.4.23 SSU fails at boot with `the index 'BanditVeteran' does not
  exist` (`mod_sellswords/config/spawnlist_bandits.nut:1`) and then `IsLowerVanity` in Legends' crafting;
  NgGH with `the index 'LegendFavouredEnemyGhoul' does not exist` (`mod_nggh/config/config.nut:958`), then `Simp`.

## Older (kept)

| File | Mod, version | Source |
| --- | --- | --- |
| `mod_modern_hooks-0.6.0.zip`, `mod_msu-1.8.0-russian.zip` | the `fw` token's frameworks | the game's data dir |
| `mod_framework-0.8.17-russian.zip` | Reforged 0.8.x's frameworks in one zip (Dynamic Perks, Spawns, Item Tables, Modular Vanilla, Nested Tooltips, Stack Based Skills, UPD) | the game's data dir |
| `mod_reforged_core-0.8.18-russian.zip` | Reforged 0.8.18 | the game's data dir |
| `mod_hooks_hackflow_TMP.zip` | hackflow's mod_hooks shim (old `::mods_*` API) | the game's data dir |
| `mod_Black_Pyramid_0.4_eng_0.4_Z3ILe0WK1.zip`, `mod_crock_pot-russian.zip` (0.8.0), `mod_clever_recruiter-549-2-1-6-1721399739.zip` (2.1.6) | earlier copies used by existing suites | Nexus / game data dir |
| `mod_rosetta_TMP.zip`, `mod_backgrounds_and_events_TMP.zip`, `mod_settlement_prices_tooltip-311-6-1612838334.zip` | used by existing suites | game data dir / Nexus |

The `*_TMP.zip` files are local builds: the store skips them (headers now name the releases: mod_hooks 21.2,
Rosetta 0.4.0, XBE 0.8). Black Pyramid 0.4 and Clever Recruiter 2.1.6 are no longer used by any test.
