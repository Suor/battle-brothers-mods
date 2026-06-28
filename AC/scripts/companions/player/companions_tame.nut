this.companions_tame <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.companions_tame";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.BeforeLast + 100;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = true;
		this.m.IsUsingHitchance = false;

		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;

		this.m.Name = "Tame Beast";
		this.m.Description = "Attempt to tame an adjacent beast. Failing the attempt makes further attempts on the same beast impossible. Succeeding the attempt equips the beast in the brother\'s accessory slot, but it cannot be unleashed in the same battle in which it was tamed.";
		this.m.Icon = "skills/tame_ac.png";
		this.m.IconDisabled = "skills/tame_sw_ac.png";
		this.m.SoundOnUse = ["sounds/dice_01.wav", "sounds/dice_02.wav", "sounds/dice_03.wav"];
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		return ret;
	}

	function isHidden()
	{
		local acc = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

		if (acc == null)
		{
			return false;
		}

		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		return true;
	}

	function onUpdate(_properties)
	{
		this.m.IsHidden = this.isHidden();
	}

	function getHitchance(_targetEntity)
	{
		local tameDefault = this.Const.Companions.TameChance.Default / 10.0;
		local tameBeastmaster = this.Const.Companions.TameChance.Beastmaster / 10.0;
		local chance = this.getContainer().getActor().getSkills().hasSkill("background.companions_beastmaster") ? (1.0 - _targetEntity.getHitpointsPct()) * tameBeastmaster : (1.0 - _targetEntity.getHitpointsPct()) * tameDefault;

		if (_targetEntity.getCurrentProperties().IsRooted)
		{
			chance *= 1.25;
		}

		return chance;
	}

	function hasMaxTamed(type)
	{
		local matchNum = 0;
		local size = this.Tactical.getMapSize();
		for( local x = 0; x < size.X; x = ++x )
		{
			for( local y = 0; y < size.Y; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				if (tile.IsContainingItems)
				{
					foreach( item in tile.Items )
					{
						if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
						{
							if (type == this.Const.Companions.TypeList.Unhold || type == this.Const.Companions.TypeList.UnholdArmor)
							{
								if (item.getType() == this.Const.Companions.TypeList.Unhold || item.getType() == this.Const.Companions.TypeList.UnholdArmor)
									++matchNum;
							}
							else
							{
								if (item.getType() == type)
									++matchNum;
							}
						}
					}
				}
			}
		}

		local stash = this.World.Assets.getStash().getItems();
		foreach(item in stash)
		{
			if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
			{
				if (type == this.Const.Companions.TypeList.Unhold || type == this.Const.Companions.TypeList.UnholdArmor)
				{
					if (item.getType() == this.Const.Companions.TypeList.Unhold || item.getType() == this.Const.Companions.TypeList.UnholdArmor)
						++matchNum;
				}
				else
				{
					if (item.getType() == type)
						++matchNum;
				}
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		foreach(bro in brothers)
		{
			local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
			if (acc != null && "setType" in acc)
			{
				if (type == this.Const.Companions.TypeList.Unhold || type == this.Const.Companions.TypeList.UnholdArmor)
				{
					if (acc.getType() == this.Const.Companions.TypeList.Unhold || acc.getType() == this.Const.Companions.TypeList.UnholdArmor)
						++matchNum;
				}
				else
				{
					if (acc.getType() == type)
						++matchNum;
				}
			}
		}

		if (matchNum >= this.Const.Companions.Library[type].MaxPerCompany)
		{
			return true;
		}

		return false;
	}

	function onVerifyTarget(_originTile, _targetTile)
	{
		if (_targetTile.IsEmpty)
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (target == null)
		{
			return false;
		}
		if (!target.isAlive())
		{
			return false;
		}
		if (target.getFlags().has("taming_protection"))
		{
			return false;
		}
		if (this.isKindOf(target, "lindwurm_tail"))
		{
			return false;
		}

		local actor = this.getContainer().getActor();

		if (actor.isAlliedWith(target))
		{
			return false;
		}

		local type = this.Const.Companions.getType(target);

		if (type == null)
		{
			return false;
		}
		if (type != null && hasMaxTamed(type))
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile);
	}

	function onUse(_user, _targetTile)
	{
		local tameDefault = this.Const.Companions.TameChance.Default;
		local tameBeastmaster = this.Const.Companions.TameChance.Beastmaster;
		local actor = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		local chance = actor.getSkills().hasSkill("background.companions_beastmaster") ? (1.0 - target.getHitpointsPct()) * tameBeastmaster : (1.0 - target.getHitpointsPct()) * tameDefault;

		if (target.getCurrentProperties().IsRooted)
		{
			chance *= 1.25;
		}

		if (this.Math.rand(1, 1000) <= chance)
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + " successfully tamed " + this.Const.UI.getColorizedEntityName(target));
			local loot = this.new("scripts/items/accessory/wardog_item");
			loot.setType(this.Const.Companions.getType(target));
			local ET = _targetTile.getEntity().m.Type;
			local ETC = this.Const.EntityType;

			if (ET == ETC.Unhold)
			{
				loot.setVariant(2);
			}
			else if (ET == ETC.UnholdFrost)
			{
				loot.setVariant(1);
			}
			else if (ET == ETC.UnholdBog)
			{
				loot.setVariant(3);
			}
			else if (ET == ETC.BarbarianUnhold)
			{
				loot.setVariant(4);
			}
			else if (ET == ETC.BarbarianUnholdFrost)
			{
				loot.setVariant(5);
			}

			loot.m.Wounds = this.Math.floor((1.0 - target.getHitpointsPct()) * 100.0);
			loot.updateCompanion();
			actor.getItems().equip(loot);

			local unleash = this.getContainer().getActor().getSkills().getSkillByID("actives.unleash_companion");
			if (unleash != null)
			{
				unleash.m.IsUsed = true;
				unleash.m.IsHidden = unleash.isUsed();
			}

			if (target.m.WorldTroop != null && ("Party" in target.m.WorldTroop) && target.m.WorldTroop.Party != null && !target.m.WorldTroop.Party.isNull())
			{
				target.m.WorldTroop.Party.removeTroop(target.m.WorldTroop);
			}

			if (this.isKindOf(target, "lindwurm") && target.m.Tail != null && !target.m.Tail.isNull() && target.m.Tail.isAlive())
			{
//				target.m.Tail.m.IsTurnDone = true;
				target.m.Tail.m.IsDying = true;
				target.m.Tail.m.IsAlive = false;
				target.m.Tail.removeFromMap();
				target.m.Tail = null;
			}

//			target.m.IsTurnDone = true;
			target.m.IsDying = true;
			target.m.IsAlive = false;
			target.removeFromMap();
//			target.die();
		}
		else
		{
			this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(actor) + " failed to tame " + this.Const.UI.getColorizedEntityName(target));
			this.spawnIcon("status_effect_111", _targetTile);
			target.getFlags().add("taming_protection");
			target.m.Skills.add(this.new("scripts/companions/player/companions_taming_protection"));
		}

		this.m.IsHidden = this.isHidden();
		return true;
	}
});
