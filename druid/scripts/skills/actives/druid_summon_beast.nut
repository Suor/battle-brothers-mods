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
        this.m.Icon = "druid/summon.png";
        this.m.IconDisabled = "druid/summon_sw.png";
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

    function pickBeastID()
    {
        local biomes = this.Const.Druid.Biomes;
        local terrain = this.getTerrainType();
        local pool = terrain in biomes.Pools ? biomes.Pools[terrain] : biomes.Default;
        return pool[this.Math.rand(0, pool.len() - 1)];
    }

    // Apex specimen of a beast that has no greater cousin to swap into: just bigger and tougher.
    // Multipliers are rough first-pass balance — tune to taste.
    function makeApex(_beast)
    {
        local hpMult = 1.5;
        _beast.m.BaseProperties.Hitpoints = this.Math.round(_beast.m.BaseProperties.Hitpoints * hpMult);
        _beast.m.CurrentProperties.Hitpoints = this.Math.round(_beast.m.CurrentProperties.Hitpoints * hpMult);
        _beast.setHitpoints(_beast.getHitpointsMax());

        // Spiders expose a native size knob that scales every body part; the rest just grow their body sprite.
        try {
            _beast.setSize(1.1);
        } catch (error) {
            local body = _beast.getSprite("body");
            if (body != null) body.Scale = 1.25;
        }
    }

    function onUse(_user, _targetTile)
    {
        local biomes = this.Const.Druid.Biomes;
        local isApex = _user.getSkills().hasSkill("perk.druid.apex");
        local beastID = this.pickBeastID();

        // Apex: swap to a greater beast where one exists, otherwise rear a bigger, tougher specimen.
        local boostApex = false;
        if (isApex) {
            if (beastID in biomes.ApexMap) beastID = biomes.ApexMap[beastID];
            else boostApex = true;
        }

        local script = "scripts/entity/tactical/enemies/" + beastID;
        local beast = this.Tactical.spawnEntity(script, _targetTile.Coords.X, _targetTile.Coords.Y);
        if (beast == null) return false;
        if (boostApex) this.makeApex(beast);

        beast.setFaction(this.Const.Faction.PlayerAnimals);
        beast.m.druid_master <- ::MSU.asWeakTableRef(_user);
        beast.m.druid_RaisedByPlayer = true;

        // Pack Leader: beasts arrive emboldened — they start Confident and, thanks to the
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

        this.m.ChargesUsed++;
        _user.getSkills().onSummonBeast(beast);
        return true;
    }
});
