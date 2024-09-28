local Str = ::std.Str, Text = ::std.Text,
      Array = ::std.Array, Table = ::std.Table, Util = ::std.Util;

local function Prop(_def) {
    return Util.extend({
        value = null
        function get() {
            if (value == null) value = calc()
            return value;
        }
    }, _def)
}

this.fun_facts <- {
    m = {
        Stats = {
            // TODO: kills in a single hit, single turn
            Kills = []
            Deaths = []
            Injuries = []
            InjuriesDealt = []
            BattlesLog = []
            Battles = 0
            CombatsSkipped = []
            NineLivesUses = 0
            NineLivesSaves = 0

            // Obsolete
            BattlesSkipped = 0  // Supserseded by CombatsSkipped array
        }
        Props = null
        TmpCombat = null
        // Ranks = {}
        Player = null
        Name = "<not-set>"
        Version = 2
    }

    function create() {
        createProps();
    }
    function createProps() {
        local function countEffectProp(_effect) {
            return Prop({
                ref = this.m.Stats.BattlesLog
                function calc() {
                    return Array.sum(
                        ref.map(@(c) "Added" in c && _effect in c.Added ? c.Added[_effect] : 0))
                }
                function onCombatEnd(_record) {
                    value += Table.get(_record.Added, _effect, 0);
                }
            })
        }

        // TODO: move props to stdlib?
        this.m.Props = {
            PlayerKills = Prop({
                ref = this.m.Stats.Kills
                calc = @() ref.filter(@(_, r) r.IsPlayer)
                function onKill(_record) {if (_record.IsPlayer) value.push(_record)}
            })
            SkippedDrunk = Prop({
                ref = this.m.Stats.CombatsSkipped
                // calc = @() ref.filter(@(_, c) c.Effects.find("effects.drunk") != null).len()
                function calc() {
                    value = 0;
                    ::std.Debug.log("SkippedDrunk calc", ref);
                    foreach (record in ref) onCombatSkipped(record);
                    return value;
                }
                function onCombatSkipped(_record) {
                    if (_record.Effects.find("effects.drunk") != null
                        || _record.Effects.find("effects.hangover") != null) value++
                }
            })
            Charmed = countEffectProp("charmed")
            Swallowed = countEffectProp("swallowed_whole")
            Rooted = Prop({
                ref = this.m.Stats.BattlesLog
                function calc() {
                    value = 0;
                    foreach (record in ref) onCombatEnd(record);
                    return value;
                }
                function onCombatEnd(_record) {
                    if (!("Added" in _record)) return;
                    foreach (effect in ["net" "web" "rooted"])
                        value += Table.get(_record.Added, effect, 0);
                }
            })
        }
    }
    function getProp(_name) {
        return this.m.Props[_name].get();
    }
    function updateProps(_event, _record) {
        foreach (_, prop in this.m.Props) {
            if (_event in prop) {
                if (prop.value == null) prop.value = prop.calc();
                prop[_event](_record);
            }
        }
    }

    function setPlayer(_player) {
        this.m.Player = ::WeakTableRef(_player);
        this.m.Name = _player.getName();
    }
    function setName(_name) {
        this.m.Name = _name;
    }

    function getLastBattleId() {
        if (this.m.Stats.BattlesLog.len() == 0) return null;
        local lastBattle = this.m.Stats.BattlesLog.top();
        return "Id" in lastBattle ? lastBattle.Id : null;
    }

    function onCombatStart(_player) {
        this.m.TmpCombat = {
            Start = this.getEffectsDesc(_player)
            Added = {}
        }
        ::FunFacts.Debug.log("onCombatStart " + _player.getName(), this.m.TmpCombat.Start);
    }

    function getEffectsDesc(_player) {
        local interestingIds = [
            "effects.drunk" "effects.hangover" "effects.exhausted" "effects.afraid"
            "injury.sickness"
        ]
        local ids = [];
        local injured = false, drugged = false;
        foreach (skill in _player.getSkills().m.Skills) {
            local id = skill.getID(), isDrug = skill.isType(::Const.SkillType.DrugEffect);
            if (isDrug || interestingIds.find(id) != null) ids.push(id);
            if (isDrug) drugged = true;
            if (skill.isType(::Const.SkillType.TemporaryInjury)) injured = true;
        }
        local hpPct = Math.round(_player.getHitpointsPct() * 100);
        // NOTE: Drugged and hpPct was added later
        return {Effects = ids, Injured = injured, Drugged = drugged, HpPct = hpPct}
    }

    function onCombatEnd(_player) {
        this.m.Stats.Battles++;
        local record = {
            Id = ::FunFacts.getBattleId()
            Kills = _player.m.CombatStats.Kills
            XPGained = _player.m.CombatStats.XPGained
            Fled = _player.m.ff_fled
            Returned = _player.m.ff_returned
            // Added later
            Start = this.m.TmpCombat.Start
            Added = this.m.TmpCombat.Added
        }
        this.m.TmpCombat = null;
        ::FunFacts.Debug.log("onBattle ", record);
        this.m.Stats.BattlesLog.push(record);
        this.updateProps("onCombatEnd", record);
    }

    function onCombatSkipped(_player) {
        this.m.Stats.BattlesSkipped++;
        local record = Table.extend({Id = ::FunFacts.getBattleId()}, this.getEffectsDesc(_player));
        this.m.Stats.CombatsSkipped.push(record);
        this.updateProps("onCombatSkipped", record);
        // ::FunFacts.Debug.log("onCombatSkipped ", record);
        this.m.TmpCombat = null;
    }

    function onKill(_target, _skill, _fatalityType) {
        local record = {
            BattleId = ::FunFacts.getBattleId()
            IsPlayer = _target.isPlayerControlled()
            Name = _target.getName()
            ClassName = _target.ClassName
            XP = _target.getXPValue()
            Fatality = _fatalityType
            Day = this.World.getTime().Days
            // Added later
            Faction = _target.getFaction() // This or target player could be charmed or smth
            Skill = _skill ? _skill.getID() : null
            // about this player
            // Self = {
            //     Faction = this.m.Player.getFaction()
            //     Charmed = this.m.Player.m.Flags.has("Charmed")
            // }
        }
        ::FunFacts.Debug.log("onKill record", record);
        this.m.Stats.Kills.push(record);
        ::FunFacts.Debug.log("onKill total records", this.m.Stats.Kills.len());
        this.updateProps("onKill", record);
    }

    function onDeath(_killer, _fatalityType) {
        local record = {
            BattleId = ::FunFacts.getBattleId()
            IsPlayer = _killer.isPlayerControlled()
            Name = _killer.getName()
            ClassName = _killer.ClassName
            XP = _killer.getXPValue()
            Fatality = _fatalityType
            Day = this.World.getTime().Days
        }
        ::FunFacts.Debug.log("onDeath record", record);
        this.m.Stats.Deaths.push(record);
        ::FunFacts.Debug.log("onDeath total records", this.m.Stats.Deaths.len());
    }

    function onTargetHit(_skill, _target, _bodyPart, _damageHitpoints, _damageArmor) {
    }

    function onInjury(_attacker, _injury) {
        local record = {
            BattleId = ::FunFacts.getBattleId()
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
            BattleId = ::FunFacts.getBattleId()
            Injury = _injury.m.ID.slice("injury.".len())
            TargetClass = _target.ClassName
            TargetName = _target.getName()
            Day = this.World.getTime().Days
        }
        ::FunFacts.Debug.log("onInjuryDealt record", record);
        this.m.Stats.InjuriesDealt.push(record);
        ::FunFacts.Debug.log("onInjuryDealt total records", this.m.Stats.InjuriesDealt.len());
    }

    function onSkillAdded(_skill) {
        if (this.m.TmpCombat == null) return;
        local interestingIds = [
            "effects.charmed" "effects.sleeping" "effects.net" "effects.web" "effects.rooted"
            "effects.chilled" "effects.dazed" "effects.distracted" "effects.disarmed"
            "effects.horrified" "effects.stunned" "effects.swallowed_whole"
            "effects.acid" "effects.bleeding" "effects.goblin_poison" "effects.spider_poison"
            "effects.whipped"
        ]
        local id = _skill.getID();
        if (interestingIds.find(id) == null) return;

        local name = Str.cutprefix(id, "effects.");
        if (name in this.m.TmpCombat.Added) this.m.TmpCombat.Added[name]++;
        else this.m.TmpCombat.Added[name] <- 1;
    }

    function onNineLivesUse() {
        this.m.Stats.NineLivesUses++;
        ::FunFacts.Debug.log("onNineLivesUse ", this.m.Stats.NineLivesUses);
    }

    function onNineLivesSave() {
        this.m.Stats.NineLivesSaves++;
        ::FunFacts.Debug.log("onNineLivesSave ", this.m.Stats.NineLivesSaves);
    }

    function extendTooltip( _tooltip, _idCounter ) {
        // ::FunFacts.Debug.log("battleId", ::FunFacts.getBattleId());

        local function red(text) {return ::MSU.Text.colorRed(text + "")}
        local function green(text) {return ::MSU.Text.colorGreen(text + "")}
        local function addHint(icon, text) {
            if (text == "") return;
            _idCounter++;
            _tooltip.push({id = _idCounter, type = "hint", icon = icon, text = text});
        }

        local deaths = this.m.Stats.Deaths.len();
        if (deaths > 0) {
            local text = deaths == 1 ? "Died once"
                : format("Died %s time%s", red(deaths), Text.plural(deaths));
            local fromBros = this.m.Stats.Deaths.filter(@(_, d) d.IsPlayer).len();
            if (fromBros) {
                text += ". " + (fromBros == 1 ? "One" : fromBros) + " of them from a hand of a bro."
            }
            addHint("ui/icons/obituary.png", text);
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

            // local function getTroopType(name) {
            //     if (Str.startswith(name, "zombie")) return "zombie";
            //     if (Str.startswith(name, "skeleton")) return "skeleton";
            //     if (Str.startswith(name, "bandit")) return "bandit";
            //     if (Str.startswith(name, "nomad")) return "nomad";
            //     if (Str.startswith(name, "barbarian")) return "barbarian";
            //     if (Str.startswith(name, "goblin")) return "goblin";
            //     if (Str.startswith(name, "orc")) return "orc";
            //     if (Str.startswith(name, "ghoul")) return "ghoul";
            //     if (Str.startswith(name, "vampire")) return "vampire";
            //     if (Str.startswith(name, "mercenary")) return "mercenary";
            //     if (name == "wolf" || name == "direwolf") return "wolf";
            //     if (name == "hyena" || name == "hyena_high") return "hyena";
            //     return name;
            // }
            // local killsByClass = ::MSU.Class.WeightedContainer();
            // foreach (kill in this.m.Stats.Kills) killsByClass.add(getTroopType(kill.ClassName));
            // local killsByClassSorted = killsByClass.toArray(false);
            // killsByClassSorted.sort(@(a, b) b[0] <=> a[0])
            // ::FunFacts.Debug.log("killsByClass", killsByClassSorted);
        }

        local maxKills = Array.max(this.m.Stats.BattlesLog.map(@(b) b.Kills)); // move to prop
        if (maxKills && maxKills >= 5) {
            local text = format("Killed %s %s in a single battle",
                                red(maxKills), Text.plural(maxKills, "enemy", "enemies"));
            addHint("ui/icons/round_information/enemies_icon.png", text);
        }

        local playerKills = this.getProp("PlayerKills");
        local fatalities = {
            [1] = "Chopped %s's head",
            [2] = "Smashed %s's head",
            [3] = "Gutted %s"
        }
        if (playerKills.len() > 0) {
            local kills = playerKills.map(function(_kill) {
                local tpl = _kill.Fatality in fatalities ? fatalities[_kill.Fatality] : "Killed %s";
                return format(tpl, Text.ally(_kill.Name));
            })
            addHint("ui/icons/asset_brothers.png", Str.join(", ", kills));
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

        local fled = 0;
        local fledBattles = 0;
        // TODO: move to props
        foreach (battle in this.m.Stats.BattlesLog) {
            fled += battle.Fled;
            if (battle.Fled) fledBattles++;
        }
        if (fled > 0) {
            local text = format("Fled %s times in %s battles", red(fled), red(fledBattles));
            addHint("ui/icons/tracking_disabled.png", text);
        }

        if (this.m.Stats.BattlesSkipped > 0) {
            local total = this.m.Stats.BattlesSkipped + this.m.Stats.Battles;
            local text = "Slacked for " + this.m.Stats.BattlesSkipped + " battles of total " + total;
            local skippedDrunk = this.getProp("SkippedDrunk");
            if (skippedDrunk != 0) {
                text += ". " + skippedDrunk + " of them being drunk or hangover.";
            }
            addHint("ui/icons/campfire.png", text)
        }

        // Experimental
        local swallowed = getProp("Swallowed");
        local charmed = getProp("Charmed");
        local rooted = getProp("Rooted");
        if (charmed > 0 || swallowed > 0 || rooted > 0) {
            local text = "";
            if (swallowed >= 3) {
                text = format("Was swallowed %d time%s", swallowed, Text.plural(swallowed));
            }
            if (charmed >= 3 || text && charmed > 0) {
                text += text.len() ? "," : "Was";
                text += format(" charmed %d time%s", charmed, Text.plural(charmed));
            }
            if (rooted >= 3 || text && rooted > 0) {
                text += text.len() ? "," : "Was";
                text += format(" captured %d time%s", rooted, Text.plural(rooted));
            }
        }
    }

    // function clearRanks()
    // {
    //     foreach (rank, value in this.m.Ranks)
    //     {
    //         this.m.Ranks[rank] = 0;
    //     }
    // }

    function pack() {
        local ret = Util.pack(this.m.Stats);
        logInfo("Pack " + this.m.Name + " " + ret.len());
        return ret;
    }
    function unpack(packed) {
        local state = Util.unpack(packed);
        Util.extend(this.m.Stats, state);
        createProps(); // need to call since "ref" things changed, may be remove in future
    }
}
