// mode: campaign seed=bbtest-battle fresh=1 launch=kb
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md repros (KB<n>) and regression tests of the fixed ones (KB<n> fixed), vanilla.
// A KB test describes the correct behaviour and fails while the bug is open.

test("swap quiver: an empty quiver is swapped for a full one from the bag", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.emptyQuiverArcher(["scripts/items/ammo/quiver_of_arrows"]);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        local torkel = ::Tales.byName("Torkel");
        if (!("ammo" in t.state.seen) && torkel.getItems().getItemAtSlot(::Const.ItemSlot.Ammo).getAmmo() > 0)
            t.state.seen.ammo <- ::Time.getRound();
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.ammo, 1, "a full quiver equipped in round 1");
    t.eq(::APT.autoBehaviors("Torkel")[0].what, "autopilot_swap_quiver", "his first AI action");
    t.ok(::APT.autoUses("Torkel").filter(@(_, u) u.what == "actives.quick_shot" || u.what == "actives.aimed_shot").len() > 0,
         "shoots after the swap");
    t.eq(p.st.stuck, [], "no stuck turn");
});

// Quick-switch with ::Autopilot.quickSwitch off (Extra Keybinds / Legends quickly_swap_items)
local function quickSwitchOff(_seen, _how) {
    return function (_e) {
        ::Autopilot.quickSwitch = false;
        ::APT.clearBag(_e);
        local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
        local main = _e.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        local ap = _e.getActionPoints();
        _seen.buttons <- ::Tactical.TurnSequenceBar.convertEntitySkillsToUIData(_e).len()
                         - _e.getSkills().queryActives().len();
        if (_how == "key") ::Tactical.State.onKeyInput(::APT.key(_e.getSkills().queryActives().len() + 1));
        else ::Tactical.State.turnsequencebar_onEntitySkillClicked(dagger.getInstanceID());
        _seen.after <- [_e.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand) == main, ap - _e.getActionPoints()];
        ::Autopilot.quickSwitch = true;
    };
}

test("KB2: quick switch off: the number key past the skills swaps nothing", function (t) {
    ::Tales.toughen(null, true);
    local seen = {};
    local p = ::APT.pilot({before = quickSwitchOff(seen, "key")});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.buttons, 0, "no quick-switch buttons");
    t.eq(seen.after, [true, 0], "weapon kept, no AP spent");
});

test("KB2: quick switch off: a click with a bag item's id swaps nothing", function (t) {
    ::Tales.toughen(null, true);
    local seen = {};
    local p = ::APT.pilot({before = quickSwitchOff(seen, "click")});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.after, [true, 0], "weapon kept, no AP spent");
});

