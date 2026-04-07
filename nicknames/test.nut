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

function hire(bro) {
    local impl = onHired(@(_bg, _add) null); // bind no-op __original, get inner function
    impl.call(bro, null, true);              // call with bro as "this", _addTraits = true
}

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

// TODO: check nicknames/titles.nut instead
// // ── Nickname length checks ────────────────────────────────────────────────

// function unicodeLen(s) {
//     local count = 0;
//     for (local i = 0; i < s.len(); i++)
//         if ((s[i] & 0xC0) != 0x80) count++;
//     return count;
// }

// // English: no nickname longer than 16 chars
// local longEn = [];
// foreach (entry in def.Nicknames)
//     foreach (n in entry.nicknames)
//         if (n.len() > 16) longEn.push(n);
// if (longEn.len() > 0)
//     throw "English nicknames > 16 chars: " + longEn.reduce(@(a, b) a + ", " + b);
// print("all English nicknames <= 16 chars OK\n");

// // Russian: no nickname longer than 16 unicode chars
// local ruNicknames = [];
// ::Rosetta <- {function add(_meta, pairs) {foreach (p in pairs) ruNicknames.push(p.ru)}}
// dofile("nicknames/rosetta_ru.nut", true);
// local longRu = [];
// foreach (n in ruNicknames)
//     if (unicodeLen(n) > 16) longRu.push(n);
// if (longRu.len() > 0)
//     throw "Russian nicknames > 16 chars: " + longRu.reduce(@(a, b) a + ", " + b);
// print("all Russian nicknames <= 16 chars OK\n");

// ── def.Titles tests ─────────────────────────────────────────────────────────

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

print("Tests OK\n");
