// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_career_stats==1.0.2 mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut
// needs: ui

// KNOWN_BUGS #8 in the page, in Chromium and the original (`needs: ui`; runner README): Career Stats 1.0.2 and
// Fun Facts both bind a tooltip to each obituary row (MSU 'msu-generic', elementId "Fallen"); vanilla's
// bindToElement unbinds what was bound before, so the row shows only the last mod's (Fun Facts loads after
// Career Stats). Correct: hovering a fallen bro's row shows both mods' lines.

// Whether every text shows among the tooltip's lines: up to its first BBCode tag (colours and images
// render as markup).
local function showsAll(_lines, _texts) {
    foreach (text in _texts) {
        local at = text.find("[");
        local prefix = at == null ? text : text.slice(0, at);
        local found = false;
        foreach (l in _lines) if (l.find(prefix) == 0) found = true;
        if (!found) return false;
    }
    return true;
}

local function hasLine(_lines, _s) {
    foreach (l in _lines) if (l.find(_s) != null) return true;
    return false;
}

test("KB8: a fallen bro's obituary row shows both mods' tooltips", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local victim = t.roster()[0], hero = t.roster()[1];
    t.state.victim <- victim;
    t.state.hero <- hero;
    local name = victim.getName();
    ::FFT.setSurvival(victim, false);
    yield t.battle({entities = ::Tales.thugs(2), player = ::Tales.scripted([
        @(t) ::FFT.hit(::Tales.hostiles()[0], t.state.hero, 20),
        function (t) { local thug = ::Tales.hostiles()[0]; t.state.victim.kill(thug, ::Tales.attack(thug), ::Const.FatalityType.None); },
        @(t) ::Tales.killAll(t.state.hero)
    ])});
    local idx = ::FFT.fallenByName(name);
    t.eq(idx, 0, "the victim is the latest fallen");
    ::World.State.topbar_options_module_onObituaryButtonClicked();
    yield t.untilJs("$('.world-obituary-screen .l-row').length == 1");
    t.hover(".world-obituary-screen .l-row");
    yield t.untilJs("$('.tooltip-module').hasClass('display-block')", 120);
    local lines = t.js("$('.tooltip-module').find('.title, .description, .text').map(function () { return $(this).text(); }).get()");
    local ff = ::FFT.fallenHints(idx), cs = ::FFT.obituaryTooltip(idx, "mod_career_stats", "CareerStats_Idx").slice(1);
    t.eq({FunFacts = showsAll(lines, ff), CareerStats = showsAll(lines, cs)},
         {FunFacts = true, CareerStats = true}, "the row's tooltip has every line of both mods");
});

// The bro popup (a 'roster-entity' tooltip) is built in Squirrel by both mods' getRosterTooltip hooks.
test("KB8: a bro's popup in the character screen shows both mods' lines", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local hero = t.roster()[0];
    t.state.hero <- hero;
    yield t.battle({entities = ::Tales.thugs(2), player = ::Tales.scripted([
        @(t) ::FFT.hit(::Tales.hostiles()[0], t.state.hero, 20),
        @(t) ::Tales.killAll(t.state.hero)
    ])});
    hero = ::Tales.byName(hero.getName());
    ::World.State.showCharacterScreen();
    yield t.untilJs("$('.is-brother-slot .brother').length > 0");
    t.hover(".is-brother-slot .brother");
    yield t.untilJs("$('.tooltip-module').hasClass('display-block')", 120);
    // Let the screen and the tooltip finish fading in before the shot
    yield t.untilJs("(window.ffShotWait = (window.ffShotWait || 0) + 1) > 60", 120);
    t.shot("bro_popup");
    local lines = t.js("$('.tooltip-module').find('.title, .description, .text').map(function () { return $(this).text(); }).get()");
    t.probe("bro popup lines", lines);
    t.eq({FunFacts = hasLine(lines, "Inflicted"), CareerStats = hasLine(lines, "DMG Dealt")}, {FunFacts = true, CareerStats = true},
         "the popup has both mods' lines");
});
