::BroGen <- {
    ID = "mod_brogen"
    Name = "BroGen"
    Version = 0.1

    // Debug = true // requires stdlib
}
local Rand = std.Rand;


::mods_registerMod(::BroGen.ID, ::BroGen.Version, ::BroGen.Name);
// ::mods_queue(::BroGen.ID, "mod_hooks(>=20)", function () {
//     ::include("brogen/chances");
//     ::include("brogen/hackflows_perks");
// })


local badTraitIds = [
    "trait.ailing"
    "trait.asthmatic"
    "trait.bleeder"
    "trait.brute"
    "trait.clubfooted"
    "trait.clumsy"
    "trait.cocky"
    "trait.craven"
    "trait.dastard"
    "trait.disloyal" // Actually positive :), but sounds bad
    "trait.dumb"
    "trait.fainthearted"
    "trait.fear_beasts"
    "trait.fear_greenskins"
    "trait.fear_undead"
    "trait.fragile"
    "trait.gluttonous"
    "trait.greedy"
    "trait.hesitant"
    "trait.insecure"
    "trait.irrational"
    "trait.night_blind"
    "trait.pessimist"
    "trait.short_sighted"
    "trait.superstitious"
    // Legends
    "trait.fear_nobles"
    "trait.frail"
    "trait.legend_appetite_donkey"
    "trait.legend_fear_dark"
    "trait.predictable"
    "trait.slack"

    // stupid game
    "trait.impatient"
];

local dubiousTraitIds = [
    "trait.drunkard"
    "trait.fat"
    "trait.impatient"
    // Legends
    "trait.aggressive"
    "trait.legend_diurnal"
    "trait.light"
    // additional to master
    "trait.huge"
    "trait.tiny"
    "trait.paranoid"
];

local allTraits = ::Const.CharacterTraits;
local okTraits = allTraits.filter(@(_, t) badTraitIds.find(t[0]) == null);
local goodTraits = okTraits.filter(@(_, t) dubiousTraitIds.find(t[0]) == null);

local function isDubious(traitId) {
    return dubiousTraitIds.find(traitId) != null;
}

// Expose this function so that it could be called externally or patched
function BroGen::setupPlayer(_player) {
    // local trait = Rand.choice(goodTraits);
    // _player.getSkills().add(new(trait[1]))

    // Stupid mode
    local pool = okTraits.filter(@(_, t) !_player.getSkills().hasSkill(t[0]));
    local gen = Rand.itake(pool);
    local num = 1, dubious = 0;
    while (num > 0) {
        local trait = resume gen;
        num--;
        if (isDubious(trait[0])) {
            num++;
            if (dubious) num++;
            dubious++;
        };
        this.logInfo("bg: bro " + _player.getName() + " adding " + trait[0]
            + (isDubious(trait[0]) ? " SOSO" : ""));
        _player.getSkills().add(new(trait[1]));
    }
}


::mods_queue(::BroGen.ID, "mod_hooks(>=20)", function() {
    local starting = false;
    ::mods_hookNewObject("entity/tactical/player", function (obj) {
        // local baseSetStartValuesEx = obj.setStartValuesEx;
        // obj.setStartValuesEx = function ( _backgrounds ) {
        //     baseSetStartValuesEx(_backgrounds);
        //     if (!starting) ::BroGen.setupPlayer(this);
        // };

        local onHired = obj.onHired;
        obj.onHired = function() {
          // this.logInfo("vap: hired " + this.getName());
          onHired();
          ::BroGen.setupPlayer(this);
        }
    });

    // TODO: update this comment
    // On setting up a new campaign all sort of things are hard coded,  typical is to  call
    // .setStartValuesEx() and assign LevelUps and call .fillAttributeLevelUpValues() later,
    // which breaks Gifted
    ::mods_hookExactClass("states/world_state", function (obj) {
        local startNewCampaign = obj.startNewCampaign;
        obj.startNewCampaign = function() {
            starting = true;
            startNewCampaign();
            starting = false;
            local roster = World.getPlayerRoster().getAll();
            foreach (bro in roster) ::BroGen.setupPlayer(bro);
        }
    });
})
