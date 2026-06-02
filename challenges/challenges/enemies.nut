local def = ::Challenges, mod = def.mh;

// Settings
def.add(::MSU.Class.SettingsDivider("enemiesDiv"));
def.add(::MSU.Class.SettingsTitle("enemiesTitle", "Enemies"));
def.add(::Challenges.SliderSetting("enemyScale", 1.0,
    [1.0, 1.25, 1.5, 2.0, 3.0],
    ["1x" "1.25x" "1.5x" "2x" "3x"],
    "Enemy Scaling",
    "Inflate the player party's perceived strength. Enemies scale to match it: "
    + "bigger parties for contracts, raids and ambushes; AI more willing to attack."));

// Hooks

// Player party strength feeds contract scaling, faction spawns and world AI.
// Multiply after the vanilla calc so all of them ratchet up together.
mod.hook("scripts/entity/world/player_party", function (q) {
    q.updateStrength = @(__original) function () {
        __original();
        local mult = def.conf("enemyScale");
        if (mult != 1.0) this.m.Strength = this.m.Strength * mult;
    }
})
