// mode: campaign seed=bbtest-battle fresh=1 launch=core
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Core: the AI button hands the company to Autopilot's own agents, which play whole battles.

// Who has what agent, right after the AI popup is confirmed.
local function agents() {
    local out = {};
    foreach (bro in ::APT.company()) {
        local a = bro.getAIAgent();
        out[bro.getName()] <- {
            agent = a == null ? null : a.ClassName,
            mode = "_autopilot" in bro.m ? clone bro.m._autopilot : null,
            runner = "__autoplayHanded" in bro.m,
            controlled = bro.m.IsControlledByPlayer,
        };
    }
    return out;
}

test("company", function (t) {
    local gear = {};
    foreach (bro in t.roster()) {
        local main = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        gear[bro.getName()] <- main == null ? null : main.getID();
    }
    t.eq(gear, {Bertel = "weapon.woodcutters_axe", Torkel = "weapon.light_crossbow", Wendel = "weapon.militia_spear"},
         "starting company of the seed, the other tests rely on it");
});

test("AI button: autopilot's agents play a whole battle", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (st, t) {
        if (!("agents" in t.state.seen)) t.state.seen.agents <- agents();
    }});
    yield t.battle({spawn = "BanditRaiders", resources = 60, player = p.fn, maxFrames = 30000});
    ::APProbe.on = false;
    t.eq(seen.agents, {
        Bertel = {agent = "military_melee_agent", controlled = true, runner = false,
                  mode = {agent = "military_melee", ranged = false, throwing = false}},
        Torkel = {agent = "military_ranged_agent", controlled = true, runner = false,
                  mode = {agent = "military_ranged", ranged = true, throwing = false}},
        Wendel = {agent = "military_melee_agent", controlled = true, runner = false,
                  mode = {agent = "military_melee", ranged = false, throwing = false}},
    }, "agents after the AI popup");
    t.eq(p.st.stuck, [], "no turn longer than 40 s");
    t.eq(t.result.survivors.enemies, 0, "company wins");
    t.eq(p.st.retreatDialogs, 0, "no 'enemy retreats' dialog while on AI");
    local attackers = ::Tales.uniq(::APT.autoUses().filter(@(_, u) u.what != "actives.recover"
        && u.what != "actives.reload_bolt").map(@(u) u.who), true);
    t.eq(attackers, ["Bertel", "Torkel", "Wendel"], "every bro attacked on AI");
    t.probe("skills used", ::Tales.uniq(::APT.autoUses().map(@(u) u.what), true));
    t.probe("behaviors", ::Tales.uniq(::APT.autoBehaviors().map(@(u) u.what), true));
    t.probe("result", t.result);
    t.probe("turns", p.st.turns);
    // Back on the world map the bros are the player's again
    local after = {};
    foreach (bro in t.roster())
        after[bro.getName()] <- [bro.getAIAgent().ClassName, "_autopilot" in bro.m, "_oldAgent" in bro.m];
    t.eq(after, {Bertel = ["player_agent", false, false], Torkel = ["player_agent", false, false],
                 Wendel = ["player_agent", false, false]}, "AI control gone after the battle");
});

// Finishes the battle on AI once _cond() holds: presses AI on the next human turn and confirms.
local function thenAI(_cond) {
    local st = {pressed = false};
    return function (_pst) {
        if (st.pressed) {
            if (::APT.confirmDialog()) st.pressed = "confirmed";
            return st.pressed == "confirmed";
        }
        if (!_cond()) return true;
        if (!::APT.playerTurnReady() || !::APT.humanTurn(::Tactical.TurnSequenceBar.getActiveEntity()))
            return true;
        ::Tactical.TurnSequenceBar.onAIButtonPressed();
        st.pressed = true;
        return false;
    };
}

