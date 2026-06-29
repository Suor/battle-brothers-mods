// ::Const.Perks.Druid - Druid-only perks, injected into the perk tree for the background.
// ::Const.Druid - Druid runtime config: beast pools, group exclusion rules, Beastform/Rage tunables.
//
// The tree splits into two mutually exclusive groups (see docs/beast-branch/plan.md):
//   Nature: Regrowth, Hatch, Entangling Roots, Greater Beasts
//   Beast:  Beastform (gate) -> Beast Aura, Beast Rage
//   Venom:  ungrouped, adapts to whichever side you commit to
// The group is chosen implicitly by the first group perk taken; ::Const.Druid.isPerkBlocked
// enforces the exclusion (see mod_druid.nut for where it is consulted).

::Const.Perks.Druid <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    // DPF's native lock: its isPerkUnlockable consults this and the perk tooltip shows the
    // reason. Without DPF nothing calls it; the druid_blocked path in mod_druid.nut applies.
    perk.verifyPrerequisites <- function (_player, _tooltip) {
        local reason = ::Const.Druid.perkBlockReason(this.ID, _player.getSkills());
        if (reason == null) return true;
        _tooltip.push({id = 3, type = "hint", icon = "ui/icons/icon_locked.png", text = reason});
        return false;
    }
    ::Const.Perks.Druid.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

// --- Nature group ----------------------------------------------------------
addPerk({
    ID = "perk.druid.regrowth"
    Script = "scripts/skills/perks/perk_druid_regrowth"
    Name = "Regrowth"
    Tooltip = "Knit an ally's wounds turn after turn, double for beasts and animals."
            + " One bearer at a time."
            + "\n" + red("Taking it closes the path of the Beast.")
    Icon = "druid/perk_regrowth.png"
    IconDisabled = "druid/perk_regrowth_sw.png"
    Row = 1
})
addPerk({
    ID = "perk.druid.hatch"
    Script = "scripts/skills/perks/perk_druid_hatch"
    Name = "Hatch"
    Tooltip = "Banks a fresh summon charge " + green("every third turn") + ", not just once per battle."
    Icon = "druid/perk_hatch.png"
    IconDisabled = "druid/perk_hatch_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.druid.entangle"
    Script = "scripts/skills/perks/perk_druid_entangle"
    Name = "Entangling Roots"
    Tooltip = "Call writhing roots from the earth to root an enemy in place."
    Icon = "druid/perk_entangle.png"
    IconDisabled = "druid/perk_entangle_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.druid.apex"
    Script = "scripts/skills/perks/perk_druid_apex"
    Name = "Greater Beasts"
    Tooltip = "Your call reaches greater beasts. Direwolves and hyenas answer frenzied,"
            + " spiders bloated and broodmother-sized, and young schrats rise full-grown."
    Icon = "druid/perk_apex.png"
    IconDisabled = "druid/perk_apex_sw.png"
    Row = 6
})

// --- Beast group -----------------------------------------------------------
addPerk({
    ID = "perk.druid.beastform"
    Script = "scripts/skills/perks/perk_druid_beastform"
    Name = "Beastform"
    Tooltip = "Take the shape of the beast for good: " + green("+10% Melee Skill") + ", "
            + green("+10% Melee Defense") + " and " + green("+20% Hitpoints") + "."
            + " But you can no longer bear heavy shields, helmets or armor, nor ranged weapons."
            + "\n" + red("Taking it closes the path of Nature.")
    Icon = "druid/perk_beastform.png"
    IconDisabled = "druid/perk_beastform_sw.png"
    Row = 1
})
addPerk({
    ID = "perk.druid.beast_aura"
    Script = "scripts/skills/perks/perk_druid_beast_aura"
    Name = "Beast Aura"
    Tooltip = "Beasts know you for their alpha. Your beasts keep to your side instead of"
            + " chasing the foe, and any allied beast near you stands " + green("fearless")
            + " and emboldened."
    Icon = "druid/perk_beast_aura.png"
    IconDisabled = "druid/perk_beast_aura_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.druid.beast_rage"
    Script = "scripts/skills/perks/perk_druid_beast_rage"
    Name = "Beast Rage"
    Tooltip = "Blood feeds a rising fury: stacking melee damage, resolve and"
            + " " + green("healing") + " each turn, at the cost of defense. At its height"
            + " you tear off your own shield and roar."
    Icon = "druid/perk_beast_rage.png"
    IconDisabled = "druid/perk_beast_rage_sw.png"
    Row = 5
})

