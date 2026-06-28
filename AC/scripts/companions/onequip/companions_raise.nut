this.companions_raise <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null,
		UseCount = 0
	},
	function create()
	{
		this.m.ID = "actives.raise_companion";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.BeforeLast + 100;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
	}

	function getItem()
	{
		return this.m.Item;
	}

	function setItem(_i)
	{
		if (typeof _i == "instance")
		{
			this.m.Item = _i;
		}
		else
		{
			this.m.Item = this.WeakTableRef(_i);
		}
	}

	function applyCompanionModification()
	{
		if (this.m.Item == null || this.m.Item.isNull())
			return;

		this.m.Name = "Reanimate Dead";
		this.m.Description = "Reanimate the dead and have them engage the enemy. Requires a resurrectable corpse on an empty tile. Can be used twice per battle."
		this.m.Icon = this.Const.Companions.Library[this.m.Item.m.Type].Unleash.Icon(this.m.Item.m.Variant);
		this.m.IconDisabled = this.Const.Companions.Library[this.m.Item.m.Type].Unleash.IconDisabled(this.m.Item.m.Variant);
		this.m.Overlay = this.Const.Companions.Library[this.m.Item.m.Type].Unleash.Overlay;
		this.m.SoundOnUse = this.Const.Companions.Library[this.m.Item.m.Type].UnleashSounds;
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
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a max range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.MaxRange + "[/color] tiles"
			}
		];
		return ret;
	}

	function isUsable()
	{
		if (!this.skill.isUsable() || this.m.UseCount >= 2)
		{
			return false;
		}

		return true;
	}

	function onUpdate(_properties)
	{
		this.applyCompanionModification();
		this.m.IsHidden = this.m.UseCount >= 2;
	}

	function onCombatFinished()
	{
		this.m.UseCount = 0;
		this.m.Item.setEntity(null);
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		local distance = _targetTile.getDistanceTo(this.getContainer().getActor().getTile());
		local range = this.Math.min(this.m.MaxRange, this.getContainer().getActor().getCurrentProperties().getVision());

		if (distance > range)
		{
			return false;
		}
		if (!_targetTile.IsCorpseSpawned)
		{
			return false;
		}
		if (!_targetTile.Properties.get("Corpse").IsResurrectable)
		{
			return false;
		}
		if (_targetTile.Properties.get("Corpse").Type == "scripts/entity/tactical/enemies/zombie_betrayer")
		{
			return false;
		}
		if (_targetTile.Properties.get("Corpse").Type == "scripts/entity/tactical/enemies/skeleton_lich" || _targetTile.Properties.get("Corpse").Type == "scripts/entity/tactical/enemies/skeleton_boss")
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function spawnUndead(_user, _tile)
	{
		local p = _tile.Properties.get("Corpse");
		p.Faction = this.Const.Faction.PlayerAnimals;
		local e = this.Tactical.Entities.onResurrect(p, true);

		if (e != null)
		{
			e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
			e.setFaction(this.Const.Faction.PlayerAnimals);

			local currentOffhand = e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			if (currentOffhand != null) e.getItems().unequip(currentOffhand);
			local currentMainhand = e.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (currentMainhand != null) e.getItems().unequip(currentMainhand);

			local propertiesNew =
			{
				ActionPoints = e.m.BaseProperties.ActionPoints,
				Hitpoints = e.m.BaseProperties.Hitpoints + this.m.Item.m.Attributes.Hitpoints,
				Stamina = e.m.BaseProperties.Stamina + this.m.Item.m.Attributes.Stamina,
				Bravery = e.m.BaseProperties.Bravery + this.m.Item.m.Attributes.Bravery,
				Initiative = e.m.BaseProperties.Initiative + this.m.Item.m.Attributes.Initiative,
				MeleeSkill = e.m.BaseProperties.MeleeSkill + this.m.Item.m.Attributes.MeleeSkill,
				RangedSkill = e.m.BaseProperties.RangedSkill + this.m.Item.m.Attributes.RangedSkill,
				MeleeDefense = e.m.BaseProperties.MeleeDefense + this.m.Item.m.Attributes.MeleeDefense,
				RangedDefense = e.m.BaseProperties.RangedDefense + this.m.Item.m.Attributes.RangedDefense,
				Armor = [e.m.BaseProperties.Armor[0], e.m.BaseProperties.Armor[1]],
				FatigueEffectMult = e.m.BaseProperties.FatigueEffectMult,
				MoraleEffectMult = e.m.BaseProperties.MoraleEffectMult,
				FatigueRecoveryRate = e.m.BaseProperties.FatigueRecoveryRate
			};
			local propertiesBase = e.m.BaseProperties;
			propertiesBase.setValues(propertiesNew);
			e.m.CurrentProperties = propertiesBase;
			e.m.Hitpoints = propertiesBase.Hitpoints;

			if (currentOffhand != null) e.getItems().equip(currentOffhand);
			if (currentMainhand != null) e.getItems().equip(currentMainhand);

			if (this.m.Item.m.Quirks.len() != 0)
			{
				foreach(i, quirk in this.m.Item.m.Quirks)
				{
					local getQuirk = this.new(quirk);
					local hasQuirk = e.getSkills().getSkillByID(getQuirk.m.ID);
					if (hasQuirk == null && getQuirk.m.ID != "quirk.good_boy") e.m.Skills.add(this.new(quirk));
				}
			}

			if (e.getFlags().has("zombie_minion"))
			{
				e.m.AIAgent = this.new("scripts/ai/tactical/agents/zombie_agent");
			}
			else if (e.getFlags().has("skeleton"))
			{
				if (e.m.Type == this.Const.EntityType.SkeletonPriest)
				{
					e.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_priest_agent");
				}
				else
				{
					e.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_melee_agent");
				}
			}
			e.m.AIAgent.setActor(e);

			if (e.m.AIAgent.m.Actor.getSkills().hasSkill("perk.adrenaline") && e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.Adrenaline) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_adrenaline"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Adrenaline] = 0.25;
			}
			if (e.m.AIAgent.m.Actor.getSkills().hasSkill("perk.recover") && e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.Recover) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/companions/behaviors/companions_recover"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Recover] = 0.25;
			}
			if (e.m.AIAgent.m.Actor.getSkills().hasSkill("perk.rotation") && e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.Rotation) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Rotation] = 0.25;
			}
			if (e.m.AIAgent.m.Actor.getSkills().hasSkill("perk.rally_the_troops") && e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.Rally) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rally"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Rally] = 0.25;
			}
			if (e.m.AIAgent.m.Actor.getSkills().hasSkill("perk.footwork") && e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.Disengage) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Disengage] = 0.25;
			}
			if (e.m.AIAgent.m.Actor.getSkills().hasSkill("perk.indomitable") && e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.Indomitable) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_indomitable"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Indomitable] = 0.25;
			}
			if (e.m.AIAgent.m.Actor.getSkills().hasSkill("actives.throw_dirt") && e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.Distract) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_distract"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Distract] = 0.25;
			}
			if (e.m.AIAgent.getBehavior(this.Const.AI.Behavior.ID.PickupWeapon) == null)
			{
				e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_pickup_weapon"));
				e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.PickupWeapon] = 0.25;
			}

			this.Tactical.TurnSequenceBar.removeEntity(e);
			e.m.IsTurnDone = false;
			e.m.IsActingImmediately = true;
			this.Tactical.TurnSequenceBar.insertEntity(e);
		}
	}

	function onUse( _user, _targetTile )
	{
		if (_targetTile.IsVisibleForPlayer)
		{
			if (this.Const.Tactical.RaiseUndeadParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
				}
			}

			if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " reanimates the dead");
			}
		}

		this.spawnUndead(_user, _targetTile);
		this.m.UseCount += 1;
		this.m.IsHidden = this.m.UseCount >= 2;
		return true;
	}
});
