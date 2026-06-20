this.druid_summon_beast <- this.inherit("scripts/skills/skill", {
    m = {
        // Summons left this battle. Without Hatch you get the one (once per battle). Hatch banks a
        // fresh charge every third turn (4, 7, 10...), so they stockpile instead of forcing a rush.
        Charges = 1
        // Rounds the druid has acted this battle, counted in onTurnStart - drives the Hatch refill.
        Round = 0
    },
    function create()
    {
        this.m.ID = "actives.druid_summon_beast";
        this.m.Name = "Summon Beast";
        this.m.Description = "Call a beast of the surrounding wilds to a free tile beside you."
                           + " It will hunt your enemies but cannot otherwise be commanded.";
        this.m.Icon = "druid/active_summon.png";
        this.m.IconDisabled = "druid/active_summon_sw.png";
        // No SoundOnUse here: the call is voiced by the summoned beast in onUse().
        this.m.Type = this.Const.SkillType.Active;
        this.m.Order = this.Const.SkillOrder.Any + 75;
        this.m.IsSerialized = true;
        this.m.IsActive = true;
        this.m.IsTargeted = true;
        this.m.IsStacking = false;
        this.m.IsAttack = false;
        this.m.IsRanged = false;
        this.m.IsUsingHitchance = false;
        this.m.IsTargetingActor = false;
        this.m.IsDoingForwardMove = false;
        this.m.ActionPointCost = 5;
        this.m.FatigueCost = 25;
        this.m.MinRange = 1;
        this.m.MaxRange = 1;
    }

    function getTooltip()
    {
        local charge;
        if (this.hasHatch()) {
            // Rounds until the next Hatch charge banks (charges arrive on rounds 4, 7, 10...), so
            // away is always 1..3; 1 reads as "next turn" rather than "in 1 turn".
            local next = 4;
            while (next <= this.m.Round) next += 3;
            local away = next - this.m.Round;
            if (this.m.Charges > 0) {
                charge = "Has " + ::std.Text.positive(this.m.Charges) + " charge" + ::std.Text.plural(this.m.Charges)
                       + (away == 1 ? ", gains next turn"
                                    : ", gains next in " + ::std.Text.positive(away) + " turns");
            } else {
                charge = away == 1
                    ? "Next charge next turn"
                    : "Next charge in " + ::std.Text.positive(away) + " turn" + ::std.Text.plural(away);
            }
        } else {
            charge = this.m.Charges > 0 ? "Ready - once per battle" : "Spent for this battle";
        }

        local tooltip = this.getDefaultUtilityTooltip();
        tooltip.push({
            id = 6,
            type = "text",
            icon = "ui/icons/special.png",
            text = charge
        });
        return tooltip;
    }

    function hasHatch()
    {
        return this.getContainer().hasSkill("perk.druid.hatch");
    }

    function isUsable()
    {
        return this.skill.isUsable() && this.m.Charges > 0;
    }

    // Only the Hatch perk refills the summon: every third round (turns 4, 7, 10...) it banks a
    // fresh charge, so an unused call is never wasted. Without Hatch the lone charge never returns.
    function onTurnStart()
    {
        this.skill.onTurnStart();
        this.m.Round++;
        if (this.hasHatch() && this.m.Round >= 4 && (this.m.Round - 4) % 3 == 0) this.m.Charges++;
    }

    function onVerifyTarget(_originTile, _targetTile)
    {
        return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
    }

    function onCombatStarted()
    {
        this.m.Charges = 1;
        this.m.Round = 0;
    }

    function onCombatFinished()
    {
        this.skill.onCombatFinished();
        this.m.Charges = 1;
        this.m.Round = 0;
    }

    // Which world terrain are we fighting on? Falls back to the default pool.
    function getTerrainType()
    {
        try {
            local player = ::World.State.getPlayer();
            if (player != null) return player.getTile().Type;
        } catch (e) {}
        return -1;
    }

    function pickBeastType()
    {
        local biomes = ::Const.Druid.Biomes;
        local terrain = this.getTerrainType();
        local pool = terrain in biomes.Pools ? biomes.Pools[terrain] : biomes.Default;
        return pool[::Math.rand(0, pool.len() - 1)];
    }

    // Greater Beasts upgrade for a beast with no greater cousin to swap into (spider, schrat,
    // serpent): reared bigger and meaner in place. Shares the Frenzied recipe (+5 Melee Skill,
    // x1.25 damage, +20 Bravery, Relentless) with the swapped-in direwolves/hyenas, plus
    // per-beast tuning on top.
    function makeApex(_beast, _type)
    {
        // Bump the base stats and let the skill container rebuild CurrentProperties; writing
        // CurrentProperties directly would just be clobbered by the next update().
        local b = _beast.m.BaseProperties;
        b.MeleeSkill += 5;
        b.DamageTotalMult *= 1.25;
        b.Bravery += 20;

        local skills = _beast.getSkills();
        // Serpents already carry Relentless, so guard against a duplicate.
        if (!skills.hasSkill("perk.relentless"))
            skills.add(this.new("scripts/skills/perks/perk_relentless"));

        switch (_type) {
            case "spider":
                b.Hitpoints = 100;
                b.MeleeDefense += 10;
                skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
                break;
            case "schrat_small":
                b.Hitpoints = 100;
                skills.add(this.new("scripts/skills/perks/perk_hold_out"));
                break;
            case "serpent":
                b.Hitpoints += 20;
                b.Initiative = 90;  // Dodge turns the raised Initiative into +Melee/Ranged Defense.
                skills.add(this.new("scripts/skills/perks/perk_dodge"));
                break;
        }

        skills.update();
        _beast.setHitpoints(_beast.getHitpointsMax());

        // Spiders expose a native size knob that scales every body part and keeps it grounded.
        // For the rest we scale the body sprites ourselves.
        local mult = 1.2;  // TODO: vary a bit?
        try {
            _beast.setSize(mult);
        } catch (error) {
            foreach (part in ::Druid.BodySprites) {
                if (_beast.hasSprite(part)) _beast.getSprite(part).Scale *= mult;
            }
        }
    }

    function onUse(_user, _targetTile)
    {
        local biomes = ::Const.Druid.Biomes;
        local beastType;
        local boostApex = false;
        local hasApex = _user.getSkills().hasSkill("perk.druid.apex");

        // A plain Wolf still answers most calls early on, the wild biome variety creeping in as the
        // druid grows (see ::Const.Druid.wolfChance). Apex closes the door on the common wolf for
        // good - every call now brings a greater beast.
        if (!hasApex && ::Math.rand(1, 100) <= ::Const.Druid.wolfChance(_user.getLevel())) {
            beastType = biomes.Starter;
        } else {
            beastType = this.pickBeastType();
            // Apex: swap to a greater beast where one exists, otherwise rear a bigger specimen.
            if (hasApex) {
                if (beastType in biomes.ApexMap) beastType = biomes.ApexMap[beastType];
                else boostApex = true;
            }
        }

        local script = "scripts/entity/tactical/enemies/" + beastType, tile = _targetTile.Coords;
        local beast = ::Tactical.spawnEntity(script, tile.X, tile.Y);
        if (beast == null) {
            ::logError("druid: failed to spawn '" + beastType + "' at " + tile.X + "," + tile.Y);
            return false;
        }
        if (boostApex) this.makeApex(beast, beastType);

        beast.m.druid_master <- ::MSU.asWeakTableRef(_user);
        // Set before setFaction so the onFactionChanged hook flips the body sprites.
        beast.m.druid_Summoned = true;
        beast.setFaction(this.Const.Faction.PlayerAnimals);

        // Beast Aura: the druid's own beasts arrive Confident and leashed to his side; the aura
        // receiver (fearlessness by proximity) rides every animal already. See onBeastJoinedPack.
        ::Druid.onBeastJoinedPack(_user, beast);

        // Venom (Nature variant): the druid's beasts hunt with envenomed bites. In Beastform
        // the venom rides the druid's own attacks instead (see perk_druid_venom), not his beasts'.
        if (_user.getSkills().hasSkill("perk.druid.venom")
            && !_user.getSkills().hasSkill("perk.druid.beastform")) {
            beast.getSkills().add(this.new("scripts/skills/racial/druid_venom"));
        }

        beast.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
        beast.setDirty(true);

        // Act this very round, trick borrowed from AC
        ::Tactical.TurnSequenceBar.removeEntity(beast);
        beast.m.IsTurnDone = false;
        beast.m.IsActingImmediately = true;
        ::Tactical.TurnSequenceBar.insertEntity(beast);

        // Voice the call with the summoned beast's own cry instead of a fixed bark.
        beast.playSound(::Const.Sound.ActorEvent.Idle, ::Const.Sound.Volume.Skill);

        this.m.Charges--;
        return true;
    }
});
