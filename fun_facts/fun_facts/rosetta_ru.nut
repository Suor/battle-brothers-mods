if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.3.1")) return;

local Array = ::std.Array, Str = ::std.Str;

local rosetta = {
    mod = {id = ::FunFacts.ID, version = ::FunFacts.Version}
    author = "hackflow"
    lang = "ru"
}

// Independent rosetta instance for kill verbs — its own .maps so it doesn't pollute ::Rosetta.
// TODO: make an official feature?
local verbsRosetta = {maps = {}}.setdelegate(::Rosetta);
verbsRosetta._ = verbsRosetta.translate.bindenv(verbsRosetta);

// "Bob, John and Mike" <-> ["Bob", "John", "Mike"]
local function splitAnd(_andWord, _str) {
    local sep = " " + _andWord + " ";
    return Array.cat(Str.split(sep, _str).map(@(chunk) Str.split(", ", chunk)));
    // local result = [];
    // foreach (chunk in Str.split(sep, _str))
    //     result.extend(Str.split(", ", chunk))
    // return result;
}
local function joinAnd(_andWord, _list) {
    if (_list.len() == 0) return "";
    if (_list.len() == 1) return _list[0];
    return Str.join(", ", _list.slice(0, -1)) + " " + _andWord + " " + _list.top();
    // return Str.join(", ", _list.slice(0, _list.len() - 1)) + " " + _andWord + " " + _list.top();
}

