// Clever Recruiter 2.1.8 (2026-11-01) + Elite Few, shared by tale_cr218_cr_bugs_elite_few.nut (vanilla) and
// tale_legends_cr_bugs_elite_few.nut (Legends 19.4.23). KNOWN_BUGS.md #8: CR swaps ::Math.rand while building its temp
// player; Elite Few may add the master trait then. And EF2 (new): CR 2.1.8 runs a recruit's buildAttributes twice
// (clever_recruiter/character_background.nut: once with every roll pinned to its maximum, then for real), so Elite
// Few's master roll inside it runs twice per recruit.

::EFCR <- {};

::EFCR.tempPlayer <- function (t) {
    t.probe("CR base attributes at campaign start", ::CleverRecruiter.BaseAttributes == null ? null : ::CleverRecruiter.BaseAttributes.len());
    local err = null;
    ::EFT.with({selectMode = "all"}, function () {
        try { ::CleverRecruiter.initBaseAttributes(); } catch (e) { err = e; }
    });
    t.eq(err, null, "EF-KB8: initBaseAttributes under selectMode all");
}

::EFCR.refresh <- function (t) {
    local town = null;
    foreach (s in ::World.EntityManager.getSettlements()) if (!s.isMilitary()) { town = s; break; }
    ::EFT.with({selectMode = "all"}, @() town.updateRoster(true));
    local recruits = ::World.getRoster(town.getID()).getAll();
    t.ok(recruits.len() > 0, "recruits generated");
    t.eq(recruits.filter(@(_, b) !::EFT.isMaster(b)).len(), 0, "all masters");
}

// EF2: one master roll per recruit, and the trait matches that roll.
::EFCR.masterOnce <- function (t) {
    local rolls = [];
    local logInfo = ::logInfo;
    ::logInfo = function (_m) { if (typeof _m == "string" && _m.find("ef: roll for") == 0) rolls.push(_m); logInfo(_m); };
    local bros = [];
    try {
        ::EFT.with({selectMode = "roll", multiplier = 20}, function () {
            for (local i = 0; i < 40; i++) bros.push(::Tales.recruit("sellsword_background"));
        });
    } catch (e) { ::logInfo = logInfo; throw e; }
    ::logInfo = logInfo;
    t.probe("rolls for 40 recruits", rolls.len());
    t.probe("masters of 40", bros.filter(@(_, b) ::EFT.isMaster(b)).len());
    t.eq(rolls.len(), 40, "EF2: master rolls");
    // A recruit is a master iff its last (real) roll said so.
    local mismatch = 0;
    foreach (i, b in bros) {
        local last = rolls.len() == 80 ? rolls[2 * i + 1] : rolls[i];
        if ((last.find(" MASTER") != null) != ::EFT.isMaster(b)) mismatch++;
    }
    t.eq(mismatch, 0, "EF2: recruits whose master trait doesn't match the real roll");
}
