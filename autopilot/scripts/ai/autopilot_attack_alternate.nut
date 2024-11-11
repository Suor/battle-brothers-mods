// Adding skill to ai_attack_default works most of the time, however, if some skill not always
// available because of no proper targets then a bro might just wait and skip for nothing.
this.autopilot_attack_alternate <- ::inherit("scripts/ai/tactical/behaviors/ai_attack_default", {
    m = {},
    function create()
    {
        this.m.ID = ::Const.AI.Behavior.ID.AP_AttackAlternate;
        this.m.Order = ::Const.AI.Behavior.Order.AP_AttackAlternate;
        this.m.PossibleSkills = [
            "actives.xxitem_deadbookaa_skill" // Fantasy Brothers, Death Ritual
        ];
        this.behavior.create();
    }
});
