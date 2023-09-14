this.perk_feint <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.feint";
		this.m.Name = this.Const.Strings.PerkName.Feint;
		this.m.Description = this.Const.Strings.PerkDescription.Feint;
		this.m.Icon = "wotn_perks/double_strike.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		local actor = this.getContainer().getActor();
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - this.Math.floor(_skill.getFatigueCost() * 0.5)));
	}

});
