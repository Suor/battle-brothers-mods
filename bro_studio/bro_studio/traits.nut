local Rand = ::std.Rand;

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
    "trait.disloyal"
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
function BroGen::addTraits(_player) {
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
        if (::BroGen.Debug) {
            this.logInfo("bg: bro " + _player.getName() + " adding " + trait[0]
                            + (isDubious(trait[0]) ? " SOSO" : ""));
        }
        _player.getSkills().add(new(trait[1]));
    }
}