test("KB5: AI pressed with Aimed Shot selected: no selected skill, shots within AP", function (t) {
    ::Tales.toughen(null, true);
    ::APProbe.uses = [];
    ::APProbe.on = false;
    local torkel = ::Tales.byName("Torkel");
    ::Tales.equip(torkel, "scripts/items/weapons/short_bow");
    ::Tales.equip(torkel, "scripts/items/ammo/quiver_of_arrows").setAmmo(10);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({
        before = [
            function (_e, t) {
                if (_e.getName() != "Torkel") return "pass";
                ::APProbe.on = true;
                ::Tactical.State.setActionStateBySkillId("actives.aimed_shot");
                t.state.seen.selected <- ::Tactical.State.m.SelectedSkillID;
            },
        ],
        each = function (_st, t) {
            if (!("stateAfterAI" in t.state.seen)) t.state.seen.stateAfterAI <- [::Tactical.State.m.CurrentActionState, ::Tactical.State.m.SelectedSkillID];
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.ok(seen.selected != null, "aimed shot selected before AI");
    t.eq(seen.stateAfterAI, [null, null], "no action state once on AI");
    local perRound = {};
    foreach (u in ::APProbe.uses) {
        if (!u.ok || u.who != "Torkel" || u.what.find("shot") == null) continue;
        perRound[u.round] <- (u.round in perRound ? perRound[u.round] : 0) + 1;
    }
    t.probe("Torkel's shots per round", perRound);
    local most = 0;
    foreach (r, n in perRound) if (n > most) most = n;
    t.ok(most <= 2, "at most 2 shots a turn with 9 AP, got " + most);
});

// A non-player actor in the player's faction under human control (Legends/SSU summons, NgGH
// beasts): a thug spawned for the player, given a player's agent.
local function humanThug() {
    local thug = ::Tales.unit("BanditThug", "enemies/bandit_thug");
    thug.Faction <- ::Const.Faction.Player;
    return thug;
}
local function takeOverThug() {
    foreach (u in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)) {
        if (::std.Util.isKindOf(u, "player")) continue;
        u.m.IsControlledByPlayer = true;
        local agent = ::new("scripts/ai/tactical/player_agent");
        agent.setActor(u);
        u.setAIAgent(agent);
        u.setName("Ally Thug");
    }
}
local function onThugTurn(_fn) {
    return function (_e) {
        if (::std.Util.isKindOf(_e, "player")) return "pass";
        return _fn(_e);
    };
}

local function thugBattle(_t, _p) {
    return _t.battle({entities = ::Tales.thugs(3), player = _p.fn, maxFrames = 6000,
        setup = function (_props) { _props.Entities.push(humanThug()); _props.AfterDeploymentCallback = takeOverThug; }});
}
// A popup left open (the AI button's) is cancelled once its fade-in is over, before the battle ends
local function endBattle(_st) {
    if (::APT.dialogShown()) { ::APT.cancelDialog(); return false; }
    if (!("killed" in _st)) { _st.killed <- true; ::Tales.killAll(); }
}

test("KB6: quick-switch click on a non-player ally: the item swapped in, AP paid", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onThugTurn(function (_e) {
        ::APT.clearBag(_e);
        local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
        ::Tales.ctx().state.seen.swap <- ::APT.quickSwap(_e, dagger,
            @() ::Tactical.State.turnsequencebar_onEntitySkillClicked(dagger.getInstanceID()));
    })});
    yield thugBattle(t, p);
    t.probe("swap", seen.swap);
    t.eq(seen.swap, {error = null, inHand = true, oldInBag = true, spent = seen.swap.cost, cost = seen.swap.cost},
         "dagger in hand, the old weapon in the bag, AP paid");
});

test("A1: number key past the skills on a non-player ally: no error, nothing swapped (no buttons shown)", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onThugTurn(function (_e) {
        ::APT.clearBag(_e);
        local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
        local n = _e.getSkills().queryActives().len();
        ::Tales.ctx().state.seen.swap <- ::APT.quickSwap(_e, dagger, @() ::Tactical.State.setActionStateBySkillIndex(n));
    })});
    yield thugBattle(t, p);
    t.eq(seen.swap, {error = null, inHand = false, oldInBag = false, spent = 0, cost = seen.swap.cost}, "no error, nothing swapped");
});

test("A2: AI button on a non-player ally's turn: no error", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = onThugTurn(function (_e) {
        ::Tales.ctx().state.seen.error <- ::Tales.tryCall(@() ::Tactical.TurnSequenceBar.onAIButtonPressed());
        ::Tales.ctx().state.seen.popup <- ::APT.dialogShown();
    })});
    yield thugBattle(t, p);
    t.eq(seen.error, null, "no error");
});

test("A2: AI confirmed with a non-player ally in the company: no error, bros on AI", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle,
        before = [
            function (_e) {
                if (!::std.Util.isKindOf(_e, "player")) return "pass";
                ::Tactical.TurnSequenceBar.onAIButtonPressed();
            },
            function (_e, t) {
                if (!::APT.dialogReady()) return false;
                t.state.seen.error <- ::Tales.tryCall(@() ::DialogScreen.onOkPressed());
                t.state.seen.auto <- ::Tales.uniq(::APT.company().filter(@(_, b) "_autopilot" in b.m).map(@(b) b.getName()), true);
                t.state.seen.cancel <- ::Tales.tryCall(@() ::Tactical.TurnSequenceBar.cancelAutoActions());
            },
        ]});
    yield thugBattle(t, p);
    t.eq(seen.error, null, "confirming AI: no error");
    t.eq(seen.auto, ["Bertel", "Torkel", "Wendel"], "the bros on AI");
    t.eq(seen.cancel, null, "KB19 fixed: cancel with a non-player ally: no error");
});

