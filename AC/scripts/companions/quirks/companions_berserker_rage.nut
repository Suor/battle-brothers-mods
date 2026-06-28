this.companions_berserker_rage <- this.inherit("scripts/skills/skill", {
	m = {
		RageStacks = 0
	},
	function create()
	{
		this.m.ID = "quirk.berserker_rage";
		this.m.Name = "Rage";
		this.m.Description = "Rage.";
		this.m.Icon = "skills/status_effect_34.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
	}

	function addRage( _r )
	{
		this.m.RageStacks += _r;
		local actor = this.getContainer().getActor();

		if (!actor.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " gains rage!");
		}
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.RageStacks == 0;
		_properties.DamageReceivedTotalMult *= this.Math.maxf(0.3, 1.0 - 0.02 * this.m.RageStacks);
		_properties.Bravery += 1 * this.m.RageStacks;
		_properties.DamageRegularMin += 1 * this.m.RageStacks;
		_properties.DamageRegularMax += 1 * this.m.RageStacks;
		_properties.Initiative += 1 * this.m.RageStacks;
	}

	function onTurnStart()
	{
		this.m.RageStacks = this.Math.max(0, this.m.RageStacks - 1);
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.addRage(2);
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		this.addRage(5);
	}
});
