// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legacy==2.13 mod_hooks stdlib@dev

// Control for tale_legacy_bridge_perma.nut: Legacy without Permanent Injuries.
// KNOWN_BUGS perma "unclear, likely not ours": MSU's "Tried to read data beyond (0) the length (0) of the
// Deserialization Emulator" on every load with MSU + Permanent Injuries + Legacy, right after
// "MSU Serialization: Loading Legacy × Perma Hackflow (mod_legacy_perma_hook)". Legacy 2.13 bundles that bridge
// (mod_legacy_perma_hook 1.1.9). Control without Perma: tale_legacy_control_perma.nut. Errors in a test fail it.

test("control: a new campaign saves and loads without serialization emulator errors", function (t) {
    t.probe("bridge registered", ::Hooks.hasMod("mod_legacy_perma_hook"));
    local seen = [], logError = ::logError;
    // bound, not captured: the game's closures read a yielding test's locals as null
    ::logError = function (_m) { if (_m.find("Deserialization Emulator") != null) this.seen.push(_m); this.logError(_m); }.bindenv({seen = seen, logError = logError});
    t.save("legacy1");
    yield t.load("legacy1");
    t.save("legacy2");
    yield t.load("legacy2");
    ::logError = logError;
    t.eq(seen, [], "emulator errors over two save/load rounds");
});

test("control: an injured bro saves and loads without serialization emulator errors", function (t) {
    local bro = t.roster()[0];
    bro.getSkills().add(::new("scripts/skills/injury_permanent/missing_ear_injury"));
    local seen = [], logError = ::logError;
    // bound, not captured: the game's closures read a yielding test's locals as null
    ::logError = function (_m) { if (_m.find("Deserialization Emulator") != null) this.seen.push(_m); this.logError(_m); }.bindenv({seen = seen, logError = logError});
    t.save("legacy3");
    yield t.load("legacy3");
    ::logError = logError;
    t.eq(seen, [], "emulator errors");
    t.eq(t.roster()[0].getSkills().hasSkill("injury.missing_ear"), true, "injury kept");
});
