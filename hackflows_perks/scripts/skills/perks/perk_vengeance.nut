this.perk_vengeance <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.vengeance";
		this.m.Name = this.Const.Strings.PerkName.Vengeance;
		this.m.Description = this.Const.Strings.PerkDescription.Vengeance;
		this.m.Icon = "wotn_perks/vengeance.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		local actor = this.getContainer().getActor();

		if (!_attacker.isAlliedWith(actor) && !actor.getSkills().hasSkill("effect.vengeance"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/vengeance_effect"));
		}
	}

});
