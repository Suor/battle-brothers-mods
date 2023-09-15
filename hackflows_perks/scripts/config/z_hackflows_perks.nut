local function addPerk(row, afterID, perk) {
    local pos;
    if (afterID == null) {
        pos = 0;
    } else {
        local afterPerk = ::Const.Perks.LookupMap[afterID];
        pos = ::Const.Perks.Perks[row].find(afterPerk) + 1;
    }
    ::Const.Perks.Perks[row].insert(pos, perk);
    perk.Row <- row;
    perk.Unlocks <- row;
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

// TODO: rename to tireless, liquid, energetic, enduring, exercise, shadow, flexible ???
addPerk(4, "perk.lone_wolf", {
    ID = "perk.hackflows.steadfast"
    Script = "scripts/skills/perks/perk_hackflows_steadfast"
    Name = "Steadfast"
    Tooltip = "Getting hit or missed costs " + green("half") + " of the usual fatigue."
    Icon = "wotn_perks/clarity_circle.png"
    IconDisabled = "wotn_perks/clarity_circle_bw.png"
})
addPerk(4, null, {
    ID = "perk.hackflows.bloody_harvest"
    Script = "scripts/skills/perks/perk_hackflows_bloody_harvest"
    Name = "Bloody Harvest"
    Tooltip = "Gain " + green("+10%") + " chance to hit for all area of effect attacks."
    Icon = "wotn_perks/double_strike.png" // TODO: better icon
    IconDisabled = "wotn_perks/double_strike_sw.png"
})

addPerk(5, "perk.berserk", {
    ID = "perk.hackflows.full_force"
    Script = "scripts/skills/perks/perk_hackflows_full_force"
    Name = "Full Force"
    Tooltip = "Put your full weight into every blow and gain " + green("+1%") + " minimal melee damage for each " + red(3) + " fatigue caused by things worn and held. Items in the bag do not contribute."
    Icon = "ui/perks/perk_18.png"
    IconDisabled = "ui/perks/perk_18_sw.png"
})

addPerk(6, "perk.killing_frenzy", {
    ID = "perk.hackflows.battle_flow"
    Script = "scripts/skills/perks/perk_hackflows_battle_flow"
    Name = "Battle Flow"
    Tooltip = "The first kill each turn does not accumulate fatigue."
    Icon = "wotn_perks/battle_flow.png"
    IconDisabled = "wotn_perks/battle_flow_sw.png"
})

// A faster healing perk, using awesome last_stand icon
addPerk(2, "perk.taunt", {
    ID = "perk.hackflows.flesh_on_the_bones",
    Script = "scripts/skills/perks/perk_hackflows_flesh_on_the_bones",
    Name = "Flesh on the Bones"
    Tooltip = "If the bones is there flesh will grow. Restores hitpoints at " + green("double rate") + " unless any bones are broken. Old injuries are fine."
    Icon = "ui/perks/perk_32.png",
    IconDisabled = "ui/perks/perk_32_sw.png"
})

// A Medium Armor support Stabilized perk,
// taken from https://www.nexusmods.com/battlebrothers/mods/525 and rebalanced
addPerk(5, "perk.nimble", {
    ID = "perk.hackflows.stabilized"
    Script = "scripts/skills/perks/perk_hackflows_stabilized"
    Name = "Stabilized"
    Tooltip = "Specialize in medium armor! Hitpoint and armor damage is reduced by " + green("25%") + " when the total penalty to Maximum Fatigue from head and body armor is between " + red(25) + " and " + red(37) + ". Outside this range, the bonus drops rapidly.\n\nCombines multiplicatively with Nimble and Battle Forged."
    Icon = "icons/stabilized.png"
    IconDisabled = "icons/stabilized_sw.png"
})
