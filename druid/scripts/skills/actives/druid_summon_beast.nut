this.druid_summon_beast <- this.inherit("scripts/skills/skill", {
    m = {
        ChargesUsed = 0
    },
    function create()
    {
        this.m.ID = "actives.druid_summon_beast";
        this.m.Name = "Summon Beast";
        this.m.Description = "Call a beast of the surrounding wilds to a free tile beside you."
                           + " It will hunt your enemies but cannot otherwise be commanded.";
        this.m.Icon = "skills/active_99.png";
        this.m.IconDisabled = "skills/active_99_sw.png";
        this.m.SoundOnUse = [
            "sounds/enemies/wolf_idle_00.wav",
            "sounds/enemies/wolf_idle_01.wav",
            "sounds/enemies/wolf_idle_02.wav"
        ];
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

    function getMaxCharges()
    {
        return this.getContainer().hasSkill("perk.druid.pack") ? 2 : 1;
    }

    function getTooltip()
    {
        return [
            {
                id = 1,
                type = "title",
                text = this.getName()
            },
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            },
            {
                id = 3,
                type = "text",
                text = this.getCostString()
            },
            {
                id = 6,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Beasts left this battle: "
                     + ::std.Text.positive(this.getMaxCharges() - this.m.ChargesUsed)
            }
        ];
    }

    function isUsable()
    {
        return this.skill.isUsable() && this.m.ChargesUsed < this.getMaxCharges();
    }

    function onVerifyTarget(_originTile, _targetTile)
    {
        return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
    }

    function onCombatStarted()
    {
        this.m.ChargesUsed = 0;
    }

    function onCombatFinished()
    {
        this.skill.onCombatFinished();
        this.m.ChargesUsed = 0;
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

    function pickBeastScript(_user)
    {
        local biomes = this.Const.Druid.Biomes;
        local terrain = this.getTerrainType();
        local pool = terrain in biomes.Pools ? biomes.Pools[terrain] : biomes.Default;

        local beastID = pool[this.Math.rand(0, pool.len() - 1)];
        if (_user.getSkills().hasSkill("perk.druid.apex") && beastID in biomes.ApexMap) {
            beastID = biomes.ApexMap[beastID];
        }
        return "scripts/entity/tactical/enemies/" + beastID;
    }

    function onUse(_user, _targetTile)
    {
        local script = this.pickBeastScript(_user);
        local beast = this.Tactical.spawnEntity(script, _targetTile.Coords.X, _targetTile.Coords.Y);
        if (beast == null) return false;

        beast.setFaction(this.Const.Faction.PlayerAnimals);
        beast.m.druid_master <- ::MSU.asWeakTableRef(_user);
        beast.m.druid_RaisedByPlayer = true;

        // Pack Leader: beasts arrive emboldened and never break (Ignore = morale never checked).
        if (_user.getSkills().hasSkill("perk.druid.pack_leader")) {
            beast.setMoraleState(this.Const.MoraleState.Ignore);
        }
        // Venom: their bites carry poison.
        if (_user.getSkills().hasSkill("perk.druid.venom")) {
            beast.getSkills().add(this.new("scripts/skills/racial/druid_venom"));
        }

        beast.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
        beast.setDirty(true);

        this.m.ChargesUsed++;
        _user.getSkills().onSummonBeast(beast);
        return true;
    }
});
