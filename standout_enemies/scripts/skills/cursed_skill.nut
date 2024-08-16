local Mod = StandoutEnemies.Mod;

this.cursed_skill <- this.inherit("scripts/skills/skill", {
    m = {},
    function create() {
        this.m.ID = "standout_enemies.special.cursed";
        this.m.Name = "Cursed";
        this.m.Description = "Spreads curses, weakening everybody around";
        this.m.Type = this.Const.SkillType.Special;
        this.m.Order = this.Const.SkillOrder.Last;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsHidden = true;
    }

    function onAdded() {
        local actor = this.getContainer().getActor();
        // Make black
        foreach (sprite in ["head" "face" "hair" "beard" "beard_top" "body" "arms_icon" "shield_icon"]) {
            Mod.color(actor, sprite, "#777777", 0.8);
        }
    }

    function curse(_target) {
        if (!_target.isAlive()) return;
        _target.getSkills().add(this.new("scripts/skills/cursed_effect"));
    }

    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {
        this.curse(_targetEntity)
    }

    function onTargetMissed( _skill, _targetEntity ) {
        this.curse(_targetEntity);
    }

    function onMissed( _attacker, _skill ) {
        this.curse(_attacker)
    }

    function onDamageReceived( _attacker, _damageHitpoints, _damageArmor ) {
        this.curse(_attacker)
    }

    function onDeath( _fatalityType ) {
        local actor = this.getContainer().getActor();
        local tile = actor.getTile();

        for (local i = 0; i != 6; i = ++i) {
            if (!tile.hasNextTile(i)) continue;

            local otherTile = tile.getNextTile(i);
            if (!otherTile.IsOccupiedByActor) continue;

            local otherActor = otherTile.getEntity();
            if (!otherActor.isAlliedWith(actor)) {
                this.curse(otherActor);
            }
        }
    }
});
