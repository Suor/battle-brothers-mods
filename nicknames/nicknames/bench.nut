// In-game micro-benchmark for the title hot path, on the real game VM (Squirrel
// 3.0.4) and real bro objects — unlike the standalone bench.nut, whose mocks make
// getSkills()/getCurrentProperties()/WeakRef trivial and so understate buildFactorSet.
//
// Runs over a whole set of bros (one bro isn't representative — cost varies with
// background, trait count and how many titles match), reporting avg/min/max per call:
//   ::Nicknames.bench()          // our brothers (player roster)
//   ::Nicknames.bench("city")    // recruits in the nearest settlement's hire roster
//   ::Nicknames.bench("city", 500)
//
// Times only the side-effect-free reads (buildFactorSet, buildCandidates); fillTitle
// is skipped because it calls setTitle() and writes World.Flags. Blocks the game for
// ~(bros x _n x per-call) — trigger it by hand. Read results with:
//   ../_scripts/parse_log.py --tag SQ | grep 'nicknames bench'
local def = ::Nicknames;

def.bench <- function (_source = "roster", _n = 300) {
    local bros;
    if (_source == "city") {
        local tile = ::World.State.getPlayer().getTile();
        local nearest = null, best = 999999;
        foreach (s in ::World.EntityManager.getSettlements()) {
            local roster = ::World.getRoster(s.getID()).getAll();  // hire roster; empty until visited
            if (roster.len() == 0) continue;
            local d = s.getTile().getDistanceTo(tile);
            if (d < best) { best = d; nearest = s; bros = roster; }
        }
        if (nearest == null) return ::logError("nicknames bench | no settlement with recruits found");
        ::logInfo(format("nicknames bench | nearest city %s (%d tiles), %d recruits",
            nearest.getName(), best, bros.len()));
    } else {
        bros = ::World.getPlayerRoster().getAll();
        ::logInfo(format("nicknames bench | player roster, %d bros", bros.len()));
    }
    if (bros.len() == 0) return ::logError("nicknames bench | no bros to measure");

    // getExactTime() is the high-res clock that ticks mid-frame (what the AI uses for its
    // per-run time budget); getRealTimeF() is the frame clock — frozen inside our blocking
    // loop, so it would report 0. Both return seconds.
    local function measure(_label, _fn) {
        for (local i = 0; i < 50; i++) _fn(bros[0]);   // warm up
        local sum = 0.0, mn = 1e30, mx = 0.0;
        foreach (b in bros) {
            local t0 = ::Time.getExactTime();
            for (local i = 0; i < _n; i++) _fn(b);
            local per = (::Time.getExactTime() - t0) / _n * 1e6;
            sum += per;
            if (per < mn) mn = per;
            if (per > mx) mx = per;
        }
        ::logInfo(format("nicknames bench | %-16s avg %7.2f  min %7.2f  max %7.2f us/call",
            _label, sum / bros.len(), mn, mx));
    }
    measure("buildFactorSet",  @(b) def.buildFactorSet(b));
    measure("buildCandidates", @(b) def.buildCandidates(b));
}
