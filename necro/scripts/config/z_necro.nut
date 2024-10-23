::Const.Perks.Necro <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Necro.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.necro.regeneration"
    Script = "scripts/skills/perks/perk_necro_regeneration"
    Name = "Undead Regeneration"
    Tooltip = "The restoration won't stop after a corpse is raised, but continue at "
            + green(10) + " hitpoints per turn."
    Icon = "necro/perk_regeneration.png"
    IconDisabled = "necro/perk_regeneration_sw.png"
    Row = 2
})
addPerk({
    ID = "perk.necro.mastery"
    Script = "scripts/skills/perks/perk_necro_mastery"
    Name = "Necromastery"
    Tooltip = "Master raising undead. Use "
            + green("4 AP") + " and " + green("25%") + " less fatigue to raise."
    Icon = "necro/perk_mastery.png"
    IconDisabled = "necro/perk_mastery_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.necro.possess"
    Script = "scripts/skills/perks/perk_necro_possess"
    Name = "Possess"
    Tooltip = "Allows possessing raised undead. The master will feel when his puppet is hurt."
    Icon = "necro/perk_possess.png"
    IconDisabled = "necro/perk_possess_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.necro.mind_meld"
    Script = "scripts/skills/perks/perk_necro_mind_meld"
    Name = "Mind Meld"
    Tooltip = "Share some of your perks with raised undead and learn a couple in return."
    Icon = "necro/perk_mind_meld.png"
    IconDisabled = "necro/perk_mind_meld_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.necro.blood_sucking"
    Script = "scripts/skills/perks/perk_necro_blood_sucking"
    Name = "Blood Suckers"
    Tooltip = "Give your undead blood sucking ability."
    Icon = "necro/perk_blood_sucking.png"
    IconDisabled = "necro/perk_blood_sucking_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.necro.range"
    Script = "scripts/skills/perks/perk_necro_range"
    Name = "Necrotic Reach"
    Tooltip = "Extend your necrotic reach. Allows raising undead twice as far."
    Icon = "necro/perk_range.png"
    IconDisabled = "necro/perk_range_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.necro.flesh_of_iron"
    Script = "scripts/skills/perks/perk_necro_flesh_of_iron"
    Name = "Flesh of Iron"
    Tooltip = "Iron is another dead matter."
            + " Partially restores armor when raising undead."
            + "\n\nContinues to do so if you also have Undead Regeneration."
    Icon = "necro/perk_flesh_of_iron.png"
    IconDisabled = "necro/perk_flesh_of_iron_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.necro.soul_link"
    Script = "scripts/skills/perks/perk_necro_soul_link"
    Name = "Soul Link"
    Tooltip = "Redirect some hits to one of his undead."
            + " If about to die will evaporate one of them instead."
    Icon = "necro/perk_soul_link.png"
    IconDisabled = "necro/perk_soul_link_sw.png"
    Row = 6
})
