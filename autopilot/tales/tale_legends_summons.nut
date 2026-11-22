// mode: campaign seed=bbtest-battle fresh=1 launch=lsum
// mods: mod_legends==19.4.23 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut lib/legends_helpers.nut

// Autopilot with the real Legends 19.4.23: a necromancer's summon (Legends' own legend_spawn_*
// skill and stash item) is a non-player actor the player controls, the case A1/A2/KB6/KB19 stand in for.

// A popup left open (the AI button's) is cancelled once its fade-in is over, before the battle ends
local function endBattle(_st) {
    if (::APT.dialogShown()) { ::APT.cancelDialog(); return false; }
    if (!("killed" in _st)) { _st.killed <- true; ::Tales.killAll(); }
}
// Steps: Bertel raises a summon on his turn, the bros pass, _fn runs on the summon's turn.
local function onSummonTurn(_seen, _fn, _skill = null, _item = null) {
    return [
        function (_e) {
            if (!::std.Util.isKindOf(_e, "player")) return "pass";
            local s = _skill == null ? ::APL.summon(_e) : ::APL.summon(_e, _skill, _item);
            _seen.summon <- typeof s == "string" ? s : [s.ClassName, s.isPlayerControlled(), s.getAIAgent().ClassName];
            if (typeof s == "string") { ::logInfo("bbtales summon failed: " + s); return "pass"; }
        },
        function (_e) {
            if (!::APL.isSummon(_e)) return "pass";
            return _fn(_e);
        },
    ];
}
local function battle(_t, _p) {
    return _t.battle({entities = ::Tales.thugs(3), player = _p.fn, maxFrames = 8000});
}

test("Legends: AI battle, autopilot plays it through", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local errors = [], restore = ::Tales.catchErrors(errors);
    local p = ::APT.pilot();
    yield t.battle({spawn = "BanditRaiders", resources = 60, player = p.fn, maxFrames = 30000});
    restore();
    t.eq(errors, [], "no errors");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
    t.ok(::APT.autoUses().len() > 0, "the bros act");
    t.probe("quickSwitch (off: Legends integrates quickly_swap_items)", ::Autopilot.quickSwitch);
    t.probe("skills used", ::Tales.uniq(::APT.autoUses().map(@(u) u.what), true));
});

test("A1 Legends: number key past the skills on a Legends skeleton: the item swapped in, AP paid", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onSummonTurn(seen, function (_e) {
        local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
        local n = _e.getSkills().queryActives().len();
        ::Tales.ctx().state.seen.swap <- ::APT.quickSwap(_e, dagger, @() ::Tactical.State.setActionStateBySkillIndex(n));
    })});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.probe("swap", seen.swap);
    t.eq(seen.swap, {error = null, inHand = true, oldInBag = true, spent = seen.swap.cost, cost = seen.swap.cost},
         "dagger in hand, the old weapon in the bag, AP paid");
});

test("KB6 Legends: quick-switch click on a Legends skeleton: the item swapped in, AP paid", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onSummonTurn(seen, function (_e) {
        local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
        ::Tales.ctx().state.seen.swap <- ::APT.quickSwap(_e, dagger,
            @() ::Tactical.State.turnsequencebar_onEntitySkillClicked(dagger.getInstanceID()));
    })});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.probe("swap", seen.swap);
    t.eq(seen.swap, {error = null, inHand = true, oldInBag = true, spent = seen.swap.cost, cost = seen.swap.cost},
         "dagger in hand, the old weapon in the bag, AP paid");
});

test("A2 Legends: AI button on a Legends skeleton's turn: no error", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onSummonTurn(seen, function (_e) {
        ::Tales.ctx().state.seen.error <- ::Tales.tryCall(@() ::Tactical.TurnSequenceBar.onAIButtonPressed());
        ::Tales.ctx().state.seen.popup <- ::APT.dialogShown();
    })});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.probe("popup", seen.popup);
    t.eq(seen.error, null, "no error");
});

test("A2 Legends: AI confirmed with a Legends skeleton in the company: no error, bros on AI; KB19 cancel", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle,
        before = [
            function (_e, t) {
                if (!::std.Util.isKindOf(_e, "player")) return "pass";
                local s = ::APL.summon(_e);
                t.state.seen.summon <- typeof s == "string" ? s : s.ClassName;
                ::Tactical.TurnSequenceBar.onAIButtonPressed();
            },
            function (_e, t) {
                if (!::APT.dialogReady()) return false;
                t.state.seen.error <- ::Tales.tryCall(@() ::DialogScreen.onOkPressed());
                t.state.seen.auto <- ::Tales.uniq(::APT.company().filter(@(_, b) "_autopilot" in b.m).map(@(b) b.getName()), true);
                t.state.seen.cancel <- ::Tales.tryCall(@() ::Tactical.TurnSequenceBar.cancelAutoActions());
            },
        ]});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.eq(seen.error, null, "confirming AI: no error");
    t.eq(seen.auto, ::Tales.uniq(t.roster().map(@(b) b.getName()), true), "the bros on AI");
    t.eq(seen.cancel, null, "KB19 fixed: cancel with a summon: no error");
});

test("A1 Legends: number key past the skills on a Legends zombie: the item swapped in, AP paid", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onSummonTurn(seen, function (_e) {
        local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
        local n = _e.getSkills().queryActives().len();
        ::Tales.ctx().state.seen.swap <- ::APT.quickSwap(_e, dagger, @() ::Tactical.State.setActionStateBySkillIndex(n));
    }, "legend_spawn_zombie_low_skill", "legend_zombie_item")});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.probe("swap", seen.swap);
    t.eq(seen.swap, {error = null, inHand = true, oldInBag = true, spent = seen.swap.cost, cost = seen.swap.cost},
         "dagger in hand, the old weapon in the bag, AP paid");
});
