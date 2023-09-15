this.Const.Strings.PerkName.BattleFlow <- "Battle Flow";
this.Const.Strings.PerkName.BloodyHarvest <- "Bloody Harvest";
this.Const.Strings.PerkName.FullForce <- "Full Force";
this.Const.Strings.PerkName.Steadfast <- "Steadfast";


local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

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

this.Const.Strings.PerkDescription.BattleFlow <- "The first kill each turn does not accumulate fatigue.";

this.Const.Strings.PerkDescription.BloodyHarvest <- "Gain [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] chance to hit for all area of effect attacks.";

this.Const.Strings.PerkDescription.FullForce <- format("Put your full weight into every blow and gain %s minimal melee damage for each %s fatigue caused by things worn and held. Items in the bag do not contribute.", green("+1%"), red(3));

this.Const.Strings.PerkDescription.Steadfast <- format("Getting hit or missed costs %s of the usual fatigue.", green("half"));


// TODO: rename to tireless, liquid, energetic, enduring, exercise, shadow, flexible ???
addPerk(4, "perk.lone_wolf", {
    ID = "perk.steadfast",
    Script = "scripts/skills/perks/perk_steadfast",
    Name = this.Const.Strings.PerkName.Steadfast,
    Tooltip = this.Const.Strings.PerkDescription.Steadfast,
    Icon = "wotn_perks/clarity_circle.png",
    IconDisabled = "wotn_perks/clarity_circle_bw.png"
})
addPerk(4, null, {
    ID = "perk.bloody_harvest",
    Script = "scripts/skills/perks/perk_bloody_harvest",
    Name = this.Const.Strings.PerkName.BloodyHarvest,
    Tooltip = this.Const.Strings.PerkDescription.BloodyHarvest,
    Icon = "wotn_perks/double_strike.png", // TODO: better icon
    IconDisabled = "wotn_perks/double_strike_sw.png"
})

addPerk(5, "perk.berserk", {
    ID = "perk.full_force",
    Script = "scripts/skills/perks/perk_full_force",
    Name = this.Const.Strings.PerkName.FullForce,
    Tooltip = this.Const.Strings.PerkDescription.FullForce,
    Icon = "ui/perks/perk_18.png",
    IconDisabled = "ui/perks/perk_18_sw.png"
})


addPerk(6, "perk.killing_frenzy", {
    ID = "perk.battle_flow",
    Script = "scripts/skills/perks/perk_battle_flow",
    Name = this.Const.Strings.PerkName.BattleFlow,
    Tooltip = this.Const.Strings.PerkDescription.BattleFlow,
    Icon = "wotn_perks/battle_flow.png",
    IconDisabled = "wotn_perks/battle_flow_sw.png"
})


// A faster healing perk, using awesome last_stand icon
this.Const.Strings.PerkName.FleshOnTheBones <- "Flesh on the Bones";
this.Const.Strings.PerkDescription.FleshOnTheBones <- format("If the bones is there flesh will grow. Restores hitpoints at %s unless any bones are broken. Old injuries are fine.", green("double rate"));
addPerk(2, "perk.taunt", {
    ID = "perk.flesh_on_the_bones",
    Script = "scripts/skills/perks/perk_flesh_on_the_bones",
    Name = this.Const.Strings.PerkName.FleshOnTheBones,
    Tooltip = this.Const.Strings.PerkDescription.FleshOnTheBones,
    Icon = "ui/perks/perk_32.png",
    IconDisabled = "ui/perks/perk_32_sw.png"
})

// A Medium Armor support Stabilized perk,
// taken from https://www.nexusmods.com/battlebrothers/mods/525 and rebalanced
this.Const.Strings.PerkName.Stabilized <- "Stabilized";
this.Const.Strings.PerkDescription.Stabilized <- "Specialize in medium armor! Hitpoint and armor damage is reduced by " + green("25%") + " when the total penalty to Maximum Fatigue from head and body armor is between " + red(25) + " and " + red(37) + ". Outside this range, the bonus drops rapidly.\n\nCombines multiplicatively with Nimble and Battle Forged.";

// Add stabilized between Nimble and Battle Forged
addPerk(5, "perk.nimble", {
    ID = "perk.stabilized",
    Script = "scripts/skills/perks/perk_stabilized",
    Name = this.Const.Strings.PerkName.Stabilized,
    Tooltip = this.Const.Strings.PerkDescription.Stabilized,
    Icon = "icons/stabilized.png",
    IconDisabled = "icons/stabilized_sw.png"
})
