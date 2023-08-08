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

        local function red(text) {return ::MSU.Text.colorRed(text + "")}

        // _idCounter++;
        // _tooltip.extend([
        //     {
        //         id = _idCounter,
        //         type = "hint",
        //         icon = "ui/icons/kills.png",
        //         text = "Killed [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Stats.Kills.len() + "[/color] things"
        //     },
        //     // this.makeTooltipSegment("ui/icons/damage_dealt.png", this.m.Ranks.DamageDealt,
        //     //     format("DMG Dealt %s[img]gfx/mods/fun_facts/health_mini.png[/img]%s[img]gfx/mods/fun_facts/armor_body_mini.png[/img]",
        //     //         ::MSU.Text.colorGreen(this.m.Stats.DamageDealtHitpoints.tostring()),
        //     //         ::MSU.Text.colorGreen(this.m.Stats.DamageDealtArmor.tostring()))),
        // ]);

        local kills = this.m.Stats.Kills.len();
        if (kills > 0) {
            local message = "";
            local fatalityMessages = {
                "1": "Chopped %s heads",
                "2": "Gutted %s enemies",
                "3": "Smashed %s heads",
            };

            // Summarize fatalities
            local fatalities = ::MSU.Class.WeightedContainer();
            foreach (kill in this.m.Stats.Kills) fatalities.add(kill.Fatality);
            ::FunFacts.Debug.log("fatalities", fatalities.toArray(false));
            if (fatalities.contains(this.Const.FatalityType.None))
                fatalities.remove(this.Const.FatalityType.None);

            if (fatalities.len() > 0) {
                local favorite = fatalities.max();
                local favoriteCount = fatalities.getWeight(favorite);
                if (favoriteCount >= 3 && favorite.tostring() in fatalityMessages) {
                    local template = fatalityMessages[favorite.tostring()];
                    message += format(template, red(favoriteCount))
                    if (kills > favoriteCount) {
                        message += format(", among %s total enemies slain", red(kills));
                    }
                }
            }

            if (message != "") {
                _idCounter++;
                _tooltip.push({
                    id = _idCounter, type = "hint", icon = "ui/icons/kills.png", text = message
                })
            }
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
        if (this.m.Stats.NineLivesSaves > 0 || this.m.Stats.NineLivesUses > 0) {
            local text = this.m.Stats.NineLivesSaves > 0
                ? "Saved " + this.m.Stats.NineLivesSaves + " times by nine lives"
                : "Never saved by nine lives";
            if (this.m.Stats.NineLivesUses > this.m.Stats.NineLivesSaves) {
                text += ", used it " + this.m.Stats.NineLivesUses + " times";
            }
            _idCounter++;
            _tooltip.push({
                id = _idCounter
                type = "hint"
                icon = "ui/perks/perk_07.png"
                text = text
            })
        }
        if (this.m.Stats.BattlesSkipped > 0) {
            _idCounter++;
            _tooltip.push({
                id = _idCounter
                type = "hint"
                icon = "ui/icons/camp.png"
                text = "Slacked for " + this.m.Stats.BattlesSkipped + " battles"
            })
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
