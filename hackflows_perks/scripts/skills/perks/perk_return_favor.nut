this.perk_return_favor <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.return_favor";
		this.m.Name = this.Const.Strings.PerkName.ReturnFavor;
		this.m.Description = this.Const.Strings.PerkDescription.ReturnFavor;
		this.m.Icon = "ui/perks/perk_31.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.return_favor"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/return_favor"));
		}
	}

});
