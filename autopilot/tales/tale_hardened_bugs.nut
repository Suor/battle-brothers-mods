// mode: campaign seed=bbtest-battle fresh=1 launch=hardened
// mods: mod_hardened==1.26.3 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut lib/legends_helpers.nut lib/kb31_body.nut

// Autopilot with the real Reforged 0.9.3 + Hardened 1.26.3: KNOWN_BUGS #31, #32, #33.

test("KB32: AI battle under Reforged 0.9.3 + Hardened: autopilot plays it through", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local errors = [], restore = ::Tales.catchErrors(errors);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        if ("agents" in t.state.seen) return;
        t.state.seen.agents <- {};
        foreach (b in ::APT.company()) {
            local a = b.getAIAgent();
            t.state.seen.agents[b.getName()] <- a == null ? 0 : a.m.Behaviors.len();
        }
    }});
    yield t.battle({spawn = "BanditRaiders", resources = 60, player = p.fn, maxFrames = 30000});
    restore();
    t.probe("behaviors per bro", seen.agents);
    t.eq(::Tales.withoutRfAI(errors), [], "no errors");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
    t.ok(::APT.autoUses().len() > 0, "the bros act");
    t.probe("skills used", ::Tales.uniq(::APT.autoUses().map(@(u) u.what), true));
});

test("KB33: Throwing Mastery with a free swap: quick-switch buttons and the swap-quiver check work", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = function (_st, t) { if (!("k" in t.state.seen)) { t.state.seen.k <- 1; ::Tales.killAll(); } },
        before = function (_e, t) {
            if (!::std.Util.isKindOf(_e, "player")) return "pass";
            local skills = _e.getSkills();
            if (!skills.hasSkill("perk.mastery.throwing")) skills.add(::new("scripts/skills/perks/perk_mastery_throwing"));
            local perk = skills.getSkillByID("perk.mastery.throwing");
            perk.m.HasQuickSwitch = true;
            local items = _e.getItems();
            local main = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
            if (main != null) items.unequip(main);
            ::APT.clearBag(_e);
            local axes = ::APT.bag(_e, "scripts/items/weapons/throwing_axe");
            local errors = [], restore = ::Tales.catchErrors(errors);
            t.state.seen.ui <- ::Tales.tryCall(function () { t.state.seen.n <- ::Tactical.TurnSequenceBar.convertEntitySkillsToUIData(_e).len(); });
            t.state.seen.one <- ::Tales.tryCall(function () { t.state.seen.costOne <- items.isActionAffordable([axes]); });
            t.state.seen.none <- ::Tales.tryCall(function () { t.state.seen.costNone <- items.isActionAffordable([]); });
            t.state.seen.switchable <- ::Tales.tryCall(function () { t.state.seen.items <- _e.querySwitchableItems().map(@(i) i.getID()); });
            restore();
            t.state.seen.errors <- errors;
            t.state.seen.hasPerk <- perk.m.HasQuickSwitch;
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 8000});
    t.probe("free swap on", seen.hasPerk);
    t.probe("switchable", "items" in seen ? seen.items : null);
    t.probe("affordable [axe], []", ["costOne" in seen ? seen.costOne : null, "costNone" in seen ? seen.costNone : null]);
    t.eq([seen.ui, seen.one, seen.none, seen.switchable], [null, null, null, null], "no error");
    t.eq(seen.errors, [], "nothing logged");
});

test("KB31 Hardened: an enemy at full fatigue with a free attack evaluates attack_default without an error", ::KB31);
