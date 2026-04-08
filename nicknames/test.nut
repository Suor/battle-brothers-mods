dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/mocks.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/helpers.nut", true);
dofile("mocks.nut", true);
dofile("scripts/!mods_preload/mod_nicknames.nut", true);

// TODO: redo tests to assert candidates list, i.e. move randomness out
local onHired = getNicknamesOnHired();
local def = ::Nicknames;

function assertIn(val, arr) {
    foreach (item in arr)
        if (item == val) return;
    throw "assertIn failed: '" + val + "' not in [" + arr.reduce(@(a, b) a + ", " + b) + "]";
}

function candidateTitles(bro) {
    return def.buildCandidates(bro).map(@(c) c.title);
}

// Vanilla background .m.Titles are used
// Use an unknown background (not in BackgroundNicknames) so only m.Titles contribute
local broVanillaBg = makeBro("background.unknown_bg", null, [], null, null, 5, ["VanillaBgTitle"]);
def.fillTitle(broVanillaBg)
assertIn(broVanillaBg.getTitle(), ["VanillaBgTitle"]);
print("vanilla background m.Titles OK\n");

// Vanilla trait .m.Titles are used
// Use an unknown trait ID (not in TraitNicknames) so only m.Titles contribute
local broVanillaTrait = makeBro("background.unknown_bg", null,
    [{id = "trait.unknown", titles = ["VanillaTraitTitle"]}]);
def.fillTitle(broVanillaTrait)
assertIn(broVanillaTrait.getTitle(), ["VanillaTraitTitle"]);
print("vanilla trait m.Titles OK\n");

// Single-factor title: trait.tiny should produce Shorty, Little, Ant, etc.
local broTiny = makeBro("background.farmhand", null, ["trait.tiny"]);
local tinyTitles = candidateTitles(broTiny);
foreach (expected in ["Shorty", "Little", "Ant"])
    assertIn(expected, tinyTitles);
print("titles: single factor (trait.tiny) OK\n");

// Multi-factor title: trait.tiny + trait.bright → Imp
local broImp = makeBro("background.farmhand", null, ["trait.tiny", "trait.bright"]);
local impTitles = candidateTitles(broImp);
assertIn("Imp", impTitles);
// Should also have single-factor titles
assertIn("Shorty", impTitles);
print("titles: multi-factor combo OK\n");

// Title NOT matched when factors are missing
local broBrave = makeBro("background.farmhand", null, ["trait.brave"]);
local braveTitles = candidateTitles(broBrave);
if (braveTitles.find("Shorty") != null) throw "Shorty should not appear for trait.brave";
print("titles: no false matches OK\n");

// Titles weight: combo should weigh more than single factor
local W = def.Weights;
local weightCands = def.buildCandidates(broImp);
assertEq(weightCands.filter(@(_, c) c.title == "Shorty"), [{title = "Shorty", weight = W.trait}]);
assertEq(weightCands.filter(@(_, c) c.title == "Imp"), [{title = "Imp", weight = W.trait * W.trait}]);
print("titles: combo weight > single weight OK\n");

// Built-in vanilla background .m.Titles appear in candidates
local broBuiltinBg = makeBro("background.unknown_bg", null, [], null, null, 5, ["VanillaBgTitle"]);
assertIn("VanillaBgTitle", candidateTitles(broBuiltinBg));
print("titles: built-in background titles in candidates OK\n");

// Built-in vanilla trait .m.Titles appear in candidates
local broBuiltinTrait = makeBro("background.unknown_bg", null,
    [{id = "trait.unknown", titles = ["VanillaTraitTitle"]}]);
assertIn("VanillaTraitTitle", candidateTitles(broBuiltinTrait));
print("titles: built-in trait titles in candidates OK\n");

// perk.* factor: perk.student should unlock Pedant
local broPerkStudent = makeBro("background.farmhand", null, [], null, null, 5, [], ["perk.student"]);
assertIn("Pedant", candidateTitles(broPerkStudent));
print("titles: perk factor (perk.student) OK\n");

// perk factor NOT matched when bro lacks the perk
local broNoPerk = makeBro("background.farmhand");
if (candidateTitles(broNoPerk).find("Pedant") != null) throw "Pedant should not appear without perk.student";
print("titles: perk factor absent → no match OK\n");

// ── attr.high / attr.low tests ───────────────────────────────────────────────

