this.companions_taming_protection <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "special.taming_protection";
		this.m.Name = "Taming Protection";
		this.m.Description = "Cannot be tamed.";
		this.m.Icon = "skills/status_effect_111.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onCombatFinished()
	{
		local entities = this.Tactical.Entities.getAllInstances();
		foreach(ent in entities)
		{
			foreach(e in ent)
			{
				if (e.getFlags().has("taming_protection"))
				{
					e.getFlags().remove("taming_protection");
				}
			}
		}

		this.removeSelf();
	}
});
