this.perk_battle_flow <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "perk.battle_flow";
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
			actor.setFatigue(actor.getFatigue() - _skill.getFatgueCost());
			actor.setDirty(true);
			this.spawnIcon("battle_flow", this.m.Container.getActor().getTile());
		}
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}
	
	function onCombatStarted()
	{
		this.m.IsSpent = false; // Should not be needed
	}

});

