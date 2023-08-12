this.fun_facts <- {
    m = {
        Stats = {
            Kills = []
            Injuries = []
            InjuriesDealt = []
            HitsDealt = {}
            HitsReceived = {}
            Battles = 0
            BattlesSkipped = 0
            BattlesInReserve = 0
            NineLivesUses = 0
            NineLivesSaves = 0
            // NineLives = 0
            // Flee = 0
        },
        // Ranks = {}
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

    function onNineLivesUse() {
        this.m.Stats.NineLivesUses++;
        ::FunFacts.Debug.log("onNineLivesUse ", this.m.Stats.NineLivesUses);
    }

    function onNineLivesSave() {
        this.m.Stats.NineLivesSaves++;
        ::FunFacts.Debug.log("onNineLivesSave ", this.m.Stats.NineLivesSaves);
    }

    function onBattleSkipped() {
        this.m.Stats.BattlesSkipped++;
        ::FunFacts.Debug.log("onBattleSkipped ", this.m.Stats.BattlesSkipped);
    }

    function extendTooltip( _tooltip, _idCounter ) {
        local function red(text) {return ::MSU.Text.colorRed(text + "")}
        local function green(text) {return ::MSU.Text.colorGreen(text + "")}
        local function addHint(icon, text) {
            if (text == "") return;
            _idCounter++;
            _tooltip.push({id = _idCounter, type = "hint", icon = icon, text = text});
        }

        local kills = this.m.Stats.Kills.len();
        if (kills > 0) {
            local chopped = 0, gutted = 0, smashed = 0;
            foreach (kill in this.m.Stats.Kills) {
                if (kill.Fatality == 1) chopped++;
                if (kill.Fatality == 2) gutted++;
                if (kill.Fatality == 3) smashed++;
            }

            local text = "";
            if (chopped >= 3) {
                text = format("Chopped %s heads", red(chopped));
                if (smashed > 0) text += format(", smashed %s more", red(smashed));
            } else if (smashed >= 3) {
                text = format("Smashed %s heads", red(smashed));
                if (chopped > 0) text += format(", chopped %s more", red(chopped));
            } else if (gutted >= 3) {
                text = format("Gutted %s enemies", red(gutted));
            }

            addHint("ui/icons/kills.png", text);
        }

        if (this.m.Stats.Injuries.len() > 0) {
            addHint("ui/icons/damage_received.png",
                format("Suffered %s injuries", red(this.m.Stats.Injuries.len())))
        }
        if (this.m.Stats.InjuriesDealt.len() > 0) {
            addHint("ui/icons/damage_dealt.png",
                format("Delivered %s injuries", red(this.m.Stats.InjuriesDealt.len())))
        }

        if (this.m.Stats.NineLivesSaves > 0 || this.m.Stats.NineLivesUses > 0) {
            local uses = this.m.Stats.NineLivesUses;
            local saves = this.m.Stats.NineLivesSaves;
            local text;
            if (uses > saves) {
                text = "Used nine lives " + (uses  > 1 ? uses + " times" : "once");
                if (saves == 0) {
                    text += uses > 1 ? ", died every time" : ", died anyway"
                } else {
                    text += ", survived " + (saves  > 1 ? saves + " times" : "once")
                }
            } else {
                text = "Saved by nine lives " + (saves  > 1 ? saves + " times" : "once")
            }
            addHint("ui/perks/perk_07.png", text);
        }

        if (this.m.Stats.BattlesSkipped > 0) {
            local text = "Slacked for " + this.m.Stats.BattlesSkipped + " battles of total " + this.m.Stats.Battles;
            addHint("ui/icons/camp.png", text)
        }
    }

    // function clearRanks()
    // {
    //     foreach (rank, value in this.m.Ranks)
    //     {
    //         this.m.Ranks[rank] = 0;
    //     }
    // }

    function onSerialize( _out ) {
        ::MSU.Utils.serialize(this.m.Stats, _out);
    }

    function onDeserialize( _in ) {
        ::MSU.Utils.deserializeInto(this.m.Stats, _in);
    }

}
