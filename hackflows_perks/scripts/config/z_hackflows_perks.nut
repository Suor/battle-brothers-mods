this.Const.Strings.PerkName.BatteringRam <- "Battering Ram"
this.Const.Strings.PerkName.BattleFlow <- "Battle Flow";
this.Const.Strings.PerkName.BloodyHarvest <- "Bloody Harvest";
this.Const.Strings.PerkName.DevastatingStrikes <- "Devastating Strikes";
this.Const.Strings.PerkName.DoubleStrike <- "Double Strike";
this.Const.Strings.PerkName.FullForce <- "Full Force";
this.Const.Strings.PerkName.InspiringPresence <- "Inspiring Presence";
this.Const.Strings.PerkName.LastStand <- "Last Stand";
this.Const.Strings.PerkName.Lookout <- "Lookout";
this.Const.Strings.PerkName.Feint <- "Feint";
this.Const.Strings.PerkName.Rebound <- "Rebound";
this.Const.Strings.PerkName.ReturnFavor <- "Return Favor";
this.Const.Strings.PerkName.Sprint <- "Sprint";
this.Const.Strings.PerkName.Stalwart <- "Stalwart";
this.Const.Strings.PerkName.Steadfast <- "Steadfast";
this.Const.Strings.PerkName.SunderingStrikes <- "Sundering Strikes";
this.Const.Strings.PerkName.Vengeance <- "Vengeance";


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

this.Const.Strings.PerkDescription.BatteringRam <- "Immunity against being stunned.";

this.Const.Strings.PerkDescription.BattleFlow <- "The first kill each turn does not accumulate fatigue.";
// this.Const.Strings.PerkDescription.BattleFlow <- "The first attack killing an enemy in a turn does not accumulate fatigue.";

this.Const.Strings.PerkDescription.BloodyHarvest <- "Gain [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] chance to hit for all area of effect attacks.";

this.Const.Strings.PerkDescription.DevastatingStrikes <- "All damage inflicted is increased by [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] for any weapon used. What could stand before you now?";

this.Const.Strings.PerkDescription.DoubleStrike <- "After landing a hit, the next attack does [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] damage to both hitpoints and armor. If the attack misses, the effect is wasted.";

this.Const.Strings.PerkDescription.FullForce <- format("Put your full weight into every blow and gain %s minimal melee damage for each %s fatigue caused by things worn and held. Items in the bag do not contribute.", green("+1%"), red(3));

"If you are fighting melee weapons, your minimal damage is multiplied by a percentage equal to 33% of your total fatigue from helmet, body and both arms."

this.Const.Strings.PerkDescription.InspiringPresence <- "A great leader of men inspires his followers to overcome their limits. Allies start every battle at confident morale unless prohibited by character traits.";

this.Const.Strings.PerkDescription.LastStand <- "Gain [color=" + this.Const.UI.Color.PositiveValue + "]+1%[/color] additional Melee and Ranged Defense for every 1% of hitpoints missing.";

this.Const.Strings.PerkDescription.Lookout <- "Learn to find your enemies before they find you. Vision is increased by [color=" + this.Const.UI.Color.PositiveValue + "]+1[/color].";

this.Const.Strings.PerkDescription.Feint <- "If an attack misses, it costs [color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] less fatigue than normal.";

this.Const.Strings.PerkDescription.Rebound <- "Fatigue regeneration is increased by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] per turn.";

this.Const.Strings.PerkDescription.ReturnFavor <- "Unlocks the \'Return Favor\' skill which when active has a [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] chance to stun any opponent missing a melee attack against this character in retaliation. Immunities and resistances against being stunned still apply.";

this.Const.Strings.PerkDescription.Sprint <- "Unlocks the \'Sprint\' skill which allows for sprinting over short distances in straight lines instantly.",

this.Const.Strings.PerkDescription.Stalwart <- "Immunity against being knocked back or pulled up close. Applies to skills such as Knock Back, Hook and others that change a character\'s position.";

this.Const.Strings.PerkDescription.Steadfast <- "Getting hit or missed costs half of the usual fatigue.";

this.Const.Strings.PerkDescription.SunderingStrikes <- "Effectiveness vs. Armor is increased by [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] for any weapon used.";

this.Const.Strings.PerkDescription.Vengeance <- "After receiving a blow, the next attack of this character will inflict [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] damage to both hitpoints and armor. If the attack misses, the effect is wasted.";


// Kind of dups Resillent
// this.Const.Perks.Perks[0].append(
//     {
//         ID = "perk.battering_ram",
//         Script = "scripts/skills/perks/perk_battering_ram",
//         Name = this.Const.Strings.PerkName.BatteringRam,
//         Tooltip = this.Const.Strings.PerkDescription.BatteringRam,
//         Icon = "wotn_perks/battering_ram.png",
//         IconDisabled = "wotn_perks/battering_ram_sw.png"
//     }
// )

