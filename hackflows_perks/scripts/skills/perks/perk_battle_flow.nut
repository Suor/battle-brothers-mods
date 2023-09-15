this.perk_hackflows_battle_flow <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "perk.hackflows.battle_flow";
		this.m.Name = this.Const.Strings.PerkName.BattleFlow;
		this.m.Description = this.Const.Strings.PerkDescription.BattleFlow;
		this.m.Icon = "wotn_perks/battle_flow.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();
		
		if (actor.isAlliedWith(_targetEntity)) return;

		if (!this.m.IsSpent) {
			this.m.IsSpent = true;
			actor.setFatigue(Math.max(0, actor.getFatigue() - _skill.getFatigueCost()));
			actor.setDirty(true);
			this.spawnIcon("battle_flow", this.m.Container.getActor().getTile());
		}
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}
})

