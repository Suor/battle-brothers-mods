// Helpers of the UI page tests (tale_ui_page.nut, tale_ui_page_vanilla.nut) and the KNOWN_BUGS #4 test they share.

// The turn bar's status effect icons as shown: none while the container is hidden.
::UIPage <- {};
::UIPage.SHOWN_EFFECTS <- @"(function () {
    var c = $('.status-effects-container');
    if (!c.length || c.css('display') == 'none' || +c.css('opacity') == 0) return [];
    return c.find('.l-status-effect img').map(function () { return this.getAttribute('src').split('/').pop(); }).get();
})()";

::UIPage.basename <- function (_path) {
    return split(_path, "/").top();
}

// Plays the company's turns: on each player turn runs _step(t, e, frame) every frame until it
// returns true, then ends the turn. Ends the battle (kills the hostiles) once _done(t) holds.
::UIPage.stepper <- function (_step, _done) {
    local st = {turnOf = null, frame = 0, ended = false};
    return function () {
        if (st.ended || !::APT.playerTurnReady()) return;
        local t = ::Tales.ctx();
        if (_done(t)) { st.ended = true; ::Tales.killAll(); return; }
        local bar = ::Tactical.TurnSequenceBar, e = bar.getActiveEntity();
        if (st.turnOf != e.getID()) { st.turnOf = e.getID(); st.frame = 0; }
        if (_step(t, e, st.frame++)) bar.onNextTurnButtonPressed();
    };
}

// KNOWN_BUGS #4: the status bar after a tile hover's cost preview (which calls showStatsPanel)
// shows the active bro's own effect icons.
::UIPage.kb4 <- function (t) {
    ::Tales.toughen(null, true);
    // Neutral mood: no roll for a Confident start (its morale icon), so only the effects given here show
    foreach (bro in t.roster()) bro.m.Mood = ::Const.MoodState.Neutral + 0.5;
    // Torkel acts first (Killing Frenzy keeps his initiative), Bertel with no effects after him
    ::Tales.byName("Torkel").getSkills().add(::new("scripts/skills/effects/killing_frenzy_effect"));
    ::Tales.byName("Wendel").getSkills().add(::new("scripts/skills/effects/dazed_effect"));
    t.state.seen <- {};
    local player = ::UIPage.stepper(function (t, _e, _frame) {
        local seen = t.state.seen;
        local bar = ::Tactical.TurnSequenceBar;
        // A tile hover: its movement costs previewed.
        if (_frame == 0) { bar.setActiveEntityCostsPreview({ActionPoints = 2, Fatigue = 2}); return false; }
        if (_frame < 5) return false;
        local own = bar.onQueryEntityStatusEffects(_e.getID());
        // His morale (special.morale.check) is shown when not steady: Confident is status_effect_14
        own = own == null ? [] : own.map(@(x) ::UIPage.basename(x.imagePath));
        if (!(_e.getName() in seen)) seen[_e.getName()] <- {own = own, shown = t.js(::UIPage.SHOWN_EFFECTS)};
        bar.resetActiveEntityCostsPreview();
        return true;
    }, @(t) t.state.seen.len() == 3 || ::Time.getRound() > 2);
    yield t.battle({entities = ::Tales.thugs(3), player = player, maxFrames = 30000});
    local seen = t.state.seen;
    t.probe("own and shown", seen);
    foreach (name, s in seen) t.eq(s.shown, s.own, name + ": the icons shown are his own");
}
