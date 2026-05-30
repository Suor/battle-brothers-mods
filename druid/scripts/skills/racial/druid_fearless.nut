// Pack Leader's beasts know their master for the alpha: they hold their nerve and never flee.
// A huge Bravery bonus makes checkMorale bail on any morale change (see actor.checkMorale,
// the `bravery > 500` early-out), so the beast keeps whatever state it starts the battle in.
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
        return "This beast knows its master for the alpha. It stays confident and will never break or flee the field.";
    }

    function onUpdate( _properties )
    {
        # FIX: this is complete bullshit! It should not flee but should not resist all morale effects
        _properties.Bravery += 1000;
    }
});
