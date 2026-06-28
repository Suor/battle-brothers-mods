this.companions_snake <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Variant = 1,
		Item = null,
		Name = "Serpent"
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Serpent;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.IsActingImmediately = true;
		this.m.XP = this.Const.Tactical.Actor.Serpent.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 5);
		this.m.DecapitateSplatterOffset = this.createVec(15, -26);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.ExcludedInjuries = [
			"injury.fractured_hand",
			"injury.crushed_finger",
			"injury.fractured_elbow",
			"injury.sprained_ankle",
			"injury.bruised_leg",
			"injury.smashed_hand",
			"injury.broken_arm",
			"injury.broken_leg",
			"injury.cut_arm_sinew",
			"injury.cut_arm",
			"injury.cut_achilles_tendon",
			"injury.split_hand",
			"injury.injured_shoulder",
			"injury.pierced_hand",
			"injury.pierced_arm_muscles",
			"injury.injured_knee_cap",
			"injury.burnt_legs",
			"injury.burnt_hands"
		];
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc6/snake_hurt_01.wav",
			"sounds/enemies/dlc6/snake_hurt_02.wav",
			"sounds/enemies/dlc6/snake_hurt_03.wav",
			"sounds/enemies/dlc6/snake_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc6/snake_death_01.wav",
			"sounds/enemies/dlc6/snake_death_02.wav",
			"sounds/enemies/dlc6/snake_death_03.wav",
			"sounds/enemies/dlc6/snake_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc6/snake_idle_01.wav",
			"sounds/enemies/dlc6/snake_idle_02.wav",
			"sounds/enemies/dlc6/snake_idle_03.wav",
			"sounds/enemies/dlc6/snake_idle_04.wav",
			"sounds/enemies/dlc6/snake_idle_05.wav",
			"sounds/enemies/dlc6/snake_idle_06.wav",
			"sounds/enemies/dlc6/snake_idle_07.wav",
			"sounds/enemies/dlc6/snake_idle_08.wav",
			"sounds/enemies/dlc6/snake_idle_09.wav",
			"sounds/enemies/dlc6/snake_idle_10.wav",
			"sounds/enemies/dlc6/snake_idle_11.wav",
			"sounds/enemies/dlc6/snake_idle_12.wav",
			"sounds/enemies/dlc6/snake_idle_13.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.7;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.AIAgent = this.new("scripts/companions/types/companions_snake_agent");
		this.m.AIAgent.setActor(this);
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

	function setName(_n)
	{
		this.m.Name = _n;
	}

	function getName()
	{
		return this.m.Name;
	}

	function setVariant(_v)
	{
		if (_v == 1)
		{
			this.getSprite("body").setBrush("bust_snake_01_head_01");
		}
		else if (_v == 2)
		{
			this.getSprite("body").setBrush("bust_snake_01_head_02");
		}
		else if (_v == 3)
		{
			this.getSprite("body").setBrush("bust_snake_02_head_01");
		}
		else if (_v == 4)
		{
			this.getSprite("body").setBrush("bust_snake_02_head_02");
		}

		this.setDirty(true);
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 33)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			local body_decal;
			local head_decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			decal = _tile.spawnDetail("bust_snake_body_0" + this.m.Variant + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.9;
			body_decal = decal;

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail("bust_snake_body_0" + this.m.Variant + "_head_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = body.Color;
				decal.Saturation = body.Saturation;
				decal.Scale = 0.9;
				head_decal = decal;
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					"bust_snake_body_0" + this.m.Variant + "_head_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-50, 20), 0.0, "bust_snake_body_head_dead_bloodpool");
				decap[0].Color = body.Color;
				decap[0].Saturation = body.Saturation;
				decap[0].Scale = 0.9;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "A Serpent";
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			corpse.IsConsumable = false;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.setEntity(null);

			if (this.m.Item.getContainer() != null)
			{
				if (this.m.Item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
				{
					this.m.Item.getContainer().removeFromBag(this.m.Item.get());
				}
				else
				{
					this.m.Item.getContainer().unequip(this.m.Item.get());
				}
			}

			this.m.Item = null;
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);

		if (!this.Tactical.State.isScenarioMode())
		{
			local f = this.World.FactionManager.getFaction(this.getFaction());

			if (f != null)
			{
				this.getSprite("socket").setBrush(f.getTacticalBase());
			}
		}
		else
		{
			this.getSprite("socket").setBrush(this.Const.FactionBase[this.getFaction()]);
		}
	}

	function onActorKilled(_actor, _tile, _skill)
	{
		this.actor.onActorKilled(_actor, _tile, _skill);

		if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local XPgroup = _actor.getXPValue();
			local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

			foreach( bro in brothers )
			{
				bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));

				local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (acc != null && "setType" in acc)
				{
					if (acc.getType() != null)
						acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
				}
			}
		}
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Serpent);
		b.Initiative += this.Math.rand(0, 50);
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		this.m.Variant = this.Math.rand(1, 2);
		body.setBrush("bust_snake_0" + this.m.Variant + "_head_0" + this.Math.rand(1, 2));

		if (this.m.Variant == 2 && this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.1);
		}
		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.1, 0.1, 0.1);
		}
		if (this.Math.rand(0, 100) < 90)
		{
			body.varyBrightness(0.1);
		}

		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_snake_injury");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 20));
		this.setSpriteOffset("status_stunned", this.createVec(-35, 20));
		this.setSpriteOffset("arrow", this.createVec(0, 20));
		this.m.Skills.add(this.new("scripts/skills/racial/serpent_racial"));
		this.m.Skills.add(this.new("scripts/skills/actives/serpent_hook_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/serpent_bite_skill"));
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 9,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative + this.Math.rand(0, 50),
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [40, 40],
			FatigueEffectMult = 1.0,
			MoraleEffectMult = 1.0,
			FatigueRecoveryRate = 15
		};
		local propertiesBase = this.m.BaseProperties;
		propertiesBase.setValues(propertiesNew);
		this.m.CurrentProperties = propertiesBase;
		this.m.Hitpoints = propertiesBase.Hitpoints;


		foreach(quirk in this.m.Item.m.Quirks)
		{
			this.m.Skills.add(this.new(quirk));
		}
		this.m.AIAgent.addQuirkBehaviors();
	}
});
