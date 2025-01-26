::mods_hookExactClass("entity/tactical/actor", function (o) {
    local kill = o.kill;
    o.kill = function (_killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false) {
        if (_killer != null) this.ff_killer <- ::MSU.asWeakTableRef(_killer);
        return kill(_killer, _skill, _fatalityType, _silent);
    }

    local onDeath = o.onDeath;
    o.onDeath = function (_killer, _skill, _tile, _fatalityType) {
        local killer = "ff_killer" in this && this.ff_killer.isAlive() ? this.ff_killer.get() : _killer;
        if (killer != null && "FunFacts" in killer.m)
            killer.m.FunFacts.onKill(this, _skill, _fatalityType);
        if ("FunFacts" in this.m)
            this.m.FunFacts.onDeath(killer, _fatalityType);
        return onDeath(_killer, _skill, _tile, _fatalityType)
    }

    local onDamageReceived = o.onDamageReceived;
    o.onDamageReceived = function (_attacker, _damageSkill, _hitInfo) {
        local injuries = [];
        local skillAdd = this.m.Skills.add;
        this.m.Skills.add = function (_skill, _order = 0) {
            if (::mods_isClass(_skill, "injury")) injuries.push(_skill);
            return skillAdd(_skill, _order);
        }

        local damage = onDamageReceived(_attacker, _damageSkill, _hitInfo);
        this.m.Skills.add = skillAdd;

        foreach (injury in injuries) {
            if ("FunFacts" in this.m) this.m.FunFacts.onInjury(_attacker, injury);
            if ("FunFacts" in _attacker.m) _attacker.m.FunFacts.onInjuryDealt(this, injury);
        }

        return damage;
    }
});
