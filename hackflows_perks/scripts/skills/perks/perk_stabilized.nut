this.perk_stabilized <- this.inherit("scripts/skills/skill", {
	m = {
		BonusMax = 30
		ArmorIdealMin = 25
		ArmorIdealMax = 37
	}
	function create()
	{
		this.m.ID = "perk.stabilized";
		this.m.Name = this.Const.Strings.PerkName.Stabilized;
		this.m.Description = this.Const.Strings.PerkDescription.Stabilized;
		this.m.Icon = "icons/stabilized.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function isHidden()
	{
		local items = this.getContainer().getActor().getItems();
		local body = items.getItemAtSlot(this.Const.ItemSlot.Body);
		local head = items.getItemAtSlot(this.Const.ItemSlot.Head);
		return !body && !head;
	}

	function getDescription() {
		return "Perfectly balanced! This character makes use of their armor\'s blend of protection and mobility, granting them a reduction in damage taken to both Hitpoints and Armor.";
	}

	function getTooltip()
	{
		local function positive(text) {
		    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
		}
		// local function red(text) {
		//     return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
		// }

		local bonus = this.getBonus();
		local totalArmorFatPenalty = this.getTotalArmorFat();
		local tooltip = this.skill.getTooltip();

		if (bonus > 0)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive " + positive((100 - bonus) + "%") + " of any attack damage"
			});

			local actor = this.getContainer().getActor();
			local nimble = actor.getSkills().getSkillByID("perk.nimble");
			local bf = actor.getSkills().getSkillByID("perk.battle_forged");
			if (nimble || bf) {
				local hpMult = 1.0 - bonus * 0.01;
				local armorMult = hpMult;
				if (nimble) hpMult *= nimble.getChance();
				if (bf) {
					local armor = actor.getArmor(::Const.BodyPart.Head) + actor.getArmor(::Const.BodyPart.Body);
					armorMult *= 1.0 - armor * 0.05 * 0.01;
				}

				local others = nimble && bf ? "Nimble and Battle Forged" :
					           nimble ? "Nimble" : bf ? "Battle Forged" : null;
				local hp = positive(Math.round(100 * hpMult) + "%");
				local armor = positive(Math.round(100 * armorMult) + "%");
				tooltip.push({
					id = 7
					type = "hint"
					icon = "ui/icons/regular_damage.png"
					text = format("Combined with %s you only receive %s damage to Hitpoints and %s damage to Armor", others, hp, armor)
				})
			}
		}
		else if (totalArmorFatPenalty < this.m.ArmorIdealMin)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "This brother\'s armor is too flimsy to benefit from being stabilized! Try equipping some heavier armor."
			});
		}
		else if (totalArmorFatPenalty > this.m.ArmorIdealMax)
		{
			tooltip.push({
				id = 6,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "This brother\'s armor is too cumbersome to benefit from being stabilized! Try equipping some lighter armor."
			});
		}

		return tooltip;
	}

	function getTotalArmorFat()
	{
		local items = this.getContainer().getActor().getItems();
		local body = items.getItemAtSlot(this.Const.ItemSlot.Body);
		local head = items.getItemAtSlot(this.Const.ItemSlot.Head);

		local fat = 0;
		if (body != null) fat += body.getStaminaModifier();
		if (head != null) fat += head.getStaminaModifier();

		return Math.abs(fat);
	}

	function getBonus()
	{
		if (this.getContainer() == null) return 0;
		local actor = this.getContainer().getActor();
		if (actor == null) return 0;

		local armorFat = this.getTotalArmorFat();
		local badFat = armorFat < this.m.ArmorIdealMin ? this.m.ArmorIdealMin - armorFat :
		               armorFat > this.m.ArmorIdealMax ? armorFat - this.m.ArmorIdealMax : 0;
		return Math.maxf(0, this.m.BonusMax - Math.pow(badFat, 2));
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker == null || _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack())
		{
			return;
		}

		local bonus = this.getBonus();
		_properties.DamageReceivedArmorMult *= 1.0 - bonus * 0.01;
		_properties.DamageReceivedRegularMult *= 1.0 - bonus * 0.01;
	}
});
