// Shared helpers for the Autopilot New scenarios, loaded by `// include: lib/helpers.nut`.

::APT <- {};

// The early-access company named as seed bbtest-battle's worldgen names it, found by their weapons: the code env
// starts it without worldgen, with the same gear and other names. Before the fresh save, so every test sees them.
::APT.SeedNames <- {["weapon.woodcutters_axe"] = "Bertel", ["weapon.light_crossbow"] = "Torkel",
                    ["weapon.militia_spear"] = "Wendel"};
::APT.nameCompany <- function () {
    local bros = ::World.getPlayerRoster().getAll(), named = {};
    foreach (bro in bros) {
        local main = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (main == null || !(main.getID() in ::APT.SeedNames)) return;
        named[main.getID()] <- bro;
    }
    if (bros.len() != 3 || named.len() != 3) return;
    foreach (id, bro in named) {
        bro.setName(::APT.SeedNames[id]);
        bro.setTitle("");
    }
}
::Tales.setupCampaign(@() ::APT.nameCompany());

::APT.bag <- function (_bro, _script) {
    local item = typeof _script == "string" ? ::new(_script) : _script;
    _bro.getItems().addToBag(item);
    return item;
}

::APT.clearBag <- function (_bro) {
    local items = _bro.getItems();
    foreach (item in items.getAllItemsAtSlot(::Const.ItemSlot.Bag)) items.removeFromBag(item);
}

// Torkel with a short bow and an empty quiver; _bag goes into his cleared bag.
::APT.emptyQuiverArcher <- function (_bag) {
    local torkel = ::Tales.byName("Torkel");
    ::Tales.equip(torkel, "scripts/items/weapons/short_bow");
    local quiver = ::Tales.equip(torkel, "scripts/items/ammo/quiver_of_arrows");
    quiver.setAmmo(0);
    ::APT.clearBag(torkel);
    foreach (script in _bag) ::APT.bag(torkel, script);
    return torkel;
}

::APT.company <- function () {
    return ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)
        .filter(@(_, u) u != null && u.isAlive());
}

::APT.probeReset <- function () {
    ::APProbe.uses = [];
    ::APProbe.behaviors = [];
    ::APProbe.on = true;
}
// Probe records of autopilot bros only, optionally of one bro: skills used and behaviors picked.
::APT.autoUses <- function (_who = null) {
    return ::APProbe.uses.filter(@(_, u) u.ok && u.auto && (_who == null || u.who == _who));
}
::APT.autoBehaviors <- function (_who = null) {
    return ::APProbe.behaviors.filter(@(_, b) b.auto && (_who == null || b.who == _who));
}

// The popup is shown and its fade is over: answering it mid-fade leaves vanilla's tactical menu stack
// with an entry nothing pops (the real page's fades; the stub shows popups at once).
::APT.dialogReady <- function () {
    local d = ::DialogScreen;
    return d.isVisible() && !d.isAnimating();
}
// Confirms the open "AI Control"/"Wait"/"Shield Wall" popup, as its Ok button does.
::APT.confirmDialog <- function () {
    if (!::APT.dialogReady()) return false;
    ::DialogScreen.onOkPressed();
    return true;
}
::APT.cancelDialog <- function () {
    if (!::APT.dialogReady()) return false;
    ::DialogScreen.onCancelPressed();
    return true;
}
::APT.dialogShown <- function () {
    local d = ::DialogScreen;
    return d.isVisible() || d.isAnimating();
}

// The turn bar is ready for a player's input on the active entity.
::APT.playerTurnReady <- function () {
    if (!::Tales.inBattle()) return false;
    local ts = ::Tactical.State;
    if (ts.isBattleEnded() || ::LoadingScreen.isVisible()) return false;
    local bar = ::Tactical.TurnSequenceBar, e = bar.getActiveEntity();
    return e != null && e.isPlayerControlled() && e.isTurnStarted() && !bar.m.IsLocked
        && !ts.isInputLocked() && !::Time.hasEventScheduled(::TimeUnit.Virtual);
}

