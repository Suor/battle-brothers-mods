// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_beast_loot@dev mod_msu stdlib@dev

// Beast Loot: every origin gets +50% extra beast loot chance (as Beast Slayers do in vanilla),
// Beast Slayers get 100%. The chance is what the beasts' onDeath rolls against.

// The extra loot chance each origin's onInit gives, from a zeroed asset manager.
local function chanceOf(_script) {
    local origin = ::new(_script);
    ::World.Assets.m.ExtraLootChance = 0;
    origin.onInit();
    return ::World.Assets.m.ExtraLootChance;
}

test("every origin: +50% extra beast loot, Beast Slayers 100%", function (t) {
    t.eq(::World.Assets.getExtraLootChance(), 50, "the company as started");
    local got = {}, want = {};
    foreach (file in ::IO.enumerateFiles("scripts/scenarios/world/")) {
        local name = split(file, "/").top();
        if (name == "starting_scenario") continue;
        got[name] <- chanceOf(file);
        want[name] <- name == "beast_hunters_scenario" ? 100 : 50;
    }
    ::World.Assets.resetToDefaults();
    t.eq(got.len(), 16, "vanilla origins checked");
    t.eq(got, want, "extra loot chance per origin");
});

test("the chance survives a reset of the assets and a load", function (t) {
    ::World.Retinue.setFollower(0, ::World.Retinue.getFollower("follower.cook")); // resets the assets
    t.eq(::World.Assets.getExtraLootChance(), 50, "after a reset");
    t.save("bl");
    yield t.load("bl");
    t.eq(::World.Assets.getExtraLootChance(), 50, "after a load");
});
