// mode: campaign seed=bbtest-battle fresh=1 launch=lbugs
// mods: mod_legends==19.4.23 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut lib/legends_helpers.nut

// KNOWN_BUGS #9 with the real Legends 19.4.23: its ai_engage_melee asks known allies isTurnDone(),
// and Autopilot wraps known allies in ActorRef, whose stand-in for a gone ally (ActorFake) lacks it.

test("KB9 Legends: an unarmed bro on AI ends his turns, no error", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local bro = t.roster()[0];
    local main = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    if (main != null) bro.getItems().unequip(main);
    local errors = [], restore = ::Tales.catchErrors(errors);
    local p = ::APT.pilot();
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    restore();
    t.probe("unarmed bro's skills used", ::Tales.uniq(::APT.autoUses(bro.getName()).map(@(u) u.what), true));
    t.eq(errors, [], "no errors");
    t.eq(p.st.stuck, [], "no stuck turn");
});

// A known ally gone from memory mid-battle (its weak ref nulled, as the original's refcounting does
// on death; this engine collects only at battle end, runner README) is what ActorRef guards against.
test("KB9 Legends: engage melee with a gone known ally evaluates without an error", function (t) {
    ::Tales.toughen(null, true);
    local bros = t.roster();
    local pikeman = t.state.pikeman <- bros[bros.len() - 1];
    ::Tales.equip(pikeman, "scripts/items/weapons/pike");
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        // Not `{ ... } return;` on one line: 3.0 wants a statement after an if-block on a line of its own.
        if ("error" in t.state.seen) {
            if (!("k" in t.state.seen)) { t.state.seen.k <- 1; ::Tales.killAll(); }
            return;
        }
        if (!("_autopilot" in t.state.pikeman.m)) return;
        local agent = t.state.pikeman.getAIAgent();
        local b = agent.getBehavior(::Const.AI.Behavior.ID.EngageMelee);
        local warnings = [], logWarning = ::logWarning;
        ::logWarning = function (_m) { warnings.push(_m); };
        t.state.seen.error <- ::Tales.tryCall(function () {
            agent.m.KnownAllies = [::ActorRef(null)];
            foreach (u in ::APT.company()) if (u != t.state.pikeman) agent.m.KnownAllies.push(::ActorRef(u));
            local g = b.onEvaluate(t.state.pikeman);
            if (typeof g == "generator") while (g.getstatus() != "dead") resume g;
        });
        ::logWarning = logWarning;
        t.state.seen.warnings <- warnings.filter(@(_, w) w.find("ActorRef") != null);
        t.state.seen.idealRange <- t.state.pikeman.getIdealRange();
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 8000});
    t.probe("ideal range", seen.idealRange);
    t.probe("ActorRef warnings", seen.warnings);
    t.eq(seen.error, null, "no error");
});

test("KB21 Legends: a bro with Legends' unarmed mastery gets no pick-up-weapon behavior on AI", function (t) {
    ::Tales.toughen(null, true);
    local bro = t.state.bro <- t.roster()[0];
    local main = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    if (main != null) bro.getItems().unequip(main);
    local perk = ::new("scripts/skills/perks/perk_legend_mastery_unarmed");
    bro.getSkills().add(perk);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        if ("pickup" in t.state.seen || !("_autopilot" in t.state.bro.m)) return;
        t.state.seen.pickup <- t.state.bro.getAIAgent().getBehavior(::Const.AI.Behavior.ID.PickupWeapon) != null;
        ::Tales.killAll();
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 8000});
    t.probe("perk id", perk.getID());
    t.eq(seen.pickup, false, "no PickupWeapon behavior");
});

test("KB36 Legends: a skill hotkey during an autopilot turn does nothing", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        if ("state" in t.state.seen) return;
        local e = ::Tactical.TurnSequenceBar.getActiveEntity();
        if (e == null || !("_autopilot" in e.m) || !::Tactical.State.isInputLocked()) return;
        local before = [::Tactical.State.m.CurrentActionState, e.getActionPoints()];
        t.state.seen.error <- ::Tales.tryCall(function () { t.state.seen.handled <- ::Tactical.State.onKeyInput(::APT.key(::APT.Keys.Num1)); });
        t.state.seen.state <- [before, [::Tactical.State.m.CurrentActionState, e.getActionPoints()]];
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.error, null, "no error");
    t.eq(seen.state[1], seen.state[0], "no skill selected, no AP spent");
    t.eq(p.st.stuck, [], "no stuck turn");
});

test("KB16 fixed Legends: a bag item shows one quick-switch button, not two", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = function (_st, t) { if (!("k" in t.state.seen)) { t.state.seen.k <- 1; ::Tales.killAll(); } },
        before = function (_e, t) {
            if (!::std.Util.isKindOf(_e, "player")) return "pass";
            ::APT.clearBag(_e);
            local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
            local ui = ::Tactical.TurnSequenceBar.convertEntitySkillsToUIData(_e);
            t.state.seen.buttons <- ui.filter(@(_, b) b.id == dagger.getInstanceID()).len();
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 8000});
    t.eq(seen.buttons, 1, "one button for the dagger");
});
