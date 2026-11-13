// bbtest prelude: test registry, scheduler and helpers. Loaded at the main menu before the
// test files. The driver calls ::BBTest.tick() once a frame, outside any try, so an error
// in test code is an uncaught script error with its stack; the driver then calls
// ::BBTest.tickFailed().

::BBTest <- {
    Tests = []
    Setups = []
    Only = null          // run only tests whose full name contains this
    File = null          // the test file being loaded
    Index = 0
    Current = null
    Started = false
    Finished = false
    Campaign = {}        // overrides for the new-campaign settings, see startCampaign()
    Autoplay = true      // answer events with their first button on the world map
    Fresh = false        // reload the campaign as it started before every test but the first
    Reload = null
    Reloaded = 0          // the Index of the test the campaign was last reloaded for
    Unsaved = null       // set after loading a snapshot: unsaved world state as it was at the campaign start
    StableRng = false    // --stable-rng, see stableRng()
    Seed = 0             // the current test's seed
    Reseeds = 0
    Rand0 = 1            // the state of Math.rand()'s stream, see stableRng()
    Env = "engine"       // code | engine | jsdom | ui: what runs the scenarios, see bbtest.py --env
    Has = {}             // the `needs` this env satisfies, set by the driver
    Skip = null          // why the current test is skipped, set by Unsupported()
}

// What this env can't do: `throw ::BBTest.Unsupported("t.days")` ends the test as SKIP, not as a failure.
::BBTest.Unsupported <- function (_what) {
    ::BBTest.Skip = _what;
    return "unsupported in env " + ::BBTest.Env + ": " + _what;
}

// The RNG trace (README, "Determinism across envs"): 2-arg Math.rand draws of the current test, counted and
// hashed (Enduriel's hash, below 2^31 for the original's 32-bit integers), a mark every 2000 draws; with `log` each
// draw and reseed goes to BBTEST_DRAWS rows with its call site. The engine's scripted player logs `n` too.
::__rng <- {n = 0, h = 0, marks = [], log = false, buf = [], pinned = null};
{
    local rand = ::Math.rand, seed = ::Math.seedRandom;
    ::Math.rand = function (...) {
        if (vargv.len() == 0) return rand();
        local a = vargv[0], b = vargv[1], t = ::__rng;
        // Draws of these callers (::BBTest.pinBattle) answer without drawing.
        if (t.pinned != null) {
            local c = ::getstackinfos(2);
            if (c != null && c.func in t.pinned && (t.pinned[c.func] == true || t.pinned[c.func](c.locals))) return a;
        }
        local r = rand(a, b);
        t.n++;
        t.h = (t.h * 33 + (r.tointeger() % 65521) + (a.tointeger() % 65521) * 3 + (b.tointeger() % 65521) * 5) % 1000003;
        if (t.h < 0) t.h += 1000003;
        if (t.n % 2000 == 0) t.marks.push(t.n + ":" + t.h);
        if (t.log && ::BBTest.Current != null) ::BBTest.logDraw(a + "," + b + "=" + r);
        return r;
    };
    ::Math.seedRandom = function (_s) {
        if (::__rng.log && ::BBTest.Current != null) ::BBTest.logDraw("seed " + _s);
        return seed(_s);
    };
}

// A draw with its call site (3 frames up from Math.rand), rows of 20.
::BBTest.logDraw <- function (_what) {
    local t = ::__rng, site = "";
    for (local l = 3; l < 7; l++) {
        local i = ::getstackinfos(l);
        if (i == null) break;
        local src = i.src.slice(i.src.find("scripts/") == null ? 0 : i.src.find("scripts/"));
        site += (l > 3 ? "/" : "") + i.func + "@" + src + ":" + i.line;
    }
    // An AI pick: whose, among which scores.
    local c = ::getstackinfos(3);
    if (c != null && c.func == "pickBehavior" && "this" in c.locals) {
        local agent = c.locals["this"], scores = [];
        foreach (b in agent.m.SortedBehaviors) scores.push(b.getID() + "=" + b.getScore());
        site += " " + agent.m.Actor.getName() + " [" + ::BBTest.join(scores, ",") + "]";
    }
    t.buf.push(t.n + " " + _what + " " + site);
    if (t.buf.len() >= 20) ::BBTest.flushDraws();
}

::BBTest.flushDraws <- function () {
    local t = ::__rng;
    if (t.buf.len() == 0) return;
    ::logInfo("BBTEST_DRAWS " + ::BBTest.join(t.buf, " ; "));
    t.buf = [];
}

// The trace's state as a wait ends: a BBTEST_RNG row.
::BBTest.rngRow <- function (_what, _from) {
    local t = ::__rng;
    ::BBTest.flushDraws();
    local marks = [];
    foreach (m in t.marks) if (m.slice(0, m.find(":")).tointeger() > _from) marks.push(m);
    ::logInfo("BBTEST_RNG " + ::BBTest.Current.t.name + " | " + _what + ": draws " + _from + ".." + t.n + " hash " + t.h
        + " marks " + ::BBTest.join(marks, " "));
}

// --- Registration (called at the top level of a test file) ---

// _opts.needs: what the test needs beyond the API (e.g. ["worldgen"]), skipped where the env lacks it.
::BBTest.test <- function (_name, _fn, _opts = null) {
    local name = ::BBTest.File + "::" + _name;
    if (::BBTest.Only != null && name.find(::BBTest.Only) == null) return;
    ::BBTest.Tests.push({name = name, fn = _fn, needs = _opts != null && "needs" in _opts ? _opts.needs : []});
}

// Runs at the main menu before New Campaign: set MSU settings, Const tweaks, ::BBTest.Campaign.
::BBTest.beforeCampaign <- function (_fn) {
    ::BBTest.Setups.push(_fn);
}

// --- Value printing and comparison ---