test("KB8: a guest is not automated and doesn't block the turn order", function (t) {
    ::Tales.toughen(null, true);
    ::Tales.byName("Wendel").setGuest(true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        if (!("wendel" in t.state.seen)) t.state.seen.wendel <- "_autopilot" in ::Tales.byName("Wendel").m;
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    ::Tales.byName("Wendel").setGuest(false);
    t.eq(seen.wendel, false, "the guest stays under human control");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("KB9: an ActorRef of a gone ally answers what ai_protect asks", function (t) {
    local ref = ::ActorRef({getName = @() "Gone"});
    t.eq(ref.isAlive(), false, "isAlive");
    t.eq(::Tales.tryCall(@() ref.isTurnDone()), null, "isTurnDone");
    t.eq(::Tales.tryCall(@() ref.getCurrentProperties()), null, "getCurrentProperties");
});

// The popup is shown by an async UI call, so DialogScreen.isVisible() stays false until the UI
// answers; showDialogPopup's own guard lets a second request through meanwhile.
test("KB10: wait-all pressed twice before the popup shows: one Yes clears it", function (t) {
    ::Tales.toughen(null, true);
    t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle,
        before = [
            function (_e, t) {
                ::Tactical.TurnSequenceBar.onWaitTurnAllButtonPressed();
                ::Tactical.TurnSequenceBar.onWaitTurnAllButtonPressed();
                t.state.seen.depth <- [::Tactical.State.m.MenuStack.m.Stack.len()];
            },
            function (_e) { return ::APT.confirmDialog(); },
            function (_e, t) {
                local seen = t.state.seen;
                if (::APT.dialogShown()) return false;  // its fade-out, whose end pops a backstep
                seen.depth.push(::Tactical.State.m.MenuStack.m.Stack.len());
                local stack = ::Tactical.State.m.MenuStack;
                seen.after <- [::APT.dialogShown(), stack.hasBacksteps(), ::Tactical.TurnSequenceBar.m.IsWaitingRound];
                // a stale backstep holds the battle's end (onBattleEndedDelayed) and the keys
                while (stack.hasBacksteps()) stack.pop();
            },
        ]});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 6000});
    local seen = t.state.seen;
    t.probe("menu stack depth after the presses, after Yes", seen.depth);
    t.eq(seen.after, [false, false, true], "popup gone, no menu backstep left, waiting round on");
});

test("KB10: wait-all pressed once: one Yes clears it (control)", function (t) {
    ::Tales.toughen(null, true);
    t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle,
        before = [
            function (_e) { ::Tactical.TurnSequenceBar.onWaitTurnAllButtonPressed(); },
            function (_e) { return ::APT.confirmDialog(); },
            function (_e, t) {
                if (::APT.dialogShown()) return false;
                t.state.seen.after <- [::APT.dialogShown(), ::Tactical.State.m.MenuStack.hasBacksteps(),
                               ::Tactical.TurnSequenceBar.m.IsWaitingRound];
            },
        ]});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 6000});
    local seen = t.state.seen;
    t.eq(seen.after, [false, false, true], "popup gone, no menu backstep left, waiting round on");
});

test("KB4: the active bro's status effects are his own (UI data)", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {effects = {}};
    local p = ::APT.pilot({
        before = function (_e) { ::Tales.byName("Wendel").getSkills().add(::new("scripts/skills/effects/dazed_effect")); },
        each = function (_st, t) {
            local bar = ::Tactical.TurnSequenceBar, e = bar.getActiveEntity();
            if (e == null || ::Time.getRound() != 1 || !::std.Util.isKindOf(e, "player")) return;
            local ids = bar.onQueryEntityStatusEffects(e.getID());
            local own = e.getSkills().m.Skills.map(@(s) s.getID());
            // His tile's effects (terrain.*) are his own too; which he gets depends on the map
            t.state.seen.effects[e.getName()] <- ids == null ? null : ids.map(@(x) x.id).filter(@(_, id) own.find(id) == null);
            if (ids != null && ids.map(@(x) x.id).find("effects.dazed") != null && t.state.seen.dazed.find(e.getName()) == null)
                t.state.seen.dazed.push(e.getName());
        }});
    seen.dazed <- [];
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.effects, {Bertel = [], Torkel = [], Wendel = []},
         "status effects asked for each active bro in round 1 that aren't his");
    t.eq(seen.dazed, ["Wendel"], "the dazed bro is shown dazed");
});

