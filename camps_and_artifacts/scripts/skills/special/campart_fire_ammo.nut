this.campart_fire_ammo <- ::inherit("scripts/skills/skill", {
    m = {
        TargetTile = null
    },
    function create()
    {
        this.m.ID = "special.campart_fire_ammo";
        this.m.Name = "Flaming Ammo Effect";
        this.m.Description = "A successful hit will light the target tile on fire for 2 rounds.";
        this.m.Icon = "";
        this.m.Type = this.Const.SkillType.Special;
        this.m.Order = ::Const.SkillOrder.VeryLast;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsHidden = true;
    }

    function onQueryTooltip( _skill, _tooltip )
    {
        if (this.m.Item.appliesTo(_skill))
        {
            _tooltip.push({
                id = 10,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Will light the landing tile on fire for 2 rounds"
            });
        }
    }

    function onCombatFinished()
    {
        this.skill.onCombatFinished();
        this.m.TargetTile = null;
    }

    function onBeforeAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
    {
        this.m.TargetTile = null;
    }

    function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
    {
        if (this.m.Item.appliesTo(_skill)) this.m.TargetTile = _targetEntity.getTile();
    }

    // See overwhelm
    // function onTargetMissed( _skill, _targetEntity )
    // {
    // }

    // The code below mostly copy-pasted from perk_rf_flaming_arrows
    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
    {
        if (this.m.TargetTile == null) return;
        ::Time.scheduleEvent(::TimeUnit.Real, 50, this.onApply.bindenv(this), {
            Skill = this,
            User = this.getContainer().getActor(),
            TargetTile = this.m.TargetTile
        });
    }

    function onApply( _data )
    {
        local targets = [];
        targets.push(_data.TargetTile);

        local p = {
            Type = "fire",
            Tooltip = "Fire rages here, melting armor and flesh alike",
            IsPositive = false,
            IsAppliedAtRoundStart = false,
            IsAppliedAtTurnEnd = true,
            IsAppliedOnMovement = false,
            IsAppliedOnEnter = false,
            IsByPlayer = _data.User.isPlayerControlled(),
            Timeout = ::Time.getRound() + 2,
            Callback = ::Const.Tactical.Common.onApplyFire,
            function Applicable( _a )
            {
                return true;
            }
        };

        foreach (tile in targets)
        {
            if (tile.Subtype != ::Const.Tactical.TerrainSubtype.Snow && tile.Subtype != ::Const.Tactical.TerrainSubtype.LightSnow && tile.Type != ::Const.Tactical.TerrainType.ShallowWater && tile.Type != ::Const.Tactical.TerrainType.DeepWater)
            {
                if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "fire")
                {
                    tile.Properties.Effect.Timeout = ::Time.getRound() + 2;
                }
                else
                {
                    if (tile.Properties.Effect != null)
                    {
                        ::Tactical.Entities.removeTileEffect(tile);
                    }

                    tile.Properties.Effect = clone p;
                    local particles = [];

                    for( local i = 0; i < ::Const.Tactical.FireParticles.len(); i = ++i )
                    {
                        particles.push(::Tactical.spawnParticleEffect(true, ::Const.Tactical.FireParticles[i].Brushes, tile, ::Const.Tactical.FireParticles[i].Delay, ::Const.Tactical.FireParticles[i].Quantity, ::Const.Tactical.FireParticles[i].LifeTimeQuantity, ::Const.Tactical.FireParticles[i].SpawnRate, ::Const.Tactical.FireParticles[i].Stages));
                    }

                    ::Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
                    tile.clear(::Const.Tactical.DetailFlag.Scorchmark);
                    tile.spawnDetail("impact_decal", ::Const.Tactical.DetailFlag.Scorchmark, false, true);
                }
            }

            if (tile.IsOccupiedByActor)
            {
                ::Const.Tactical.Common.onApplyFire(tile, tile.getEntity());
            }
        }

        this.m.TargetTile = null;
    }
});