::BBTest.repr <- function (_v, _depth = 0) {
    switch (typeof _v) {
        case "string": return "\"" + _v + "\"";
        case "null": return "null";
        case "array":
            if (_depth > 4) return "[...]";
            local parts = [];
            foreach (x in _v) parts.push(::BBTest.repr(x, _depth + 1));
            return "[" + ::BBTest.join(parts, ", ") + "]";
        case "table":
            if (_depth > 4) return "{...}";
            local keys = [];
            foreach (k, _ in _v) keys.push(k);
            keys.sort(@(a, b) a.tostring() <=> b.tostring());
            local parts = [];
            foreach (k in keys) parts.push(k + " = " + ::BBTest.repr(_v[k], _depth + 1));
            return "{" + ::BBTest.join(parts, ", ") + "}";
        case "instance":
            try { if (_v.isNull()) return "instance:null"; } catch (e) {}
            try { if ("ClassName" in _v) return "instance:" + _v.ClassName; } catch (e) {}
            return "instance";
        default: return _v.tostring();
    }
}

::BBTest.join <- function (_arr, _sep) {
    local s = "";
    foreach (i, x in _arr) s += (i > 0 ? _sep : "") + x;
    return s;
}

::BBTest.equal <- function (_a, _b) {
    local ta = typeof _a, tb = typeof _b;
    if (ta == "array" && tb == "array") {
        if (_a.len() != _b.len()) return false;
        foreach (i, x in _a) if (!::BBTest.equal(x, _b[i])) return false;
        return true;
    }
    if (ta == "table" && tb == "table") {
        if (_a.len() != _b.len()) return false;
        foreach (k, x in _a) if (!(k in _b) || !::BBTest.equal(x, _b[k])) return false;
        return true;
    }
    return _a == _b;
}

::BBTest.hash <- function (_s) {
    local h = 5381;
    foreach (c in _s) h = (h * 33 + c) & 0x7fffffff;
    return h;
}

// --- The test context ---

