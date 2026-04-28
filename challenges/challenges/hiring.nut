local def = ::Challenges, mod = def.mh;
local Array = ::std.Array;

// Settings
def.add(::MSU.Class.SettingsDivider("hiringDiv"));
def.add(::MSU.Class.SettingsTitle("hiringTitle", "Hiring"));
def.add(::Challenges.SliderSetting("hiringRequirement", 0,
    [0, 5, 10, 20],
    ["off" "5x" "10x" "20x"],
    "Hiring Requirement",
    "You need to have this multiple of a bro's hiring cost in gold to even see him."
    + "Cheap bros like beggars and cripples are always there for you though."));

// Guaranteed cheap bros: never filtered out regardless of gold requirement.
// Just to not end up with noone to hire at all.
def.CheapBackgrounds <- [
    "beggar_background"
    "cripple_background"
    "ratcatcher_background"
    "refugee_background"
    "vagabond_background"
];
if (::Hooks.hasMod("mod_backgrounds_and_events")) {
    def.CheapBackgrounds.extend([
        "hackflows/leper_background"
        "hackflows/drifter_background"
    ]);
}
def.CheapClasses <- {}
foreach (bg in def.CheapBackgrounds) def.CheapClasses[split(bg, "/").top()] <- true;
// Wage fallback for other cheap backgrounds not in the explicit list.
def.LowWage <- 8;

local function isOk(_bro, _costLimit) {
    return _bro.getBackground().ClassName in def.CheapClasses
        || _bro.getDailyCost() <= def.LowWage
        || _bro.getHiringCost() <= _costLimit;
}

// Hook
mod.hookTree("scripts/scenarios/world/starting_scenario", function (q) {
    local prevList = def.CheapBackgrounds;
    q.onUpdateDraftList = @(__original) function (_list) {
        __original(_list);
        prevList = _list;
    }
    q.onUpdateHiringRoster = @(__original) function (_roster) {
        __original(_roster);

        local mult = def.conf("hiringRequirement");
        if (mult == 0) return;

        local limit = ::World.Assets.getMoney() / mult;
        local garbage = _roster.getAll().filter(@(_, b) !isOk(b, limit));

        // remove and replace them
        local toAdd = garbage.len()
        foreach (bro in garbage) _roster.remove(bro);

        local backgrounds = Array.concat(prevList, def.CheapBackgrounds); // make sure they are there
        while (toAdd > 0) {
            local newBro = _roster.create("scripts/entity/tactical/player");
            newBro.setStartValuesEx(backgrounds);
            if (isOk(newBro, limit)) toAdd--;
            else _roster.remove(newBro);
        }
    }
})
