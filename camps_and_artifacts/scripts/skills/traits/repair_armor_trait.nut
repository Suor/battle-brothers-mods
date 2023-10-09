this.repair_armor_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.repair_armor";
		this.m.Name = "Repair Armor";
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
		local armor = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body)
		armor.m.Condition = this.Math.minf(armor.m.ConditionMax, armor.m.Condition + 50.0)
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor()
		local armor = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body)
		armor.m.Condition = armor.m.ConditionMax;
		armor.updateAppearance();
	}

});

