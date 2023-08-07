::mods_hookExactClass("entity/tactical/actor", function (o) {
    local onDeath = o.onDeath;
    o.onDeath = function (_killer, _skill, _tile, _fatalityType) {
        if ("FunFacts" in _killer.m) _killer.m.FunFacts.onKill(this, _fatalityType);
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

        // // Remember injuries before
        // local oldInjuries = {};
        // foreach (skill in ::std.Util.concat(this.m.Skills, this.m.SkillsToAdd)) {
        //     if (!skill.isGarbage() && ::mods_isClass(skill, "injury"))
        //         oldInjuries[skill.ClassName] <- true;
        // }

        // local damage = onDamageReceived(_attacker, _damageSkill, _hitInfo);

        // // Find new injuries
        // local injuries = [];
        // foreach (skill in ::std.Util.concat(this.m.Skills, this.m.SkillsToAdd)) {
        //     if (!skill.isGarbage() && ::mods_isClass(skill, "injury") && !(skill.ClassName in oldInjuries))
        //         injuries.push(skill);
        // }

        foreach (injury in injuries) {
            if ("FunFacts" in this.m) this.m.FunFacts.onInjury(_attacker, injury);
            if ("FunFacts" in _attacker.m) _attacker.m.FunFacts.onInjuryDealt(this, injury);
        }

        return damage;
    }
});
