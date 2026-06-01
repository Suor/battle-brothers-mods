// ::Const.Perks.Druid - Druid-only perks, injected into the perk tree for the background.
// ::Const.Druid.Biomes - which beasts a Druid may summon on a given battlefield.

::Const.Perks.Druid <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Druid.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}

addPerk({
    ID = "perk.druid.regrowth"
    Script = "scripts/skills/perks/perk_druid_regrowth"
    Name = "Regrowth"
    Tooltip = "Channel nature's vigor into a single ally, knitting their wounds back at "
            + green(10) + " hitpoints per turn. Only one ally can carry it at a time -"
            + " bestow it elsewhere and the previous one stops mending."
    Icon = "druid/perk_regrowth.png"
    IconDisabled = "druid/perk_regrowth_sw.png"
    Row = 1
})
addPerk({
    ID = "perk.druid.venom"
    Script = "scripts/skills/perks/perk_druid_venom"
    Name = "Venom"
    Tooltip = "Your beasts hunt with envenomed fang and sting. Their bites poison the prey."
    Icon = "druid/perk_venom.png"
    IconDisabled = "druid/perk_venom_sw.png"
    Row = 1
})
addPerk({
    ID = "perk.druid.entangle"
    Script = "scripts/skills/perks/perk_druid_entangle"
    Name = "Entangling Roots"
    Tooltip = "Call writhing roots from the earth to root an enemy in place."
    Icon = "druid/perk_entangle.png"
    IconDisabled = "druid/perk_entangle_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.druid.hatch"
    Script = "scripts/skills/perks/perk_druid_hatch"
    Name = "Hatch"
    Tooltip = "The wilds teem with new broods. Your summon no longer spends itself once per battle -"
            + " instead it recharges, ready again " + green("every other turn") + "."
    Icon = "druid/perk_hatch.png"
    IconDisabled = "druid/perk_hatch_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.druid.pack_leader"
    Script = "scripts/skills/perks/perk_druid_pack_leader"
    Name = "Pack Leader"
    Tooltip = "The beasts know you for their alpha. Summoned beasts arrive "
            + green("confident") + " and will never flee the field."
    Icon = "druid/perk_pack_leader.png"
    IconDisabled = "druid/perk_pack_leader_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.druid.apex"
    Script = "scripts/skills/perks/perk_druid_apex"
    Name = "Apex Predators"
    Tooltip = "Your call reaches greater beasts. Direwolves and hyenas answer frenzied,"
            + " spiders bloated and broodmother-sized, and young schrats rise full-grown."
    Icon = "druid/perk_apex.png"
    IconDisabled = "druid/perk_apex_sw.png"
    Row = 6
})


// Beast pools per battlefield. Values are enemy entity script base names under
// scripts/entity/tactical/enemies/. Apex perk upgrades these per ApexMap below.
local T = ::Const.World.TerrainType;
::Const.Druid <- {
    Biomes = {
        Pools = {
            [T.Snow] = ["direwolf"],
            [T.SnowyForest] = ["direwolf"],
            [T.Tundra] = ["direwolf"],
            [T.Plains] = ["direwolf", "spider"],
            [T.Farmland] = ["direwolf", "spider"],
            [T.Forest] = ["direwolf", "spider", "schrat_small"],
            [T.LeaveForest] = ["direwolf", "spider", "schrat_small"],
            [T.AutumnForest] = ["direwolf", "spider", "schrat_small"],
            [T.Steppe] = ["direwolf", "hyena"],
            [T.Desert] = ["hyena", "serpent"],
            [T.Oasis] = ["hyena", "serpent"],
            [T.Swamp] = ["spider", "serpent"],
            [T.Hills] = ["direwolf", "hyena"],
            [T.Mountains] = ["direwolf", "hyena"],
            [T.Badlands] = ["direwolf", "hyena"],
        }
        Default = ["direwolf"]
        ApexMap = {
            direwolf = "direwolf_high"
            hyena = "hyena_high"
            // Beasts with no entry here (spider, schrat_small, serpent) are grown in place
            // by druid_summon_beast.makeApex() instead of swapping to another entity.
        }
    }
}
