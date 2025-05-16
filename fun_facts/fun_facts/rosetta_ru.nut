if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_fun_facts", version = "1.0.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: fun_facts/actor.nut
    {
        en = "injury"
        ru = ""
    }
    // FILE: fun_facts/statistics_manager.nut
    {
        // ::std.Flags.pack(this.m.Flags, "FallenFunFacts." + i, fallen.FunFacts.pack());
        mode = "pattern"
        en = "FallenFunFacts.<i>"
        ru = ""
    }
    {
        en = "Noone remembers anything fun about this dude."
        ru = ""
    }
    // FILE: scripts/!mods_preload/mod_fun_facts.nut
    {
        en = "Fun Facts"
        ru = ""
    }
    // FILE: scripts/mods/fun_facts/fun_facts.nut
    {
        en = "<not-set>"
        ru = ""
    }
    {
        en = "charmed"
        ru = ""
    }
    {
        en = "swallowed"
        ru = ""
    }
    {
        en = "netted"
        ru = ""
    }
    {
        en = "stunned"
        ru = ""
    }
    {
        // Injury = _injury.m.ID.slice("injury.".len())
        mode = "pattern"
        en = "injury.<.len()>"
        ru = ""
    }
    {
        en = "effects."
        ru = ""
    }
    {
        en = "Died once"
        ru = ""
    }
    {
        // : format("Died %s time%s", red(deaths), Text.plural(deaths));
        mode = "pattern"
        en = "Died <red(deaths)> time<Text.plural(deaths)>"
        ru = ""
    }
    {
        en = "One"
        ru = ""
    }
    {
        en = " of them from a hand of a bro."
        ru = ""
    }
    {
        // text = format("Chopped %s heads", red(chopped));
        mode = "pattern"
        en = "Chopped <red(chopped)> heads"
        ru = ""
    }
    {
        // if (smashed > 0) text += format(", smashed %s more", red(smashed));
        mode = "pattern"
        en = ", smashed <red(smashed)> more"
        ru = ""
    }
    {
        // text = format("Smashed %s heads", red(smashed));
        mode = "pattern"
        en = "Smashed <red(smashed)> heads"
        ru = ""
    }
    {
        // if (chopped > 0) text += format(", chopped %s more", red(chopped));
        mode = "pattern"
        en = ", chopped <red(chopped)> more"
        ru = ""
    }
    {
        // text = format("Gutted %s enemies", red(gutted));
        mode = "pattern"
        en = "Gutted <red(gutted)> enemies"
        ru = ""
    }
    {
        // local text = format("Killed %s %s in a single battle",
        //                     red(maxKills), Text.plural(maxKills, "enemy", "enemies"));
        mode = "pattern"
        en = "Killed <red(maxKills)> <Text.plural(maxKills, enemy, enemies)> in a single battle"
        ru = ""
    }
    {
        en = "Chopped %s's head"
        ru = ""
    }
    {
        en = "Smashed %s's head"
        ru = ""
    }
    {
        en = "Gutted %s"
        ru = ""
    }
    {
        en = "Killed %s"
        ru = ""
    }
    {
        // format("Suffered %s injuries", red(this.m.Stats.Injuries.len())))
        mode = "pattern"
        en = "Suffered <red(this.m.Stats.Injuries.len())> injuries"
        ru = ""
    }
    {
        // format("Delivered %s injuries", red(this.m.Stats.InjuriesDealt.len())))
        mode = "pattern"
        en = "Delivered <red(this.m.Stats.InjuriesDealt.len())> injuries"
        ru = ""
    }
    {
        // text = "Used nine lives " + (uses  > 1 ? uses + " times" : "once");
        mode = "pattern"
        en = "Used nine lives <uses> times"
        ru = ""
    }
    {
        // text = "Used nine lives " + (uses  > 1 ? uses + " times" : "once");
        en = "Used nine lives once"
        ru = ""
    }
    {
        en = ", died every time"
        ru = ""
    }
    {
        en = ", died anyway"
        ru = ""
    }
    {
        // text += ", survived " + (saves  > 1 ? saves + " times" : "once")
        mode = "pattern"
        en = ", survived <saves> times"
        ru = ""
    }
    {
        // text += ", survived " + (saves  > 1 ? saves + " times" : "once")
        en = ", survived once"
        ru = ""
    }
    {
        // text = "Saved by nine lives " + (saves  > 1 ? saves + " times" : "once")
        mode = "pattern"
        en = "Saved by nine lives <saves> times"
        ru = ""
    }
    {
        // text = "Saved by nine lives " + (saves  > 1 ? saves + " times" : "once")
        en = "Saved by nine lives once"
        ru = ""
    }
    {
        // local text = format("Fled %s times in %s battles", red(fled), red(fledBattles));
        mode = "pattern"
        en = "Fled <red(fled)> times in <red(fledBattles)> battles"
        ru = ""
    }
    {
        // local text = "Slacked for " + this.m.Stats.BattlesSkipped + " battles of total " + total;
        mode = "pattern"
        en = "Slacked for <this.m.Stats.BattlesSkipped> battles of total <total>"
        ru = ""
    }
    {
        // text += ". " + skippedDrunk + " of them being drunk or hangover.";
        mode = "pattern"
        en = ". <skippedDrunk> of them being drunk or hangover."
        ru = ""
    }
    {
        en = "Effects"
        ru = ""
    }
    {
        // .map(@(n) format("%s %d times", n, effects[n]));
        mode = "pattern"
        en = "<n> <effects[n]> times"
        ru = ""
    }
    {
        // local text = "Was " + Str.join(", ", desc);
        mode = "pattern"
        en = "Was <Str.join(, , desc)>"
        ru = ""
    }
    {
        en = "[img]gfx/ui/tooltips/money.png[/img]"
        ru = ""
    }
    {
        // costs.push(format("Hired for %s%d, earned %s%d as wages.",
        //                   moneyImg, S.Hire, moneyImg, S.Wages))
        mode = "pattern"
        en = "Hired for <moneyImg><S.Hire>, earned <moneyImg><S.Wages> as wages."
        ru = ""
    }
    {
        // costs.push(format("Hired for %s%d.", moneyImg, S.Hire))
        mode = "pattern"
        en = "Hired for <moneyImg><S.Hire>."
        ru = ""
    }
    {
        // costs.push(format("Was payed %s%d as wages.", moneyImg, S.Wages))
        mode = "pattern"
        en = "Was payed <moneyImg><S.Wages> as wages."
        ru = ""
    }
    {
        // if (S.Food >= 1) spent.push("[img]gfx/fun_facts/food.png[/img]" + Util.round(S.Food));
        mode = "pattern"
        en = "[img]gfx/fun_facts/food.png[/img]<Util.round(S.Food)>"
        ru = ""
    }
    {
        // if (S.Parts >= 1) spent.push("[img]gfx/fun_facts/supplies.png[/img]" + Util.round(S.Parts));
        mode = "pattern"
        en = "[img]gfx/fun_facts/supplies.png[/img]<Util.round(S.Parts)>"
        ru = ""
    }
    {
        // if (S.Ammo >= 1) spent.push("[img]gfx/fun_facts/ammo.png[/img]" + Util.round(S.Ammo));
        mode = "pattern"
        en = "[img]gfx/fun_facts/ammo.png[/img]<Util.round(S.Ammo)>"
        ru = ""
    }
    {
        // if (S.Herbs >= 1) spent.push("[img]gfx/fun_facts/medicine.png[/img]" + Util.round(S.Herbs));
        mode = "pattern"
        en = "[img]gfx/fun_facts/medicine.png[/img]<Util.round(S.Herbs)>"
        ru = ""
    }
    {
        // if (spent.len() > 0) costs.push("Spent " + Str.join("&nbsp;", spent)); // used, consumed, wasted
        mode = "pattern"
        en = "Spent <Str.join(&nbsp;, spent)>"
        ru = ""
    }
    {
        // costs.push(format("TCO ~ %s%d", moneyImg, total))
        mode = "pattern"
        en = "TCO ~ <moneyImg><total>"
        ru = ""
    }
]
::Rosetta.add(rosetta, pairs);
