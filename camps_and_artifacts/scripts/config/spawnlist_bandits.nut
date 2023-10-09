local gt = this.getroottable();

if (!("World" in gt.Const))
{
	gt.Const.World <- {};
}

if (!("Spawn" in gt.Const.World))
{
	gt.Const.World.Spawn <- {};
}

gt.Const.World.Spawn.BanditRoamers <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 3
			}
		]
	}
];
gt.Const.World.Spawn.BanditScouts <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.Wardog,
				Num = 2
			}
		]
	}
];
gt.Const.World.Spawn.BanditRaiders <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 11
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	}
];
gt.Const.World.Spawn.BanditDefenders <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_bandit_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	}
];
gt.Const.World.Spawn.BanditBoss <- [
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditThug,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	}
];
gt.Const.World.Spawn.BanditCEO <- [
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.MercenaryRanged,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.Mercenary,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 30
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 20
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 35
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 25
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 40
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 30
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 10
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 12
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 18
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 24
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.HedgeKnight,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.Swordmaster,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 14
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 18
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 13
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaider,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditMarksman,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.MasterArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.BanditLeader,
				Num = 3
			}
		]
	}
];
gt.Const.World.Spawn.BanditsDisguisedAsDirewolves <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 9
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 10
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 11
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 12
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 13
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 14
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 15
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 16
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 17
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 18
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_werewolf_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.BanditRaiderWolf,
				Num = 19
			}
		]
	}
];
function onCostCompare( _t1, _t2 )
{
	if (_t1.Cost < _t2.Cost)
	{
		return -1;
	}
	else if (_t1.Cost > _t2.Cost)
	{
		return 1;
	}

	return 0;
}

function calculateCosts( _p )
{
	foreach( p in _p )
	{
		p.Cost <- 0;

		foreach( t in p.Troops )
		{
			p.Cost += t.Type.Cost * t.Num;
		}

		if (!("MovementSpeedMult" in p))
		{
			p.MovementSpeedMult <- 1.0;
		}
	}

	_p.sort(this.onCostCompare);
}

this.calculateCosts(this.Const.World.Spawn.BanditRoamers);
this.calculateCosts(this.Const.World.Spawn.BanditScouts);
this.calculateCosts(this.Const.World.Spawn.BanditRaiders);
this.calculateCosts(this.Const.World.Spawn.BanditDefenders);
this.calculateCosts(this.Const.World.Spawn.BanditBoss);
this.calculateCosts(this.Const.World.Spawn.BanditCEO);
this.calculateCosts(this.Const.World.Spawn.BanditsDisguisedAsDirewolves);