local pairs = [
    // FILE: fun_facts/buys.nut
    // Internal Buys-table keys, not user-facing.
    // en = "Food"
    // en = "Ammo"
    // en = "Parts"
    // en = "Herbs"
    // FILE: fun_facts/statistics_manager.nut
    {
        en = "Noone remembers anything fun about this dude."
        ru = "Никто не помнит ничего забавного об этом парне."
    }
    // FILE: scripts/!mods_preload/mod_fun_facts.nut
    {
        en = "Fun Facts"
        ru = "Забавные факты"
    }
    // FILE: scripts/mods/fun_facts/fun_facts.nut
    {
        en = "charmed"
        ru = "зачарован"
    }
    {
        en = "swallowed"
        ru = "проглочен"
    }
    {
        en = "netted"
        ru = "спутан"
    }
    {
        en = "stunned"
        ru = "оглушён"
    }
    {
        // local text = deaths == 1 ? "Died once"
        //     : format("Died %s time%s", red(deaths), Text.plural(deaths));
        mode = "pattern"
        en = "Died once<end:str>"
        ru = "Помер разок<end:t>"
    }
    {
        // local text = deaths == 1 ? "Died once"
        // : format("Died %s time%s", red(deaths), Text.plural(deaths));
        plural = "deaths"
        en = "Died <deaths:int_tag> time<s:word><end:str>"
        n1 = "Умер <deaths> раз<end:t>"
        n2 = "Умер <deaths> раза<end:t>"
        n5 = "Умер <deaths> раз<end:t>"
    }
    {
        // text += fromBros == 1 ? " from a hand of a bro" : " from his bros hands."
        en = " from a hand of a bro"
        ru = " от руки товарища"
    }
    {
        // text += fromBros == 1 ? " from a hand of a bro" : " from his bros hands."
        en = " with some help from his bros"
        ru = " c братской помощью"
    }
    {
        // text += ". " + (fromBros == 1 ? "One" : fromBros) + " of them from a hand of a bro."
        en = ". One of them from a hand of a bro."
        ru = ". Один из них от руки товарища."
    }
    {
        // text += ". " + (fromBros == 1 ? "One" : fromBros) + " of them from a hand of a bro."
        mode = "pattern"
        en = ". <from:int> of them from a hand of a bro."
        ru = ". <from> из них от руки товарища."
    }
    {
        // text = format("Chopped %s heads", red(chopped));
        plural = "n"
        en = "Chopped <n:int_tag> heads"
        n1 = "Срубил <n> голову"
        n2 = "Срубил <n> головы"
        n5 = "Срубил <n> голов"
    }
    {
         // if (smashed > 0) text += format(", smashed %s more", red(smashed));
        plural = "n"
        en = "Chopped <n:int_tag> heads, smashed <m:int_tag> more"
        n1 = "Срубил <n> голову, разбил ещё <m>"
        n2 = "Срубил <n> головы, разбил ещё <m>"
        n5 = "Срубил <n> голов, разбил ещё <m>"
    }
    {
        // text = format("Smashed %s heads", red(smashed));
        plural = "n"
        en = "Smashed <n:int_tag> heads"
        n1 = "Разбил <n> голову"
        n2 = "Разбил <n> головы"
        n5 = "Разбил <n> голов"
    }
    {
        // if (chopped > 0) text += format(", chopped %s more", red(chopped));
        plural = "n"
        en = "Smashed <n:int_tag> heads, chopped <m:int_tag> more"
        n1 = "Разбил <n> голову, срубил ещё <m>"
        n2 = "Разбил <n> головы, срубил ещё <m>"
        n5 = "Разбил <n> голов, срубил ещё <m>"
    }
    {
        // text = format("Gutted %s enemies", red(gutted));
        plural = "n"
        en = "Gutted <n:int_tag> enemies"
        n1 = "Выпотрошил <n> врага"
        n2 = "Выпотрошил <n> врагов"
        n5 = "Выпотрошил <n> врагов"
    }
    {
        // local text = format("Killed %s %s in a single battle",
        //                     red(maxKills), Text.plural(maxKills, "enemy", "enemies"));
        plural = "n"
        en = "Killed <n:int_tag> enem<_:word> in a single battle"
        n1 = "Сразил <n> врага в одном бою"
        n2 = "Сразил <n> врагов в одном бою"
        n5 = "Сразил <n> врагов в одном бою"
    }
    // en = "enemy"
    {
        // return "Unwittingly " + Str.join(". ", parts);
        mode = "pattern"
        en = "Unwittingly <kills:str>"
        function use(_str, _m) {
            return "Нечаянно " + Str.join(". ",
                Str.split(". ", _m.kills).map(@(p) Str.replace(verbsRosetta._(p), " and ", " и ")));
                // Str.split(". ", _m.kills).map(@(p) joinAnd("и", splitAnd("and", verbsRosetta._(p)))));
        }
    }
    // en = "<_names[0]> and <_names[1]>"
    // en = "<Str.join(, , _names.slice(0, _names.len()-1))> and <_names[_names.len()-1]>"
    {
        // format("Suffered %s injuries", red(this.m.Stats.Injuries.len())))
        plural = "n"
        en = "Suffered <n:int_tag> injuries"
        n1 = "Получил <n> травму"
        n2 = "Получил <n> травмы"
        n5 = "Получил <n> травм"
    }
    {
        // format("Inflicted %s injuries", red(this.m.Stats.InjuriesDealt.len())))
        plural = "n"
        en = "Inflicted <n:int_tag> injuries"
        n1 = "Нанёс <n> травму"
        n2 = "Нанёс <n> травмы"
        n5 = "Нанёс <n> травм"
    }
    {
        // text = "Used nine lives " + (uses  > 1 ? uses + " times" : "once");
        plural = "uses"
        en = "Used nine lives <uses:int> times<end:str>"
        n1 = "Использовал 'Девять жизней' <uses> раз<end:t>"
        n2 = "Использовал 'Девять жизней' <uses> раза<end:t>"
        n5 = "Использовал 'Девять жизней' <uses> раз<end:t>"
    }
    {
        // text = "Used nine lives " + (uses  > 1 ? uses + " times" : "once");
        mode = "pattern"
        en = "Used nine lives once<end:str>"
        ru = "Однажды использовал 'Девять жизней'<end:t>"
    }
    {
        // text += uses > 1 ? ", died every time" : ", died anyway"
        en = ", died every time"
        ru = ", помирал каждый раз"
    }
    {
        // text += uses > 1 ? ", died every time" : ", died anyway"
        en = ", died anyway"
        ru = ", всё равно подох"
    }
    {
        // text += ", survived " + (saves  > 1 ? saves + " times" : "once")
        plural = "saves"
        en = ", survived <saves:int> times"
        n1 = ", выжил <saves> раз"
        n2 = ", выжил <saves> раза"
        n5 = ", выжил <saves> раз"
    }
    {
        // text += ", survived " + (saves  > 1 ? saves + " times" : "once")
        en = ", survived once"
        ru = ", выжил разок"
    }
    {
        // text = "Saved by nine lives " + (saves  > 1 ? saves + " times" : "once")
        plural = "saves"
        en = "Saved by nine lives <saves:int> times"
        n1 = "Выжил на кошечке <saves> раз"
        n2 = "Выжил на кошечке <saves> раза"
        n5 = "Выжил на кошечке <saves> раз"
    }
    {
        // text = "Saved by nine lives " + (saves  > 1 ? saves + " times" : "once")
        en = "Saved by nine lives once"
        ru = "Как-то раз выжил на кошечке"
    }
    {
        // local text = format("Fled %s times in %s battles", red(fled), red(fledBattles));
        plural = "fled"
        en = "Fled <fled:int_tag> times in <battles:int_tag> battles"
        // TODO:
        //   ru = "Бежал <fled:p(раз,раза,раз)> в <battles:p(битве,битвах,битвах)>"
        //   ru = "Бежал <fled> <fled:p:раз,раза,раз> в <battles> <battles:p:битве,битвах,битвах>"
        n1 = "Бежал <fled> раз в <battles> битвах"
        n2 = "Бежал <fled> раза в <battles> битвах"
        n5 = "Бежал <fled> раз в <battles> битвах"
    }
    {
        // local text = "Slacked for " + this.m.Stats.BattlesSkipped + " battles of total " + total;
        plural = "n"
        en = "Slacked for <n:int> battles of total <total:int><end:str>"
        n1 = "Профилонил <n:int> битву из <total:int><end:t>"
        n2 = "Профилонил <n:int> битвы из <total:int><end:t>"
        n5 = "Профилонил <n:int> битв из <total:int><end:t>"
    }
    {
        // text += ". " + skippedDrunk + " of them being drunk or hangover.";
        mode = "pattern"
        en = ". <n:int> of them being drunk or hangover."
        ru = ". <n> из них валялся пьяным или с похмелья."
    }
        // en = "Effects"
    {
        // .map(@(n) format("%s %d times", n, effects[n]));
        plural = "n"
        en = "<effect:str> <n:int> times"
        n1 = "<effect:t> <n> раз"
        n2 = "<effect:t> <n> раза"
        n5 = "<effect:t> <n> раз"
    }
    {
        // local text = "Was " + Str.join(", ", desc);
        mode = "pattern"
        en = "Was <middle:str> times"
        function use(_str, _m) {
            return "Был " + ::Rosetta.useSplit(this, ", ", _m.middle + " times")
        }
    }
    {
        // costs.push(format("Hired for %s%d, earned %s%d as wages.",
        //                   moneyImg, S.Hire, moneyImg, S.Wages))
        mode = "pattern"
        en = "Hired for <money1:img><hire:int>, earned <money2:img><wages:int> as wages."
        ru = "Нанят за <money1><hire>, зарплата - <money2><wages>."
    }
    {
        // costs.push(format("Hired for %s%d.", moneyImg, S.Hire))
        mode = "pattern"
        en = "Hired for <money:img><hire:int>."
        ru = "Нанят за <money><hire>."
    }
    {
        // costs.push(format("Was payed %s%d as wages.", moneyImg, S.Wages))
        mode = "pattern"
        en = "Was payed <money:img><wages:int> as wages."
        ru = "Уплачено <money><wages> зарплаты."

    }
    {
        // if (spent.len() > 0) costs.push("Spent " + Str.join("&nbsp;", spent)); // used, consumed, wasted
        mode = "pattern"
        en = "Spent <spent:line>"
        ru = "Потратил <spent>"
    }
    {
        // S.Temple.len() == 1 ? format("Healed for %s%d.", ...)
        mode = "pattern"
        en = "Healed for <money:img><total:int>."
        ru = "Полечился за <money><total>."
    }
    {
        // : format("Healed for %s%d at temple (%d times).", ...)
        plural = "n"
        en = "Healed <n:int> times, <money:img><total:int> total."
        n1 = "Лечился <n> раз, спустил <money><total>."
        n2 = "Лечился <n> раза, спустил <money><total>."
        n5 = "Лечился <n> раз, спустил <money><total>."
    }
    // Internal expression with table keys, not user-facing.
    // en = "<S.Hire + S.Wages + templeTotal + S.Food*Buys.getAvgPrice(Food, 4) + S.Parts*Buys.getAvgPrice(Parts, 12) + S.Ammo*Buys.getAvgPrice(Ammo, 3) + S.Herbs*Buys.getAvgPrice(Herbs, 15)>"
    {
        // costs.push(format("TCO ~ %s%d", moneyImg, total))
        en = "<start:str>\nTCO ~ <end:str>"
        split = "\n"
    }
    {
        // costs.push(format("TCO ~ %s%d", moneyImg, total))
        mode = "pattern"
        en = "TCO ~ <money:img><total:int>"
        ru = "TCO ~ <money><total>"
    }
]
::Rosetta.add(rosetta, pairs);

