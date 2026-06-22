dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/mocks.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/helpers.nut", true);
dofile("mocks.nut", true);
dofile("scripts/!mods_preload/mod_nicknames.nut", true);

// TODO: redo tests to assert candidates list, i.e. move randomness out
local def = ::Nicknames;

function assertIn(val, arr) {
    foreach (item in arr)
        if (item == val) return;
    throw "assertIn failed: '" + val + "' not in [" + arr.reduce(@(a, b) a + ", " + b) + "]";
}

function candidateTitles(bro) {
    return def.buildCandidates(bro).map(@(c) c.title);
}

function attrLimit(bro, attr, isHigh) {
    local br = def.BaseAttrRanges[attr];
    local changeAttrs = bro.getBackground().onChangeAttributes();
    local stars = bro.m.Talents[::Const.Attributes[attr == "Stamina" ? "Fatigue" : attr]];
    return isHigh ? br[1] + changeAttrs[attr][1] - stars + 1 : br[0] + changeAttrs[attr][0];
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
foreach (expected in ["Shorty", "the Little", "the Ant"])
    assertIn(expected, tinyTitles);
print("titles: single factor (trait.tiny) OK\n");

// Multi-factor title: trait.tiny + trait.bright → Imp
local broImp = makeBro("background.farmhand", null, ["trait.tiny", "trait.bright"]);
local impTitles = candidateTitles(broImp);
assertIn("the Imp", impTitles);
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
assertEq(weightCands.filter(@(_, c) c.title == "the Imp"), [{title = "the Imp", weight = W.trait * W.trait}]);
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
assertIn("the Pedant", candidateTitles(broPerkStudent));
print("titles: perk factor (perk.student) OK\n");

// perk factor NOT matched when bro lacks the perk
local broNoPerk = makeBro("background.farmhand");
if (candidateTitles(broNoPerk).find("the Pedant") != null) throw "the Pedant should not appear without perk.student";
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
// attr.Stamina.high: stars=1, limit = base_high(100) + bgChange - stars(1) + 1
// talents index: Hitpoints=0, Stamina=1
local broHighStamina = makeBro("background.farmhand", null, [], [0, 1, 0, 0, 0, 0, 0, 0],
    withProp({Stamina = 110}));
assertEq(attrLimit(broHighStamina, "Stamina", true), 110);
assertIn("the Workhorse", candidateTitles(broHighStamina));
print("attr.Stamina.high triggers OK\n");

// attr.Stamina.high does NOT trigger one below the limit (109 with 1 star)
local broAlmostHighStamina = makeBro("background.farmhand", null, [], [0, 1, 0, 0, 0, 0, 0, 0],
    withProp({Stamina = 109}));
if (candidateTitles(broAlmostHighStamina).find("the Workhorse") != null)
    throw "the Workhorse should not appear one below the high limit";
print("attr.Stamina.high: one below limit → no trigger OK\n");

// attr.Stamina.high does NOT trigger without a talent
local broHighStaminaNoTalent = makeBro("background.farmhand", null, [], null,
    withProp({Stamina = 110}));
if (candidateTitles(broHighStaminaNoTalent).find("the Workhorse") != null)
    throw "the Workhorse should not appear without stamina talent";
print("attr.Stamina.high: no talent → no trigger OK\n");

// attr.Initiative.low: stars=0, limit = base_low(100) + bgChange
// talents index: Initiative=3
local broLowInit = makeBro("background.farmhand", null, [], null,
    withProp({Initiative = 100}));
assertEq(attrLimit(broLowInit, "Initiative", false), 100);
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
assertEq(attrLimit(broLowHP, "Hitpoints", false), 50);
assertIn("the Runt", candidateTitles(broLowHP));
print("attr.Hitpoints.low triggers OK\n");

// attr.Hitpoints.low does NOT trigger when bro has a Hitpoints talent (stars=1)
local broLowHPWithTalent = makeBro("background.farmhand", null, [], [1, 0, 0, 0, 0, 0, 0, 0],
    withProp({Hitpoints = 50}));
if (candidateTitles(broLowHPWithTalent).find("the Runt") != null)
    throw "the Runt should not appear when bro has hitpoints talent";
print("attr.Hitpoints.low: has talent → no trigger OK\n");

// ── BgPerks.fallbacks → perk aliases ─────────────────────────────────────────

// perk.rf_promised_potential is a fallback for perk.student → should match Pedant
local broFallbackPerk = makeBro("background.farmhand", null, [], null, null, 5, [], ["perk.rf_promised_potential"]);
assertIn("the Pedant", candidateTitles(broFallbackPerk));
print("aliases: BgPerks fallback perk matches canonical perk titles OK\n");

// ── North Expansion traits ───────────────────────────────────────────────────

// trait.skald inspires allies → woven into the Bannerman
local broSkald = makeBro("background.sellsword", null, ["trait.skald"]);
assertIn("the Bannerman", candidateTitles(broSkald));
print("NE: trait.skald matches the Bannerman OK\n");

// trait.chosen → the Chosen
local broChosen = makeBro("background.sellsword", null, ["trait.chosen"]);
assertIn("the Chosen", candidateTitles(broChosen));
print("NE: trait.chosen matches the Chosen OK\n");

// ── group.* tests ────────────────────────────────────────────────────────────

// group.pauper: beggar is in the pauper list
local broPauper = makeBro("background.beggar");
assert("group.pauper" in def.buildFactorSet(broPauper));
local broNotPauper = makeBro("background.sellsword");
assert(!("group.pauper" in def.buildFactorSet(broNotPauper)));
print("group.pauper OK\n");

// group.noble: set via bgProps
local broNoble = makeBro("background.adventurous_noble", null, [], null, null, 5, [], [], {IsNoble = true});
assert("group.noble" in def.buildFactorSet(broNoble));
local broNotNoble = makeBro("background.adventurous_noble");
assert(!("group.noble" in def.buildFactorSet(broNotNoble)));
print("group.noble OK\n");

// group.combat: set via bgProps
local broCombat = makeBro("background.sellsword", null, [], null, null, 5, [], [], {IsCombatBackground = true});
assert("group.combat" in def.buildFactorSet(broCombat));
local broNotCombat = makeBro("background.farmhand");
assert(!("group.combat" in def.buildFactorSet(broNotCombat)));
print("group.combat OK\n");

// group.lowborn: set via bgProps
local broLowborn = makeBro("background.farmhand", null, [], null, null, 5, [], [], {IsLowborn = true});
assert("group.lowborn" in def.buildFactorSet(broLowborn));
local broNotLowborn = makeBro("background.farmhand");
assert(!("group.lowborn" in def.buildFactorSet(broNotLowborn)));
print("group.lowborn OK\n");


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

// background.chosen now aliases into trait.chosen (not wildman) → the Chosen
local broBgChosen = makeBro("background.chosen");
assert("trait.chosen" in def.buildFactorSet(broBgChosen));
assertIn("the Chosen", candidateTitles(broBgChosen));
print("aliases: background.chosen matches the Chosen OK\n");

// trait.thrall (NE) aliases into background.slave → the Brand
local broThrall = makeBro("background.sellsword", null, ["trait.thrall"]);
assert("background.slave" in def.buildFactorSet(broThrall));
assertIn("the Brand", candidateTitles(broThrall));
print("aliases: trait.thrall matches slave titles OK\n");

// background.xxherosp should match titles for background.adventurous_noble
local broXXherosp = makeBro("background.xxherosp");
local nobleBro = makeBro("background.adventurous_noble");
local nobleCandidates = candidateTitles(nobleBro);
local xxheroCandidates = candidateTitles(broXXherosp);
foreach (t in nobleCandidates)
    assertIn(t, xxheroCandidates);
print("aliases: xxherosp matches adventurous_noble titles OK\n");

// ── injury.* (permanent injuries) tests ──────────────────────────────────────

// injury.missing_eye should unlock One-Eye and Squinty
local broMissingEye = makeBro("background.farmhand", null, [], null, null, 5, [], [], null, ["injury.missing_eye"]);
local eyeTitles = candidateTitles(broMissingEye);
assertIn("One-Eye", eyeTitles);
assertIn("the Squinty", eyeTitles);
print("injury.missing_eye triggers OK\n");

// injury factor appears in factorSet
assert("injury.missing_eye" in def.buildFactorSet(broMissingEye));
print("injury factor in factorSet OK\n");

// injury weight is applied correctly
local eyeCands = def.buildCandidates(broMissingEye);
assertEq(eyeCands.filter(@(_, c) c.title == "One-Eye"), [{title = "One-Eye", weight = W.injury}]);
print("injury weight OK\n");

// no injury → no injury titles
local broNoInjury = makeBro("background.farmhand");
if (candidateTitles(broNoInjury).find("One-Eye") != null)
    throw "One-Eye should not appear without injury.missing_eye";
print("no injury → no injury titles OK\n");

// combo: injury + trait
local broDancer = makeBro("background.farmhand", null, ["trait.drunkard"], null, null, 5, [], [], null, ["injury.broken_knee"]);
assertIn("the Dancer", candidateTitles(broDancer));
print("injury + trait combo OK\n");

// ── post-filter cascade tests ────────────────────────────────────────────────
// Helpers
function makeRosterBro(_title) {
    local b = makeBro("background.farmhand");
    b.setTitle(_title);
    b.m.Title <- _title;
    return b;
}
function fresh(traits = ["trait.tiny"]) {
    return makeBro("background.farmhand", null, traits);
}

// Reset and run on a clean state, single bro picks Shorty (first by Math.rand mock)
resetTestFlags();
def.State = null;
setTestRoster([]);
setTestDay(10);
local bro1 = fresh();
def.fillTitle(bro1);
assertEq(bro1.getTitle(), "Shorty");
print("fillTitle: clean state picks first OK\n");

// State recorded after fillTitle
local state = def.loadState();
assertEq(state.generated.Shorty.days, [10]);
print("fillTitle: writes generated[title].days OK\n");

// Same day, second generated bro: Shorty is in set14 → next candidate picked
local bro2 = fresh();
def.fillTitle(bro2);
if (bro2.getTitle() == "Shorty") throw "set14 should block Shorty";
print("fillTitle: set14 blocks recently generated OK\n");

// Title in current roster → blocked by `bros`
resetTestFlags();
def.State = null;
local rosterBro = makeRosterBro("Shorty");
setTestRoster([rosterBro]);
local bro3 = fresh();
def.fillTitle(bro3);
if (bro3.getTitle() == "Shorty") throw "bros should block Shorty";
print("fillTitle: bros set blocks current roster OK\n");

// onHired records to state.hired and fallen blocks it
resetTestFlags();
def.State = null;
setTestRoster([]);
def.loadState().hired["Shorty"] <- 1; // simulate prior hire
def.saveState();
local bro4 = fresh();
def.fillTitle(bro4);
if (bro4.getTitle() == "Shorty") throw "fallen (hired - bros) should block Shorty";
print("fillTitle: fallen blocks ever-hired non-roster OK\n");

// Record outside window: day 10 entry, today=30 → trim drops it on next fillTitle
// Use trait.brave bro so Shorty isn't re-picked.
resetTestFlags();
def.State = null;
setTestDay(30);
def.loadState().generated["Shorty"] <- {days = [10]};
def.saveState();
local braveBro = makeBro("background.farmhand", null, ["trait.brave"]);
def.fillTitle(braveBro); // triggers trim
local s = def.loadState();
assertEq(s.generated, {[braveBro.getTitle()] = {days = [30]}}); // Shorty gone, only today's pick
print("fillTitle: trim removes records past 14-day window OK\n");

// 7-day window narrower than 14: Shorty at day 8, today=20 → in set14, not in set7
resetTestFlags();
def.State = null;
setTestDay(20);
def.loadState().generated["Shorty"] <- {days = [8]};
def.saveState();
local bro5 = fresh();
def.fillTitle(bro5);
// Level1 (set14) blocks Shorty → picks next non-Shorty
if (bro5.getTitle() == "Shorty") throw "set14 should still block Shorty at day 20";
local s2 = def.loadState();
assertEq(s2.generated.Shorty, {days = [8]}); // within 14-day window, untouched
print("fillTitle: 7-day window narrower than 14 OK\n");

// Cascade fallback: ALL candidates blocked at level1 → falls back, eventually picks
resetTestFlags();
def.State = null;
setTestDay(10);
local probe = fresh();
local allCandidateTitles = candidateTitles(probe);
local st = def.loadState();
foreach (t in allCandidateTitles) st.generated[t] <- {days = [10]};
def.saveState();
local bro6 = fresh();
def.fillTitle(bro6); // set14 blocks all → falls through; eventually empty-set level → pick first
assertIn(bro6.getTitle(), allCandidateTitles);
print("fillTitle: cascade falls back when all blocked OK\n");

// onHired hook captured and writes to state.hired
resetTestFlags();
def.State = null;
local hiredBro = makeRosterBro("Bjorn");
local onHiredFn = getNicknamesOnHired();
assert(onHiredFn != null);
onHiredFn.call(hiredBro);
assertEq(def.loadState().hired.Bjorn, 1);
onHiredFn.call(hiredBro);
assertEq(def.loadState().hired.Bjorn, 2);
print("onHired hook records into state.hired OK\n");

print("Tests OK\n");
