this.companions_unleash <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null,
		IsUsed = false
	},
	function create()
	{
		this.m.ID = "actives.unleash_companion";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.BeforeLast + 100;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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

		this.m.Name = "Unleash " + this.m.Item.m.Name;
		this.m.Description = "Unleash " + this.m.Item.m.Name + " and have them engage the enemy. Needs a free adjacent tile. Can be used once per battle."
		if (this.m.Item.m.Type == this.Const.Companions.TypeList.Noodle) this.m.Description = "Unleash " + this.m.Item.m.Name + " and have them engage the enemy. Needs a free adjacent tile (and a free adjacent tile next to that one, for the tail). Can be used once per battle."
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
			}
		];
		return ret;
	}

	function isUsed()
	{
		return this.m.IsUsed;
	}

	function isUsable()
	{
		if (this.m.Item.isUnleashed() || !this.skill.isUsable() || this.m.Item.getScript() == null || this.m.IsUsed == true)
		{
			return false;
		}

		return true;
	}

	function onUpdate(_properties)
	{
		this.applyCompanionModification();
		this.m.IsHidden = this.isUsed();
	}

	function onCombatFinished()
	{
		this.m.IsUsed = false;
	}

	function findTailTile(_targetTile)
	{
		local myTile = _targetTile;

		if (myTile.hasNextTile(this.Const.Direction.NE) && myTile.getNextTile(this.Const.Direction.NE).IsEmpty)
		{
			return true;
		}
		else if (myTile.hasNextTile(this.Const.Direction.SE) && myTile.getNextTile(this.Const.Direction.SE).IsEmpty)
		{
			return true;
		}
		else if (myTile.hasNextTile(this.Const.Direction.N) && myTile.getNextTile(this.Const.Direction.N).IsEmpty)
		{
			return true;
		}
		else if (myTile.hasNextTile(this.Const.Direction.S) && myTile.getNextTile(this.Const.Direction.S).IsEmpty)
		{
			return true;
		}
		else if (myTile.hasNextTile(this.Const.Direction.NW) && myTile.getNextTile(this.Const.Direction.NW).IsEmpty)
		{
			return true;
		}
		else if (myTile.hasNextTile(this.Const.Direction.SW) && myTile.getNextTile(this.Const.Direction.SW).IsEmpty)
		{
			return true;
		}

		return false;
	}

	function onVerifyTarget(_originTile, _targetTile)
	{
		if (this.m.Item.m.Type == this.Const.Companions.TypeList.Noodle && !this.findTailTile(_targetTile))
		{
			return false;
		}

		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse(_user, _targetTile)
	{
		local entity = this.Tactical.spawnEntity(this.m.Item.getScript(), _targetTile.Coords.X, _targetTile.Coords.Y);
		entity.setItem(this.m.Item);
		entity.setName(this.m.Item.getName());
		entity.setVariant(this.m.Item.getVariant());
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.applyCompanionScaling();
		this.m.Item.setEntity(entity);

		if (this.m.Item.getArmorScript() != null)
		{
			local item = this.new(this.m.Item.getArmorScript());
			entity.getItems().equip(item);
		}

		if (this.getContainer().hasSkill("background.houndmaster") || this.getContainer().hasSkill("background.companions_beastmaster"))
		{
			entity.setMoraleState(this.Const.MoraleState.Confident);
		}

		if (!this.World.getTime().IsDaytime)
		{
			entity.getSkills().add(this.new("scripts/skills/special/night_effect"));
		}

		local healthPercentage = (100.0 - this.m.Item.m.Wounds) / 100.0;
		entity.setHitpoints(this.Math.max(1, this.Math.floor(healthPercentage * entity.m.Hitpoints)));
		entity.setDirty(true);

		this.m.IsUsed = true;
		this.m.IsHidden = this.isUsed();
		local leash = this.getContainer().getActor().getSkills().getSkillByID("actives.leash_companion");
		if (leash != null) leash.m.IsHidden = !this.m.Item.isUnleashed();
		return true;
	}
});
