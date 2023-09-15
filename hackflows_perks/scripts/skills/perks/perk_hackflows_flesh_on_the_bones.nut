this.perk_hackflows_flesh_on_the_bones <- this.inherit("scripts/skills/skill", {
	m = {}
	function create()
	{
		this.m.ID = "perk.hackflows.flesh_on_the_bones";
		this.m.Name = this.Const.Strings.PerkName.FleshOnTheBones;
		this.m.Description = this.Const.Strings.PerkDescription.FleshOnTheBones;
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
})