::BBTest.Context <- {
    name = null
    fails = 0
    result = null      // what the last wait produced: the battle's outcome
    env = null         // ::BBTest.Env
    state = null       // a table of the test's own, for its callbacks (README, pitfalls)

    // End the test as SKIP: what it needs this env can't do.
    function skip(_what) {
        throw ::BBTest.Unsupported(_what);
    }

    function where(_level = 3) {
        local s = ::getstackinfos(_level);
        return s == null ? "?" : s.src + ":" + s.line;
    }

    function fail(_msg) {
        this.fails++;
        ::logInfo("BBTEST_ASSERT " + this.name + " | " + _msg + " | " + this.where());
    }

    function ok(_cond, _msg = "expected true") {
        if (_cond) return true;
        this.fails++;
        ::logInfo("BBTEST_ASSERT " + this.name + " | " + _msg + " | " + this.where());
        return false;
    }

    function eq(_actual, _expected, _msg = null) {
        if (::BBTest.equal(_actual, _expected)) return true;
        this.fails++;
        ::logInfo("BBTEST_ASSERT " + this.name + " | " + (_msg == null ? "" : _msg + ": ")
            + "expected " + ::BBTest.repr(_expected) + ", got " + ::BBTest.repr(_actual) + " | " + this.where());
        return false;
    }

    function near(_actual, _expected, _eps = 0.001, _msg = null) {
        if (::fabs(_actual - _expected) <= _eps) return true;
        this.fails++;
        ::logInfo("BBTEST_ASSERT " + this.name + " | " + (_msg == null ? "" : _msg + ": ")
            + "expected " + _expected + " +- " + _eps + ", got " + _actual + " | " + this.where());
        return false;
    }

    // _fn must throw; _match, if given, must be a substring of the error.
    function throws(_fn, _match = null) {
        try { _fn(); } catch (e) {
            if (_match == null || (typeof e == "string" && e.find(_match) != null)) return true;
            this.fails++;
            ::logInfo("BBTEST_ASSERT " + this.name + " | threw " + ::BBTest.repr(e) + ", wanted " + _match + " | " + this.where());
            return false;
        }
        this.fails++;
        ::logInfo("BBTEST_ASSERT " + this.name + " | did not throw | " + this.where());
        return false;
    }

    function probe(_key, _value) {
        ::logInfo("BBTEST_PROBE " + this.name + " | " + _key + " = " + ::BBTest.repr(_value));
    }

    function log(_msg) {
        ::logInfo("BBTEST_LOG " + this.name + " | " + _msg);
    }

    // --- Waits: `yield t.frames(10);` inside a test makes it a generator ---

    function frames(_n) {
        return {desc = _n + " frames", max = _n + 1, check = @(w) w.frames >= _n};
    }

    // _cond may take the test's `t`.
    function until(_cond, _maxFrames = 600, _desc = "a condition") {
        return {desc = _desc, max = _maxFrames, check = @(w) ::BBTest.callWith(_cond, [::BBTest.ctx()])};
    }

    // Run the world map for _n days (fractions fine). Quiet by default: the company can't be
    // attacked meanwhile. The world is paused again afterwards.
    function days(_n, _opts = null) {
        local opts = {quiet = true, speed = 4.0};
        if (_opts != null) foreach (k, v in _opts) opts[k] <- v;
        local player = ::World.State.getPlayer();
        local wasAttackable = player.isAttackable();
        if (opts.quiet) player.setAttackable(false);
        local target = ::Time.getVirtualTimeF() + _n * ::World.getTime().SecondsPerDay;
        local from = ::__rng.n;
        ::World.State.m.LastWorldSpeedMult = opts.speed;
        ::World.setSpeedMult(opts.speed);
        return {
            // Twice the frames the days take at this speed, plus room for events.
            desc = _n + " days", max = (_n * ::World.getTime().SecondsPerDay * 120 / opts.speed).tointeger() + 600,
            check = function (w) {
                local ws = ::World.State;
                if (ws.isPaused() && !ws.getEventScreen().isVisible() && !::BBTest.inBattle()) {
                    ws.setAutoPause(false);
                    ws.setPause(false);
                }
                // Events reset LastWorldSpeedMult (setNormalTime), and world_state.onUpdate
                // then holds the world clock to it while the virtual clock keeps our speed.
                if (!ws.isPaused()) {
                    ws.m.LastWorldSpeedMult = opts.speed;
                    ::World.setSpeedMult(opts.speed);
                }
                return ::Time.getVirtualTimeF() >= target;
            }
            status = function () {
                local ws = ::World.State, ev = ::World.Events.m.ActiveEvent;
                return "day " + ::World.getTime().Days + ", paused " + ws.isPaused()
                    + ", event " + (ev == null ? "none" : ev.getID()) + ", event screen " + ws.getEventScreen().isVisible()
                    + ", menu backsteps " + ws.getMenuStack().hasBacksteps();
            }
            done = function () {
                ::World.State.setPause(true);
                ::BBTest.rngRow(_n + " days", from);
                if (opts.quiet) ::World.State.getPlayer().setAttackable(wasAttackable);
            }
        };
    }

    // A scripted battle next to the company, on the world map. Options:
    //   spawn = "BanditRaiders" (a ::Const.World.Spawn key), resources = 100
    //   entities = [...] instead of spawn: entries as addUnitsToCombat makes them
    //   faction = "Bandits" (a ::Const.FactionType key), terrain = "tactical.plains"
    //   fight = true: the AI plays the company too; false: it ends its turns
    //   retreat = false: the company's AI may not retreat (vanilla's player AI is the
    //     auto-retreat one, so it walks off the map early otherwise)
    //   enemyRetreat = "end": answer vanilla's "The Enemy Retreats" dialog with "It's over";
    //     "chase": with "Run them down!"
    //   player = function (t) {} called every battle frame to play the company instead (`t` optional)
    //   setup = function (_properties) {} to tweak the combat properties
    // After `yield`, t.result = {result = ::Const.Tactical.CombatResult.X, frames = N,
    // survivors = {player = N, enemies = N}} (counted as the battle ended). With fight = true
    // the game may report PlayerRetreated on a win: the company isn't player-controlled then.
    function battle(_opts = null) {
        local opts = {spawn = "BanditRaiders", resources = 100, entities = null, faction = "Bandits",
            terrain = "tactical.plains", fight = true, retreat = false, enemyRetreat = "end", player = null, setup = null, maxFrames = 36000};
        if (_opts != null) foreach (k, v in _opts) opts[k] <- v;
        local from = ::__rng.n, unpin = ::BBTest.StableRng ? ::BBTest.pinBattle() : null;
        local st = ::World.State;
        st.m.IsAutosaving = false;
        local p = st.getLocalCombatProperties(st.getPlayer().getPos(), true);
        p.Entities = [];
        p.Parties = [];
        p.TerrainTemplate = opts.terrain;
        p.CombatID = "BBTest";
        local faction = ::World.FactionManager.getFactionOfType(::Const.FactionType[opts.faction]).getID();
        if (opts.entities != null) {
            foreach (e in opts.entities) {
                if (!("Faction" in e)) e.Faction <- faction;
                p.Entities.push(e);
            }
        } else {
            ::Const.World.Common.addUnitsToCombat(p.Entities, ::Const.World.Spawn[opts.spawn], opts.resources, faction);
        }
        if (opts.setup != null) opts.setup(p);
        if ("__lastCombatResult" in ::getroottable()) delete ::__lastCombatResult;
        ::__autoplayEngage = true;
        ::__autoplayFight = opts.fight && opts.player == null;
        ::__autoplayDieAsPlayers = true;
        ::__autoplayPlayer = opts.player == null ? null : @() ::BBTest.callWith(opts.player, [::BBTest.ctx()]);
        // Not Math.rand(): its stream moves with the UI's setDirty calls.
        if (unpin != null && st.m.CombatSeed == 0) st.m.CombatSeed = ::Math.rand(1, 32767);
        st.startScriptedCombat(p, true, true, true);
        local ctx = this;
        return {
            desc = "the battle to end", max = opts.maxFrames,
            check = function (w) {
                if (unpin != null && ::BBTest.inBattle()) ::BBTest.pinBar();
                if (!opts.retreat && ::BBTest.inBattle()) ::BBTest.noRetreat();
                if (::BBTest.inBattle()) ::BBTest.answerEnemyRetreat(opts.enemyRetreat == "end");
                if (::BBTest.inBattle() && ::Tactical.State.isBattleEnded() && !("survivors" in w))
                    w.survivors <- ::BBTest.survivors();
                if (!("__lastCombatResult" in ::getroottable())) return false;
                // Not RootState.get("TacticalFromWorldState"): the original logs an error for a state that is gone.
                if (::BBTest.inBattle()) return false;
                return ::World.State.isVisible() && !::LoadingScreen.isVisible();
            }
            status = function () {
                if (!::BBTest.inBattle()) return "not in battle";
                return "round " + ::Time.getRound() + ", alive " + ::BBTest.repr(::BBTest.survivors())
                    + ", ended " + ::Tactical.State.isBattleEnded();
            }
            done = function () {
                ::__autoplayEngage = false;
                ::__autoplayFight = false;
                ::__autoplayPlayer = null;
                if (unpin != null) unpin();
                ::BBTest.rngRow("battle", from);
                ctx.result = {result = "__lastCombatResult" in ::getroottable() ? ::__lastCombatResult : null, frames = this.frames,
                    survivors = "survivors" in this ? this.survivors : null};
            }
        };
    }

    // Save the campaign to the launch's saves dir under _name.
    function save(_name) {
        ::World.State.saveCampaign(_name);
    }

    // Load a save made by t.save(): back on the world map, paused, when it yields. Root-table
    // globals survive, as in the game. Waits 260 frames first: the world ignores a load
    // within 4 s of the last one.
    function load(_name) {
        local st = {loading = false, at = 0};
        return {
            desc = "loading " + _name, max = 6600,
            check = function (w) {
                if (!st.loading) {
                    if (w.frames < 260) return false;
                    ::World.State.campaign_menu_module_onLoadPressed(_name);
                    st.loading = true;
                    st.at = w.frames;
                    return false;
                }
                return w.frames - st.at >= 10 && ::BBTest.inWorld() && !::LoadingScreen.isVisible()
                    && ::World.State.m.CampaignToLoadFileName == null;
            }
            done = function () {
                if (::BBTest.inWorld()) ::World.State.setPause(true);
            }
        };
    }

    // --- The UI page (bbtest.py --env ui, --env jsdom) ---

    // The value of the JS expression _code in the page (objects and arrays as tables and
    // arrays); a JS exception raises. Calls the page makes into the scripts run inline.
    function js(_code) {
        if (!("BBTest_js" in ::getroottable())) throw ::BBTest.Unsupported("t.js: no UI page (--env ui or jsdom)");
        return ::BBTest_js(_code).v;
    }

    // A wait: until the JS expression _code is truthy in the page.
    function untilJs(_code, _maxFrames = 600) {
        return this.until(@(t) t.js(_code), _maxFrames, "JS " + _code);
    }

    // A PNG of the page as last painted, <run dir>/logs/<_name>.png; its path. null in jsdom (nothing is drawn).
    function shot(_name) {
        if ("BBTest_shot" in ::getroottable()) return ::BBTest_shot(_name);
        if ("BBTest_js" in ::getroottable()) return null;
        throw ::BBTest.Unsupported("t.shot: no UI page (--env ui or jsdom)");
    }

    // A wait: quits the campaign to the main menu and starts a new one through it, as a launch starts its
    // campaign (past the origin's intro, paused). Saves made before stay. _opts: origin, seed.
    function newCampaign(_opts = null) {
        local opts = {origin = "scenario.early_access", seed = "bbtest-new"};
        if (_opts != null) foreach (k, v in _opts) opts[k] <- v;
        if (::BBTest.Env == "code") {
            // codetest starts it at once, and drops the saves on the way
            local saves = clone ::__CT.saves;
            ::CT.startCampaign(opts.origin, opts.seed);
            foreach (k, v in saves) ::__CT.saves[k] <- v;
            ::World.State.setPause(true);
            return this.frames(1);
        }
        local st = {phase = "quit", at = 0};
        ::World.State.exitGame();
        return {
            desc = "a new campaign", max = 12000,
            check = function (w) {
                switch (st.phase) {
                    case "quit":
                        local mm = ::RootState.get("MainMenuState").m.MainMenuScreen;
                        if (::BBTest.inWorld() || ::LoadingScreen.isVisible() || !mm.isVisible() || mm.isAnimating()) return false;
                        ::BBTest.newCampaign();
                        st.phase = "new";
                        return false;
                    case "new":
                        ::BBTest.startCampaign(opts.seed, opts.origin);
                        st.phase = "starting";
                        return false;
                    case "starting":
                        if (("MSU" in ::getroottable()) && ::MSU.SettingsScreen.isVisible()) ::MSU.SettingsScreen.onSaveButtonPressed({});
                        if (!::BBTest.inWorld() || ::LoadingScreen.isVisible()) return false;
                        st.phase = "intro";
                        st.at = w.frames;
                        return false;
                    case "intro":
                        // the origin's intro event shows 1 s in, the autoplay answers it
                        return w.frames - st.at >= 90 && !::World.State.getEventScreen().isVisible();
                }
            }
            status = @() "phase " + st.phase
            done = function () {
                if (::BBTest.inWorld()) ::World.State.setPause(true);
            }
        };
    }

    // Hovers the page's first element matching the jQuery selector _sel, as the mouse does (its tooltip
    // shows after the delay); t.unhover(_sel) leaves it.
    function hover(_sel) { this.js("$(" + ::BBTest.jsString(_sel) + ").first().trigger('mouseenter')"); }
    function unhover(_sel) { this.js("$(" + ::BBTest.jsString(_sel) + ").first().trigger('mouseleave')"); }

    // --- World shortcuts ---

    function roster() { return ::World.getPlayerRoster().getAll(); }
}

