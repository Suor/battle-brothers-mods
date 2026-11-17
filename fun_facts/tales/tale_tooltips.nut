// mode: campaign seed=bbtest-battle fresh=1 launch=misc
// mods: mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// The texts the Squirrel side hands to the UI: roster and obituary tooltips, the obituary
// screen's data. Stats are set the way a save loads them (unpack), so the counts are exact.

::FFT.kill <- function (_name, _fatality, _skill = null, _isPlayer = false) {
    return {BattleId = 1, IsPlayer = _isPlayer, Name = _name, ClassName = "bandit_thug", XP = 150,
        Fatality = _fatality, Day = 1, Faction = 22, Skill = _skill, Self = false, Charmed = false};
}
::FFT.death <- function (_byBro) {
    return {BattleId = 1, IsPlayer = _byBro, Name = _byBro ? "Bro" : "Brigand Thug",
        ClassName = _byBro ? "player" : "bandit_thug", XP = 150, Fatality = 0, Day = 1, Self = false};
}
::FFT.battle <- function (_kills, _fled = 0, _added = {}) {
    return {Id = 1, Kills = _kills, XPGained = 100, Fled = _fled, Returned = 0,
        Start = {Effects = [], Injured = false, Drugged = false, HpPct = 100}, Added = _added};
}
::FFT.injury <- @() {BattleId = 1, Injury = "cut_arm", AttackerClass = "bandit_thug",
    AttackerName = "Brigand Thug", TargetClass = "bandit_thug", TargetName = "Brigand Thug", Day = 1};

// A FunFacts object loaded from these stats, and the hint texts it adds to a tooltip.
::FFT.load <- function (_stats) {
    local ff = ::new("scripts/mods/fun_facts/fun_facts");
    _stats.Version <- 3;
    ff.unpack(_stats);
    return ff;
}
::FFT.texts <- function (_stats) {
    local tooltip = [];
    ::FFT.load(_stats).extendTooltip(tooltip, 0);
    return tooltip.map(@(e) e.text);
}
::FFT.resetBuys <- function () {
    foreach (k, v in ::FunFacts.Buys.Stats) { v.Amount = 0; v.Spent = 0; }
}

local red = ::FFT.red, money = "[img]gfx/ui/tooltips/money.png[/img]";

test("kill lines", function (t) {
    local F = ::Const.FatalityType;
    t.eq(::FFT.texts({Kills = [::FFT.kill("a", F.Decapitated), ::FFT.kill("b", F.Decapitated),
            ::FFT.kill("c", F.Decapitated), ::FFT.kill("d", F.Smashed)], BattlesLog = [::FFT.battle(4)]}),
         ["Chopped " + red(3) + " heads, smashed " + red(1) + " more"], "chopped and smashed");
    t.eq(::FFT.texts({Kills = [::FFT.kill("a", F.Disemboweled), ::FFT.kill("b", F.Disemboweled),
            ::FFT.kill("c", F.Disemboweled)], BattlesLog = [::FFT.battle(3)]}),
         ["Gutted " + red(3) + " enemies"], "gutted");
    local five = [];
    for (local i = 0; i < 6; i++) five.push(::FFT.kill("x", F.None));
    t.eq(::FFT.texts({Kills = five, BattlesLog = [::FFT.battle(1), ::FFT.battle(6)]}),
         ["Killed " + red(6) + " enemies in a single battle"], "best battle");
});

test("death lines", function (t) {
    t.eq(::FFT.texts({Deaths = [::FFT.death(false)]}), ["Died once"], "once");
    t.eq(::FFT.texts({Deaths = [::FFT.death(true)]}), ["Died once from a hand of a bro"], "once by a bro");
    // KNOWN_BUGS #5, the English text: struck down twice, once by a bro's arrow
    t.eq(::FFT.texts({Deaths = [::FFT.death(false), ::FFT.death(true)]}),
         ["Died " + red(2) + " times. One of them from a hand of a bro."], "twice, once by a bro");
    t.eq(::FFT.texts({Deaths = [::FFT.death(false), ::FFT.death(true), ::FFT.death(true)]}),
         ["Died " + red(3) + " times. 2 of them from a hand of a bro."], "three times, twice by bros");
    t.eq(::FFT.texts({Deaths = [::FFT.death(true), ::FFT.death(true)]}),
         ["Died " + red(2) + " times with some help from his bros"], "all by bros");
});