// --- Ungrouped -------------------------------------------------------------
addPerk({
    ID = "perk.druid.venom"
    Script = "scripts/skills/perks/perk_druid_venom"
    Name = "Venom"
    Tooltip = "Envenomed fang and sting: a weakening venom that blurs sight and slows the foe."
            + " Your summoned beasts hunt with it - but once you walk in Beastform it is yours"
            + " alone, riding your own bite instead of theirs."
    Icon = "druid/perk_venom.png"
    IconDisabled = "druid/perk_venom_sw.png"
    Row = 5
})


local T = ::Const.World.TerrainType;
::Const.Druid <- {
    // Beast pools per battlefield. Values are enemy entity script base names under
    // scripts/entity/tactical/enemies/. A low-level call mostly yields a plain Wolf, the biome
    // pool creeping in as the druid grows (see wolfChance() and druid_summon_beast.onUse). Apex
    // upgrades these per ApexMap.
    Biomes = {
        // The plain Wolf the wilds answer with early on; the biome variety (direwolf, spider,
        // schrat...) creeps in as the druid grows - see wolfChance() and druid_summon_beast.onUse.
        Starter = "wolf"

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

    // Beastform tunables (balance pass Q5 - see plan.md). Equipment limits read an item's
    // fatigue penalty magnitude (-getStaminaModifier); a light shield/buckler stays allowed.
    Beastform = {
        MeleeSkillMult = 1.1
        MeleeDefenseMult = 1.1
        HitpointsMult = 1.2
        ShieldFatigueMax = 10
        HelmetFatigueMax = 10
        BodyFatigueMax = 20
    }

    // Beast Rage tunables (Q5). Like Reforged's perk_rf_feral_rage but damage reduction is
    // swapped for per-stack hitpoint regen, with an extra stack granted on a melee miss.
    Rage = {
        PerStackHpRegen = 2
        PerStackMaxHp = 2
        PerStackDamagePct = 2
        PerStackResolve = 2
        PerStackInitiative = 2
        PerStackMeleeDefense = -1
        StacksPerTurn = -3
        ShieldDropThreshold = 10
        // A beast's death stokes the rage: hard for the druid's own kin, a flicker for any other
        // allied beast that falls (see the actor.onDeath hook in mod_druid).
        OwnBeastDeath = 3
        AllyBeastDeath = 1
    }

    // Beast Aura tunables (Q5).
    Aura = {
        Range = 2
        Resolve = 10
        // The leash: the druid's beasts carry ai_protect (onBeastJoinedPack) and he reads as a VIP
        // (TargetAttractionMult > 1.0), so they cluster to guard him instead of charging off. The
        // side cost is drawing more enemy eyes, kept modest at 2.0.
        TargetAttractionMult = 2.0
    }

    // The Wolf-and-the-Bear origin walks the wild paths: its band slips quicker through the trees
    // and sees farther beneath the canopy. Scenario-only - see the world hooks in mod_druid.
    Forest = {
        SpeedMult = 1.6 // 0.64 is base for forests, 0.64 * 1.6 is a little bit over 1.0
        VisionMult = 1.4
        Terrain = {
            [T.Forest] = true,
            [T.SnowyForest] = true,
            [T.LeaveForest] = true,
            [T.AutumnForest] = true,
        }
    }

    GroupPerks = {
        Nature = ["perk.druid.regrowth", "perk.druid.hatch", "perk.druid.entangle",
                  "perk.druid.apex"]
        Beast = ["perk.druid.beastform", "perk.druid.beast_aura", "perk.druid.beast_rage"]
    }

    // The implicit-group exclusion rule. Returns a reason string when _perkID may NOT be taken
    // given the perks _skills already holds, null when it may. Single source of truth: feeds
    // verifyPrerequisites (DPF lock + tooltip), the data_helper UI gate and the unlock guard
    // (player.unlockPerk) via isPerkBlocked.
    function perkBlockReason(_perkID, _skills) {
        local has = @(id) _skills.hasSkill(id);
        local hasNature = false;
        foreach (id in ::Const.Druid.GroupPerks.Nature) if (has(id)) { hasNature = true; break; }
        local hasBeastform = has("perk.druid.beastform");

        switch (_perkID) {
        case "perk.druid.regrowth":
        case "perk.druid.hatch":
        case "perk.druid.entangle":
        case "perk.druid.apex":
            // Nature perks closed once you turn Beast
            return hasBeastform ? "Locked because this character walks the path of the Beast" : null;
        case "perk.druid.beastform":
            // Beastform closed once you took any Nature perk
            return hasNature ? "Locked because this character walks the path of Nature" : null;
        case "perk.druid.beast_aura":
            return hasBeastform ? null : "Locked because it requires Beastform";
        case "perk.druid.beast_rage":
            if (!hasBeastform) return "Locked because it requires Beastform";
            return has("perk.druid.venom") ? "Locked because Venom and Beast Rage are mutually exclusive" : null;
        case "perk.druid.venom":
            return has("perk.druid.beast_rage") ? "Locked because Venom and Beast Rage are mutually exclusive" : null;
        }
        return null;
    }

    function isPerkBlocked(_perkID, _skills) {
        return ::Const.Druid.perkBlockReason(_perkID, _skills) != null;
    }

    // Whether a Beastform druid may equip _item. Heavy shields/helmets/armor and any ranged
    // weapon are forbidden; a light shield (buckler) under the fatigue cap stays allowed.
    function beastformAllows(_item) {
        local IT = ::Const.Items.ItemType;
        if (_item.isItemType(IT.RangedWeapon)) return false;
        local fatigue = -_item.getStaminaModifier();  // penalties are stored negative
        local B = ::Const.Druid.Beastform;
        if (_item.isItemType(IT.Shield) && fatigue > B.ShieldFatigueMax) return false;
        if (_item.isItemType(IT.Helmet) && fatigue > B.HelmetFatigueMax) return false;
        if (_item.isItemType(IT.Armor)  && fatigue > B.BodyFatigueMax)   return false;
        return true;
    }

    // Chance (percent) a summon answers as a plain Wolf rather than a biome beast, by druid level.
    // The wild variety creeps in as he grows; Apex drives this to 0 (see druid_summon_beast.onUse),
    // so every call then brings a greater beast.
    function wolfChance(_level)
    {
        if (_level <= 3) return 95;
        if (_level == 4) return 85;
        if (_level == 5) return 50;
        if (_level == 6) return 15;
        if (_level == 7) return 10;
        return 5;
    }

    function isAnimal(_actor)
    {
        if (_actor.getFaction() == ::Const.Faction.PlayerAnimals) return true;

        local t = _actor.getType();
        if (::Const.EntityType.getDefaultFaction(t) == ::Const.FactionType.Beasts) return true;

        switch (t)
        {
        case ::Const.EntityType.Wardog:
        case ::Const.EntityType.ArmoredWardog:
        case ::Const.EntityType.Warhound:
        case ::Const.EntityType.Wolf:
        case ::Const.EntityType.BarbarianUnhold:
        case ::Const.EntityType.BarbarianUnholdFrost:
            return true;
        }

        return false;
    }
}
