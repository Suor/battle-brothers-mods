// mode: campaign seed=bbtest-battle fresh=1 launch=stress_c
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Autopilot against every kind of foe (stress_a/b/c): each battle must end without a script error
// or a turn that never ends, with the bros acting. Who wins doesn't matter.

test("vs SandGolems.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "SandGolems"); });
test("vs VampiresAndSkeletons.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "VampiresAndSkeletons", "Undead"); });
test("vs Lindwurm.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Lindwurm"); });
test("vs Mercenaries.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Mercenaries"); });
test("vs Noble.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Noble"); });
test("vs Cultists.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Cultists"); });
test("vs Southern.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "Southern"); });
test("vs BountyHunters.", function (t) { ::APT.stressCompany(); yield ::APT.stress(t, "BountyHunters"); });
