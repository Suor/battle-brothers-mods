this.repair_helmet_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.repair_helmet";
		this.m.Name = "Repair Helmet";
		this.m.Icon = "";
		this.m.Description = "";
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor()
		local helmet = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head)
		helmet.m.Condition = this.Math.minf(helmet.m.ConditionMax, helmet.m.Condition + 50.0)
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor()
		local helmet = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head)
		helmet.m.Condition = helmet.m.ConditionMax;
		helmet.updateAppearance();
	}

});

