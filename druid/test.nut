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

// --- isPerkBlocked: implicit Nature/Beast exclusion -------------------------

// Nothing taken yet: both gates open, the Beastform-gated perks closed, Venom open.
local none = makeSkills([]);
eq(Druid.isPerkBlocked(D + "regrowth",  none), false, "fresh: regrowth open");
eq(Druid.isPerkBlocked(D + "beastform", none), false, "fresh: beastform open");
eq(Druid.isPerkBlocked(D + "beast_aura", none), true,  "fresh: beast_aura gated by beastform");
eq(Druid.isPerkBlocked(D + "beast_rage", none), true,  "fresh: beast_rage gated by beastform");
eq(Druid.isPerkBlocked(D + "venom",     none), false, "fresh: venom open");

// A Nature perk taken: Beastform and the whole Beast side close; Nature stays open.
local nature = makeSkills([D + "regrowth"]);
eq(Druid.isPerkBlocked(D + "beastform",  nature), true,  "nature: beastform closed");
eq(Druid.isPerkBlocked(D + "hatch",      nature), false, "nature: hatch open");
eq(Druid.isPerkBlocked(D + "entangle",   nature), false, "nature: entangle open");
eq(Druid.isPerkBlocked(D + "apex",       nature), false, "nature: apex open");
eq(Druid.isPerkBlocked(D + "beast_aura", nature), true,  "nature: beast_aura closed");
eq(Druid.isPerkBlocked(D + "beast_rage", nature), true,  "nature: beast_rage closed");
eq(Druid.isPerkBlocked(D + "venom",      nature), false, "nature: venom open");

// Beastform taken: all Nature perks close; Beast Aura/Rage open up; Venom still open.
local beast = makeSkills([D + "beastform"]);
eq(Druid.isPerkBlocked(D + "regrowth",   beast), true,  "beast: regrowth closed");
eq(Druid.isPerkBlocked(D + "hatch",      beast), true,  "beast: hatch closed");
eq(Druid.isPerkBlocked(D + "entangle",   beast), true,  "beast: entangle closed");
eq(Druid.isPerkBlocked(D + "apex",       beast), true,  "beast: apex closed");
eq(Druid.isPerkBlocked(D + "beast_aura", beast), false, "beast: beast_aura open");
eq(Druid.isPerkBlocked(D + "beast_rage", beast), false, "beast: beast_rage open");
eq(Druid.isPerkBlocked(D + "venom",      beast), false, "beast: venom open");

// Venom before Rage: Beast Rage closes (the exclusive pair), Venom itself unaffected.
local beastVenom = makeSkills([D + "beastform", D + "venom"]);
eq(Druid.isPerkBlocked(D + "beast_rage", beastVenom), true,  "venom+beastform: beast_rage closed");
eq(Druid.isPerkBlocked(D + "beast_aura", beastVenom), false, "venom+beastform: beast_aura open");
eq(Druid.isPerkBlocked(D + "venom",      beastVenom), false, "venom+beastform: venom (held) not blocked");

// Rage taken: Venom closes (other half of the exclusive pair).
local rager = makeSkills([D + "beastform", D + "beast_rage"]);
eq(Druid.isPerkBlocked(D + "venom",      rager), true,  "rage: venom closed");
eq(Druid.isPerkBlocked(D + "beast_aura", rager), false, "rage: beast_aura open");

print("isPerkBlocked OK\n");

// --- perkBlockReason + verifyPrerequisites (the DPF lock) -------------------

eq(Druid.perkBlockReason(D + "regrowth", none), null, "fresh: regrowth has no block reason");
eq(Druid.perkBlockReason(D + "regrowth", beast),
   "Locked because this character walks the path of the Beast", "beast: regrowth reason");
eq(Druid.perkBlockReason(D + "beastform", nature),
   "Locked because this character walks the path of Nature", "nature: beastform reason");
eq(Druid.perkBlockReason(D + "beast_aura", none),
   "Locked because it requires Beastform", "fresh: beast_aura reason");
eq(Druid.perkBlockReason(D + "venom", rager),
   "Locked because Venom and Beast Rage are mutually exclusive", "rage: venom reason");

// verifyPrerequisites on the perk def: passes when open, pushes a locked hint when blocked.
local regrowthDef = ::Const.Perks.LookupMap[D + "regrowth"];
local openTooltip = [];
eq(regrowthDef.verifyPrerequisites({getSkills = @() none}, openTooltip), true,
   "verifyPrerequisites: open perk passes");
eq(openTooltip.len(), 0, "verifyPrerequisites: open perk adds no hint");
local lockedTooltip = [];
eq(regrowthDef.verifyPrerequisites({getSkills = @() beast}, lockedTooltip), false,
   "verifyPrerequisites: blocked perk fails");
eq(lockedTooltip.len(), 1, "verifyPrerequisites: blocked perk adds one hint");
eq(lockedTooltip[0].text, "Locked because this character walks the path of the Beast",
   "verifyPrerequisites: hint carries the reason");

print("perkBlockReason OK\n");

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
eq(Druid.GroupPerks.Nature.len(), 4, "four Nature perks");
eq(Druid.GroupPerks.Beast.len(), 3, "three Beast perks");

print("config OK\n");
print("Tests OK\n");
