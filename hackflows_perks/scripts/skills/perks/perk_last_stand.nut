this.perk_last_stand <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.last_stand";
		this.m.Name = this.Const.Strings.PerkName.LastStand;
		this.m.Description = this.Const.Strings.PerkDescription.LastStand;
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onCombatStarted()
	{
		this.getContainer().add(this.new("scripts/skills/effects/last_stand_effect"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.last_stand");
	}

});
