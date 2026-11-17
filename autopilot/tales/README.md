# Autopilot New — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree (HEAD, 8 unreleased commits after 2.9.0). The AI button is pressed
the way the turn bar's button and `Q` do (`onAIButtonPressed` + the popup's Ok), so the bros are
played by **Autopilot's own agents**, not by the runner's `military_melee_agent` hand-over:
`t.battle({player = ...})` with `fight` off, and `tale_core.nut` asserts every bro's agent is
Autopilot's and none was handed over by the runner. Tests named `KB<n>: ...` (KNOWN_BUGS.md) or
`A<n>: ...` (FOUND_BUGS.md) describe correct behaviour and fail while the bug is open.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 8 ../mods/autopilot/tales/tale_*.nut               # all: 80 tests, 13 launches, ~22 s
./bbtales.py --isolate -j 12 ../mods/autopilot/tales/tale_*.nut    # one launch per test, ~31 s
./bbtales.py -k A2 ../mods/autopilot/tales/tale_known_bugs.nut     # tests whose name has "A2"
./bbtales.py -j 8 -r mod_autopilot_new==2.9.0 ../mods/autopilot/tales/tale_*.nut   # the same against the released 2.9.0
```

Timings on suor-p1. Exit code 1 while the bugs are open: 15 failing tests (KB1 ×2, KB2 ×2, KB3,
KB5, KB6, KB9, KB10, A1, A2 ×2, A3, A4, A5) and 2 launch failures (the two KB1 launches, see
below), "80 tests, 17 failures/problems".

Packed and `--isolate` runs give the same statuses and the same assert lines; four packed runs in a
row gave the same statuses and asserts (checked 2026-11-12). Vanilla probes repeat too; Reforged's
AI battles don't (frames, skills used and nets thrown vary, runner README), so the Reforged tests
assert on the agent's setup, not on what the AI rolled. Probes of AI choices may also differ between
packed and isolated runs: an AI battle depends on what the earlier tests of the launch left in memory.

## Files

Vanilla 1.5.2 + Modern Hooks + MSU + stdlib, seed `bbtest-battle`, `fresh=1`; the company is the
early-access start (Bertel: woodcutter's axe, Torkel: light crossbow, Wendel: militia spear and
shield), toughened (`::Tales.toughen`), against 3–4 bandit thugs unless said otherwise.

- `tale_core.nut` — the AI button: Autopilot's agents (`military_ranged` for the crossbowman, `_autopilot`
  mode table), a whole battle won with every bro attacking, no "enemy retreats" dialog on AI,
  control handed back after the battle, two battles in a row; hotkeys through
  `tactical_state.onKeyInput`: `Q` (AI), `V` (cancel, then AI again), `H` (mass wait: everybody
  waits once), `N` (mass shield wall); Ignore button; "Auto Player Characters" off; quick switch
  (bag item as the last skill button, its tooltip, number key and click swap it for 4 AP);
  end-of-turn auto skills (reload, cut an adjacent ally free, bandage self, recover; settings off);
  "Verbose AI" on; the behaviors instantiate, an archer's agent setup (no map needed).
- `tale_behaviors.nut` — Autopilot's behaviors in AI battles: unbag and throw a net (Wendel alone, rooted by the Oath of
  Fortification in round 1, a thug put 2 tiles off: the net is the AI's only move), "Throw Nets" off,
  unbag a shield, dogs `at will` / `never` / `defensive` (the dog's turn bar UI data, KB28),
  a javelin thrower (melee agent, throwing mode), a pike bro, and HEAD's `autopilot_cleanse_ally`
  (cut a netted ally free, bandage a bleeding one).
- `tale_edge.nut` — charm on AI and after (one thug, unkillable until Bertel has acted again, next to him), `V` while charmed, A3, retreat while on AI (KB34), a skill
  hotkey during an Autopilot turn (KB36).
- `tale_known_bugs.nut` — swap quiver, KB2, KB5, KB6, A1, A2, KB8, KB9, KB10 (+ control), KB4, KB29, A4, A5.
- `tale_kb1_throwing.nut`, `tale_kb1_firelance.nut` — KB1, in a launch of their own (`kb1`): while the bug is there,
  each battle runs to its frame limit.
- `tale_kb31.nut`, `tale_kb31_vanilla.nut`, `tale_kb31_reforged.nut` — KB31 with Autopilot, without it, and with
  Reforged (the test is `lib/kb31_body.nut`).
- `tale_reforged.nut` — Reforged 0.9.3 (bros found by their weapons): an AI battle, KB3
  (+ control), KB12 (no ThrowNet behavior with nets off; + control), KB20 (swordstaff), KB35 (button
  tooltips).
- `tale_stress_a.nut`, `tale_stress_b.nut`, `tale_stress_c.nut` — six bros on Autopilot against 25 kinds of foes
  (`::Const.World.Spawn` keys, resources 120): each battle must end with no script error and no turn
  longer than 40 s of game time. All pass.
- `tale_ui_page.nut`, `tale_ui_page_vanilla.nut` — in the real UI page, in jsdom and in Chromium (`// needs: ui`, the
  runner's README): Autopilot's turn bar buttons and their hover tooltips; KB4, and KB4 without Autopilot.
- `lib/helpers.nut` — `::APT` helpers (`// include:`): `::APT.pilot(opts)` is the `player` of
  `t.battle` that presses AI, runs setup steps on player turns, ends the turns of bros left under
  human control, and records a turn longer than `stuckFrames` (2400) in `st.stuck` and ends it, so a
  freeze is reported with the entity and round instead of a timeout.
- `mod_ap_probe/` — a test-only mod (zipped as is) that records every `skill.use()` and every AI
  behavior picked while `::APProbe.on`, with whether the actor was on Autopilot.

## Released 2.9.0 vs HEAD

`run_released.sh`: every bug test above fails on 2.9.0 too, with the same asserts: none of the
findings depends on unreleased code. What differs is HEAD's new features: dog modes (2.9.0 has an
on/off "dogs" setting, so `at will` isn't there), `autopilot_cleanse_ally` and bandages (absent:
both cleanse tests and the bandage part of "end of turn" fail; the bandage test errors on the missing
`AP_CleanseAlly` id and stops its launch).

## Not covered

- UI/JS: the buttons themselves, hiding them on AI, the status bar icons (KB4 is checked at the
  Squirrel UI-data level only and passes there), Enter/Esc on popups (JS keyup), Extra Keybinds' F1–F4.
  The Squirrel handlers the buttons and hotkeys call are driven directly.
- Mods not loadable here: Legends (KB9, KB16, KB21), SSU (KB11), Stronghold (KB8 is checked with a
  vanilla guest), NgGH (KB14), AC (KB15, KB28 beyond vanilla dogs), Hardened (KB33), Druid, Pandora's
  Hobby, Fantasy Brothers, BP (heal_ally's skills). A non-player actor under the player's control
  (Legends summons, NgGH beasts) is stood in for by a bandit thug in the player's faction with a
  player's agent.
- KB7 (Recover while swallowed): a swallowed bro gets no turn in vanilla, so no end of turn to test;
  the Ghouls stress battles pass.
- KB32 (Reforged Kata Step script missing): engine-level "Failed to load script" lines don't reach
  `::logError`; the Reforged AI battle passes.
