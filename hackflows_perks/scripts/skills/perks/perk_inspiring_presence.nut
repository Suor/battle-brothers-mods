this.perk_inspiring_presence <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.inspiring_presence";
		this.m.Name = this.Const.Strings.PerkName.InspiringPresence;
		this.m.Description = this.Const.Strings.PerkDescription.InspiringPresence;
		this.m.Icon = "ui/perks/perk_28.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onCombatStarted()
	{
		this.logInfo("inspiring presence: on combat started!");
		this.skill.onCombatStarted();
		local allies = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());
		local ownID = this.getContainer().getActor().getID();

		foreach( ally in allies )
		{
			if (ally.getID() == ownID)
			{
				continue;
			}

			if (ally.getMoraleState() != this.Const.MoraleState.Ignore)
			{
				ally.setMoraleState(this.Const.MoraleState.Confident);
			}
		}
	}

});

