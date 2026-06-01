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
            local player = this.World.State.getPlayer();
            if (player != null) return player.getTile().Type;
        } catch (e) {}
        return -1;
    }

    function pickBeastType()
    {
        local biomes = this.Const.Druid.Biomes;
        local terrain = this.getTerrainType();
        local pool = terrain in biomes.Pools ? biomes.Pools[terrain] : biomes.Default;
        return pool[this.Math.rand(0, pool.len() - 1)];
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
        local biomes = this.Const.Druid.Biomes;
        local isApex = _user.getSkills().hasSkill("perk.druid.apex");
        local beastType = this.pickBeastType();

        // Apex: swap to a greater beast where one exists, otherwise rear a bigger, tougher specimen.
        local boostApex = false;
        if (isApex) {
            if (beastType in biomes.ApexMap) beastType = biomes.ApexMap[beastType];
            else boostApex = true;
        }

        local script = "scripts/entity/tactical/enemies/" + beastType;
        local beast = this.Tactical.spawnEntity(script, _targetTile.Coords.X, _targetTile.Coords.Y);
        if (beast == null) return false;
        if (boostApex) this.makeApex(beast);

        beast.setFaction(this.Const.Faction.PlayerAnimals);
        beast.m.druid_master <- ::MSU.asWeakTableRef(_user);
        beast.m.druid_RaisedByPlayer = true;

        // Pack Leader: beasts arrive emboldened - they start Confident and, thanks to the
        // fearless racial, never break or flee. Unlike MoraleState.Ignore they still react
        // to the battle and reap the Confident combat bonus.
        if (_user.getSkills().hasSkill("perk.druid.pack_leader")) {
            beast.getSkills().add(this.new("scripts/skills/racial/druid_fearless"));
            beast.setMoraleState(this.Const.MoraleState.Confident);
        }
        // Venom: their bites carry poison.
        if (_user.getSkills().hasSkill("perk.druid.venom")) {
            beast.getSkills().add(this.new("scripts/skills/racial/druid_venom"));
        }

        beast.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
        beast.setDirty(true);

        // Voice the call with the summoned beast's own cry instead of a fixed bark.
        local idle = beast.m.Sound[this.Const.Sound.ActorEvent.Idle];
        if (idle != null && idle.len() != 0) {
            this.Sound.play(idle[this.Math.rand(0, idle.len() - 1)], this.Const.Sound.Volume.Skill, beast.getPos());
        }

        // Cooldown 2 = ready again every other turn (used turn N -> ready turn N+2). Without the
        // Hatch perk this is never decremented, so it acts as a once-per-battle lock.
        this.m.Cooldown = 2;
        _user.getSkills().onSummonBeast(beast);
        return true;
    }
});