// TODO: maybe need to cut in half
addPerk(4, "perk.lone_wolf", {
    ID = "perk.steadfast",
    Script = "scripts/skills/perks/perk_steadfast",
    Name = this.Const.Strings.PerkName.Steadfast,
    Tooltip = this.Const.Strings.PerkDescription.Steadfast,
    Icon = "wotn_perks/clarity_circle.png",
    IconDisabled = "wotn_perks/clarity_circle_bw.png"
})
// Not sure, but may be overpowered. Also not really interesting
// this.Const.Perks.Perks[1].append(
//     {
//         ID = "perk.double_strike",
//         Script = "scripts/skills/perks/perk_double_strike",
//         Name = this.Const.Strings.PerkName.DoubleStrike,
//         Tooltip = this.Const.Strings.PerkDescription.DoubleStrike,
//         Icon = "wotn_perks/double_strike.png",
//         IconDisabled = "wotn_perks/double_strike_sw.png"
//     }
// )
addPerk(4, null, {
    ID = "perk.bloody_harvest",
    Script = "scripts/skills/perks/perk_bloody_harvest",
    Name = this.Const.Strings.PerkName.BloodyHarvest,
    Tooltip = this.Const.Strings.PerkDescription.BloodyHarvest,
    Icon = "wotn_perks/double_strike.png", // TODO: better icon
    IconDisabled = "wotn_perks/double_strike_sw.png"
})

// NOTE: probably should buff. Either make stronger or don't waste on miss or both.
addPerk(2, "perk.backstabber", {
    ID = "perk.vengeance",
    Script = "scripts/skills/perks/perk_vengeance",
    Name = this.Const.Strings.PerkName.Vengeance,
    Tooltip = this.Const.Strings.PerkDescription.Vengeance,
    Icon = "wotn_perks/vengeance.png",
    IconDisabled = "wotn_perks/vengeance_sw.png"
})

// Too many fatigue perks ?
// addPerk(2, "perk.shield_expert", {
//     ID = "perk.feint",
//     Script = "scripts/skills/perks/perk_feint",
//     Name = this.Const.Strings.PerkName.Feint,
//     Tooltip = this.Const.Strings.PerkDescription.Feint,
//     Icon = "wotn_perks/double_strike.png",
//     IconDisabled = "wotn_perks/double_strike_sw.png"
// })

// Too boring, duplicates Eagle Eye
// this.Const.Perks.Perks[2].append(
//     {
//         ID = "perk.lookout",
//         Script = "scripts/skills/perks/perk_lookout",
//         Name = this.Const.Strings.PerkName.Lookout,
//         Tooltip = this.Const.Strings.PerkDescription.Lookout,
//         Icon = "wotn_perks/lookout.png",
//         IconDisabled = "wotn_perks/lookout_sw.png"
//     }
// )

// Overpowred ?
// this.Const.Perks.Perks[2].append(
//     {
//         ID = "perk.sprint",
//         Script = "scripts/skills/perks/perk_sprint",
//         Name = this.Const.Strings.PerkName.Sprint,
//         Tooltip = this.Const.Strings.PerkDescription.Sprint,
//         Icon = "wotn_perks/sprint.png",
//         IconDisabled = "wotn_perks/sprint_sw.png"
//     }
// )

// Duplicated Indomitable
// this.Const.Perks.Perks[4].append(
//     {
//         ID = "perk.stalwart",
//         Script = "scripts/skills/perks/perk_stalwart",
//         Name = this.Const.Strings.PerkName.Stalwart,
//         Tooltip = this.Const.Strings.PerkDescription.Stalwart,
//         Icon = "wotn_perks/stalwart.png",
//         IconDisabled = "wotn_perks/stalwart_sw.png"
//     }
// )

addPerk(5, "perk.berserk", {
    ID = "perk.full_force",
    Script = "scripts/skills/perks/perk_full_force",
    Name = this.Const.Strings.PerkName.FullForce,
    Tooltip = this.Const.Strings.PerkDescription.FullForce,
    Icon = "ui/perks/perk_18.png",
    IconDisabled = "ui/perks/perk_18_sw.png"
})


// Way too strong, dups Iron lungs, repetitve given other fatigue traits
// this.Const.Perks.Perks[5].append(
//     {
//         ID = "perk.rebound",
//         Script = "scripts/skills/perks/perk_rebound",
//         Name = this.Const.Strings.PerkName.Rebound,
//         Tooltip = this.Const.Strings.PerkDescription.Rebound,
//         Icon = "wotn_perks/rebound.png",
//         IconDisabled = "wotn_perks/rebound_sw.png"
//     }
// )

