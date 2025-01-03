this.perk_necro_mind_meld <- this.inherit("scripts/skills/skill", {
    m = {
        Skip = null
    }
    function create() {
        this.m.ID = "perk.necro.mind_meld";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;

        this.m.Skip = [
            "perk.gifted"
            "perk.nimble"
            "perk.battle_forged"
            // Medium Armor perks
            "perk.hackflows.stabilized" // Hackflow's Perks
            "perk.stabilized"           // mod_stabilized
            "perk.rf_poise"             // Reforged
            "perk.lithe"                // True Balance
        ]
    }

    function onRaiseUndead(_undead) {
        ::logInfo("necro: mind_meld.onRaiseUndead");

        // // TODO: learn whatever they know already ???
        // foreach (skill in _undead.m.Skills.getAllSkillsOfType(::Const.SkillType.Perk)) {
        //     // local script = IO.scriptFilenameByHash(skill.ClassNameHash));
        //     ::logInfo("necro: meld return " + skill.m.ID);
        // }

        foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Perk)) {
            if (this.m.Skip.find(skill.m.ID) != null || skill.m.ID.find("perk.necro.") != null)
                continue;
            local script = IO.scriptFilenameByHash(skill.ClassNameHash);
            ::logInfo("necro: to meld " + script);
            _undead.m.Skills.add(::new(script))
        }
    }

    function onCombatStarted() {
        local necro = this.getContainer().getActor();
        // These are added on comabt start to make Mind Meld useful in no corpses battles
        foreach (id in ["perk.necro.regeneration" "perk.necro.blood_sucking"]) {
            local perk = this.m.Container.getSkillByID(id);
            if (perk) perk.onRaiseUndead(necro);
        }
    }
})
