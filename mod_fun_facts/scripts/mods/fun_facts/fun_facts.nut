this.fun_facts <- {
	m = {
		Stats = {
			Kills = []
			Injuries = []
			InjuriesDealt = []
			HitsDealt = {}
			HitsReceived = {}
			Battles = 0
			BattlesInReserve = 0
			// NineLives = 0
			// Flee = 0
		},
		// Ranks = {}
		IDCounter = 0 // TODO
		Version = 2
	},

	function onKill(_target, _fatalityType) {
		// ::FunFacts.Debug.log("onKill target", _target);
		// ::FunFacts.Debug.log("onKill fatality", _fatalityType);

		local record = {
			IsPlayer = _target.isPlayerControlled()
			Name = _target.getName()
			ClassName = _target.ClassName
			XP = _target.getXPValue()
			Fatality = _fatalityType
			Day = this.World.getTime().Days
		}
		::FunFacts.Debug.log("onKill record", record);
		this.m.Stats.Kills.push(record);
		::FunFacts.Debug.log("onKill total records", this.m.Stats.Kills.len());
	}

	function onTargetHit(_skill, _target, _bodyPart, _damageHitpoints, _damageArmor) {
	}

	function onInjury(_attacker, _injury) {
		local record = {
			Injury = _injury.m.ID.slice("injury.".len())
			AttackerClass = _attacker.ClassName
			AttackerName = _attacker.getName()
			Day = this.World.getTime().Days
		}
		::FunFacts.Debug.log("onInjury record", record);
		this.m.Stats.Injuries.push(record);
		::FunFacts.Debug.log("onInjury total records", this.m.Stats.Injuries.len());
	}

	function onInjuryDealt(_target, _injury) {
		local record = {
			Injury = _injury.m.ID.slice("injury.".len())
			TargetClass = _target.ClassName
			TargetName = _target.getName()
			Day = this.World.getTime().Days
		}
		::FunFacts.Debug.log("onInjuryDealt record", record);
		this.m.Stats.InjuriesDealt.push(record);
		::FunFacts.Debug.log("onInjuryDealt total records", this.m.Stats.InjuriesDealt.len());
	}

	function makeTooltipSegment( _icon, _rank, _text )
	{
		local rank = _rank == 0 ? "" : "#" + _rank + " ";

		return {
			id = this.m.IDCounter++,
			type = "hint",
			text = rank + _text,
			icon = _icon
		}
	}

	function extendTooltip( _tooltip, _idCounter ) {
		this.m.IDCounter = _idCounter;

		_idCounter++;
		_tooltip.extend([
			{
				id = _idCounter,
				type = "hint",
				icon = "ui/icons/kills.png",
				text = "Killed [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Stats.Kills.len() + "[/color] things"
			},
			// this.makeTooltipSegment("ui/icons/damage_dealt.png", this.m.Ranks.DamageDealt,
			// 	format("DMG Dealt %s[img]gfx/mods/fun_facts/health_mini.png[/img]%s[img]gfx/mods/fun_facts/armor_body_mini.png[/img]",
			// 		::MSU.Text.colorGreen(this.m.Stats.DamageDealtHitpoints.tostring()),
			// 		::MSU.Text.colorGreen(this.m.Stats.DamageDealtArmor.tostring()))),
		]);

		if (this.m.Stats.Kills.len() > 0) {
			local lastKill = this.m.Stats.Kills[this.m.Stats.Kills.len() - 1];
			_idCounter++;
			_tooltip.push({
				id = _idCounter,
				type = "hint",
				icon = "ui/icons/damage_dealt.png",
				text = "Last one was " + lastKill.Name + " XP " + lastKill.XP + " fatality " + lastKill.Fatality
			})
		}
		if (this.m.Stats.Injuries.len() > 0) {
			_idCounter++;
			_tooltip.push({
				id = _idCounter,
				type = "hint",
				icon = "ui/icons/damage_received.png",
				text = "Suffered " + this.m.Stats.Injuries.len() + " injuries"
			})
		}
		if (this.m.Stats.InjuriesDealt.len() > 0) {
			_idCounter++;
			_tooltip.push({
				id = _idCounter
				type = "hint"
				icon = "ui/icons/damage_dealt.png"
				text = "Delivered " + this.m.Stats.InjuriesDealt.len() + " injuries"
			})
		}
	}

	// function clearRanks()
	// {
	// 	foreach (rank, value in this.m.Ranks)
	// 	{
	// 		this.m.Ranks[rank] = 0;
	// 	}
	// }

	function onSerialize( _out ) {
		::MSU.Utils.serialize(this.m.Stats, _out);
	}

	function onDeserialize( _in ) {
		::MSU.Utils.deserializeInto(this.m.Stats, _in);
	}

}
