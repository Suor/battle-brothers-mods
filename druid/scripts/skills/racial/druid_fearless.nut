// Beast Aura's beasts know their master for the alpha: they can be shaken but never routed.
// This is a marker skill - mod_druid hooks actor.checkMorale to floor a fearless beast's morale
// at Breaking, so morale effects still bite but the roll can never drop it into Fleeing.
this.druid_fearless <- this.inherit("scripts/skills/skill", {
    m = {},
    function create()
    {
        this.m.ID = "racial.druid_fearless";
        this.m.Name = "Fearless";
        this.m.Type = this.Const.SkillType.Racial;
        this.m.Order = this.Const.SkillOrder.Last;
        this.m.IsRemovedAfterBattle = true;
        this.m.IsHidden = false;
    }

    function getDescription()
    {
        return "This beast knows its master for the alpha. It may be shaken in the thick of battle, but it will never flee the field.";
    }
});
