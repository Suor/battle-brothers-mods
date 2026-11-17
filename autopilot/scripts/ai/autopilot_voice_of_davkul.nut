// Drums' behavior counts any tired ally, but the Voice is only heard by cultists.
this.autopilot_voice_of_davkul <- this.inherit("scripts/ai/tactical/behaviors/ai_boost_stamina", {
    m = {},
    function create()
    {
        this.m.ID = this.Const.AI.Behavior.ID.AP_VoiceOfDavkul;
        this.m.Order = this.Const.AI.Behavior.Order.AP_VoiceOfDavkul;
        this.m.PossibleSkills = ["actives.voice_of_davkul"];
        this.m.IsThreaded = false;
        this.behavior.create();
    }

    function isCultist( _actor )
    {
        if (_actor.getType() == ::Const.EntityType.Cultist) return true;
        if (!::std.Util.isKindOf(_actor, "player")) return false;
        local bg = _actor.getBackground();
        if (::std.Util.isNull(bg)) return false;
        // Legends marks cultists by type, its own backgrounds among them
        if (::Hooks.hasMod("mod_legends")) {
            return bg.isBackgroundType(::Const.BackgroundType.Cultist)
                || bg.isBackgroundType(::Const.BackgroundType.ConvertedCultist);
        }
        local id = bg.getID();
        return id == "background.cultist" || id == "background.converted_cultist";
    }

    function onEvaluate( _entity )
    {
        this.m.Skill = null;
        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP) return 0;
        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing) return 0;

        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return 0;

        // The Voice reaches the whole field, so no distance cut as for drums
        local targets = 0;
        foreach (a in this.Tactical.Entities.getInstancesOfFaction(_entity.getFaction())) {
            if (a.getID() == _entity.getID() || a.getFatigue() <= 20) continue;
            local morale = a.getMoraleState();
            if (morale == this.Const.MoraleState.Ignore || morale == this.Const.MoraleState.Fleeing) continue;
            if (!this.isCultist(a) || a.getSkills().hasSkill("effects.voice_of_davkul")) continue;
            targets++;
        }
        if (targets == 0) return 0;

        // Weighed as vanilla drums: 0.4 of the base score per tired ally
        return ::Const.AI.Behavior.Score.AP_VoiceOfDavkul * 0.4 * targets
            * this.getFatigueScoreMult(this.m.Skill) * this.getProperties().BehaviorMult[this.m.ID];
    }
});