// The `player` of t.battle() that hands the company to Autopilot: presses the AI button
// (onAIButtonPressed, what the button and Q call) on the first player turn and confirms the
// popup. Bros left under human control (ignored, skipped, cancelled) end their turns at once.
// Options:
//   before = function (_e, t) {} - steps run on the first player turns before pressing, one per
//            frame; a function or an array; a step may return false to be retried, "pass" to
//            end this turn and be retried on the next player turn
//   press = false: never press AI
//   each = function (_st, t) {} - called every battle frame once AI is confirmed
//   stuckFrames = 2400: a turn of one entity longer than this (40 s of game time) is recorded
//            in st.stuck and ended with initNextTurn(), so a freeze is reported, not timed out
// Returns {fn, st}: st.pressed, st.confirmed, st.stuck = [{who, round, frames}], st.turns (turn
// starts per name), st.maxTurnFrames, st.dialogs (times the enemy retreat dialog showed).
::APT.pilot <- function (_opts = null) {
    local opts = {before = null, press = true, each = null, stuckFrames = 2400};
    if (_opts != null) foreach (k, v in _opts) opts[k] <- v;
    local steps = opts.before == null ? [] : typeof opts.before == "array" ? opts.before : [opts.before];
    local st = {step = 0, pressed = false, confirmed = false, stuck = [], turnOf = null,
                turnFrames = 0, turns = {}, maxTurnFrames = 0, frame = 0, retreatDialogs = 0};
    local fn = function () {
        if (!::Tales.inBattle()) return;
        local ts = ::Tactical.State;
        if (ts.isBattleEnded() || ::LoadingScreen.isVisible()) return;
        st.frame++;
        local bar = ::Tactical.TurnSequenceBar, e = bar.getActiveEntity();
        if (ts.m.TacticalDialogScreen.isVisible()) st.retreatDialogs++;

        // Freeze watch
        local id = e == null ? null : e.getID();
        if (id != st.turnOf) {
            st.turnOf = id;
            st.turnFrames = 0;
            if (e != null) {
                local n = e.getName();
                st.turns[n] <- (n in st.turns ? st.turns[n] : 0) + 1;
            }
        } else if (!ts.isPaused() && !::APT.dialogShown()) {
            st.turnFrames++;
            if (st.turnFrames > st.maxTurnFrames) st.maxTurnFrames = st.turnFrames;
            if (st.turnFrames == opts.stuckFrames && e != null) {
                st.stuck.push({who = e.getName(), round = ::Time.getRound(), frames = st.turnFrames});
                bar.initNextTurn();
                return;
            }
        }

        if (st.step < steps.len()) {
            if (!::APT.playerTurnReady() && !::APT.dialogShown()) return;
            local r = ::Tales.callWith(steps[st.step], [e, ::Tales.ctx()]);
            if (r == "pass") bar.onNextTurnButtonPressed();
            else if (r != false) st.step++;
            return;
        }
        if (opts.press && !st.pressed) {
            if (!::APT.playerTurnReady()) return;
            bar.onAIButtonPressed();
            st.pressed = true;
            return;
        }
        if (opts.press && !st.confirmed) {
            if (::APT.confirmDialog()) st.confirmed = true;
            return;
        }
        if (opts.each != null && ::Tales.callWith(opts.each, [st, ::Tales.ctx()]) == false) return;
        if (::APT.dialogShown()) return;
        if (::APT.playerTurnReady() && ::APT.humanTurn(e) && !ts.isAutoRetreat())
            bar.onNextTurnButtonPressed();
    };
    return {fn = fn, st = st};
}

// The active entity's turn is the player's to play: autopilot's isHumanControlled() when the mod
// is loaded, vanilla's isPlayerControlled() otherwise.
::APT.humanTurn <- function (_e) {
    if (_e == null || !_e.isPlayerControlled()) return false;
    if (!("Autopilot" in ::getroottable())) return true;
    return ::Tactical.TurnSequenceBar.isHumanControlled(_e);
}

// Nets the bro as throw_net.onUse does (effect + its own break free skill).
::APT.net <- function (_bro) {
    _bro.getSkills().add(::new("scripts/skills/effects/net_effect"));
    local breakFree = ::new("scripts/skills/actives/break_free_skill");
    breakFree.setDecal("net_destroyed");
    breakFree.setChanceBonus(0);
    _bro.getSkills().add(breakFree);
}

// Sets an Autopilot setting; one this version doesn't have (the released zip) is skipped.
::APT.setting <- function (_id, _value) {
    if (::Autopilot.msu.ModSettings.hasSetting(_id)) ::getModSetting("mod_autopilot_new", _id).set(_value);
}
::APT.Defaults <- {player = true, dogsMode = "defensive", nets = true, freewake = true,
                   bandages = true, reload = true, verbose = false};
// Every Autopilot setting back to its default (settings are root state a fresh=1 reload keeps).
::APT.resetSettings <- function () {
    foreach (k, v in ::APT.Defaults) ::APT.setting(k, v);
}

// A key event as the engine passes to onKeyInput: state 0 = released, modifier 1 = shift.
::APT.key <- function (_code, _state = 0, _modifier = 0) {
    return {getKey = @() _code, getState = @() _state, getModifier = @() _modifier};
}
::APT.Keys <- {Q = 27, H = 18, N = 24, V = 32, Num1 = 1};

// Charms the bro for the first hostile's faction, as a hexe does (no master, so it lasts its turns).
::APT.charm <- function (_bro) {
    local c = ::new("scripts/skills/effects/charmed_effect");
    c.setMasterFaction(::Tales.hostiles()[0].getFaction());
    _bro.getSkills().add(c);
    return c;
}

// Runs the battle of the given spawn with the company on autopilot: it must end without a turn
// that never ends, with the bros acting. Who wins doesn't matter.
::APT.stress <- function (_t, _spawn, _faction = "Bandits") {
    ::APT.probeReset();
    local p = ::APT.pilot();
    local b = _t.battle({spawn = _spawn, resources = 120, player = p.fn, maxFrames = 40000, faction = _faction});
    local done = b.done;
    b.done = function () {
        done.call(this);
        _t.probe("result", _t.result);
        _t.probe("skills used", ::Tales.uniq(::APT.autoUses().map(@(u) u.what), true));
        _t.eq(p.st.stuck, [], "no stuck turn");
        _t.ok(p.st.confirmed, "AI on");
        _t.ok(::APT.autoUses().len() > 0, "the bros act");
    };
    return b;
}

// Six bros: the three of the start and three recruits with a bow, a pike and a shield.
::APT.stressCompany <- function () {
    local archer = ::Tales.hireTough("hunter_background", 9, "Hans", true);
    ::Tales.equip(archer, "scripts/items/weapons/hunting_bow");
    ::Tales.equip(archer, "scripts/items/ammo/quiver_of_arrows");
    ::Tales.equip(::Tales.hireTough("farmhand_background", 3, "Jorg", true), "scripts/items/weapons/pike");
    local shield = ::Tales.hireTough("farmhand_background", 5, "Lutz", true);
    ::Tales.equip(shield, "scripts/items/weapons/arming_sword");
    ::Tales.equip(shield, "scripts/items/shields/kite_shield");
    ::Tales.equip(::Tales.byName("Wendel"), "scripts/items/tools/throwing_net");
    ::APT.bag(::Tales.byName("Wendel"), "scripts/items/shields/wooden_shield");
    ::Tales.toughen(null, true);
}