// Units alive on the battlefield: the player's faction and every hostile one.
::BBTest.survivors <- function () {
    local out = {player = 0, enemies = 0};
    foreach (faction, units in ::Tactical.Entities.getAllInstances()) {
        foreach (u in units) {
            if (u == null || !u.isAlive()) continue;
            if (faction == ::Const.Faction.Player) out.player++;
            else if (!u.isAlliedWithPlayer()) out.enemies++;
        }
    }
    return out;
}

// The brothers the autoplay handed to the AI never pick the Retreat behaviour.
::BBTest.noRetreat <- function () {
    foreach (bro in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)) {
        if (!("__autoplayHanded" in bro.m)) continue;
        bro.getAIAgent().getProperties().BehaviorMult[::Const.AI.Behavior.ID.Retreat] = 0.0;
    }
}

// Vanilla's "The Enemy Retreats" dialog, which holds the battle until answered.
::BBTest.answerEnemyRetreat <- function (_end) {
    local st = ::Tactical.State, dialog = st.m.TacticalDialogScreen;
    if (!st.m.IsEnemyRetreatDialogShown || !dialog.isVisible() || dialog.isAnimating()) return;
    if (_end) st.tactical_retreat_screen_onYesPressed();
    else st.tactical_retreat_screen_onNoPressed();
}

::BBTest.inBattle <- function () {
    return ("State" in ::Tactical) && ::Tactical.State != null;
}

// --- Driver hooks ---

::BBTest.runBeforeCampaign <- function () {
    foreach (fn in ::BBTest.Setups) fn();
}

::BBTest.newCampaign <- function () {
    ::RootState.get("MainMenuState").m.MainMenuScreen.getMainMenuModule().onNewCampaignButtonPressed();
}

::BBTest.startCampaign <- function (_seed, _origin) {
    local s = {companyName = "BBTest Company", banner = "banner_04", combatDifficulty = 1,
        economicDifficulty = 1, budgetDifficulty = 1, ironman = false, explorationDifficulty = false,
        lateGameCrisis = ::Const.World.GreaterEvilType.Random, permanentDestruction = false,
        seed = _seed, origin = _origin};
    foreach (k, v in ::BBTest.Campaign) s[k] <- v;
    ::RootState.get("MainMenuState").m.MainMenuScreen.getNewCampaignMenuModule().onStartButtonPressed(s);
}

// A save doesn't keep these, and they decide whether and which faction updates (drawing from the RNG) while
// paused: a new campaign runs them until the first unpause, a loaded one doesn't.
::BBTest.unsaved <- function () {
    return {updatesWhilePaused = ::World.State.m.IsRunningUpdatesWhilePaused,
        nextFaction = ::World.FactionManager.m.NextFactionToUpdate};
}

::BBTest.onCampaignStarted <- function () {
    ::World.State.setPause(true);
    local u = ::BBTest.Unsaved;
    if (u == null) ::logInfo("BBTEST_UNSAVED " + ::BBTest.repr(::BBTest.unsaved()));
    else {
        ::World.State.m.IsRunningUpdatesWhilePaused = u.updatesWhilePaused;
        ::World.FactionManager.m.NextFactionToUpdate = u.nextFaction;
    }
    if (::BBTest.Fresh) ::World.State.saveCampaign("bbtest_fresh");
}

