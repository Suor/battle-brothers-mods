// mode: campaign seed=bbtest-battle fresh=1 launch=stress_b
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Autopilot against every kind of foe (stress_a/b/c): each battle must end without a script error
// or a turn that never ends, with the bros acting. Who wins doesn't matter.

test("vs Necromancer.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Necromancer", "Undead"); });
test("vs NomadRaiders.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "NomadRaiders"); });
test("vs Barbarians.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Barbarians"); });
test("vs Spiders.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Spiders"); });
test("vs Hexen.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Hexen"); });
test("vs Alps.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Alps"); });
test("vs Schrats.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Schrats"); });
test("vs Serpents.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Serpents"); });
test("vs Hyenas.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Hyenas"); });
