this.artifact_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {
		PrefixList = this.Const.Strings.RandomArmorPrefix,
		NameList = [],
		AttachedPerk = ""
		APTooltip = ""
		APID = ""
		UseRandomName = true
	},
	function create()
	{
		this.helmet.create();
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Artifact;
		this.m.IsDroppedAsLoot = true;
	}

	function onEquip()
	{
		this.helmet.onEquip();

		if (this.m.Name.len() == 0)
		{
			this.setName();
		}
	}

	function onAddedToStash( _stashID )
	{
		if (this.m.Name.len() == 0)
		{
			this.setName();
		}
	}

	function setName( _prefix = "" )
	{
		this.m.Name = this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = this.Math.min(0, this.m.StaminaModifier + this.Math.rand(4, 6));
		this.m.Condition = this.Math.floor(this.m.Condition * this.Math.rand(130, 150) * 0.01) * 1.0;
		this.m.ConditionMax = this.m.Condition;
	}
	function randomizePerks( _perk_type )
	{		
		if ( _perk_type == "light" )
		{
			local perk_choice = this.Math.rand(0,5)

			if (perk_choice == 0)
			{
				this.m.AttachedPerk = "scripts/skills/traits/glorious_quickness_trait"
				this.m.APTooltip = "Glorious Quickness"
				this.m.APID = "trait.glorious"
			}
			if (perk_choice == 1)
			{
				this.m.AttachedPerk = "scripts/skills/traits/bonus_ap_trait"
				this.m.APTooltip = "+1 Action Point"
				this.m.APID = "trait.bonus_ap"
			}
			if (perk_choice == 2)
			{
				this.m.AttachedPerk = "scripts/skills/traits/eagle_eyes_trait"
				this.m.APTooltip = "+1 Vision"
				this.m.APID = "trait.eagle_eyes"
			}
			if (perk_choice == 3)
			{
				this.m.AttachedPerk = "scripts/skills/traits/night_vision_trait"
				this.m.APTooltip = "Night Vision"
				this.m.APID = "trait.night_vision"
			}
			if (perk_choice == 4)
			{
				this.m.AttachedPerk = "scripts/skills/traits/repair_helmet_trait"
				this.m.APTooltip = "Self-Repairing"
				this.m.APID = "trait.repair_helmet"
			}
			if (perk_choice == 5)
			{
				this.m.AttachedPerk = "scripts/skills/traits/preternatural_dodge_trait"
				this.m.APTooltip = "Preternatural Dodge"
				this.m.APID = "trait.preternatural_dodge"
			}
		}
		
		if ( _perk_type == "heavy" )
		{
			local perk_choice = this.Math.rand(0,4)

			if (perk_choice == 0)
			{
				this.m.AttachedPerk = "scripts/skills/traits/regenerate_trait"
				this.m.APTooltip = "Regenerating"
				this.m.APID = "trait.regenerate"
			}
			if (perk_choice == 1)
			{
				this.m.AttachedPerk = "scripts/skills/traits/bonus_stam_regen_trait"
				this.m.APTooltip = "+2 Fatigue Recovery"
				this.m.APID = "trait.bonus_stam_regen"
			}
			if (perk_choice == 2)
			{
				this.m.AttachedPerk = "scripts/skills/traits/mind_immune_trait"
				this.m.APTooltip = "Immune against fear and mind control abilities"
				this.m.APID = "trait.mind_immune"
			}
			if (perk_choice == 3)
			{
				this.m.AttachedPerk = "scripts/skills/traits/grab_immune_trait"
				this.m.APTooltip = "Immunity to being rooted by nets or grasping vines"
				this.m.APID = "trait.grab_immune"
			}
			if (perk_choice == 4)
			{
				this.m.AttachedPerk = "scripts/skills/traits/grant_linebreaker_trait"
				this.m.APTooltip = "Enables the Linebreaker skill"
				this.m.APID = "trait.grant_linebreaker"
			}
		}
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeString(this.m.AttachedPerk);
		_out.writeString(this.m.APTooltip);
		_out.writeString(this.m.APID);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI8(this.m.StaminaModifier);
		this.helmet.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Name = _in.readString();
		this.m.AttachedPerk = _in.readString();
		this.m.APTooltip = _in.readString();
		this.m.APID = _in.readString();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI8();
		this.helmet.onDeserialize(_in);
		this.updateVariant();
	}

});