test("KB29 fixed: a weapon breaking mid-battle: the bro takes the spare and fights on", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local bertel = t.state.bertel <- ::Tales.byName("Bertel");
    local axe = t.state.axe <- ::Tales.equip(bertel, "scripts/items/weapons/hand_axe");
    axe.setCondition(1);
    ::APT.clearBag(bertel);
    ::APT.bag(bertel, "scripts/items/weapons/militia_spear");
    local hands = t.state.hands <- [];
    local p = ::APT.pilot({each = function (_st, t) {
        // A hit breaks it only on 50+ armor; breaking it after his first swing doesn't leave that to the rolls
        if (t.state.axe.getCondition() > 0 && ::APT.autoUses("Bertel").len() > 0) t.state.axe.lowerCondition();
        local main = t.state.bertel.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        local h = [main == null ? null : main.getID(), ::APT.autoUses("Bertel").len(), ::Time.getRound()];
        if (t.state.hands.len() == 0 || t.state.hands.top()[0] != h[0]) t.state.hands.push(h);
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    local uses = ::APT.autoUses("Bertel").map(@(u) u.what);
    t.probe("Bertel's skills", uses);
    t.probe("Bertel's mainhand: [id, skills used, round] at each change", hands);
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(hands.top()[0], "weapon.militia_spear", "the spare spear in hand after the axe broke");
    t.ok(uses.find("actives.thrust") != null, "fought on with the spare spear");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// better_attack_default's selectBestTargetAndSkill weighs each (skill, best target) option by
// score ^ 1.9; a negative score (scoreRangedTarget subtracts for allies next to the target) makes
// that NaN, and ::std.Rand.choice then always returns the last option. Driven on the real
// behavior with two stub skills and stub scores.
local function pickWith(_scores) {
    local b = ::new("scripts/ai/tactical/behaviors/ai_attack_default");
    b.m.PossibleSkills = _scores.map(@(s) s.id);
    local skills = {};
    foreach (s in _scores) {
        local s = s;
        skills[s.id] <- {id = s.id, score = s.score, isUsable = @() true, isAffordable = @() true,
            getMinRange = @() 1, getMaxRange = @() 1, getMaxLevelDifference = @() 1, isRanged = @() false};
    }
    local entity = {getTile = @() {Level = 0}, getSkills = @() {getSkillByID = @(id) skills[id]}};
    b.queryTargetsInMeleeRange <- @(_min, _max, _lvl, _tile) ["target"];
    b.queryBestMeleeTarget <- @(_e, _s, _t) {Target = {getTile = @() "tile of " + _s.id}, Score = _s.score};
    local picks = {};
    for (local i = 0; i < 50; i++) {
        b.selectBestTargetAndSkill(entity);
        local id = b.m.Skill.id;
        picks[id] <- (id in picks ? picks[id] : 0) + 1;
    }
    return picks;
}

test("A4: attack choice with a negative-scored option still prefers the good one", function (t) {
    t.eq(pickWith([{id = "good", score = 1.0}, {id = "meh", score = 0.1}]).good > 40, true,
         "control: positive scores, the good one mostly");
    t.eq(pickWith([{id = "good", score = 1.0}, {id = "bad", score = -0.5}]), {good = 50},
         "a good option and one hitting next to an ally: always the good one");
});

// The quick-switch tooltip hook asks the entity for its items whenever vanilla finds no skill.
test("A5: skill tooltip for an entity that is gone: null, as vanilla", function (t) {
    local events = t.state.events <- ::TooltipScreen.getTooltipEvents();
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false, each = endBattle, before = function (_e, t) {
        t.state.seen.unknownSkill <- ::Tales.tryCall(@() t.state.events.onQuerySkillTooltipData(_e.getID(), "actives.no_such_skill"));
        t.state.seen.goneEntity <- ::Tales.tryCall(@() t.state.events.onQuerySkillTooltipData(-1, "actives.no_such_skill"));
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 6000});
    t.eq(seen.unknownSkill, null, "an unknown skill of the active bro: no error");
    t.eq(seen.goneEntity, null, "an entity id no longer in battle: no error");
    local bro = t.roster()[0];
    t.eq(::Tales.tryCall(@() events.onQuerySkillTooltipData(bro.getID(), "actives.no_such_skill")), null,
         "on the world map: no error");
});
