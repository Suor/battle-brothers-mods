this.perk_necro_soul_link <- this.inherit("scripts/skills/skill", {
    m = {
        Minions = null
        Damage = 0
        Old = null
    }
    function create() {
        this.m.ID = "perk.necro.soul_link";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
        this.m.SoundOnUse = [
            "sounds/enemies/gruesome_feast_01.wav",
            "sounds/enemies/gruesome_feast_02.wav",
            "sounds/enemies/gruesome_feast_03.wav"
        ];
        this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;

        this.m.Minions = [];
    }

    function onRaiseUndead(_undead) {
        this.m.Minions.push(::MSU.asWeakTableRef(_undead));
    }
    function getMinions() {
        this.m.Minions = this.m.Minions.filter(@(_, a) ::std.Actor.isValidTarget(a));
        return this.m.Minions;
    }
    function hasMinions() {
        return this.getMinions().len() > 0;
    }
    function isHidden() {
        return !this.hasMinions();
    }

    function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
        if (_damageHitpoints <= 0) return;

        local necro = this.getContainer().getActor();
        local chance = 0.25 + 0.75 * _damageHitpoints / necro.m.Hitpoints;
        local roll = ::std.Rand.chance(chance);
        ::logInfo("necro: sl damage=" + _damageHitpoints + " hitpoints=" + necro.m.Hitpoints
                + " chance=" + chance + " roll=" + roll);
        if (this.hasMinions() && roll) {
            ::logInfo("necro: sl ACTIVE");
            this.m.Damage = _damageHitpoints;
            this.m.Old = {IsAbleToDie = necro.m.IsAbleToDie, Hitpoints = necro.m.Hitpoints};
            necro.m.IsAbleToDie = false;
        } else {
            this.m.Damage = 0;
            this.m.Old = null;
        }
    }
    function onAfterDamageReceived() {
        ::logInfo("necro: afterDamage 1");
        if (this.m.Old == null) return;

        ::logInfo("necro: afterDamage 2");
        local necro = this.getContainer().getActor();
        necro.m.IsAbleToDie = this.m.Old.IsAbleToDie;
        necro.m.Hitpoints = this.m.Old.Hitpoints;

        // Might loose some minion in the process
        local minions = this.getMinions();
        if (minions.len() == 0) return;
        local victim = minions[::Math.rand(0, minions.len() - 1)];
        ::logInfo("necro: afterDamage 3");

        ::Tactical.EventLog.logEx("Soul Link was activated!");

        if (this.m.Damage >= this.m.Old.Hitpoints || this.m.Damage >= victim.m.Hitpoints) {
            this.evaporate(victim);
        } else this.damage(victim, this.m.Damage);
    }

    function damage(_victim, _damage) {
        ::logInfo("necro: damage");
        this.playSound(_victim.getPos(), 0.7);

        local hitInfo = clone ::Const.Tactical.HitInfo;
        hitInfo.DamageRegular = _damage;
        hitInfo.DamageDirect = 1.0;
        hitInfo.BodyPart = ::Const.BodyPart.Body;
        hitInfo.BodyDamageMult = 1.0;
        hitInfo.FatalityChanceMult = 0.0;

        // Some skills might not understand null ref
        local attacker = this.getContainer().getActor().get();
        _victim.onDamageReceived(attacker, this, hitInfo);
    }

    function evaporate(_victim) {
        ::logInfo("necro: evaporate " + _victim.getName());
        local necro = this.getContainer().getActor();
        local victimTile = _victim.getTile();

        for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
        {
            this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, necro.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
        }
        this.playSound(_victim.getPos(), 1.2);
        this.Tactical.getShaker().shake(_victim, _victim.getTile(), 3, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, this.Const.ShakeCharacterLayers[this.Const.BodyPart.All], 2.0);
        for( local i = 0; i < this.Const.Tactical.KrakenDevourParticles.len(); i = ++i )
        {
            this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourParticles[i].Brushes, victimTile, this.Const.Tactical.KrakenDevourParticles[i].Delay, this.Const.Tactical.KrakenDevourParticles[i].Quantity, this.Const.Tactical.KrakenDevourParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourParticles[i].Stages);
        }
        for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
        {
            this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, victimTile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
        }

        // Kill it, extra stuff and effects will go in onOtherActorDeath()
        _victim.kill(necro, this);
    }

    function onOtherActorDeath(_killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType) {
        if (_skill != this) return;

        // Drop all items from corpse and remove it
        local corpse = _corpseTile.Properties.get("Corpse");

        foreach (item in corpse.Items.getAllItems()) {
            _corpseTile.Items.push(item);
            _corpseTile.IsContainingItems = true;
            item.m.Tile = _corpseTile;
            item.onDrop(_corpseTile);
        }

        ::Tactical.Entities.removeCorpse(_corpseTile);
        _corpseTile.clear(this.Const.Tactical.DetailFlag.Corpse);
        _corpseTile.Properties.remove("Corpse");
        _corpseTile.Properties.remove("IsSpawningFlies");

        this.spawnBloodbath(_victim.getTile());
    }


    function spawnBloodbath(_targetTile) {
        for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
        {
            _targetTile.spawnDetail(this.Const.CorpsePart[i]);
        }

        for( local i = 0; i != 6; i = ++i )
        {
            if (!_targetTile.hasNextTile(i))
            {
            }
            else
            {
                local tile = _targetTile.getNextTile(i);

                for( local n = this.Math.rand(0, 2); n != 0; n = --n )
                {
                    local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
                    tile.spawnDetail(decal);
                }
            }
        }

        local myTile = this.getContainer().getActor().getTile();

        for( local n = 2; n != 0; n = --n )
        {
            local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
            myTile.spawnDetail(decal);
        }
    }

    function playSound(_pos, _volumeMult) {
        if (this.m.SoundOnUse.len() != 0) {
            ::Sound.play(this.m.SoundOnUse[::Math.rand(0, this.m.SoundOnUse.len() - 1)],
                         ::Const.Sound.Volume.RacialEffect * _volumeMult, _pos);
        }
    }
})