// Fresh mode: load the save made at campaign start. Returns true while it's under way.
// The world ignores a load within 4 s of real time after the last one, hence the wait.
::BBTest.reloading <- function () {
    if (!::BBTest.Fresh || ::BBTest.Reloaded >= ::BBTest.Index) return false;
    local r = ::BBTest.Reload;
    if (r == null) r = ::BBTest.Reload = {phase = "wait", frames = 0};
    r.frames++;
    if (r.phase == "wait") {
        if (r.frames < 260) return true;
        ::World.State.campaign_menu_module_onLoadPressed("bbtest_fresh");
        r.phase = "loading";
        r.frames = 0;
        return true;
    }
    // With the UI page the load waits for the loading screen's fade-in first.
    if (r.frames < 10 || !::BBTest.inWorld() || ::LoadingScreen.isVisible()
        || ::World.State.m.CampaignToLoadFileName != null) {
        if (r.frames > 6000) throw "bbtest: reloading the fresh campaign took over 6000 frames";
        return true;
    }
    ::World.State.setPause(true);
    ::BBTest.Reload = null;
    ::BBTest.Reloaded = ::BBTest.Index;
    return false;
}

::BBTest.start <- function () {
    ::logInfo("BBTEST_START " + ::BBTest.Tests.len() + " tests");
    ::BBTest.Started = true;
    if (::BBTest.StableRng) {
        ::BBTest.stableRng();
        ::BBTest.pinMSU();
    }
    if (::BBTest.Tests.len() == 0) ::BBTest.finish();
}

::BBTest.finish <- function () {
    ::logInfo("BBTEST_FINISH");
    ::BBTest.Finished = true;
}

// Draws the per-test seed doesn't cover depend on the frames since the launch's start and on every draw before:
// the game reseeds from the real time when a battle's units are spawned and when it ends, and Math.rand() (a battle's
// seed among others) is the C runtime's stream, which seedRandom doesn't reset. These make both follow the test's seed.
::BBTest.stableRng <- function () {
    local seed = ::Math.seedRandom;
    ::Math.seedRandom = function (_s) {
        if (_s == ::Time.getRealTime()) _s = ::BBTest.Seed + ::BBTest.Reseeds++;
        return seed(_s);
    };
    // A stream of its own, as the C runtime's is: UI-driven draws (setDirty's ContentID) don't shift the 2-arg ones.
    // MINSTD by Schrage's method, below 2^31 for the original's 32-bit integers.
    if ("__sqrat_ol_ rand_0" in ::Math) ::Math["__sqrat_ol_ rand_0"] = function () {
        local x = ::BBTest.Rand0;
        x = 16807 * (x % 127773) - 2836 * (x / 127773);
        if (x <= 0) x += 2147483647;
        ::BBTest.Rand0 = x;
        return x % 32768;
    };
}

// What a battle draws on frame timing or the wall clock, pinned (README, "Determinism across envs"); returns the
// function undoing it. With StableRng, which pins the combat seed and the wall-clock reseeds.
::BBTest.pinBattle <- function () {
    local s = ::Const.Sound, ai = ::Const.AI, ws = ::World.State, mapGen = ::MapGen.get;
    local old = [s.IdleSoundBaseDelay, s.IdleSoundMinDelay, ai.AllottedTimePerEvaluationRun, ws.m.IsRunningUpdatesWhilePaused];
    // Idle sounds pick a unit on gaps of virtual time between turns.
    s.IdleSoundBaseDelay = 1.0e9;
    s.IdleSoundMinDelay = 1.0e9;
    // The AI yields its evaluation after 5 ms of the wall clock: it thinks to the end in one call instead.
    ai.AllottedTimePerEvaluationRun = 1.0e9;
    // A new campaign's factions update every paused frame, and the frames to the battle's start are the UI's.
    ws.m.IsRunningUpdatesWhilePaused = false;
    // The map draws from the stream as it was when the tactical state began: from the test's seed instead, reseeded at
    // the battle's template (its patches get theirs from it too).
    local seeded = {done = false};
    ::MapGen.get <- function (_t) {
        if (!seeded.done) {
            seeded.done = true;
            ::Math.seedRandom(::BBTest.Seed + ::BBTest.Reseeds++);
        }
        return mapGen.call(this, _t);
    };
    // Ghosts redraw their jitter whenever a sprite animation ends; the loading screen picks its tip when the UI asks;
    // a player's agent thinks in the background while the player's input is awaited, its pick unused.
    ::__rng.pinned = {onRender = true, loading_screen_onQueryData = true, pickBehavior = function (_locals) {
        local agent = _locals["this"];
        return agent.getID() == ::Const.AI.Agent.ID.Player && !::Tactical.State.isAutoRetreat();
    }};
    return function () {
        s.IdleSoundBaseDelay = old[0];
        s.IdleSoundMinDelay = old[1];
        ai.AllottedTimePerEvaluationRun = old[2];
        ::World.State.m.IsRunningUpdatesWhilePaused = old[3];
        ::MapGen.get = mapGen;
        ::__rng.pinned = null;
    };
}

// The turn bar learns of the battle's end at once, not on a 50 ms real-time event that lets the frame rate decide
// whether another round starts (a draw).
::BBTest.pinBar <- function () {
    local screen = ::Tactical.State.m.TacticalScreen;
    if (screen == null) return;
    local bar = screen.m.TurnSequenceBar;
    if (bar == null || ("__pinned" in bar)) return;
    bar.__pinned <- true;
    local update = bar.update;
    bar.update <- function () {
        if (::Tactical.Entities.isCombatFinished()) this.m.IsBattleEnded = true;
        return update.call(this);
    };
}

// Keys of _t in an order both envs share: the table's own, unless a key is an object (iterated by its address in the
// original, by its creation serial in the engine): then by content.
::BBTest.keys <- function (_t) {
    local keys = [], objects = false;
    foreach (k, _ in _t) {
        keys.push(k);
        local ty = typeof k;
        if (ty != "string" && ty != "integer" && ty != "float" && ty != "bool") objects = true;
    }
    if (!objects) return keys;
    local tagged = [];
    foreach (k in keys) tagged.push([::BBTest.canon(k), k]);
    tagged.sort(@(a, b) a[0] <=> b[0]);
    keys = [];
    foreach (p in tagged) keys.push(p[1]);
    return keys;
}

