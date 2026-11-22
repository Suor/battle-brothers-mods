// mode: campaign seed=bbtest-battle fresh=1 launch=ui
// mods: mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut
// needs: ui

// The obituary screen's real JS with Fun Facts' (ui/mods/fun_facts/world_obituary_screen.js) in the page, in
// Chromium and the original (`needs: ui`; runner README): the tooltip a fallen bro's row shows on hover, from the
// Squirrel side. Page errors fail the test they happen in.

::FFT.uiLoad <- function (_stats) {
    local ff = ::new("scripts/mods/fun_facts/fun_facts");
    _stats.Version <- 3;
    ff.unpack(_stats);
    return ff;
}

// Hover row _idx of the obituary list until the tooltip shows; its lines (title, description,
// texts) after.
::FFT.uiRowTooltip <- function (t, _idx) {
    t.js("$('.tooltip-module').addClass('display-none').removeClass('display-block');"
        + "$('.world-obituary-screen .l-row:eq(" + _idx + ")').trigger('mouseenter')");
    return t.until(@() t.js("$('.tooltip-module').hasClass('display-block')"), 120, "the tooltip shown");
}
::FFT.uiTooltipLines <- function (t) {
    local lines = t.js("$('.tooltip-module').find('.title, .description, .text')"
        + ".map(function () { return $(this).text(); }).get()");
    t.js("$('.world-obituary-screen .l-row').trigger('mouseleave')");
    return lines;
}

test("obituary rows: Fun Facts' tooltip on hover", function (t) {
    local death = {BattleId = 1, IsPlayer = false, Name = "Brigand Thug", ClassName = "bandit_thug", XP = 150,
        Fatality = 0, Day = 1, Self = false};
    local kill = @(n) {BattleId = 1, IsPlayer = false, Name = n, ClassName = "bandit_thug", XP = 150, Fatality = 1, Day = 1,
        Faction = 22, Skill = null, Self = false, Charmed = false};
    local fallen = ::World.Statistics.getFallen();
    fallen.insert(0, {Name = "Old Timer", Time = 1, TimeWithCompany = 1, Kills = 0, Battles = 0,
        KilledBy = "Killed in battle", Expendable = false});
    fallen.insert(0, {Name = "Remembered", Time = 1, TimeWithCompany = 1, Kills = 0, Battles = 0,
        KilledBy = "Killed in battle", Expendable = false, FunFacts = ::FFT.uiLoad({Kills = [kill("A"), kill("B"), kill("C")],
        Deaths = [death]})});
    ::World.State.topbar_options_module_onObituaryButtonClicked();
    yield t.untilJs("$('.world-obituary-screen .l-row').length == 2");
    t.eq(t.js("$('.world-obituary-screen .l-row .name').map(function () { return $(this).text(); }).get()"),
         ["Remembered", "Old Timer"], "rows");
    yield ::FFT.uiRowTooltip(t, 0);
    t.eq(::FFT.uiTooltipLines(t), ["Remembered", ::Tales.tr({en = "Died once", ru = "Помер разок"}), ::Tales.tr({en = "Chopped 3 heads", ru = "Срубил 3 головы"})], "with facts");
    yield ::FFT.uiRowTooltip(t, 1);
    t.eq(::FFT.uiTooltipLines(t), ["Old Timer", ::Tales.tr({en = "Noone remembers anything fun about this dude.", ru = "Никто не помнит ничего забавного об этом парне."})], "without facts");
});
