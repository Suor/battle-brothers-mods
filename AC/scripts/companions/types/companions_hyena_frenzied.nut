this.companions_hyena_frenzied <- this.inherit("scripts/companions/types/companions_hyena", {
	m = {},
	function create()
	{
		this.companions_hyena.create();
		this.m.IsHigh = true;
	}

	function onInit()
	{
		this.companions_hyena.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.FrenziedHyena);
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		b.DamageTotalMult = 1.25;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local body = this.getSprite("body");
		body.setBrush("bust_hyena_0" + this.Math.rand(4, 6));
		local head = this.getSprite("head");
		head.setBrush("bust_hyena_0" + this.Math.rand(4, 6) + "_head");
	}
});
