// mode: campaign seed=bbtest-battle fresh=1 launch=edge
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Edge cases of handing control around: charm (hexen), cancel while charmed.

local function state(_bro) {
    return [_bro.getAIAgent().ClassName, "_autopilot" in _bro.m];
}

// One thug that can't fall before round 3, next to Bertel from the first player turn: freed, he has a target in
// reach whatever the rolls; the thug dies once Bertel has acted.
test("charmed on AI: back on autopilot's agent when the charm ends", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local bertel = t.state.bertel <- ::Tales.byName("Bertel");
    local p = ::APT.pilot({
        before = function (_e, t) {
            local thug = ::Tales.hostiles()[0];
            thug.getBaseProperties().Hitpoints += 5000;
            thug.getSkills().update();
            thug.setHitpoints(thug.getHitpointsMax());
            ::Tactical.getNavigator().teleport(thug, ::Tales.freeNear(t.state.bertel), null, null, false);
        },
        each = function (_st, t) {
            if (!("charmed" in t.state.seen) && ::Time.getRound() == 2) {
                ::APT.charm(t.state.bertel);
                t.state.seen.charmed <- state(t.state.bertel);
            }
            if ("charmed" in t.state.seen && !("freed" in t.state.seen) && ::Time.getRound() == 3) {
                t.state.bertel.getSkills().removeByID("effects.charmed");
                t.state.seen.freed <- state(t.state.bertel);
            }
            if ("freed" in t.state.seen && !("killed" in t.state.seen)
                && ::APT.autoUses("Bertel").filter(@(_, u) u.round >= 3).len() > 0) {
                t.state.seen.killed <- true;
                ::Tales.killAll();
            }
        }});
    yield t.battle({entities = ::Tales.thugs(1), player = p.fn, maxFrames = 30000});
    t.eq(seen.charmed, ["charmed_player_agent", true], "charmed");
    t.eq(seen.freed, ["military_melee_agent", true], "the charm ends");
    t.ok(::APT.autoUses("Bertel").filter(@(_, u) u.round >= 3).len() > 0, "acts on AI again");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(state(bertel), ["player_agent", false], "the player's after the battle");
});

test("V while a bro is charmed: the player's own when the charm ends", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local bertel = t.state.bertel <- ::Tales.byName("Bertel");
    local p = ::APT.pilot({each = function (_st, t) {
        if (!("charmed" in t.state.seen) && ::Time.getRound() == 2) {
            ::APT.charm(t.state.bertel);
            t.state.seen.charmed <- true;
            ::Tactical.State.onKeyInput(::APT.key(::APT.Keys.V));
        }
        if ("charmed" in t.state.seen && !("freed" in t.state.seen) && !::Tactical.TurnSequenceBar.m.CancelPending) {
            t.state.bertel.getSkills().removeByID("effects.charmed");
            t.state.seen.freed <- state(t.state.bertel);
            ::Tales.killAll();
        }
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.freed, ["player_agent", false], "the charm ends after the cancel");
});

test("A3: a bro charmed when AI is switched on joins AI when the charm ends", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local bertel = t.state.bertel <- ::Tales.byName("Bertel");
    local p = ::APT.pilot({
        before = function (_e, t) {
            if (_e.getID() == t.state.bertel.getID()) return "pass";
            ::APT.charm(t.state.bertel);
        },
        each = function (_st, t) {
            if (!("freed" in t.state.seen) && ::Time.getRound() == 2) {
                t.state.bertel.getSkills().removeByID("effects.charmed");
                t.state.seen.freed <- state(t.state.bertel);
            }
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.freed, ["military_melee_agent", true], "on autopilot's agent when the charm ends");
    t.ok(::APT.autoUses("Bertel").len() > 0, "acts on AI");
});

// KNOWN_BUGS #34 (fixed in 2.4.0) and the flee hook: retreating while on AI hands the bros to
// vanilla's auto-retreat, and ending their turns then uses no end-of-turn skills.
test("KB34 fixed: retreat while on AI: no end-of-turn skills, the company leaves", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({
        before = function (_e) {
            local torkel = ::Tales.byName("Torkel");
            local xbow = torkel.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
            xbow.setLoaded(false);
            torkel.getItems().unequip(xbow);
            torkel.getItems().equip(xbow);
        },
        each = function (_st, t) {
            local ts = ::Tactical.State;
            if (!("flee" in t.state.seen)) {
                // Not while the AI popup fades out: its onDialogHidden would pop the flee dialog's menu stack entry
                if (::APT.dialogShown()) return false;
                t.state.seen.flee <- ts.topbar_options_onFleeButtonClicked();
                return false;
            }
            if ("after" in t.state.seen) return;
            if (!ts.m.TacticalDialogScreen.isVisible() || ts.m.TacticalDialogScreen.isAnimating()) return false;
            ts.tactical_flee_screen_onFleePressed();
            t.state.seen.after <- [ts.isAutoRetreat(), ::Tactical.TurnSequenceBar.m.IsOnAI,
                           ::Tales.uniq(::APT.company().filter(@(_, b) "_autopilot" in b.m).map(@(b) b.getName()), true)];
            ::APProbe.uses = [];
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.after, [true, false, []], "auto retreat on, autopilot off");
    local bros = ["Bertel", "Torkel", "Wendel"];
    t.eq(::APProbe.uses.filter(@(_, u) u.ok && bros.find(u.who) != null).map(@(u) u.who + ":" + u.what), [],
         "no skills used by the bros while retreating");
    t.eq(t.roster().len(), 3, "nobody lost");
    t.eq(t.result.result, ::Const.Tactical.CombatResult.PlayerRetreated, "the company retreats");
    t.eq(p.st.stuck, [], "no stuck turn");
});

// KNOWN_BUGS #36: a skill hotkey while an autopilot bro's turn runs (input locked)
test("KB36: a skill hotkey during an autopilot turn does nothing", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        if ("state" in t.state.seen) return;
        local e = ::Tactical.TurnSequenceBar.getActiveEntity();
        if (e == null || !("_autopilot" in e.m) || !::Tactical.State.isInputLocked()) return;
        local before = [::Tactical.State.m.CurrentActionState, e.getActionPoints()];
        t.state.seen.handled <- ::Tactical.State.onKeyInput(::APT.key(::APT.Keys.Num1));
        t.state.seen.state <- [before, [::Tactical.State.m.CurrentActionState, e.getActionPoints()]];
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.state[1], seen.state[0], "no skill selected, no AP spent");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});