test("Q hotkey turns AI on, V cancels it, AI again finishes the battle", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local cancel = t.state.cancel <- {state = "wait"};
    local p = ::APT.pilot({press = false,
        before = [
            function (_e, t) { t.state.seen.handled <- ::Tactical.State.onKeyInput(::APT.key(::APT.Keys.Q)); },
            function (_e, t) {
                if (!::APT.confirmDialog()) return false;
                t.state.seen.onAI <- ::Tactical.TurnSequenceBar.m.IsOnAI;
                t.state.seen.auto <- ::Tales.uniq(::APT.company().filter(@(_, b) "_autopilot" in b.m).map(@(b) b.getName()), true);
            },
        ],
        each = function (_st, t) {
            local bar = ::Tactical.TurnSequenceBar;
            if (t.state.cancel.state == "wait" && ::Time.getRound() >= 2) {
                // V during whoever's turn it is: a pending cancel or an immediate one
                t.state.seen.cancelHandled <- ::Tactical.State.onKeyInput(::APT.key(::APT.Keys.V));
                t.state.cancel.state = "sent";
            }
            if (t.state.cancel.state == "sent" && !bar.m.IsOnAI && !bar.m.CancelPending) {
                t.state.cancel.state = "done";
                t.state.seen.afterCancel <- ::Tales.uniq(::APT.company().filter(@(_, b) "_autopilot" in b.m).map(@(b) b.getName()), true);
                t.state.seen.agentsAfterCancel <- ::Tales.uniq(::APT.company().map(@(b) b.getAIAgent().ClassName), true);
                t.state.seen.cancelRound <- ::Time.getRound();
            }
            if (t.state.cancel.state == "done") return t.state.cancel.ai(_st);
        }});
    cancel.ai <- thenAI(@() true);
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.handled, true, "Q handled");
    t.eq(seen.onAI, true, "turn bar on AI");
    t.eq(seen.auto, ["Bertel", "Torkel", "Wendel"], "bros on AI after Q");
    t.eq(seen.cancelHandled, true, "V handled");
    t.eq(seen.afterCancel, [], "no bro on AI after V");
    t.eq(seen.agentsAfterCancel, ["player_agent"], "player agents back after V");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins after AI is turned on again");
});

