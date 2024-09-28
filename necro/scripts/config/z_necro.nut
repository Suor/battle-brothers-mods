local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.necro.flesh_of_iron"
    Script = "scripts/skills/perks/perk_necro_flesh_of_iron"
    Name = "Flesh of Iron"
    Tooltip = "Iron is another dead matter."
            + " Partially restores armor when raising undead."
    Icon = "ui/perks/perk_32.png"
    IconDisabled = "ui/perks/perk_32_sw.png"
    Row = 1
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
