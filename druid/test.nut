dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/mocks.nut", true);
dofile("mocks.nut", true);
dofile("scripts/config/z_druid.nut", true);   // defines ::Const.Druid (group rules, equip limits)
dofile("druid/rosetta_ru.nut", true);          // returns early without ::Rosetta - just a smoke check

local D = "perk.druid.";
local Druid = ::Const.Druid;

function eq(_actual, _expected, _msg) {
    if (_actual != _expected) {
        print("FAIL: " + _msg + " - got " + _actual + ", expected " + _expected + "\n");
        throw "test failed: " + _msg;
    }
}

// --- isPerkBlocked: implicit Supporter/Fighter exclusion --------------------

// Nothing taken yet: both gates open, the Beastform-gated perks closed, Venom open.
local none = makeSkills([]);
eq(Druid.isPerkBlocked(D + "regrowth",  none), false, "fresh: regrowth open");
eq(Druid.isPerkBlocked(D + "beastform", none), false, "fresh: beastform open");
eq(Druid.isPerkBlocked(D + "beast_aura", none), true,  "fresh: beast_aura gated by beastform");
eq(Druid.isPerkBlocked(D + "beast_rage", none), true,  "fresh: beast_rage gated by beastform");
eq(Druid.isPerkBlocked(D + "venom",     none), false, "fresh: venom open");

// A Nature (Supporter) perk taken: Beastform and the whole Fighter side close; Nature stays open.
local supporter = makeSkills([D + "regrowth"]);
eq(Druid.isPerkBlocked(D + "beastform",  supporter), true,  "supporter: beastform closed");
eq(Druid.isPerkBlocked(D + "hatch",      supporter), false, "supporter: hatch open");
eq(Druid.isPerkBlocked(D + "entangle",   supporter), false, "supporter: entangle open");
eq(Druid.isPerkBlocked(D + "apex",       supporter), false, "supporter: apex open");
eq(Druid.isPerkBlocked(D + "beast_aura", supporter), true,  "supporter: beast_aura closed");
eq(Druid.isPerkBlocked(D + "beast_rage", supporter), true,  "supporter: beast_rage closed");
eq(Druid.isPerkBlocked(D + "venom",      supporter), false, "supporter: venom open");

// Beastform taken: all Nature perks close; Beast Aura/Rage open up; Venom still open.
local fighter = makeSkills([D + "beastform"]);
eq(Druid.isPerkBlocked(D + "regrowth",   fighter), true,  "fighter: regrowth closed");
eq(Druid.isPerkBlocked(D + "hatch",      fighter), true,  "fighter: hatch closed");
eq(Druid.isPerkBlocked(D + "entangle",   fighter), true,  "fighter: entangle closed");
eq(Druid.isPerkBlocked(D + "apex",       fighter), true,  "fighter: apex closed");
eq(Druid.isPerkBlocked(D + "beast_aura", fighter), false, "fighter: beast_aura open");
eq(Druid.isPerkBlocked(D + "beast_rage", fighter), false, "fighter: beast_rage open");
eq(Druid.isPerkBlocked(D + "venom",      fighter), false, "fighter: venom open");

// Venom before Rage: Beast Rage closes (the exclusive pair), Venom itself unaffected.
local fighterVenom = makeSkills([D + "beastform", D + "venom"]);
eq(Druid.isPerkBlocked(D + "beast_rage", fighterVenom), true,  "venom+beastform: beast_rage closed");
eq(Druid.isPerkBlocked(D + "beast_aura", fighterVenom), false, "venom+beastform: beast_aura open");
eq(Druid.isPerkBlocked(D + "venom",      fighterVenom), false, "venom+beastform: venom (held) not blocked");

// Rage taken: Venom closes (other half of the exclusive pair).
local rager = makeSkills([D + "beastform", D + "beast_rage"]);
eq(Druid.isPerkBlocked(D + "venom",      rager), true,  "rage: venom closed");
eq(Druid.isPerkBlocked(D + "beast_aura", rager), false, "rage: beast_aura open");

print("isPerkBlocked OK\n");

// --- beastformAllows: equipment limits -------------------------------------

local IT = ::Const.Items.ItemType;
// A ranged weapon is forbidden whatever its weight.
eq(Druid.beastformAllows(makeItem(IT.RangedWeapon, 0)),   false, "ranged weapon forbidden");
// A melee weapon is fine.
eq(Druid.beastformAllows(makeItem(IT.MeleeWeapon | IT.Weapon, -15)), true, "melee weapon allowed");
// Shields: light (<= 10 fatigue) allowed, heavier forbidden, exactly 10 allowed.
eq(Druid.beastformAllows(makeItem(IT.Shield, -8)),  true,  "light shield allowed");
eq(Druid.beastformAllows(makeItem(IT.Shield, -10)), true,  "shield at the cap allowed");
eq(Druid.beastformAllows(makeItem(IT.Shield, -14)), false, "heavy shield forbidden");
// Helmets: cap 10.
eq(Druid.beastformAllows(makeItem(IT.Helmet, -10)), true,  "light helmet allowed");
eq(Druid.beastformAllows(makeItem(IT.Helmet, -16)), false, "heavy helmet forbidden");
// Body armor: cap 20.
eq(Druid.beastformAllows(makeItem(IT.Armor, -20)), true,  "light armor allowed");
eq(Druid.beastformAllows(makeItem(IT.Armor, -40)), false, "heavy armor forbidden");

print("beastformAllows OK\n");

// --- config sanity ----------------------------------------------------------

eq(Druid.Biomes.Starter, "wolf", "starter beast is a plain wolf");
eq(Druid.Biomes.UnlockLevel, 5, "biome variety unlocks at level 5");
eq(Druid.GroupPerks.Supporter.len(), 4, "four Supporter perks");
eq(Druid.GroupPerks.Fighter.len(), 3, "three Fighter perks");

print("config OK\n");
print("Tests OK\n");
