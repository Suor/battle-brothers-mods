this.companions_wardog_agent <- this.inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = this.Const.AI.Agent.ID.Wardog;
		this.m.Properties.TargetPriorityHitchanceMult = 0.25;
		this.m.Properties.TargetPriorityHitpointsMult = 0.25;
		this.m.Properties.TargetPriorityDamageMult = 0.25;
		this.m.Properties.TargetPriorityRandomMult = 0.25;
		this.m.Properties.TargetPriorityFleeingMult = 1.5;
		this.m.Properties.TargetPriorityHittingAlliesMult = 0.5;
		this.m.Properties.TargetPriorityCounterSkillsMult = 1.0;
		this.m.Properties.OverallDefensivenessMult = 0.0;
		this.m.Properties.OverallFormationMult = 0.0;
		this.m.Properties.OverallMagnetismMult = 0.0;
		this.m.Properties.EngageWhenAlreadyEngagedMult = 0.0;
		this.m.Properties.EngageFlankingMult = 2.0;
		this.m.Properties.EngageTargetMultipleOpponentsMult = 0.0;
		this.m.Properties.EngageOnGoodTerrainBonusMult = 0.0;
		this.m.Properties.EngageOnBadTerrainPenaltyMult = 0.0;
		this.m.Properties.EngageAgainstSpearwallMult = 0.0;
		this.m.Properties.EngageAgainstSpearwallWithShieldwallMult = 0.0;
		this.m.Properties.EngageTargetArmedWithRangedWeaponMult = 1.25;
		this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 1.5;
		this.m.Properties.EngageLockDownTargetMult = 1.5;
		this.m.Properties.PreferCarefulEngage = false;
		this.m.Properties.PreferWait = false;
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_melee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_flee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
	}

	function onUpdate()
	{
		this.getStrategy().compileKnownOpponents();
	}

	function addQuirkBehaviors()
	{
		if (this.m.Actor.getSkills().hasSkill("perk.adrenaline") && this.getBehavior(this.Const.AI.Behavior.ID.Adrenaline) == null)
		{
			this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_adrenaline"));
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Adrenaline] = 0.25;
		}
		if (this.m.Actor.getSkills().hasSkill("perk.recover") && this.getBehavior(this.Const.AI.Behavior.ID.Recover) == null)
		{
			this.addBehavior(this.new("scripts/companions/behaviors/companions_recover"));
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Recover] = 0.25;
		}
		if (this.m.Actor.getSkills().hasSkill("perk.rotation") && this.getBehavior(this.Const.AI.Behavior.ID.Rotation) == null)
		{
			this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Rotation] = 0.25;
		}
		if (this.m.Actor.getSkills().hasSkill("perk.rally_the_troops") && this.getBehavior(this.Const.AI.Behavior.ID.Rally) == null)
		{
			this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rally"));
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Rally] = 0.25;
		}
		if (this.m.Actor.getSkills().hasSkill("perk.footwork") && this.getBehavior(this.Const.AI.Behavior.ID.Disengage) == null)
		{
			this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Disengage] = 0.25;
		}
		if (this.m.Actor.getSkills().hasSkill("perk.indomitable") && this.getBehavior(this.Const.AI.Behavior.ID.Indomitable) == null)
		{
			this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_indomitable"));
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Indomitable] = 0.25;
		}
		if (this.m.Actor.getSkills().hasSkill("actives.throw_dirt") && this.getBehavior(this.Const.AI.Behavior.ID.Distract) == null)
		{
			this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_distract"));
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Distract] = 0.25;
		}
	}
});
