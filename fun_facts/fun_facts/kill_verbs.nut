local Str = ::std.Str, Text = ::std.Text;

local fatalities = {};
fatalities[1] <- "chopped %s";
fatalities[2] <- "smashed %s";
fatalities[3] <- "gutted %s";

local function expand(_groups) {
    local result = {};
    foreach (pair in _groups) {
        local verb = pair[0];
        foreach (id in pair[1]) result[id] <- verb;
    }
    return result;
}

local skillVerbs = expand([
    ["shot %s in the back", [
        "actives.shoot_bolt"
        "actives.aimed_shot"
        "actives.quick_shot"
        "actives.fire_handgonne"
        "actives.shoot_stake"
        "actives.sling_stone"
        "actives.rf_arrow_to_the_knee"
        "actives.rf_flaming_arrows"
    ]],
    ["skewered %s", [
        "actives.throw_javelin"
        "actives.throw_spear"
        "actives.prong"
    ]],
    ["hatcheted %s", ["actives.throw_axe"]],
    ["pelted %s",    ["actives.throw_balls"]],
    ["stabbed %s", [
        "actives.thrust"
        "actives.stab"
    ]],
    ["ran %s through", [
        "actives.puncture"
        "actives.lunge"
        "actives.rf_sword_thrust"
    ]],
    ["impaled %s",   ["actives.impale"]],
    ["gouged %s",    ["actives.rf_gouge"]],
    ["hacked up %s", [
        "actives.slash"
        "actives.chop"
        "actives.gash"
    ]],
    ["cleaved %s", [
        "actives.cleave"
        "actives.split"
        "actives.split_axe"
        "actives.split_man"
        "actives.rf_cleaving_split"
        "actives.rf_cleaving_swing"
        "actives.rf_great_cleave"
        "actives.rf_heavy_cleave"
        "actives.rf_voulge_cleave"
    ]],
    ["beheaded %s",    ["actives.decapitate"]],
    ["eviscerated %s", ["actives.rupture"]],
    ["swept %s away", [
        "actives.round_swing"
        "actives.sweep"
    ]],
    ["mowed down %s", ["actives.swing"]],
    ["reaped %s",     ["actives.reap"]],
    ["thrashed %s", [
        "actives.flail"
        "actives.rf_flail_pole"
    ]],
    ["whipped %s", [
        "actives.lash"
        "actives.rf_lash_pole"
    ]],
    ["clobbered %s", [
        "actives.bash"
        "actives.rf_shield_bash"
    ]],
    ["hammered %s",   ["actives.hammer"]],
    ["pulverized %s", ["actives.pound"]],
    ["crushed %s", [
        "actives.crush_armor"
        "actives.demolish_armor"
        "actives.rf_deep_impact"
    ]],
    ["felled %s", [
        "actives.overhead_strike"
        "actives.strike"
        "actives.strike_down"
    ]],
    ["battered %s",   ["actives.batter"]],
    ["shattered %s",  ["actives.shatter"]],
    ["pummeled %s",   ["actives.rf_pummel"]],
    ["plowed into %s",["actives.rf_swordmaster_charge"]],
    ["booted %s",     ["actives.rf_swordmaster_kick"]],
    ["tackled %s",    ["actives.rf_swordmaster_tackle"]],
]);

local function getKillVerb(_kill) {
    if (_kill.Fatality in fatalities) return fatalities[_kill.Fatality];
    if (_kill.Skill != null && (_kill.Skill in skillVerbs)) return skillVerbs[_kill.Skill];
    return "killed %s";
}

local function joinNames(_names) {
    if (_names.len() == 1) return _names[0];
    if (_names.len() == 2) return _names[0] + " and " + _names[1];
    return Str.join(", ", _names.slice(0, _names.len() - 1)) + " and " + _names[_names.len() - 1];
}

::FunFacts.PlayerKillsHint <- function(_kills) {
    local groups = {}, groupOrder = [];
    foreach (kill in _kills) {
        local verb = getKillVerb(kill);
        if (!(verb in groups)) {
            groups[verb] <- [];
            groupOrder.push(verb);
        }
        groups[verb].push(Text.ally(kill.Name));
    }
    local parts = groupOrder.map(function(verb) {
        return format(verb, joinNames(groups[verb]));
    });
    return "Unwittingly " + Str.join(". ", parts);
}
