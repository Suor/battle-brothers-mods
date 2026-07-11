// Micro-benchmark for title selection. Imports the real mod (not a copy) and
// times the hot paths: buildCandidates (evaluates every title's factor arrays,
// ~1.5k of them) and the full fillTitle (adds roster/state filtering + pick).
//
// Run: squirrel bench.nut
dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/mocks.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/helpers.nut", true);
dofile("mocks.nut", true);
dofile("scripts/!mods_preload/mod_nicknames.nut", true);

local def = ::Nicknames;

// A representative late-game combat bro: real background + several traits/perks
// and a few starred, maxed attributes so a chunk of factor arrays actually match.
local bro = makeBro(
    "background.sellsword",
    {   // onChangeAttributes, roughly a sellsword's
        Hitpoints = [5, 10], Bravery = [5, 10], Stamina = [0, 5],
        MeleeSkill = [8, 12], RangedSkill = [0, 0],
        MeleeDefense = [2, 4], RangedDefense = [0, 0], Initiative = [-5, 0]
    },
    ["trait.strong", "trait.brave", "trait.tough"],           // traits
    [3, 0, 3, 0, 0, 2, 0, 0],                                 // Talents (stars)
    {   // current properties — pushed high so *.high attr factors fire
        Hitpoints = 90, Bravery = 55, Stamina = 100,
        MeleeSkill = 75, RangedSkill = 40,
        MeleeDefense = 20, RangedDefense = 2, Initiative = 90
    },
    20,                                                        // DailyCost -> cost.high
    ["Sellsword"],                                            // vanilla bg .m.Titles
    ["perk.gifted", "perk.colossus", "perk.nine_lives",       // perks
     "perk.battle_flow", "perk.killing_frenzy", "perk.mastery.cleaver"]
);

// Warm-up + sanity: make sure we actually produce candidates.
local sample = def.buildCandidates(bro);
print(format("factors: %d, candidates: %d\n\n",
    def.buildFactorSet(bro).len(), sample.len()));

local function bench(_name, _n, _fn) {
    local t0 = clock();
    for (local i = 0; i < _n; i++) _fn();
    local total = clock() - t0;
    print(format("%-16s %6d calls  %8.1f ms total  %7.1f us/call\n",
        _name, _n, total * 1000.0, total / _n * 1e6));
}

local N = 2000;
bench("buildFactorSet", N, @() def.buildFactorSet(bro));
bench("buildCandidates", N, @() def.buildCandidates(bro));

// fillTitle mutates persisted state (recordGenerated); reset each call so the
// growing generated[] doesn't skew timing away from a fresh-bro cost.
bench("fillTitle", N, function () {
    resetTestFlags();
    def.State = null;
    def.fillTitle(bro);
});
