this.perk_double_strike <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.double_strike";
		this.m.Name = this.Const.Strings.PerkName.DoubleStrike;
		this.m.Description = this.Const.Strings.PerkDescription.DoubleStrike;
		this.m.Icon = "wotn_perks/double_strike.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local actor = this.getContainer().getActor();

		if (!_targetEntity.isAlliedWith(actor) && !actor.getSkills().hasSkill("effect.double_strike"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/double_strike_effect"));
		}
	}

});
