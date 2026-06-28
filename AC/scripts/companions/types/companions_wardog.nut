this.companions_wardog <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Item = null,
		Name = "Wardog"
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Wardog;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Wardog.XP;
		this.m.IsActingImmediately = true;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-4, -25);
		this.m.DecapitateBloodAmount = 0.5;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/wardog_hurt_00.wav",
			"sounds/enemies/wardog_hurt_01.wav",
			"sounds/enemies/wardog_hurt_02.wav",
			"sounds/enemies/wardog_hurt_03.wav",
			"sounds/enemies/wardog_hurt_04.wav",
			"sounds/enemies/wardog_hurt_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/wardog_death_00.wav",
			"sounds/enemies/wardog_death_01.wav",
			"sounds/enemies/wardog_death_02.wav",
			"sounds/enemies/wardog_death_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/wardog_flee_00.wav",
			"sounds/enemies/wardog_flee_01.wav",
			"sounds/enemies/wardog_flee_02.wav",
			"sounds/enemies/wardog_flee_03.wav",
			"sounds/enemies/wardog_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/wardog_idle_01.wav",
			"sounds/enemies/wardog_idle_02.wav",
			"sounds/enemies/wardog_idle_03.wav",
			"sounds/enemies/wardog_idle_04.wav",
			"sounds/enemies/wardog_idle_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/wardog_charge_00.wav",
			"sounds/enemies/wardog_charge_01.wav",
			"sounds/enemies/wardog_charge_02.wav"
		];
		this.m.AIAgent = this.new("scripts/companions/types/companions_wardog_agent");
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
		this.m.Items.getAppearance().Body = "bust_dog_01_body_0" + _v;
		this.getSprite("body").setBrush("bust_dog_01_body_0" + _v);
		this.getSprite("head").setBrush("bust_dog_01_head_0" + _v);
		this.setDirty(true);
	}

	function onDeath(_killer, _skill, _tile, _fatalityType)
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local appearance = this.getItems().getAppearance();
			local decal;
			this.m.IsCorpseFlipped = flip;
			decal = _tile.spawnDetail(this.getSprite("body").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.setBrightness(0.9);
			decal.Scale = 0.95;

			if (appearance.CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;
			}

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail(this.getSprite("head").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.setBrightness(0.9);
				decal.Scale = 0.95;
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					this.getSprite("head").getBrush().Name + "_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-15, 5), 0.0, this.getSprite("head").getBrush().Name + "_dead_bloodpool");
				decap[0].setBrightness(0.9);
				decap[0].Scale = 0.95;
				decap[0].setHorizontalFlipping(true);
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				_tile.spawnDetail(this.getSprite("body").getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				_tile.spawnDetail(this.getSprite("body").getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			corpse.IsResurrectable = false;
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
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("closed_eyes").setHorizontalFlipping(flip);

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
		b.setValues(this.Const.Tactical.Actor.Wardog);
		b.TargetAttractionMult = 0.1;
		b.IsAffectedByInjuries = false;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local variant = this.Math.rand(1, 4);
		this.m.Items.getAppearance().Body = "bust_dog_01_body_0" + variant;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_dog_01_body_0" + variant);
		local armor = this.addSprite("armor");
		this.addSprite("head").setBrush("bust_dog_01_head_0" + variant);
		local closed_eyes = this.addSprite("closed_eyes");
		closed_eyes.setBrush("bust_dog_01_body_0" + variant + "_eyes_closed");
		closed_eyes.Visible = false;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_dog_01_injured");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.46;
		this.setSpriteOffset("status_rooted", this.createVec(8, -15));
		this.setSpriteOffset("status_stunned", this.createVec(0, -25));
		this.setSpriteOffset("arrow", this.createVec(0, -25));
		this.m.Skills.add(this.new("scripts/skills/actives/wardog_bite"));
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 12,
			Hitpoints = this.m.Item.m.Attributes.Hitpoints,
			Stamina = this.m.Item.m.Attributes.Stamina,
			Bravery = this.m.Item.m.Attributes.Bravery,
			Initiative = this.m.Item.m.Attributes.Initiative,
			MeleeSkill = this.m.Item.m.Attributes.MeleeSkill,
			RangedSkill = this.m.Item.m.Attributes.RangedSkill,
			MeleeDefense = this.m.Item.m.Attributes.MeleeDefense,
			RangedDefense = this.m.Item.m.Attributes.RangedDefense,
			Armor = [0, 0],
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
