this.druid_summon_beast <- this.inherit("scripts/skills/skill", {
    m = {
        // Turns until the summon is ready again (0 = ready). Without the Hatch perk the count is
        // never ticked down (see onTurnStart), so a single use locks it for the rest of the battle.
        Cooldown = 0
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
        if (this.m.Cooldown > 0) {
            // Without Hatch the cooldown never ticks down (see onTurnStart), so the summon is just spent.
            charge = this.hasHatch()
                ? "Recharges in " + ::std.Text.negative(this.m.Cooldown)
                    + (this.m.Cooldown == 1 ? " turn" : " turns")
                : "Spent for this battle";
        } else {
            charge = this.hasHatch() ? "Ready - recharges every other turn" : "Ready - once per battle";
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
        return this.skill.isUsable() && this.m.Cooldown == 0;
    }

    // Only the Hatch perk lets the summon recharge; otherwise the cooldown set on use never
    // ticks down, so the call stays spent until the next battle.
    function onTurnStart()
    {
        this.skill.onTurnStart();
        if (this.hasHatch()) this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
    }

    function onVerifyTarget(_originTile, _targetTile)
    {
        return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
    }

    function onCombatStarted()
    {
        this.m.Cooldown = 0;
    }

    function onCombatFinished()
    {
        this.skill.onCombatFinished();
        this.m.Cooldown = 0;
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

    // Apex specimen of a beast that has no greater cousin to swap into (spider, schrat, serpent):
    // tougher, more skilled and harder-hitting. Beasts that do have a greater cousin (direwolf,
    // hyena) are swapped to it in onUse() and never reach here.
    function makeApex(_beast)
    {
        // Bump the base stats and let the skill container rebuild CurrentProperties; writing
        // CurrentProperties directly would just be clobbered by the next update().
        local b = _beast.m.BaseProperties;
        b.Hitpoints += 20;
        b.MeleeSkill += 5;
        b.DamageTotalMult *= 1.25;
        _beast.getSkills().update();
        _beast.setHitpoints(_beast.getHitpointsMax());

        // Spiders expose a native size knob that scales every body part and keeps it grounded.
        // For the rest we scale the body sprites ourselves.
        try {
            _beast.setSize(1.1);  // TODO: vary a bit?
        } catch (error) {
            local mult = 1.25;
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

        // Below the unlock level the wilds answer with a plain Wolf, whatever the biome; the full
        // biome variety (and Apex, later still) only opens up once the druid has grown into it.
        if (_user.getLevel() < biomes.UnlockLevel) {
            beastType = biomes.Starter;
        } else {
            beastType = this.pickBeastType();
            // Apex: swap to a greater beast where one exists, otherwise rear a bigger specimen.
            if (_user.getSkills().hasSkill("perk.druid.apex")) {
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
        if (boostApex) this.makeApex(beast);

        beast.m.druid_master <- ::MSU.asWeakTableRef(_user);
        // Set before setFaction so the onFactionChanged hook flips the body sprites.
        beast.m.druid_Summoned = true;
        beast.setFaction(this.Const.Faction.PlayerAnimals);

        // Beast Aura: the druid's own beasts arrive emboldened - they start Confident and, thanks
        // to the fearless racial, never break or flee. Unlike MoraleState.Ignore they still react
        // to the battle and reap the Confident combat bonus. They also gain the ai_protect
        // behaviour, so they keep to the druid's side instead of chasing off after the foe.
        if (_user.getSkills().hasSkill("perk.druid.beast_aura")) {
            beast.getSkills().add(this.new("scripts/skills/racial/druid_fearless"));
            beast.setMoraleState(this.Const.MoraleState.Confident);
            local agent = beast.getAIAgent();
            if (agent != null && agent.getBehavior(this.Const.AI.Behavior.ID.Protect) == null)
                agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_protect"));
        }
        // Every summon carries the aura receiver, so it is emboldened by any aura source in range.
        beast.getSkills().add(this.new("scripts/skills/effects/druid_beast_aura_effect"));

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

        // Cooldown 2 = ready again every other turn (used turn N -> ready turn N+2). Without the
        // Hatch perk this is never decremented, so it acts as a once-per-battle lock.
        this.m.Cooldown = 2;
        return true;
    }
});