// Verb pairs used by the "Unwittingly <kills:str>" rule above.
// Each part of _m.kills is built as `format(en_template, joinNames(...))`,
// so the pattern becomes `<verb> <names:str> [<suffix>]`.
local verbPairs = [
    // FILE: fun_facts/kill_verbs.nut
    {
        // fatalities[1] <- "chopped %s";
        mode = "pattern"
        en = "chopped <names:str>"
        ru = "снёс башку <names>"
    }
    {
        // fatalities[2] <- "smashed %s";
        mode = "pattern"
        en = "smashed <names:str>"
        ru = "размозжил башку <names>"
    }
    {
        // fatalities[3] <- "gutted %s";
        mode = "pattern"
        en = "gutted <names:str>"
        ru = "выпотрошил <names>"
    }
    {
        // ["shot %s in the back", [
        mode = "pattern"
        en = "shot <names:str> in the back"
        ru = "застрелил в спину <names>"
    }
    {
        // ["skewered %s", [
        mode = "pattern"
        en = "skewered <names:str>"
        ru = "наколол <names>"
    }
    {
        // ["hatcheted %s", ["actives.throw_axe"]],
        mode = "pattern"
        en = "hatcheted <names:str>"
        ru = "зарубил <names>"
    }
    {
        // ["pelted %s",    ["actives.throw_balls"]],
        mode = "pattern"
        en = "pelted <names:str>"
        ru = "закидал камнями <names>"
    }
    {
        // ["stabbed %s", [
        mode = "pattern"
        en = "stabbed <names:str>"
        ru = "заколол <names>"
    }
    {
        // ["ran %s through", [
        mode = "pattern"
        en = "ran <names:str> through"
        ru = "пронзил <names>"
    }
    {
        // ["impaled %s",   ["actives.impale"]],
        mode = "pattern"
        en = "impaled <names:str>"
        ru = "насадил <names>"
    }
    {
        // ["gouged %s",    ["actives.rf_gouge"]],
        mode = "pattern"
        en = "gouged <names:str>"
        ru = "пропорол <names>"
    }
    {
        // ["hacked up %s", [
        mode = "pattern"
        en = "hacked up <names:str>"
        ru = "изрубил <names>"
    }
    {
        // ["cleaved %s", [
        mode = "pattern"
        en = "cleaved <names:str>"
        ru = "раскроил <names>"
    }
    {
        // ["beheaded %s",    ["actives.decapitate"]],
        mode = "pattern"
        en = "beheaded <names:str>"
        ru = "снёс голову <names>"
    }
    {
        // ["eviscerated %s", ["actives.rupture"]],
        mode = "pattern"
        en = "eviscerated <names:str>"
        ru = "выпотрошил <names>"
    }
    {
        // ["swept %s away", [
        mode = "pattern"
        en = "swept <names:str> away"
        ru = "смёл <names>"
    }
    {
        // ["mowed down %s", ["actives.swing"]],
        mode = "pattern"
        en = "mowed down <names:str>"
        ru = "скосил <names>"
    }
    {
        // ["reaped %s",     ["actives.reap"]],
        mode = "pattern"
        en = "reaped <names:str>"
        ru = "пожал <names>"
    }
    {
        // ["thrashed %s", [
        mode = "pattern"
        en = "thrashed <names:str>"
        ru = "отдубасил <names>"
    }
    {
        // ["whipped %s", [
        mode = "pattern"
        en = "whipped <names:str>"
        ru = "отстегал <names>"
    }
    {
        // ["clobbered %s", [
        mode = "pattern"
        en = "clobbered <names:str>"
        ru = "огрел <names>"
    }
    {
        // ["hammered %s",   ["actives.hammer"]],
        mode = "pattern"
        en = "hammered <names:str>"
        ru = "замолотил <names>"
    }
    {
        // ["pulverized %s", ["actives.pound"]],
        mode = "pattern"
        en = "pulverized <names:str>"
        ru = "размолотил <names>"
    }
    {
        // ["crushed %s", [
        mode = "pattern"
        en = "crushed <names:str>"
        ru = "раздавил <names>"
    }
    {
        // ["felled %s", [
        mode = "pattern"
        en = "felled <names:str>"
        ru = "уложил <names>"
    }
    {
        // ["battered %s",   ["actives.batter"]],
        mode = "pattern"
        en = "battered <names:str>"
        ru = "забил <names>"
    }
    {
        // ["shattered %s",  ["actives.shatter"]],
        mode = "pattern"
        en = "shattered <names:str>"
        ru = "расплющил <names>"
    }
    {
        // ["pummeled %s",   ["actives.rf_pummel"]],
        mode = "pattern"
        en = "pummeled <names:str>"
        ru = "отметелил <names>"
    }
    {
        // ["plowed into %s",["actives.rf_swordmaster_charge"]],
        mode = "pattern"
        en = "plowed into <names:str>"
        ru = "протаранил <names>"
    }
    {
        // ["booted %s",     ["actives.rf_swordmaster_kick"]],
        mode = "pattern"
        en = "booted <names:str>"
        ru = "запинал <names>"
    }
    {
        // ["tackled %s",    ["actives.rf_swordmaster_tackle"]],
        mode = "pattern"
        en = "tackled <names:str>"
        ru = "завалил <names>"
    }
    {
        // return "killed %s";
        mode = "pattern"
        en = "killed <names:str>"
        ru = "убил <names>"
    }
]
verbsRosetta.add(rosetta, verbPairs);
