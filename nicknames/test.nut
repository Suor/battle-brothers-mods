dofile(getenv("STDLIB_DIR") + "tests/mocks.nut", true);
dofile("mocks.nut", true);
dofile("scripts/!mods_preload/mod_nicknames.nut", true);

local onHired = getNicknamesOnHired();
local def = ::Nicknames;

function assertIn(val, arr) {
    foreach (item in arr)
        if (item == val) return;
    throw "assertIn failed: '" + val + "' not in [" + arr.reduce(@(a, b) a + ", " + b) + "]";
}

function hire(bro) {
    local impl = onHired(@() null); // bind no-op __original, get inner function
    impl.call(bro);                 // call with bro as "this"
}

// Background: vanilla gravedigger
local bro = makeBro("background.gravedigger");
hire(bro);
assertIn(bro.getTitle(), def.BackgroundNicknames["gravedigger"]);
print("vanilla background OK\n");

// Background: XBE hackflows falconer (ID uses underscores, not slashes)
// Real ID set explicitly in hackflows/falconer_background.nut: m.ID = "background.hackflows_falconer"
local bro2 = makeBro("background.hackflows_falconer");
hire(bro2);
assertIn(bro2.getTitle(), def.BackgroundNicknames["hackflows_falconer"]);
print("XBE hackflows background OK\n");

// Attr-based: bro with high RangedSkill for falconer (at or above range max = 42+10 = 52)
local falconerAttrs = {
    Hitpoints = [-3, -3], Bravery = [0, 0], Stamina = [0, 0],
    MeleeSkill = [0, 0], RangedSkill = [8, 10],
    MeleeDefense = [-5, 0], RangedDefense = [4, 4], Initiative = [14, 20]
};
local falconerHighRS = makeBro("background.hackflows_falconer", falconerAttrs, [], null,
    {Hitpoints=47, Bravery=35, Stamina=95, MeleeSkill=52, RangedSkill=52,
     MeleeDefense=2, RangedDefense=6, Initiative=120});
hire(falconerHighRS);
if (falconerHighRS.getTitle() == "") throw "Expected title for high RangedSkill bro";
print("attr-based (high RangedSkill) OK\n");

// Trait-based title
local bro3 = makeBro("background.farmhand", null, ["trait.strong"]);
hire(bro3);
if (bro3.getTitle() == "") throw "Expected title for bro with trait.strong";
print("trait nickname OK\n");

// Combo: strong + brave (highest weight, picked first)
local bro4 = makeBro("background.farmhand", null, ["trait.strong", "trait.brave"]);
hire(bro4);
assertIn(bro4.getTitle(), def.ComboNicknames[0].nicknames); // first combo is strong+brave
print("combo nickname OK\n");

// Elite background + 3-star MeleeSkill talent → "Born Mercenary" / "Natural Killer"
// sellsword DailyCost = 35 → isEliteBg triggers (threshold >= 25)
local eliteTalents = [0, 0, 3, 0, 0, 0, 0, 0]; // index 2 = MeleeSkill = 3 stars
local broElite = makeBro("background.sellsword", null, [], eliteTalents, null, 35);
hire(broElite);
assertIn(broElite.getTitle(), ["Born Mercenary", "Natural Killer"]);
print("elite background combo OK\n");

// Non-elite background + 3-star MeleeSkill should NOT trigger Born Mercenary
// farmhand DailyCost = 4 → isEliteBg does not trigger
local broNonElite = makeBro("background.farmhand", null, [], eliteTalents, null, 4);
hire(broNonElite);
if (broNonElite.getTitle() == "Born Mercenary" || broNonElite.getTitle() == "Natural Killer")
    throw "Non-elite bro should not get mercenary nickname, got: " + broNonElite.getTitle();
print("non-elite background combo skipped OK\n");

// Vanilla background .m.Titles are used
// Use an unknown background (not in BackgroundNicknames) so only m.Titles contribute
local broVanillaBg = makeBro("background.unknown_bg", null, [], null, null, 5, ["VanillaBgTitle"]);
hire(broVanillaBg);
assertIn(broVanillaBg.getTitle(), ["VanillaBgTitle"]);
print("vanilla background m.Titles OK\n");

// Vanilla trait .m.Titles are used
// Use an unknown trait ID (not in TraitNicknames) so only m.Titles contribute
local broVanillaTrait = makeBro("background.unknown_bg", null,
    [{id = "trait.unknown", titles = ["VanillaTraitTitle"]}]);
hire(broVanillaTrait);
assertIn(broVanillaTrait.getTitle(), ["VanillaTraitTitle"]);
print("vanilla trait m.Titles OK\n");

print("Tests OK\n");