// Helpers: explicit baseProps so we can tweak one stat at a time
local defProps = {
    Hitpoints = 55, Bravery = 35, Stamina = 95,
    MeleeSkill = 52, RangedSkill = 37,
    MeleeDefense = 2, RangedDefense = 2, Initiative = 105
};
function withProp(overrides) {
    local p = clone defProps;
    foreach (k, v in overrides) p[k] <- v;
    return p;
}
// attr.Stamina.high: stars=1, limit = base_high(100) + bgChange - stars(1)
// talents index: Hitpoints=0, Stamina=1
local broHighStamina = makeBro("background.farmhand", null, [], [0, 1, 0, 0, 0, 0, 0, 0],
    withProp({Stamina = 109}));
assert(broHighStamina.getCurrentProperties().Stamina == 109, "expect 1 less than no-talent high limit (100+bG)");
assertIn("Workhorse", candidateTitles(broHighStamina));
print("attr.Stamina.high triggers OK\n");

// attr.Stamina.high does NOT trigger without a talent
local broHighStaminaNoTalent = makeBro("background.farmhand", null, [], null,
    withProp({Stamina = 110}));
if (candidateTitles(broHighStaminaNoTalent).find("Workhorse") != null)
    throw "Workhorse should not appear without stamina talent";
print("attr.Stamina.high: no talent → no trigger OK\n");

// attr.Initiative.low: stars=0, limit = base_low(100) + bgChange
// talents index: Initiative=3
local broLowInit = makeBro("background.farmhand", null, [], null,
    withProp({Initiative = 100}));
// FIX: do not assert the Initiative value, assert the limit, here it is low limit. Apply to all such checks here
// assertEq(broLowInit.getCurrentProperties().Initiative, 110);
assertIn("Lazybones", candidateTitles(broLowInit));
print("attr.Initiative.low triggers OK\n");

// attr.Initiative.low does NOT trigger when stat is above the limit
local broMidInit = makeBro("background.farmhand", null, [], null,
    withProp({Initiative = 101}));
if (candidateTitles(broMidInit).find("Lazybones") != null)
    throw "Lazybones should not appear when initiative is above limit";
print("attr.Initiative.low: stat above limit → no trigger OK\n");

// attr.Hitpoints.low: stars=0, limit = base_low(50) + bgChange
local broLowHP = makeBro("background.farmhand", null, [], null,
    withProp({Hitpoints = 50}));
// assertEq(broLowHP.getCurrentProperties().Hitpoints, 60);
assertIn("Runt", candidateTitles(broLowHP));
print("attr.Hitpoints.low triggers OK\n");

// attr.Hitpoints.low does NOT trigger when bro has a Hitpoints talent (stars=1)
local broLowHPWithTalent = makeBro("background.farmhand", null, [], [1, 0, 0, 0, 0, 0, 0, 0],
    withProp({Hitpoints = 50}));
if (candidateTitles(broLowHPWithTalent).find("Runt") != null)
    throw "Runt should not appear when bro has hitpoints talent";
print("attr.Hitpoints.low: has talent → no trigger OK\n");

// ── BgPerks.fallbacks → perk aliases ─────────────────────────────────────────

// perk.rf_promised_potential is a fallback for perk.student → should match Pedant
local broFallbackPerk = makeBro("background.farmhand", null, [], null, null, 5, [], ["perk.rf_promised_potential"]);
assertIn("Pedant", candidateTitles(broFallbackPerk));
print("aliases: BgPerks fallback perk matches canonical perk titles OK\n");

// ── def.Aliases tests ────────────────────────────────────────────────────────

// background.cultist_commander should match titles for background.cultist
local broCultistCmd = makeBro("background.cultist_commander");
local cultistCandidates = candidateTitles(broCultistCmd);
// Find a title that uses background.cultist factor
local cultistBro = makeBro("background.cultist");
local cultistDirectCandidates = candidateTitles(cultistBro);
foreach (t in cultistDirectCandidates)
    assertIn(t, cultistCandidates);
print("aliases: cultist_commander matches cultist titles OK\n");

// background.xxherosp should match titles for background.adventurous_noble
local broXXherosp = makeBro("background.xxherosp");
local nobleBro = makeBro("background.adventurous_noble");
local nobleCandidates = candidateTitles(nobleBro);
local xxheroCandidates = candidateTitles(broXXherosp);
foreach (t in nobleCandidates)
    assertIn(t, xxheroCandidates);
print("aliases: xxherosp matches adventurous_noble titles OK\n");

print("Tests OK\n");