test("Ignore: the ignored bro skips his turns and stays out of AI", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({
        before = function (_e, t) {
            t.state.seen.ignored <- _e.getName();
            ::Tactical.TurnSequenceBar.onIgnoreButtonPressed();
        },
        each = function (_st, t) {
            foreach (b in ::APT.company())
                if (b.getName() == t.state.seen.ignored) t.state.seen.autoIgnored <- "_autopilot" in b.m;
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.probe("ignored", seen.ignored);
    t.eq(seen.autoIgnored, false, "the ignored bro is not put on AI");
    t.eq(::Tales.uniq(::APProbe.uses.filter(@(_, u) u.who == seen.ignored).map(@(u) u.what), true), [],
         "the ignored bro does nothing");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
    t.eq(::Tales.uniq(t.roster().filter(@(_, b) "_isIgnored" in b.m).map(@(b) b.getName()), true), [],
         "ignorance cleared after the battle");
});

test("'Auto Player Characters' off: the player character stays under human control", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local pc = ::Tales.byName("Wendel");
    pc.getSkills().add(::new("scripts/skills/traits/player_character_trait"));
    ::APT.setting("player", false);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        if (!("auto" in t.state.seen))
            t.state.seen.auto <- ::Tales.uniq(::APT.company().filter(@(_, b) "_autopilot" in b.m).map(@(b) b.getName()), true);
    }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    ::APT.resetSettings();
    t.eq(seen.auto, ["Bertel", "Torkel"], "everybody but the player character on AI");
    t.eq(::APT.autoUses("Wendel"), [], "the player character never acts on AI");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("H: mass wait makes every bro wait once in the round", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {waited = []};
    local ai = t.state.ai <- thenAI(@() ::Time.getRound() >= 2);
    local p = ::APT.pilot({press = false,
        before = [
            function (_e, t) {
                t.state.seen.first <- _e.getName();
                t.state.seen.handled <- ::Tactical.State.onKeyInput(::APT.key(::APT.Keys.H));
            },
            function (_e, t) {
                if (!::APT.confirmDialog()) return false;
                t.state.seen.waitingRound <- ::Tactical.TurnSequenceBar.m.IsWaitingRound;
            },
        ],
        each = function (_st, t) {
            if (::Time.getRound() == 1)
                foreach (b in ::APT.company())
                    if (b.isWaitActionSpent() && t.state.seen.waited.find(b.getName()) == null) t.state.seen.waited.push(b.getName());
            return t.state.ai(_st);
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    seen.waited.sort();
    t.eq(seen.handled, true, "H handled");
    t.eq(seen.waitingRound, true, "waiting round on");
    t.eq(seen.waited, ["Bertel", "Torkel", "Wendel"], "every bro waited in round 1");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("N: mass shield wall raises the shields of the bros who have them", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::Tales.equip(::Tales.byName("Bertel"), "scripts/items/weapons/hand_axe");
    ::Tales.equip(::Tales.byName("Bertel"), "scripts/items/shields/wooden_shield");
    ::Tales.equip(::Tales.byName("Wendel"), "scripts/items/shields/wooden_shield");
    local seen = t.state.seen <- {};
    local ai = t.state.ai <- thenAI(@() ::Time.getRound() >= 2);
    local p = ::APT.pilot({press = false,
        before = [
            function (_e, t) { t.state.seen.handled <- ::Tactical.State.onKeyInput(::APT.key(::APT.Keys.N)); },
            function (_e) { return ::APT.confirmDialog(); },
        ],
        each = function (_st, t) {
            if (::Time.getRound() == 1)
                t.state.seen.walls <- ::Tales.uniq(::APT.company().filter(@(_, b) b.getSkills().hasSkill("effects.shieldwall"))
                                                      .map(@(b) b.getName()), true);
            return t.state.ai(_st);
        }});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(seen.handled, true, "N handled");
    t.eq(seen.walls, ["Bertel", "Wendel"], "shield walls up in round 1");
    t.eq(::Tales.uniq(::APProbe.uses.filter(@(_, u) u.ok && u.what == "actives.shieldwall" && u.round == 1).map(@(u) u.who), true),
         ["Bertel", "Wendel"], "shieldwall used by those with shields");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("quick switch: bag items as extra skills, number key and click swap them", function (t) {
    ::Tales.toughen(null, true);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({press = false,
        before = function (_e, t) {
            local bar = ::Tactical.TurnSequenceBar, items = _e.getItems();
            ::APT.clearBag(_e);
            local old = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
            local dagger = ::APT.bag(_e, "scripts/items/weapons/dagger");
            local ui = bar.convertEntitySkillsToUIData(_e);
            local actives = _e.getSkills().queryActives().len();
            t.state.seen.who <- _e.getName();
            t.state.seen.uiTail <- ui.len() == actives + 1 ? ui.top() : ui.len();
            t.state.seen.daggerId <- dagger.getInstanceID();
            local tip = ::TooltipScreen.getTooltipEvents().onQuerySkillTooltipData(_e.getID(), dagger.getInstanceID());
            t.state.seen.tip <- tip.map(@(x) x.text);
            local ap = _e.getActionPoints();
            // Number key actives+1 -> setActionStateBySkillIndex(actives)
            ::Tactical.State.onKeyInput(::APT.key(actives + 1));
            t.state.seen.afterKey <- [items.getItemAtSlot(::Const.ItemSlot.Mainhand).getID(),
                              items.getAllItemsAtSlot(::Const.ItemSlot.Bag).map(@(i) i.getID()), ap - _e.getActionPoints()];
            // A click on the bag item's button swaps back
            ap = _e.getActionPoints();
            ::Tactical.State.turnsequencebar_onEntitySkillClicked(old.getInstanceID());
            t.state.seen.afterClick <- [items.getItemAtSlot(::Const.ItemSlot.Mainhand).getID(),
                                items.getAllItemsAtSlot(::Const.ItemSlot.Bag).map(@(i) i.getID()), ap - _e.getActionPoints()];
        },
        each = thenAI(@() true)});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.probe("who", seen.who);
    t.eq(seen.uiTail, {id = seen.daggerId, imagePath = "ui/items/weapons/melee/dagger_01_70x70.png",
                       isUsable = true, isAffordable = true}, "the bag dagger is the last skill button");
    t.eq(seen.tip, ["Switch to Dagger", "Quickly switch to another item from your bag.",
                    "Costs [b]" + ::std.Text.positive(4) + "[/b] AP to switch."], "its tooltip");
    t.eq(seen.afterKey[0], "weapon.dagger", "number key: dagger in hand");
    t.eq(seen.afterKey[2], 4, "number key: 4 AP");
    t.eq(seen.afterClick[0] != "weapon.dagger", true, "click: old weapon back");
    t.eq(seen.afterClick[1], ["weapon.dagger"], "click: dagger back in the bag");
    t.eq(seen.afterClick[2], 4, "click: 4 AP");
});

// What the bros used in round 1 on their own, i.e. on ending their turns.
local function round1Uses() {
    local out = {}, bros = ::World.getPlayerRoster().getAll().map(@(b) b.getName());
    foreach (u in ::APProbe.uses) {
        if (u.round != 1 || !u.ok || bros.find(u.who) == null) continue;
        if (!(u.who in out)) out[u.who] <- [];
        out[u.who].push(u.what);
    }
    return out;
}

// Ended by hand with all AP left in round 1: Torkel's crossbow unloaded, Bertel tired with the
// Recover perk, Wendel netted, Hans bleeding with a bandage.
local function endTurnSetup() {
    ::Tales.hireTough("farmhand_background", 4, "Hans", true);
    local bertel = ::Tales.byName("Bertel");
    bertel.getSkills().add(::new("scripts/skills/perks/perk_recover"));
    // He acts before Wendel, whatever the rolled initiatives, so he is the one to cut Wendel free
    bertel.getBaseProperties().Initiative += 200;
    bertel.getSkills().update();
    return function (_e) {
        local torkel = ::Tales.byName("Torkel");
        local xbow = torkel.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        xbow.setLoaded(false);
        torkel.getItems().unequip(xbow);
        torkel.getItems().equip(xbow);  // adds reload_bolt, as shooting does
        ::Tales.byName("Bertel").setFatigue(40);
        ::APT.net(::Tales.byName("Wendel"));
        local hans = ::Tales.byName("Hans");
        ::Tales.equip(hans, "scripts/items/accessory/bandage_item");
        hans.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
    };
}

test("end of turn with AP left: reload, free an ally, bandage", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local p = ::APT.pilot({press = false, before = endTurnSetup(), each = thenAI(@() ::Time.getRound() >= 2)});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    local r1 = round1Uses();
    // Bertel comes before Wendel and cuts him free, which leaves too little AP to recover
    foreach (k, v in r1) r1[k] = ::Tales.uniq(v, true);  // freeing an ally is tried up to 3 times
    // Each try can fail (a roll): still netted on his own turn, Wendel tries himself
    if ("Wendel" in r1 && ::Tales.equal(r1.Wendel, ["actives.break_free"])) delete r1.Wendel;
    t.eq(r1, {Torkel = ["actives.reload_bolt"], Bertel = ["actives.break_ally_free"],
              Hans = ["actives.bandage_ally"]}, "skills used on ending round 1 turns");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("end of turn with the settings off: only recover is used", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.setting("freewake", false);
    ::APT.setting("reload", false);
    ::APT.setting("bandages", false);
    local p = ::APT.pilot({press = false, before = endTurnSetup(), each = thenAI(@() ::Time.getRound() >= 2)});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    ::APT.resetSettings();
    t.eq(round1Uses(), {Bertel = ["actives.recover"]}, "skills used on ending round 1 turns");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("two AI battles in a row", function (t) {
    ::Tales.toughen(null, true);
    local p1 = ::APT.pilot();
    yield t.battle({entities = ::Tales.thugs(3), player = p1.fn, maxFrames = 30000});
    t.eq([p1.st.confirmed, p1.st.stuck, t.result.survivors.enemies], [true, [], 0], "first battle");
    ::APT.probeReset();
    local p2 = ::APT.pilot();
    yield t.battle({entities = ::Tales.thugs(3), player = p2.fn, maxFrames = 30000});
    t.eq([p2.st.confirmed, p2.st.stuck, t.result.survivors.enemies], [true, [], 0], "second battle");
    t.eq(::Tales.uniq(::APT.autoUses().map(@(u) u.who), true), ["Bertel", "Torkel", "Wendel"], "all act in the second");
});

test("'Verbose AI' on: a battle plays the same way, with the AI's debug log", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.setting("verbose", true);
    local p = ::APT.pilot();
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    ::APT.resetSettings();
    t.eq(::Const.AI.VerboseMode, false, "verbose mode off again after the battle");
    t.eq(::Tales.uniq(t.roster().map(@(b) b.m.IsControlledByPlayer), true), [true], "the bros the player's");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("the behaviors are registered and instantiate", function (t) {
    local ids = [];
    foreach (f in ::IO.enumerateFiles("scripts/ai/"))
        if (f.find("scripts/ai/autopilot_") == 0) ids.push(::new(f).getID());
    t.eq(ids.len(), 10, "autopilot behaviors");
    t.eq(ids.filter(@(_, id) id == null), [], "all with an ID");
});

test("enableAIControl gives an archer the ranged agent with Autopilot's behaviors", function (t) {
    local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["hunter_background"]);
    ::Tales.equip(bro, "scripts/items/weapons/short_bow");
    ::Tales.equip(bro, "scripts/items/ammo/quiver_of_arrows");
    bro.enableAIControl();
    local agent = bro.getAIAgent();
    t.eq(agent.ClassName, "military_ranged_agent");
    t.eq([agent.getBehavior(::Const.AI.Behavior.ID.AP_SwapQuiver) != null,
          agent.getBehavior(::Const.AI.Behavior.ID.Retreat) != null], [true, false], "swap quiver, no retreat");
    ::World.getTemporaryRoster().clear();
});
