this.artifact_shield <- this.inherit("scripts/items/shields/shield", {
	m = {
		PrefixList = this.Const.Strings.RandomShieldPrefix,
		NameList = [],
		UseRandomName = true
	},
	function create()
	{
		this.shield.create();
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Artifact;
	}

	function setName( _prefix = "" )
	{
		this.m.Name = this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
	}

	function randomizeValues()
	{
		local available = [];
		available.push(function ( _i )
		{
			_i.m.MeleeDefense = this.Math.round(_i.m.MeleeDefense * this.Math.rand(140, 160) * 0.01);
		});
		available.push(function ( _i )
		{
			_i.m.RangedDefense = this.Math.round(_i.m.RangedDefense * this.Math.rand(140, 160) * 0.01);
		});
		available.push(function ( _i )
		{
			_i.m.FatigueOnSkillUse = _i.m.FatigueOnSkillUse - this.Math.rand(2, 4);
		});
		available.push(function ( _i )
		{
			_i.m.Condition = this.Math.round(_i.m.Condition * this.Math.rand(180, 200) * 0.01) * 1.0;
			_i.m.ConditionMax = _i.m.Condition;
		});
		available.push(function ( _i )
		{
			_i.m.StaminaModifier = this.Math.round(_i.m.StaminaModifier * this.Math.rand(60, 80) * 0.01);
		});

		for( local n = 3; n != 0 && available.len() != 0; n = --n )
		{
			local r = this.Math.rand(0, available.len() - 1);
			available[r](this);
			available.remove(r);
		}
	}

	function onEquip()
	{
		this.shield.onEquip();

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

	function onSerialize( _out )
	{
		_out.writeF32(this.m.ConditionMax);
		this.shield.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeI8(this.m.StaminaModifier);
		_out.writeU16(this.m.MeleeDefense);
		_out.writeU16(this.m.RangedDefense);
		_out.writeI16(this.m.FatigueOnSkillUse);
	}

	function onDeserialize( _in )
	{
		this.m.ConditionMax = _in.readF32();
		this.shield.onDeserialize(_in);
		this.m.Name = _in.readString();
		this.m.StaminaModifier = _in.readI8();
		this.m.MeleeDefense = _in.readU16();
		this.m.RangedDefense = _in.readU16();

		if (_in.getMetaData().getVersion() >= 47)
		{
			this.m.FatigueOnSkillUse = _in.readI16();
		}
		else
		{
			this.m.FatigueOnSkillUse = 0;
		}
	}

});

