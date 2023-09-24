this.perk_hackflows_full_force <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hackflows.full_force";
		this.m.Name = ::Const.Perks.LookupMap[this.m.ID].Name;
		this.m.Description = ::Const.Perks.LookupMap[this.m.ID].Description;
		this.m.Icon = "ui/perks/perk_18.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local items = actor.getItems();

		local fat = 0;
		local bodyParts = [
			this.Const.ItemSlot.Body
			this.Const.ItemSlot.Head
			this.Const.ItemSlot.Mainhand
			this.Const.ItemSlot.Offhand
		];
		foreach (slot in bodyParts) {
			local item = items.getItemAtSlot(slot);
			if (item) fat += item.getStaminaModifier();
		}

		local mainhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local unarmed = (mainhand == null || this.getContainer().hasSkill("effects.disarmed"))
		if (unarmed || actor.isArmedWithMeleeWeapon()) {
			local bonus = this.Math.abs(fat) / 3;
			_properties.DamageRegularMin *= 1.0 + 0.01 * this.Math.floor(bonus);
			local damageMin = _properties.DamageRegularMin;
			local damageMax = _properties.DamageRegularMax;
			if (damageMax < damageMin) {
				_properties.DamageRegularMax = damageMin;
				_properties.DamageRegularMin = damageMax;
			}
		}
	}

});
