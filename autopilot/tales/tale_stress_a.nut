// mode: campaign seed=bbtest-battle fresh=1 launch=stress_a
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Autopilot against every kind of foe (stress_a/b/c): each battle must end without a script error
// or a turn that never ends, with the bros acting. Who wins doesn't matter.

test("vs Zombies.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Zombies", "Undead"); });
test("vs ZombiesAndGhouls.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "ZombiesAndGhouls", "Undead"); });
test("vs Ghouls.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Ghouls"); });
test("vs Direwolves.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Direwolves"); });
test("vs GoblinRaiders.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "GoblinRaiders"); });
test("vs OrcRaiders.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "OrcRaiders"); });
test("vs Unhold.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Unhold"); });
test("vs Ghosts.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Ghosts", "Undead"); });