// What _v is, as a string free of addresses: a game object by its class and ID, a data table by its ID or its plain
// fields.
::BBTest.canon <- function (_v, _depth = 0) {
    local ty = typeof _v;
    if (ty == "string" || ty == "integer" || ty == "float" || ty == "bool") return ty[0].tochar() + _v;
    if (ty == "array") {
        local parts = [];
        if (_depth < 3) foreach (x in _v) parts.push(::BBTest.canon(x, _depth + 1));
        return "[" + ::BBTest.join(parts, ",") + "]";
    }
    if (ty != "table" && ty != "instance") return ty;
    try {
        if ("ClassName" in _v) return "o" + _v.ClassName + ("getID" in _v ? ":" + _v.getID() : "");
        if ("ID" in _v) return "t" + ::BBTest.canon(_v.ID, 3) + ("Script" in _v ? _v.Script : "");
    } catch (e) {}
    if (ty == "instance") return ty;
    local keys = [];
    foreach (k, x in _v) keys.push(k);
    keys.sort(@(a, b) a.tostring() <=> b.tostring());
    local parts = [];
    foreach (k in keys) {
        local x = _v[k], tx = typeof x;
        parts.push(k + "=" + (tx == "string" || tx == "integer" || tx == "float" || tx == "bool" ? x : tx));
    }
    return "{" + ::BBTest.join(parts, ",") + "}";
}

// MSU's random picks from tables keyed by objects (WeightedContainer: injuries, troops) as if in ::BBTest.keys order.
// Its class can't be changed once instantiated: roll()'s draw is answered with a value that lands on the item the
// draw picks in that order.
::BBTest.pinMSU <- function () {
    if (!("MSU" in ::getroottable())) return;
    ::MSU.Table.randKey = function (_table) {
        local i = ::Math.rand(0, _table.len() - 1), keys = ::BBTest.keys(_table);
        return i < keys.len() ? keys[i] : null;
    };
    ::MSU.Table.randValue = function (_table) {
        local i = ::Math.rand(0, _table.len() - 1), keys = ::BBTest.keys(_table);
        return i < keys.len() ? _table[keys[i]] : null;
    };
    local randf = ::MSU.Math.randf;
    ::MSU.Math.randf = function (_min, _max) {
        local r = randf.call(this, _min, _max), c = ::getstackinfos(2);
        if (c == null || c.func != "roll" || !("this" in c.locals) || !(c.locals["this"] instanceof ::MSU.Class.WeightedContainer))
            return r;
        local table = c.locals["this"].Table, ex = "_exclude" in c.locals ? c.locals._exclude : null, pick = null, left = r;
        foreach (item in ::BBTest.keys(table)) {
            local w = table[item];
            if (ex != null && ex.find(item) != null) continue;
            if (left <= w && w != 0.0) { pick = item; break; }
            left -= w;
        }
        if (pick == null) return r;
        local before = 0.0;
        foreach (item, w in table) {
            if (ex != null && ex.find(item) != null) continue;
            if (item == pick) return before + w * 0.5;
            before += w;
        }
        return r;
    };
}

::BBTest.begin <- function (_test) {
    local t = clone ::BBTest.Context;
    t.name = _test.name;
    t.env = ::BBTest.Env;
    t.state = {};
    ::BBTest.Skip = null;
    ::BBTest.Current = {test = _test, t = t, gen = null, wait = null, frames = 0};
    // Each test draws from its own seed, so the ones before it don't shift its rolls.
    ::BBTest.Seed = ::BBTest.hash(_test.name);
    ::BBTest.Reseeds = 1;
    ::BBTest.Rand0 = ::BBTest.Seed % 2147483646 + 1;
    ::__rng.n = 0; ::__rng.h = 0; ::__rng.marks = []; ::__rng.buf = [];
    ::Math.seedRandom(::BBTest.Seed);
    // A new campaign's factions update one a frame while paused, and the frames since its start are the env's own (the
    // original shows the origin's intro after a second of real time): which one is next, from the first.
    if (::BBTest.StableRng && ::BBTest.inWorld()) ::World.FactionManager.m.NextFactionToUpdate = 2;
    if (::BBTest.inWorld() && !::BBTest.inBattle()) ::World.State.setPause(true);
    ::logInfo("BBTEST_BEGIN " + _test.name);
    foreach (n in _test.needs) {
        if (n in ::BBTest.Has) continue;
        ::BBTest.Skip = "needs " + n;
        return;
    }
    local r = _test.fn(t);
    if (typeof r == "generator") ::BBTest.Current.gen = r;
}

::BBTest.inWorld <- function () {
    return ("State" in ::World) && ::World.State != null && ::World.State.getPlayer() != null;
}

::BBTest.end <- function (_error = null) {
    local c = ::BBTest.Current;
    ::BBTest.Current = null;
    ::BBTest.flushDraws();
    ::__autoplayEngage = false;
    ::__autoplayFight = false;
    ::__autoplayPlayer = null;
    // A failed assert before the unsupported part is still a failure.
    local skip = ::BBTest.Skip;
    local status = skip != null ? (c.t.fails > 0 ? "FAIL" : "SKIP") : _error != null ? "ERROR" : c.t.fails > 0 ? "FAIL" : "PASS";
    if (skip != null) ::logInfo("BBTEST_SKIP " + c.t.name + " | " + skip);
    else if (_error != null) ::logInfo("BBTEST_ASSERT " + c.t.name + " | " + _error + " | -");
    ::logInfo("BBTEST_END " + c.t.name + " " + status + " frames=" + c.frames);
}

