local Str = ::std.Str, Text = ::std.Text,
      Array = ::std.Array, Table = ::std.Table, Util = ::std.Util;

local function makeReducers() {
    return {
        bySeq = {}
        function new(_seq, _start, _func) {
            local reducer = {
                value = _start
                push = _func
            }
            foreach (rec in _seq) reducer.push(rec);
            if (!(_seq in bySeq)) bySeq[_seq] <- [];
            bySeq[_seq].push(reducer);
            return reducer;
        }
        function push(_seq, _rec) {
            _seq.push(_rec)
            foreach (_, prop in bySeq[_seq]) prop.push(_rec)
        }
    }
}

this.fun_facts <- {
    m = {
        Version = 3
        Stats = {
            Version = 1 // Actual version would overwrite this
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
            // v3
            Spent = {
                Hire = 0
                Wages = 0
                Food = 0.0
                Ammo = 0
                Parts = 0.0
                Herbs = 0
            }

            // Obsolete
            BattlesSkipped = 0  // Supserseded by CombatsSkipped array
        }
        Props = null
        Reducers = null
        TmpCombat = null
        // Ranks = {}
        Player = null
        Name = "<not-set>"
    }

    function create() {
        createProps();
    }
    function createProps() {
        local R = this.m.Reducers = makeReducers();

        this.m.Props = {
            PlayerKills = R.new(this.m.Stats.Kills, [], function (_rec) {
                if (_rec.IsPlayer && !_rec.Self) value.push(_rec);
            })
            KilledByBros = R.new(this.m.Stats.Deaths, 0, function (_rec) {
                if (_rec.IsPlayer && !_rec.Self) value++;
            })
            SkippedDrunk = R.new(this.m.Stats.CombatsSkipped, 0, function (_rec) {
                if (_rec.Effects.find("effects.drunk") != null
                    || _rec.Effects.find("effects.hangover") != null) value++;
            })
        }

        local effectNames = {
            charmed = "charmed", swallowed_whole = "swallowed",
            net = "netted", web = "netted", rooted = "netted",
            stunned = "stunned"
        }
        this.m.Props.Effects <- R.new(this.m.Stats.BattlesLog, {}, function (_rec) {
            foreach (effect, cnt in _rec.Added) {
                if (!(effect in effectNames)) continue;
                if (effectNames[effect] in value) value[effectNames[effect]] += cnt;
                else value[effectNames[effect]] <- cnt;
            }
        })
        // TODO: effects out of battle (reducers might need to be extended)
    }
    function getProp(_name) {
        return this.m.Props[_name].value;
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

    function onHired(_cost) {
        this.m.Stats.Spent.Hire = _cost;
    }
    function onNewDay() {
        this.m.Stats.Spent.Wages += this.m.Player.getDailyCost();
    }
    function onConsumeFood(_amount) {
        this.m.Stats.Spent.Food += _amount;
    }
    function onConsumeAmmo(_amount) {
        // TODO: consider the follower collecting ammo
        this.m.Stats.Spent.Ammo += _amount;
    }
    function onUseHerbs(_amount) {
        this.m.Stats.Spent.Herbs += _amount;
    }

    function onCombatStart(_player) {
        this.m.TmpCombat = {
            Start = this.getEffectsDesc(_player)
            Added = {}
            Items = _player.getItems().getAllItems().map(
                @(item) {item = ::MSU.asWeakTableRef(item), cond = item.getCondition()})
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
        // NOTE: Drugged and hpPct was added in v2
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
            // Added in v2
            Start = this.m.TmpCombat.Start
            Added = this.m.TmpCombat.Added
        }
        ::FunFacts.Debug.log("onBattle ", record);
        this.m.Reducers.push(this.m.Stats.BattlesLog, record);

        // Look at lost condition
        foreach (pair in this.m.TmpCombat.Items) {
            if (pair.item.isNull()) continue;

            local lostCond =  pair.cond - pair.item.getCondition();
            if (lostCond > 0)
                this.m.Stats.Spent.Parts += lostCond * ::World.Assets.m.ArmorPartsPerArmor;
        }
        this.m.TmpCombat = null;
    }

    function onCombatSkipped(_player) {
        this.m.Stats.BattlesSkipped++;
        local record = Table.extend({Id = ::FunFacts.getBattleId()}, this.getEffectsDesc(_player));
        this.m.Reducers.push(this.m.Stats.CombatsSkipped, record);
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
            // v2
            Faction = _target.getFaction() // This or target player could be charmed or smth
            Skill = _skill ? _skill.getID() : null
            // v3
            Self = _target.getID() == this.m.Player.getID()
            Charmed = this.m.Player.m.Flags.has("Charmed")
            // about this player
            // Self = {
            //     Faction = this.m.Player.getFaction()
            // }
        }
        ::FunFacts.Debug.log("onKill record", record);
        this.m.Reducers.push(this.m.Stats.Kills, record);
        ::FunFacts.Debug.log("onKill total records", this.m.Stats.Kills.len());
    }

    function onDeath(_killer, _fatalityType) {
        // TODO: check how killer is null on reposte???
        if (!_killer) {
            ::logError("ff: no killer in FunFacts.onDeath")
            ::MSU.Log.printStackTrace()
        }
        local record = {
            BattleId = ::FunFacts.getBattleId()
            IsPlayer = _killer ? _killer.isPlayerControlled() : false
            Name = _killer ? _killer.getName() : null
            ClassName = _killer ? _killer.ClassName : null
            XP = _killer ? _killer.getXPValue() : null
            Fatality = _fatalityType
            Day = this.World.getTime().Days
            // Added later
            Self = _killer && _killer.getID() == this.m.Player.getID()
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
            local fromBros = this.getProp("KilledByBros");
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

        // Effect counts
        local effects = getProp("Effects");
        if (effects.len() > 0) {
            local names = ["swallowed" "charmed" "netted" "stunned"];
            local desc = names.filter(@(_, n) n in effects)
                              .map(@(n) format("%s %d times", n, effects[n]));
            local text = "Was " + Str.join(", ", desc);
            addHint("ui/perks/perk_04.png", text)
        }

        // Costs
        local S = this.m.Stats.Spent;
        local moneyImg = "[img]gfx/ui/tooltips/money.png[/img]";
        local costs = [];
        if (S.Hire > 0 && S.Wages > 0)
            costs.push(format("Hired for %s%d, earned %s%d as wages.",
                              moneyImg, S.Hire, moneyImg, S.Wages))
        else if (S.Hire > 0) {
            costs.push(format("Hired for %s%d.", moneyImg, S.Hire))
        } else if (S.Wages > 0) {
            costs.push(format("Was payed %s%d as wages.", moneyImg, S.Wages))
        }
        local spent = [];
        if (S.Food >= 1) spent.push("[img]gfx/fun_facts/food.png[/img]" + Util.round(S.Food));
        if (S.Parts >= 1) spent.push("[img]gfx/fun_facts/supplies.png[/img]" + Util.round(S.Parts));
        if (S.Ammo >= 1) spent.push("[img]gfx/fun_facts/ammo.png[/img]" + Util.round(S.Ammo));
        if (S.Herbs >= 1) spent.push("[img]gfx/fun_facts/medicine.png[/img]" + Util.round(S.Herbs));
        if (spent.len() > 0) costs.push("Spent " + Str.join("&nbsp;", spent)); // used, consumed, wasted

        // TODO: get proper prices
        local total = S.Hire + S.Wages + S.Food * 4 + S.Parts * 12
            + S.Ammo * 3 + S.Herbs * 15;
        if (total >= 1 && spent.len() > 0) {
            local factor = total >= 2000 ? 100 :
                           total >= 1000 ? 50 :
                           total >=  200 ? 10 :
                           total >=  100 ? 5 : 1;
            total = ::Math.round(total / factor) * factor;
            costs.push(format("TCO ~ %s%d", moneyImg, total))
        }

        if (costs.len() > 0) addHint("ui/icons/asset_money.png", Str.join("\n", costs))
    }

    // function clearRanks()
    // {
    //     foreach (rank, value in this.m.Ranks)
    //     {
    //         this.m.Ranks[rank] = 0;
    //     }
    // }

    function pack() {
        return this.m.Stats;
    }
    function unpack(_state) {
        // TMP
        // if ("Spent" in _state) _state.Used <- delete _state.Spent;

        Table.deepExtend(this.m.Stats, _state);

        // Fill combat.Start, combat.Added, Drugged, HpPct
        if (this.m.Stats.Version < 2) {
            foreach (combat in this.m.Stats.BattlesLog) {
                if (!("Start" in combat)) {
                    combat.Start <- {Effects = [], Injured = false, Drugged = false, HpPct = 100};
                } else {
                    Table.setDefaults(combat.Start, {Drugged = false, HpPct = 100})
                }
                if (!("Added" in combat)) combat.Added <- {};
            }
            foreach (combat in this.m.Stats.CombatsSkipped)
                Table.setDefaults(combat, {Drugged = false, HpPct = 100})
        }

        // Fill Self & Charmed
        if (this.m.Stats.Version < 3) {
            foreach (kill in this.m.Stats.Kills) {
                if (!("Self" in kill)) kill.Self <- kill.IsPlayer && kill.Name == this.m.Name;
                if (!("Charmed" in kill)) kill.Charmed <- false;
            }
            foreach (death in this.m.Stats.Deaths) {
                if (!("Self" in death)) death.Self <- death.IsPlayer && death.Name == this.m.Name;
            }
        }

        this.m.Stats.Version = this.m.Version;

        createProps(); // need to call since ref sequences changed
    }
}
