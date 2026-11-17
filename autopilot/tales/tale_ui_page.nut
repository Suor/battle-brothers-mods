// mode: campaign seed=bbtest-battle fresh=1 launch=ui
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// needs: ui
// include: lib/helpers.nut lib/ui_page_body.nut

// The mod's JS in the real UI page, in Chromium and the original (`needs: ui`; runner README): the buttons
// Autopilot adds to the turn bar with their tooltips, and KNOWN_BUGS #4. Page errors fail the test they happen in.

local BAR = "Screens.TacticalScreen.getModule('TurnSequenceBarModule')";
local BUTTONS = [["mWaitAll", "WaitTurnAllButton"], ["mCancel", "CancelButton"], ["mShieldWall", "ShieldWallButton"],
                 ["mIgnore", "IgnoreButton"], ["mAI", "AIButton"]];

// Hover the element `_js` evaluates to (a jQuery object), as the mouse does: the tooltip shows
// after its delay, once the Squirrel side has answered.
local function hover(_t, _js) {
    _t.js("$('.tooltip-module').addClass('display-none').removeClass('display-block');"
        + "(" + _js + ").trigger('mouseenter')");
}

local function tooltipShown(_t) {
    return _t.js("$('.tooltip-module').hasClass('display-block') ? [$('.tooltip-module .title').text(),"
        + " $('.tooltip-module .description').text()] : null");
}

// Plays the first player turn: notes the buttons, then hovers each, noting its tooltip (t.state.seen).
local function buttonsPlayer(t) {
    local seen = t.state.seen, st = t.state;
    if (!::APT.playerTurnReady()) return;
    if (seen.buttons == null) {
        seen.buttons = BUTTONS.map(@(b) t.js("(function (b) { var img = b.find('img');"
            + " return [b.closest('body').length, b.parent().hasClass('l-button'),"
            + " img.attr('src').split('/').pop()]; })(" + BAR + "." + b[0] + ".button)"));
    }
    if (st.i >= BUTTONS.len()) {
        ::Tales.killAll();
        return;
    }
    local b = BUTTONS[st.i];
    if (st.frames == 0) hover(t, BAR + "." + b[0] + ".button");
    st.frames++;
    local shown = tooltipShown(t);
    if (shown != null || st.frames > 120) {
        seen.tooltips[b[1]] <- shown;
        t.js(BAR + "." + b[0] + ".button.trigger('mouseleave')");
        st.i++;
        st.frames = 0;
    }
}

test("Autopilot's buttons in the turn bar, with their tooltips", function (t) {
    ::Tales.toughen(null, true);
    t.state.seen <- {buttons = null, tooltips = {}};
    t.state.i <- 0;
    t.state.frames <- 0;
    yield t.battle({entities = ::Tales.thugs(3), player = buttonsPlayer, fight = false, maxFrames = 6000});
    local seen = t.state.seen;
    t.eq(seen.buttons, [[1, true, "icon_wait_all.png"], [1, true, "icon_cross.png"], [1, true, "icon_shieldwall_all.png"],
                        [1, true, "icon_ignore_bro.png"], [1, true, "icon_AI.png"]], "in the page, as image buttons");
    local expected = {};
    foreach (b in BUTTONS) {
        local tip = ::Autopilot.Tooltips["tactical-screen.turn-sequence-bar-module." + b[1]];
        expected[b[1]] <- [tip[0].text, tip[1].text];
    }
    t.eq(seen.tooltips, expected, "tooltips shown on hover");
});

test("KB4: after a tile hover the status bar shows the active bro's own effects", ::UIPage.kb4);