test("other lines, plural counts", function (t) {
    local inj = ::FFT.injury();
    t.eq(::FFT.texts({Injuries = [inj, inj], InjuriesDealt = [inj, inj, inj]}),
         ["Suffered " + red(2) + " injuries", "Inflicted " + red(3) + " injuries"], "injuries");
    t.eq(::FFT.texts({NineLivesUses = 3, NineLivesSaves = 2}), ["Used nine lives 3 times, survived 2 times"], "nine lives");
    t.eq(::FFT.texts({NineLivesUses = 2, NineLivesSaves = 0}), ["Used nine lives 2 times, died every time"], "nine lives, died");
    t.eq(::FFT.texts({BattlesLog = [::FFT.battle(0, 2), ::FFT.battle(0, 1), ::FFT.battle(0)]}),
         ["Fled " + red(3) + " times in " + red(2) + " battles"], "fled");
    t.eq(::FFT.texts({BattlesSkipped = 2, Battles = 3, CombatsSkipped = [
            {Id = 1, Effects = ["effects.drunk"], Injured = false, Drugged = false, HpPct = 100},
            {Id = 2, Effects = [], Injured = false, Drugged = false, HpPct = 100}]}),
         ["Slacked for 2 battles of total 5. 1 of them being drunk or hangover."], "slacked");
    t.eq(::FFT.texts({BattlesLog = [::FFT.battle(0, 0, {stunned = 2, web = 1}), ::FFT.battle(0, 0, {net = 2, charmed = 3})]}),
         ["Was charmed 3 times, netted 3 times, stunned 2 times"], "effects");
});

test("costs line and TCO", function (t) {
    ::FFT.resetBuys();
    t.eq(::FFT.texts({Spent = {Hire = 100, Wages = 50, Food = 10.4, Parts = 2.6, Ammo = 5, Herbs = 1, Temple = [30, 20], Training = [130, 145]}}),
         ["Hired for " + money + "100, earned " + money + "50 as wages.\n"
          + "Spent [img]gfx/fun_facts/food.png[/img]10&nbsp;[img]gfx/fun_facts/supplies.png[/img]3"
          + "&nbsp;[img]gfx/fun_facts/ammo.png[/img]5&nbsp;[img]gfx/fun_facts/medicine.png[/img]1\n"
          + "Healed 2 times, " + money + "50 total.\n"
          + "Trained 2 times, " + money + "275 total.\n"
          // 200 + 275 + 10.4 * 4 + 2.6 * 12 + 5 * 3 + 1 * 15 = 577.8, rounded to tens
          + "TCO ~ " + money + "580"], "full costs");
    t.eq(::FFT.texts({Spent = {Hire = 0, Wages = 0, Food = 0.0, Parts = 0.0, Ammo = 0, Herbs = 0, Temple = [45]}}),
         ["Healed for " + money + "45.\nTCO ~ " + money + "45"], "temple only");
    t.eq(::FFT.texts({Spent = {Hire = 0, Wages = 0, Food = 0.0, Parts = 0.0, Ammo = 0, Herbs = 0, Temple = [], Training = [130]}}),
         ["Trained for " + money + "130.\nTCO ~ " + money + "130"], "training only");
    // Bought prices replace the fallbacks: food at 2 a unit
    ::FunFacts.Buys.Stats.Food = {Amount = 50.0, Spent = 100};
    t.eq(::FFT.texts({Spent = {Hire = 0, Wages = 20, Food = 30.0, Parts = 0.0, Ammo = 0, Herbs = 0, Temple = []}}),
         ["Was paid " + money + "20 as wages.\nSpent [img]gfx/fun_facts/food.png[/img]30\nTCO ~ " + money + "80"],
         "wages and food at the bought price");
    ::FFT.resetBuys();
});

