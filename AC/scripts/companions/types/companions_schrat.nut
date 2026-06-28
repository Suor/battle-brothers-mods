this.companions_schrat <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Item = null,
		Name = "Schrat"
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Schrat;
		this.m.BloodType = this.Const.BloodType.Wood;
		this.m.XP = this.Const.Tactical.Actor.Schrat.XP;
		this.m.IsActingImmediately = false;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/schrat_shield_damage_01.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_02.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_03.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_04.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/schrat_hurt_shield_down_01.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_02.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_03.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_04.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_05.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_down_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/dlc2/schrat_hurt_shield_up_01.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_02.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_03.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_04.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_05.wav",
			"sounds/enemies/dlc2/schrat_hurt_shield_up_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/schrat_death_01.wav",
			"sounds/enemies/dlc2/schrat_death_02.wav",
			"sounds/enemies/dlc2/schrat_death_03.wav",
			"sounds/enemies/dlc2/schrat_death_04.wav",
			"sounds/enemies/dlc2/schrat_death_05.wav",
			"sounds/enemies/dlc2/schrat_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/schrat_idle_01.wav",
			"sounds/enemies/dlc2/schrat_idle_02.wav",
			"sounds/enemies/dlc2/schrat_idle_03.wav",
			"sounds/enemies/dlc2/schrat_idle_04.wav",
			"sounds/enemies/dlc2/schrat_idle_05.wav",
			"sounds/enemies/dlc2/schrat_idle_06.wav",
			"sounds/enemies/dlc2/schrat_idle_07.wav",
			"sounds/enemies/dlc2/schrat_idle_08.wav",
			"sounds/enemies/dlc2/schrat_idle_09.wav",
			"sounds/ambience/terrain/forest_branch_crack_00.wav",
			"sounds/ambience/terrain/forest_branch_crack_01.wav",
			"sounds/ambience/terrain/forest_branch_crack_02.wav",
			"sounds/ambience/terrain/forest_branch_crack_03.wav",
			"sounds/ambience/terrain/forest_branch_crack_04.wav",
			"sounds/ambience/terrain/forest_branch_crack_05.wav"
		];
		this.m.AIAgent = this.new("scripts/companions/types/companions_schrat_agent");
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
		this.getSprite("body").setBrush("bust_schrat_body_01");
		this.getSprite("head").setBrush("bust_schrat_head_0" + _v);
		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			decal = _tile.spawnDetail("bust_schrat_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			decal = _tile.spawnDetail(head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = head.Color;
			decal.Saturation = head.Saturation;
			decal.Scale = 0.95;

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_schrat_body_01_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_schrat_body_01_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}

			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = "A Schrat";
			corpse.IsHeadAttached = true;
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
		this.getSprite("head").setHorizontalFlipping(flip);

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
		b.setValues(this.Const.Tactical.Actor.Schrat);
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsIgnoringArmorOnAttack = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_player");
		local body = this.addSprite("body");
		body.setBrush("bust_schrat_body_01");
		body.varySaturation(0.2);
		body.varyColor(0.05, 0.05, 0.05);
		this.m.BloodColor = body.Color;
		local head = this.addSprite("head");
		head.setBrush("bust_schrat_head_0" + this.Math.rand(1, 2));
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_schrat_01_injured");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, -0));
		this.setSpriteOffset("status_stunned", this.createVec(0, -0));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
		this.m.Skills.add(this.new("scripts/skills/racial/schrat_racial"));
		this.m.Skills.add(this.new("scripts/skills/actives/grow_shield_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/uproot_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/uproot_zoc_skill"));
		this.m.Items.equip(this.new("scripts/items/shields/beasts/schrat_shield"));
	}

	function applyCompanionScaling()
	{
		local propertiesNew =
		{
			ActionPoints = 7,
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
			FatigueRecoveryRate = 25
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
