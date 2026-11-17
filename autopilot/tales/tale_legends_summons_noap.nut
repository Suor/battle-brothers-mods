// mode: campaign seed=bbtest-battle fresh=1 launch=lsumv
// mods: mod_legends==19.4.23 stdlib@dev
// include: lib/helpers.nut lib/legends_helpers.nut

// Control for tale_legends_summons.nut: the same quick-switch input on a Legends summon without Autopilot
// (Legends 19.4 has quickly_swap_items integrated, with its own swapToItem).

local function endBattle(_st) {
    if (!("killed" in _st)) { _st.killed <- true; ::Tales.killAll(); }
}
// Steps: Bertel raises a summon on his turn, the bros pass, _fn runs on the summon's turn.
local function onSummonTurn(_seen, _fn, _skill = null, _item = null) {
    return [
        function (_e) {
            if (!::std.Util.isKindOf(_e, "player")) return "pass";
            local s = _skill == null ? ::APL.summon(_e) : ::APL.summon(_e, _skill, _item);
            _seen.summon <- typeof s == "string" ? s : [s.ClassName, s.isPlayerControlled(), s.getAIAgent().ClassName];
            if (typeof s == "string") return "pass";
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

test("A1 Legends without Autopilot: number key past the skills on a Legends skeleton: no error", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onSummonTurn(seen, function (_e) {
        ::APT.bag(_e, "scripts/items/weapons/dagger");
        local n = _e.getSkills().queryActives().len();
        ::Tales.ctx().state.seen.error <- ::Tales.tryCall(@() ::Tactical.State.setActionStateBySkillIndex(n));
    })});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.eq(seen.error, null, "no error");
});

test("KB6 Legends without Autopilot: quick-switch click on a Legends skeleton: no error", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onSummonTurn(seen, function (_e) {
        local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
        ::Tales.ctx().state.seen.error <- ::Tales.tryCall(@() ::Tactical.State.turnsequencebar_onEntitySkillClicked(dagger.getInstanceID()));
    })});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.eq(seen.error, null, "no error");
});

test("A1 Legends without Autopilot: number key past the skills on a Legends zombie: no error", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onSummonTurn(seen, function (_e) {
        ::APT.bag(_e, "scripts/items/weapons/dagger");
        local n = _e.getSkills().queryActives().len();
        ::Tales.ctx().state.seen.error <- ::Tales.tryCall(@() ::Tactical.State.setActionStateBySkillIndex(n));
    }, "legend_spawn_zombie_low_skill", "legend_zombie_item")});
    yield battle(t, p);
    t.probe("summon", seen.summon);
    t.eq(seen.error, null, "no error");
});