// Boring
// addPerk(null, "perk.duelist", {
//     ID = "perk.sundering_strikes",
//     Script = "scripts/skills/perks/perk_sundering_strikes",
//     Name = this.Const.Strings.PerkName.SunderingStrikes,
//     Tooltip = this.Const.Strings.PerkDescription.SunderingStrikes,
//     Icon = "wotn_perks/sundering_strikes.png",
//     IconDisabled = "wotn_perks/sundering_strikes_sw.png"
// })

// Way too unbalanced
// this.Const.Perks.Perks[6].append(
//     {
//         ID = "perk.inspiring_presence",
//         Script = "scripts/skills/perks/perk_inspiring_presence",
//         Name = this.Const.Strings.PerkName.InspiringPresence,
//         Tooltip = this.Const.Strings.PerkDescription.InspiringPresence,
//         Icon = "ui/perks/perk_28.png",
//         IconDisabled = "ui/perks/perk_28_sw.png"
//     }
// )

// Doesn't work anymore, the effect script is missing
// this.Const.Perks.Perks[6].append(
//     {
//         ID = "perk.return_favor",
//         Script = "scripts/skills/perks/perk_return_favor",
//         Name = this.Const.Strings.PerkName.ReturnFavor,
//         Tooltip = this.Const.Strings.PerkDescription.ReturnFavor,
//         Icon = "ui/perks/perk_31.png",
//         IconDisabled = "ui/perks/perk_31_sw.png"
//     }
// )

// Duplicating traits and generally boring
// this.Const.Perks.Perks[6].append(
//     {
//         ID = "perk.devastating_strikes",
//         Script = "scripts/skills/perks/perk_devastating_strikes",
//         Name = this.Const.Strings.PerkName.DevastatingStrikes,
//         Tooltip = this.Const.Strings.PerkDescription.DevastatingStrikes,
//         Icon = "wotn_perks/devastating_strikes.png",
//         IconDisabled = "wotn_perks/devastating_strikes_sw.png"
//     }
// )

// Looks overpowered
// TODO: balance
addPerk(6, "perk.killing_frenzy", {
    ID = "perk.last_stand",
    Script = "scripts/skills/perks/perk_last_stand",
    Name = this.Const.Strings.PerkName.LastStand,
    Tooltip = this.Const.Strings.PerkDescription.LastStand,
    Icon = "ui/perks/perk_32.png",
    IconDisabled = "ui/perks/perk_32_sw.png"
})

// Current behavior is weird an counter-intuitive in numbers,
// making skill free would be more cool. Maybe overpowered though.
addPerk(6, "perk.killing_frenzy", {
    ID = "perk.battle_flow",
    Script = "scripts/skills/perks/perk_battle_flow",
    Name = this.Const.Strings.PerkName.BattleFlow,
    Tooltip = this.Const.Strings.PerkDescription.BattleFlow,
    Icon = "wotn_perks/battle_flow.png",
    IconDisabled = "wotn_perks/battle_flow_sw.png"
})

// A Medium Armor support Stabilized perk,
// taken from https://www.nexusmods.com/battlebrothers/mods/525 and rebalanced
this.Const.Strings.PerkName.Stabilized <- "Stabilized";
this.Const.Strings.PerkDescription.Stabilized <- "Specialize in medium armor! Hitpoint and armor damage is reduced by [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color] when the total penalty to Maximum Fatigue from head and body armor is between 25 and 37. Outside this range, the bonus drops rapidly.\n\nCombines multiplicatively with Nimble and Battle Forged.";

// Add stabilized between Nimble and Battle Forged
addPerk(5, "perk.nimble", {
    ID = "perk.stabilized",
    Script = "scripts/skills/perks/perk_stabilized",
    Name = this.Const.Strings.PerkName.Stabilized,
    Tooltip = this.Const.Strings.PerkDescription.Stabilized,
    Icon = "icons/stabilized.png",
    IconDisabled = "icons/stabilized_sw.png"
})

// TODO: take a look at Blend in and Full Force from True Balance mod

// // delete this.Const.Perks.LookupMap;
// this.Const.Perks.LookupMap = {};

// for( local row = 0; row < this.Const.Perks.Perks.len(); row = ++row )
// {
// 	for( local i = 0; i < this.Const.Perks.Perks[row].len(); i = ++i )
// 	{
// 		local perk = this.Const.Perks.Perks[row][i];
// 		perk.Row <- row;
// 		perk.Unlocks <- row;
// 		this.Const.Perks.LookupMap[perk.ID] <- perk;
// 	}
// }
