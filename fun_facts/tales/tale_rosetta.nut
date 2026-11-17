// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_rosetta==0.4.0 mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// The Russian tooltips through Rosetta 0.4.0 (the game runs in English here: the language is
// switched on by hand, the tooltip queried as the JS does on hovering a bro in the roster).

::FFT.ru <- function (_stats) {
    local bro = ::World.getPlayerRoster().getAll()[0];
    local ff = ::new("scripts/mods/fun_facts/fun_facts");
    _stats.Version <- 3;
    ff.unpack(_stats);
    bro.m.FunFacts = ff;
    // Rosetta detects Russian by the game's data_014.dat, which doesn't boot here (bbtales README)
    ::Rosetta.activate("ru");
    local ret = ::FFT.hints(::TooltipScreen.getTooltipEvents().onQueryRosterEntityTooltipData(bro.getID()), 6);
    ::Rosetta.activate(null);
    return ret;
}
::FFT.death <- function (_byBro) {
    return {BattleId = 1, IsPlayer = _byBro, Name = _byBro ? "Bro" : "Brigand Thug",
        ClassName = _byBro ? "player" : "bandit_thug", XP = 150, Fatality = 0, Day = 1, Self = false};
}
::FFT.kill <- function (_name, _fatality, _skill = null) {
    return {BattleId = 1, IsPlayer = true, Name = _name, ClassName = "player", XP = 150,
        Fatality = _fatality, Day = 1, Faction = 1, Skill = _skill, Self = false, Charmed = false};
}

local red = ::FFT.red, ally = ::FFT.ally;

test("Rosetta is loaded with the mod's Russian", function (t) {
    t.eq(::Rosetta.Version, "0.4.0", "Rosetta version");
    t.eq(::FFT.ru({Deaths = [::FFT.death(false)]}), ["Помер разок"], "died once");
});

// KNOWN_BUGS #5, unclear: struck down twice, once by a bro (the reporter's tooltip broke).
test("KB5: died twice, once from a bro, in Russian", function (t) {
    t.eq(::FFT.ru({Deaths = [::FFT.death(false), ::FFT.death(true)]}),
         ["Умер " + red(2) + " раза. Один из них от руки товарища."], "tooltip");
});

// KNOWN_BUGS #9 (HEAD): the hint parts are joined with commas, as are the names within a part.
test("KB9: friendly-fire hint in Russian, parts joined with commas", function (t) {
    local F = ::Const.FatalityType;
    t.eq(::FFT.ru({Kills = [::FFT.kill("Hans", F.Decapitated), ::FFT.kill("Bob", F.None, "actives.thrust")]}),
         ["Нечаянно снёс башку " + ally("Hans") + ", заколол " + ally("Bob")], "tooltip");
    t.eq(::FFT.ru({Kills = [::FFT.kill("Hans", F.Decapitated), ::FFT.kill("Ulf", F.Decapitated),
        ::FFT.kill("Jon", F.Decapitated), ::FFT.kill("Bob", F.None, "actives.thrust")]}).top(),
         "Нечаянно снёс башку " + ally("Hans") + ", " + ally("Ulf") + " и " + ally("Jon") + ", заколол " + ally("Bob"),
         "a list of names");
});

// F6 made English counts of one singular; the Russian must read as before, for one and for many.
test("F6: counts of one and many in Russian", function (t) {
    local inj = {BattleId = 1, Injury = "cut_arm", AttackerClass = "bandit_thug", AttackerName = "Brigand Thug",
        TargetClass = "bandit_thug", TargetName = "Brigand Thug", Day = 1};
    local battle = @(_fled, _added = {}) {Id = 1, Kills = 0, XPGained = 100, Fled = _fled, Returned = 0,
        Start = {Effects = [], Injured = false, Drugged = false, HpPct = 100}, Added = _added};
    local skipped = {Id = 1, Effects = [], Injured = false, Drugged = false, HpPct = 100};
    t.eq(::FFT.ru({Injuries = [inj], InjuriesDealt = [inj, inj]}),
         ["Получил " + red(1) + " травму", "Нанёс " + red(2) + " травмы"], "injuries");
    t.eq(::FFT.ru({BattlesLog = [battle(1)]}), ["Бежал " + red(1) + " раз в " + red(1) + " битвах"], "fled once");
    t.eq(::FFT.ru({BattlesLog = [battle(2), battle(1)]}), ["Бежал " + red(3) + " раза в " + red(2) + " битвах"], "fled");
    t.eq(::FFT.ru({BattlesSkipped = 1, Battles = 0, CombatsSkipped = [skipped]}),
         ["Профилонил 1 битву из 1"], "slacked once");
    t.eq(::FFT.ru({BattlesSkipped = 2, Battles = 1, CombatsSkipped = [skipped, skipped]}),
         ["Профилонил 2 битвы из 3"], "slacked");
    t.eq(::FFT.ru({BattlesLog = [battle(0, {stunned = 1, net = 2})]}), ["Был спутан 2 раза, оглушён 1 раз"], "effects");
    t.eq(::FFT.ru({BattlesLog = [battle(0, {net = 1, stunned = 3})]}), ["Был спутан 1 раз, оглушён 3 раза"], "effects");
});

test("F2: kill verbs in Russian", function (t) {
    local F = ::Const.FatalityType;
    t.eq(::FFT.ru({Kills = [::FFT.kill("Hans", F.Disemboweled)]}), ["Нечаянно выпотрошил " + ally("Hans")], "gutted");
    t.eq(::FFT.ru({Kills = [::FFT.kill("Bob", F.Smashed)]}), ["Нечаянно размозжил башку " + ally("Bob")], "smashed");
});