test("roster, casualty and obituary tooltips carry the lines", function (t) {
    local bro = t.roster()[0];
    local stats = {Injuries = [::FFT.injury(), ::FFT.injury()]};
    bro.m.FunFacts.unpack(stats);
    local tooltip = bro.getRosterTooltip();
    t.eq(tooltip.filter(@(_, e) e.id > 6).map(@(e) [e.type, e.icon, e.text]),
         [["hint", "ui/icons/damage_received.png", "Suffered " + red(2) + " injuries"]], "roster tooltip hints");
    local ids = tooltip.map(@(e) e.id);
    local unique = {};
    foreach (id in ids) unique[id] <- true;
    t.eq(unique.len(), ids.len(), "tooltip ids are unique: " + ::Tales.repr(ids));

    local fallen = ::World.Statistics.getFallen();
    fallen.insert(0, {Name = "Old Timer", Time = 1, TimeWithCompany = 1, Kills = 0, Battles = 0,
        KilledBy = "Killed in battle", Expendable = false});
    fallen.insert(0, {Name = "Remembered", Time = 1, TimeWithCompany = 1, Kills = 0, Battles = 0,
        KilledBy = "Killed in battle", Expendable = false, FunFacts = ::FFT.load({Deaths = [::FFT.death(false)]})});
    t.eq(::World.Statistics.FunFacts_getTooltipForFallen(0).map(@(e) e.text), ["Remembered", "Died once"], "obituary with facts");
    t.eq(::World.Statistics.FunFacts_getTooltipForFallen(1).map(@(e) e.text),
         ["Old Timer", "Noone remembers anything fun about this dude."], "obituary without facts");
    t.eq(::FunFacts.Mod.Tooltips.getTooltip("Fallen").getUIData({FunFacts_Idx = 0}),
         ::World.Statistics.FunFacts_getTooltipForFallen(0), "MSU tooltip Fallen");

    local data = ::World.State.m.ObituaryScreen.convertFallenToUIData();
    t.eq(data.Fallen.slice(0, 2).map(@(f) [f.Name, "FunFacts" in f, f.FunFacts_Idx]),
         [["Remembered", false, 0], ["Old Timer", false, 1]], "obituary screen data");
    t.ok("FunFacts" in fallen[0], "the statistics keep the FunFacts object");
});

test("F6: counts of one read in the singular", function (t) {
    local inj = ::FFT.injury();
    t.eq(::FFT.texts({Injuries = [inj], InjuriesDealt = [inj]}),
         ["Suffered " + red(1) + " injury", "Inflicted " + red(1) + " injury"], "injuries");
    t.eq(::FFT.texts({BattlesLog = [::FFT.battle(0, 1)]}), ["Fled " + red(1) + " time in " + red(1) + " battle"], "fled");
    t.eq(::FFT.texts({BattlesSkipped = 1, Battles = 0, CombatsSkipped = [
            {Id = 1, Effects = [], Injured = false, Drugged = false, HpPct = 100}]}),
         ["Slacked for 1 battle of total 1"], "slacked");
    t.eq(::FFT.texts({BattlesLog = [::FFT.battle(0, 0, {stunned = 1})]}), ["Was stunned 1 time"], "effects");
});

// KNOWN_BUGS #9 (HEAD): the parts of the hint are joined with commas.
test("KB9: friendly-fire hint, parts joined with commas", function (t) {
    local F = ::Const.FatalityType;
    local texts = ::FFT.texts({Kills = [::FFT.kill("Hans", F.Decapitated, null, true),
        ::FFT.kill("Bob", F.None, "actives.thrust", true), ::FFT.kill("Jon", F.None, "actives.thrust", true)]});
    t.eq(texts, ["Unwittingly chopped " + ::FFT.ally("Hans") + ", stabbed " + ::FFT.ally("Bob") + " and "
                 + ::FFT.ally("Jon")], "hint");
});