// One step of the current test per frame. Not wrapped in try: see the top.
::BBTest.tick <- function () {
    if (!::BBTest.Started || ::BBTest.Finished) return;
    local c = ::BBTest.Current;
    if (c == null) {
        if (::BBTest.Index >= ::BBTest.Tests.len()) return ::BBTest.finish();
        if (::BBTest.reloading()) return;
        return ::BBTest.begin(::BBTest.Tests[::BBTest.Index++]);
    }
    c.frames++;
    if (c.wait != null) {
        local w = c.wait;
        w.frames++;
        if (!w.check(w)) {
            if (w.frames >= w.max) {
                c.wait = null;
                local why = "status" in w ? " (" + w.status() + ")" : "";
                if ("done" in w) w.done();
                // With the UI page: what it showed then.
                if ("BBTest_shot" in ::getroottable()) {
                    why += ", page: " + ::BBTest_shot("timeout_" + ::BBTest.Index) + ", shown: " + ::BBTest.repr(::BBTest_js(
                        "Array.prototype.filter.call(document.querySelectorAll('body > div > div'), function (e) { return e.offsetParent !== null; })"
                        + ".map(function (e) { return e.className.split(' ')[0]; })").v);
                }
                ::BBTest.end("timed out after " + w.frames + " frames waiting for " + w.desc
                    + why);
            }
            return;
        }
        c.wait = null;
        if ("done" in w) w.done();
    }
    if (c.gen == null || c.gen.getstatus() == "dead") return ::BBTest.end();
    local w = resume c.gen;
    if (c.gen.getstatus() == "dead") return ::BBTest.end();
    if (typeof w != "table" || !("check" in w)) return ::BBTest.end("yielded " + ::BBTest.repr(w) + ", not a wait (t.frames/until/days/battle)");
    w.frames <- 0;
    c.wait = w;
}

// The current test raised an uncaught error (logged above it with its stack).
::BBTest.tickFailed <- function (_msg) {
    if (::BBTest.Current == null) {
        ::logInfo("BBTEST_INTERNAL " + _msg);
        ::BBTest.finish();
        return;
    }
    ::BBTest.end("uncaught error: " + _msg);
}

// The engine's scripted player (harness AUTOPLAY): plays battles as set up by t.battle() and
// answers world events with their first button unless ::BBTest.Autoplay is false.
{
    local autoplay = ::__autoplay;
    ::__autoplay = function () {
        if (::BBTest.Autoplay || ::BBTest.inBattle()) autoplay();
    };
}

// _s as a JS string literal.
::BBTest.jsString <- function (_s) {
    local out = "\"";
    foreach (c in _s) out += c == '"' ? "\\\"" : c == '\\' ? "\\\\" : c.tochar();
    return out + "\"";
}

// The current test's context: for callbacks, which mustn't capture the test's locals (README, pitfalls).
::BBTest.ctx <- function () {
    return ::BBTest.Current == null ? null : ::BBTest.Current.t;
}

// Calls _fn with as many of _args as it declares (a callback may take the test's `t` or not).
::BBTest.callWith <- function (_fn, _args) {
    local infos = _fn.getinfos();
    local n = "parameters" in infos ? infos.parameters.len() - 1 : 0;
    // Squirrel 3.0's extend() returns null, not the array.
    local args = [::getroottable()];
    args.extend(_args.slice(0, n < _args.len() ? n : _args.len()));
    return _fn.acall(args);
}

// --- Helpers for scenarios: ::BBT (README, "Helpers") ---

::BBT <- {};

// Sturdier bros (all of the roster by default) so a battle's outcome doesn't hinge on a roll: survival from
// melee and ranged defense (most hits miss), enough HP for the rest, resolve against fleeing. _repair: their
// gear repaired too, so the condition a battle takes is the repair it needs afterwards.
::BBT.toughen <- function (_bros = null, _repair = false) {
    foreach (bro in _bros || ::World.getPlayerRoster().getAll()) {
        local b = bro.getBaseProperties();
        b.Hitpoints += 200; b.MeleeDefense += 60; b.RangedDefense += 60;
        b.MeleeSkill += 30; b.RangedSkill += 30; b.Bravery += 200;
        bro.getSkills().update();
        bro.setHitpoints(bro.getHitpointsMax());
        if (_repair) foreach (item in bro.getItems().getAllItems()) item.setCondition(item.getConditionMax());
    }
}

::BBT.byId <- function (_id) {
    foreach (bro in ::World.getPlayerRoster().getAll()) if (bro.getID() == _id) return bro;
    return null;
}

::BBT.byName <- function (_name) {
    foreach (bro in ::World.getPlayerRoster().getAll()) if (bro.getName() == _name) return bro;
    return null;
}

// A new bro in the company, made the way a settlement makes recruits; with _name, named that and untitled.
::BBT.hire <- function (_background = "farmhand_background", _place = null, _name = null) {
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx([_background]);
    if (_place != null) bro.setPlaceInFormation(_place);
    if (_name != null) { bro.setName(_name); bro.setTitle(""); }
    return bro;
}

// A recruit outside the company (a roster of its own), to inspect what a background rolls.
// A roster of the test's own: after a fresh=1 reload the original crashed in create() on an earlier test's.
::BBT.recruit <- function (_background = "farmhand_background") {
    local id = 9999 + ::BBTest.Index, roster = null;
    // The original raises for a roster id it doesn't have; the engine returns null.
    try { roster = ::World.getRoster(id); } catch (e) {}
    // Then through getRoster, as a settlement makes its recruits: mod_hooks wraps its rosters' create() with the
    // mods_hookNewObject hooks, not createRoster's.
    if (roster == null) { ::World.createRoster(id); roster = ::World.getRoster(id); }
    local bro = roster.create("scripts/entity/tactical/player");
    bro.setStartValuesEx([_background]);
    return bro;
}

// Equips an item (or a script to make one) in its slot, unequipping what holds that slot or blocks it
// (a two-hander and a shield); throws if it still won't go on.
::BBT.equip <- function (_bro, _item) {
    if (typeof _item == "string") _item = ::new(_item);
    local items = _bro.getItems(), slot = _item.getSlotType();
    foreach (s in [slot, _item.getBlockedSlotType()]) {
        local old = items.getItemAtSlot(s);
        if (old != null) items.unequip(old);
    }
    local main = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
    if (slot == ::Const.ItemSlot.Offhand && main != null && main.getBlockedSlotType() == ::Const.ItemSlot.Offhand)
        items.unequip(main);
    if (!items.equip(_item)) throw "can't equip " + _item.getID();
    return _item;
}

