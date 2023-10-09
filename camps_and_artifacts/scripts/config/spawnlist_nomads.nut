local gt = this.getroottable();

if (!("World" in gt.Const))
{
	gt.Const.World <- {};
}

if (!("Spawn" in gt.Const.World))
{
	gt.Const.World.Spawn <- {};
}

gt.Const.World.Spawn.NomadRoamers <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			}
		]
	}
];
gt.Const.World.Spawn.NomadRaiders <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 11
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_04",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	}
];
gt.Const.World.Spawn.NomadDefenders <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 8
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_01",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 5
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_03",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 16
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	}
];
gt.Const.World.Spawn.NomadCEO <- [
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}

		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadSlinger,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}

		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		Cost = 0,
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadCutthroat,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 11
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 13
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 8
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 8
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 9
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_02",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 10
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 10
			}
		]
	},

	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 14
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 15
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 2
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 3
			},
			{
				Type =this.Const.World.Spawn.Troops.NomadArcher,
				Num = 3
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 4
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 4
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 5
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 5
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 6
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 7
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 7
			}
		]
	},

	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 12
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 6
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 1
			}
		]
	},
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 17
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 3
			}
		]
	}
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 20
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 4
			}
		]
	}
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 24
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 5
			}
		]
	}
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 30
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 6
			}
		]
	}
	{
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_nomad_05",
		Troops = [
			{
				Type = this.Const.World.Spawn.Troops.Executioner,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertDevil,
				Num = 1
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadOutlaw,
				Num = 35
			},
			{
				Type = this.Const.World.Spawn.Troops.DesertStalker,
				Num = 2
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadArcher,
				Num = 9
			},
			{
				Type = this.Const.World.Spawn.Troops.NomadLeader,
				Num = 7
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

this.calculateCosts(this.Const.World.Spawn.NomadRoamers);
this.calculateCosts(this.Const.World.Spawn.NomadRaiders);
this.calculateCosts(this.Const.World.Spawn.NomadDefenders);
this.calculateCosts(this.Const.World.Spawn.NomadCEO);

