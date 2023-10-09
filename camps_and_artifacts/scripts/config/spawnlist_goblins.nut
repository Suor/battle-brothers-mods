local gt = this.getroottable();

if (!("World" in gt.Const))
{
	gt.Const.World <- {};
}

if (!("Spawn" in gt.Const.World))
{
	gt.Const.World.Spawn <- {};
}

gt.Const.World.Spawn.GoblinRoamers <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 9
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 10
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 11
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 12
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 13
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 14
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 15
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 16
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 17
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 18
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 19
			}
		]
	}
];
gt.Const.World.Spawn.GoblinScouts <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 0.75,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	}
];
gt.Const.World.Spawn.GoblinRaiders <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 9
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 10
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 11
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 12
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Script = "scripts/entity/world/enemies/goblin_party",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 13
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 14
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 15
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 16
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 17
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 18
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	}
];
gt.Const.World.Spawn.GoblinDefenders <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 9
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 10
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 11
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisherLOW,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusherLOW,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_goblin_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	}
];
gt.Const.World.Spawn.GoblinBoss <- [
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 18
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	}
];
gt.Const.World.Spawn.GoblinCEO <- [
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 18
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 25
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 18
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 32
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 18
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 25
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},

	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinOverseer,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.GoblinShaman,
				Num = 1
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

this.calculateCosts(this.Const.World.Spawn.GoblinRoamers);
this.calculateCosts(this.Const.World.Spawn.GoblinScouts);
this.calculateCosts(this.Const.World.Spawn.GoblinRaiders);
this.calculateCosts(this.Const.World.Spawn.GoblinDefenders);
this.calculateCosts(this.Const.World.Spawn.GoblinBoss);
this.calculateCosts(this.Const.World.Spawn.GoblinCEO);