// t.battle entities: one of ::Const.EntityType[_type] from scripts/entity/tactical/<_script>; _n bandit thugs.
::BBT.unit <- function (_type, _script, _row = 0) {
    return {ID = ::Const.EntityType[_type], Variant = 0, Row = _row, Script = "scripts/entity/tactical/" + _script};
}
::BBT.thugs <- function (_n, _row = 0) {
    local out = [];
    for (local i = 0; i < _n; i++) out.push(::BBT.unit("BanditThug", "enemies/bandit_thug", _row));
    return out;
}

// --- In battle ---

// Living units hostile to the company: allies, the company's animals and its summons aren't.
::BBT.hostiles <- function () {
    local out = [];
    foreach (faction, units in ::Tactical.Entities.getAllInstances()) {
        if (faction == ::Const.Faction.Player) continue;
        foreach (u in units) if (u != null && u.isAlive() && !u.isAlliedWithPlayer()) out.push(u);
    }
    return out;
}

// The first attack skill of the actor, a strong reference as the game passes to kill(): queryActives()
// gives weak ones, which die with the weapon a dying bro drops.
::BBT.attack <- function (_actor) {
    foreach (sk in _actor.getSkills().queryActives()) if (sk.isAttack()) return sk.get();
    return null;
}

// Kills every hostile by _killer's attack (a living bro by default: mods hooking kill() expect a killer),
// again for those a death brings in, so the battle ends.
::BBT.killAll <- function (_killer = null, _fatality = null) {
    if (_fatality == null) _fatality = ::Const.FatalityType.None;
    if (_killer == null)
        foreach (u in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player))
            if (u != null && u.isAlive()) { _killer = u; break; }
    local skill = _killer == null ? null : ::BBT.attack(_killer);
    for (local pass = 0; pass < 3; pass++) {
        local hs = ::BBT.hostiles();
        if (hs.len() == 0) return;
        foreach (e in hs) if (e.isAlive()) e.kill(_killer, skill, _fatality);
    }
}

// An empty tile next to _actor whose ID isn't in _except.
::BBT.freeNear <- function (_actor, _except = []) {
    local tile = _actor.getTile();
    for (local d = 0; d < 6; d++) {
        if (!tile.hasNextTile(d)) continue;
        local n = tile.getNextTile(d);
        if (n.IsEmpty && !n.IsCorpseSpawned && _except.find(n.ID) == null) return n;
    }
    return null;
}

// The first empty tile of the map's middle, scanning from its left, not in the table _used (it's added there).
::BBT.freeTile <- function (_used) {
    for (local x = 8; x < 24; x++)
        for (local y = 8; y < 24; y++) {
            local tile = ::Tactical.getTileSquare(x, y);
            if (tile.IsEmpty && !tile.IsCorpseSpawned && !(tile.ID in _used)) { _used[tile.ID] <- true; return tile; }
        }
    return null;
}

::BBT.spawn <- function (_script, _tile, _faction) {
    local e = ::Tactical.spawnEntity(_script, _tile.Coords.X, _tile.Coords.Y);
    e.setFaction(_faction);
    e.assignRandomEquipment();
    return e;
}

// The `player` of a scripted t.battle(): runs _steps (a function or an array) one per frame while a player turn
// is on, a step returning false is retried next frame. Then ends the company's turns: for good, or with _killer
// until _until() (if given) holds, then kills every hostile with _killer(). Steps, _killer and _until may take `t`.
::BBT.scripted <- function (_steps, _killer = null, _until = null) {
    if (typeof _steps == "function") _steps = [_steps];
    local st = {i = 0, done = false};
    return function () {
        if (!::BBTest.inBattle() || st.done) return;
        local ts = ::Tactical.State;
        if (ts.isBattleEnded() || ::LoadingScreen.isVisible()) return;
        local bar = ::Tactical.TurnSequenceBar, e = bar.getActiveEntity();
        if (e == null || !e.isPlayerControlled() || !e.isTurnStarted()) return;
        local t = [::BBTest.ctx()];
        if (st.i < _steps.len()) {
            if (::BBTest.callWith(_steps[st.i], t) != false) st.i++;
            return;
        }
        if (_killer != null && (_until == null || ::BBTest.callWith(_until, t))) {
            st.done = true;
            ::BBT.killAll(::BBTest.callWith(_killer, t));
            return;
        }
        if (!ts.isInputLocked() && !::Time.hasEventScheduled(::TimeUnit.Virtual) && !bar.m.IsLocked)
            bar.onNextTurnButtonPressed();
    };
}

// A step of ::BBT.scripted that waits _n frames.
::BBT.wait <- function (_n) {
    local st = {left = _n};
    return @() --st.left <= 0;
}

// --- Settings and errors ---

// Sets MSU settings (_setting(name) gives one) to _values; returns a function restoring them. _raw sets
// Value directly, for sliders keeping the chosen element of their Values outside the Range bounds.
::BBT.set <- function (_setting, _values, _raw = false) {
    local old = {};
    foreach (k, v in _values) {
        local s = _setting(k);
        old[k] <- _raw ? s.Value : s.getValue();
        if (_raw) s.Value = v; else s.set(v);
    }
    return function () {
        foreach (k, v in old) {
            local s = _setting(k);
            if (_raw) s.Value = v; else s.set(v);
        }
    };
}

// Runs _fn with the settings set (::BBT.set), then restores them, also when it throws.
::BBT.with <- function (_setting, _values, _fn, _raw = false) {
    local restore = ::BBT.set(_setting, _values, _raw);
    try { local ret = _fn(); restore(); return ret; }
    catch (e) { restore(); throw e; }
}

// Collects what ::logError gets instead of logging it, until the returned function is called.
::BBT.catchErrors <- function (_out) {
    local logError = ::logError;
    ::logError = function (_msg) { _out.push(_msg); };
    return @() ::logError = logError;
}

// Drops ::logError messages containing _text until the returned function is called.
::BBT.dropErrors <- function (_text) {
    local logError = ::logError;
    ::logError = function (_m) { if (_m.find(_text) == null) logError(_m); };
    return @() ::logError = logError;
}

// Reforged's experimental AI logs this in some AI battles headless (README, Engine issues).
::BBT.tolerateRfAI <- @() ::BBT.dropErrors("onRemovedFromMap activeEntity null");
