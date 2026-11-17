// mode: campaign seed=bbtest-battle fresh=1 launch=reforged
// mods: mod_reforged==0.9.3 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Autopilot with Reforged 0.9.3. Reforged AI battles aren't deterministic (runner README).

// Bros by their starting weapons
local function bro(_weapon) {
    foreach (b in ::World.getPlayerRoster().getAll()) {
        local w = b.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (w != null && w.getID() == _weapon) return b;
    }
}
local Spear = "weapon.militia_spear", Axe = "weapon.woodcutters_axe";

test("AI battle under Reforged: autopilot plays it through", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local errors = [], restore = ::Tales.catchErrors(errors);
    local p = ::APT.pilot();
    yield t.battle({spawn = "BanditRaiders", resources = 60, player = p.fn, maxFrames = 30000});
    restore();
    t.eq(::Tales.withoutRfAI(errors), [], "no errors");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
    t.eq(::Tales.uniq(::APT.autoUses().map(@(u) u.who), true).len() > 0, true, "the bros act");
    t.probe("skills used", ::Tales.uniq(::APT.autoUses().map(@(u) u.what), true));
});

// KNOWN_BUGS #3. The bro's first turn, ended by hand with all AP left: Recover (auto, at the
// end of turn) should reset Unstoppable as Recover used by hand does.
local function unstoppable(_seen, _byHand) {
    return function (_e) {
        local skills = _e.getSkills();
        if (!skills.hasSkill("perk.rf_unstoppable")) skills.add(::new("scripts/skills/perks/perk_rf_unstoppable"));
        if (!skills.hasSkill("perk.recover")) skills.add(::new("scripts/skills/perks/perk_recover"));
        local perk = skills.getSkillByID("perk.rf_unstoppable");
        perk.m.Stacks = 3;
        _e.setFatigue(40);
        _seen.who <- _e.getName();
        _seen.active <- [];
        // Whether the bro is the turn bar's active entity when Recover runs
        local recover = skills.getSkillByID("actives.recover");
        local use = recover.use;
        recover.use <- function (_tile, _forFree = false) {
            local active = ::Tactical.TurnSequenceBar.isActiveEntity(_e);
            local ret = use(_tile, _forFree);
            if (ret) _seen.active.push(active);
            return ret;
        };
        if (_byHand) recover.use(_e.getTile());
        _seen.perk <- perk;
    };
}

test("KB3: auto Recover at the end of turn resets Reforged Unstoppable", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local errors = [], restore = ::Tales.catchErrors(errors);
    local p = ::APT.pilot({press = false, each = @(_st) ::Tales.killAll(),
        before = [unstoppable(seen, false), @(_e) ::Tactical.TurnSequenceBar.onNextTurnButtonPressed(),
                  @(_e, t) t.state.seen.stacks <- t.state.seen.perk.m.Stacks]});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 6000});
    restore();
    t.probe("who", seen.who);
    t.eq(seen.active, [false], "Recover used once, with the bro not the active entity");
    t.eq(seen.stacks, 0, "Unstoppable stacks after an auto Recover");
});

test("KB3 control: Recover used by hand resets Unstoppable", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local errors = [], restore = ::Tales.catchErrors(errors);
    local p = ::APT.pilot({press = false, each = @(_st) ::Tales.killAll(),
        before = [unstoppable(seen, true), @(_e) ::Tactical.TurnSequenceBar.onNextTurnButtonPressed(),
                  @(_e, t) t.state.seen.stacks <- t.state.seen.perk.m.Stacks]});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 6000});
    restore();
    t.eq(seen.active, [true], "Recover used once, by the active bro");
    t.eq(seen.stacks, 0, "Unstoppable stacks after Recover by hand");
});

// Whether the net is thrown in a Reforged AI battle varies run to run, so the fix is checked on the
// agent (no ThrowNet behavior when "Throw Nets" is off), the throws over the battle are a probe.
local function netBattle(_t, _nets, _seen) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.setting("nets", _nets);
    local wendel = bro(Spear);
    _seen.name <- wendel.getName();
    ::Tales.equip(wendel, "scripts/items/tools/throwing_net");
    local errors = [], restore = ::Tales.catchErrors(errors);
    local p = ::APT.pilot({each = function (_st) {
        if (!("behavior" in _seen) && "_autopilot" in wendel.m)
            _seen.behavior <- wendel.getAIAgent().getBehavior(::Const.AI.Behavior.ID.ThrowNet) != null;
    }});
    local b = _t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    local done = b.done;
    b.done = function () { done.call(this); restore(); ::APT.resetSettings(); };
    return b;
}

test("KB12 fixed: 'Throw Nets' off: Reforged's net (AIBehaviorID) isn't thrown", function (t) {
    local seen = {};
    yield netBattle(t, false, seen);
    t.eq(seen.behavior, false, "no ThrowNet behavior");
    t.eq(::APT.autoUses(seen.name).filter(@(_, u) u.what == "actives.throw_net").len(), 0, "no net thrown");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("KB12 control: 'Throw Nets' on: the net can be thrown", function (t) {
    local seen = {};
    yield netBattle(t, true, seen);
    t.eq(seen.behavior, true, "a ThrowNet behavior");
    t.probe("nets thrown", ::APT.autoUses(seen.name).filter(@(_, u) u.what == "actives.throw_net").len());
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("KB20 fixed: swordstaff bro (attacks of two ranges) attacks, not skips", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local bertel = bro(Axe), name = bertel.getName();
    ::Tales.equip(bertel, "scripts/items/weapons/rf_swordstaff");
    local errors = [], restore = ::Tales.catchErrors(errors);
    local p = ::APT.pilot();
    yield t.battle({entities = ::Tales.thugs(4), player = p.fn, maxFrames = 30000});
    restore();
    local uses = ::APT.autoUses(name).map(@(u) u.what);
    t.probe("swordstaff skills", ::Tales.uniq(uses, true));
    t.ok(uses.len() > 0, "the swordstaff bro attacks");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("KB35 fixed: tooltips of Autopilot's turn bar buttons under Reforged", function (t) {
    local events = ::TooltipScreen.getTooltipEvents(), out = {};
    foreach (id, _ in ::Autopilot.Tooltips)
        out[id] <- events.general_queryUIElementTooltipData(null, id, null).map(@(x) x.type);
    local want = {};
    foreach (id, _ in ::Autopilot.Tooltips) want[id] <- ["title", "description"];
    t.eq(out, want, "title and description for each button");
});
