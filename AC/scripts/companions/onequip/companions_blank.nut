this.companions_blank <- this.inherit("scripts/skills/skill", {
	m = {
		Item = null
	},
	function create()
	{
		this.m.ID = "passives.blank_blank";
		this.m.Icon = "";
		this.m.Type = this.Const.SkillType.Passive;
		this.m.Order = this.Const.SkillOrder.BeforeLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
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
	}
});
