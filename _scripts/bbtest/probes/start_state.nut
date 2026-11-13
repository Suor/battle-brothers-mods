// mode: campaign seed=determinism
// mods: mod_msu stdlib@dev

// Dumps the world at the campaign start and days later, and logs every reseed and Math.rand() with the draw
// counters before it, to diff launches (probes/repeat.sh). s= is the count of script objects made (toHash({})).

// 2-arg draws numbered in [__probeFrom, __probeTo) are logged with their stacks.
::__probeFrom <- 0;
::__probeTo <- 0;
::__probeFrames <- false;  // log the counters every frame till the tests start

::logInfo("RNG serial top " + ::toHash({}));

beforeCampaign(function () {
    ::logInfo("RNG serial beforeCampaign " + ::toHash({}));
    ::__probe <- {n2 = 0, n0 = 0, h = 0, seeds = 0, frame = 0};
    if (::__probeFrames) {
        local autoplay = ::__autoplay;
        ::__autoplay = function () {
            local p = ::__probe;
            ::logInfo("RNG frame " + p.frame++ + " real=" + ::Time.getRealTimeF() + " n2=" + p.n2 + " s=" + ::toHash({}));
            return autoplay();
        };
    }
    local rand = ::Math.rand, seed = ::Math.seedRandom, seedS = ::Math.seedRandomString;
    local where = function () {
        local s = ::getstackinfos(3);
        return s == null ? "?" : s.src + ":" + s.line;
    };
    ::Math.rand = function (...) {
        local p = ::__probe;
        if (vargv.len() == 0) {
            p.n0++;
            local r = rand();
            ::logInfo("RNG rand0 " + r + " n2=" + p.n2 + " n0=" + p.n0 + " h=" + p.h + " s=" + ::toHash({}) + " at " + where());
            p.h = (p.h * 31 + r + 7) & 0x7fffffff;
            return r;
        }
        p.n2++;
        local r = rand(vargv[0], vargv[1]);
        if (p.n2 >= ::__probeFrom && p.n2 < ::__probeTo) {
            local st = [];
            for (local l = 2; l < 7; l++) { local s = ::getstackinfos(l); if (s == null) break; st.push(s.func + "@" + s.src + ":" + s.line); }
            ::logInfo("RNG rand " + vargv[0] + "," + vargv[1] + "=" + r + " n2=" + p.n2 + " s=" + ::toHash({}) + " " + ::BBTest.join(st, " < "));
        }
        p.h = (p.h * 31 + r) & 0x7fffffff;
        return r;
    };
    ::Math.seedRandom = function (_s) {
        local p = ::__probe;
        ::logInfo("RNG seed " + _s + " real=" + ::Time.getRealTime() + " n2=" + p.n2 + " n0=" + p.n0 + " h=" + p.h + " s=" + ::toHash({}) + " at " + where());
        p.seeds++;
        return seed(_s);
    };
    ::Math.seedRandomString = function (_s) {
        local p = ::__probe;
        ::logInfo("RNG seedS " + _s + " n2=" + p.n2 + " n0=" + p.n0 + " h=" + p.h + " s=" + ::toHash({}) + " at " + where());
        return seedS(_s);
    };
});

::__dump <- function (t) {
    local out = [];
    local p = ::__probe;
    out.push("serial " + ::toHash({}));
    out.push("rng n2=" + p.n2 + " n0=" + p.n0 + " h=" + p.h + " seeds=" + p.seeds);
    out.push("time real=" + ::Time.getRealTimeF() + " virt=" + ::Time.getVirtualTimeF());
    local wt = ::World.getTime();
    out.push("worldtime days=" + wt.Days + " hours=" + wt.Hours + " minutes=" + wt.Minutes + " sec=" + wt.SecondsOfDay);
    out.push("unsaved " + ::BBTest.repr(::BBTest.unsaved()));
    local flags = [];
    foreach (k, v in ::World.Flags.m) flags.push(k + "=" + v.Value);
    flags.sort();
    out.push("flags " + ::BBTest.join(flags, ","));
    local a = ::World.Assets;
    out.push("assets money=" + a.getMoney() + " food=" + a.getFood() + " name=" + a.getName());
    foreach (bro in t.roster()) {
        local b = bro.getBaseProperties();
        local skills = [];
        foreach (s in bro.getSkills().m.Skills) skills.push(s.getID());
        out.push("bro " + bro.getName() + " | " + bro.getBackground().getID() + " lvl=" + bro.getLevel()
            + " hp=" + b.Hitpoints + " mskill=" + b.MeleeSkill + " res=" + b.Bravery + " | " + ::BBTest.join(skills, ","));
    }
    local pt = ::World.State.getPlayer().getTile();
    out.push("player " + pt.SquareCoords.X + "," + pt.SquareCoords.Y);
    foreach (s in ::World.EntityManager.getSettlements()) {
        local cs = [];
        foreach (c in s.getContracts()) cs.push(c.getID() + ":" + c.getType() + ":" + c.getPayment().getOnCompletion());
        local sits = [];
        foreach (x in s.getSituations()) sits.push(x.getID());
        out.push("settlement " + s.getName() + " id=" + s.getID() + " contracts=[" + ::BBTest.join(cs, " ") + "] sits=["
            + ::BBTest.join(sits, ",") + "]");
    }
    foreach (f in ::World.FactionManager.getFactions()) {
        if (f == null) continue;
        local cs = [];
        foreach (c in f.getContracts()) cs.push(c.getID() + ":" + c.getType());
        local deck = [];
        foreach (d in f.m.Deck) deck.push(d.getID() + "@" + d.getCooldownUntil() + "/" + d.getScore());
        out.push("faction " + f.getID() + " " + f.getName() + " rel=" + f.getPlayerRelation() + " lastAction="
            + f.m.LastActionTime + " lastContract=" + f.m.LastContractTime + " contracts=[" + ::BBTest.join(cs, " ") + "] deck=["
            + ::BBTest.join(deck, " ") + "]");
        foreach (u in f.getUnits()) {
            local ut = u.getTile();
            out.push("  unit " + u.getName() + " " + ut.SquareCoords.X + "," + ut.SquareCoords.Y + " troops=" + u.getTroops().len());
        }
    }
    foreach (l in out) ::logInfo("STATE " + l);
};

test("start", function (t) { ::__dump(t); });

test("a day later", function (t) {
    yield t.days(1);
    ::__dump(t);
});

test("five days later", function (t) {
    yield t.days(4);
    ::__dump(t);
});
