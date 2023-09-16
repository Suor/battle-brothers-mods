::mods_hookExactClass("entity/tactical/actor", function (o) {
    local onDeath = o.onDeath;
    o.onDeath = function (_killer, _skill, _tile, _fatalityType) {
        if (_killer != null && "FunFacts" in _killer.m) _killer.m.FunFacts.onKill(this, _fatalityType);
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
