// KNOWN_BUGS #31 with Hardened's max fatigue before its 76ba4f3 (2025-06-21): `::Math.max(stamina, min)`, an
// integer, so a full-fatigue `fatigue / (max - current)` in getFatigueScoreMult is an integer division by zero.
// Shared by tale_discord_bugs.nut (Autopilot) and tale_discord_bugs_vanilla.nut (without it).
::KB31Int <- function (t) {
    // State in t.state: closures made in this generator read its locals as null after a yield in the original.
    local seen = t.state.seen <- {};
    t.state.thug <- null;
    local p = ::APT.pilot({press = false, each = function (_st, t) { if (!("k" in t.state.seen)) { t.state.seen.k <- 1; ::Tales.killAll(); } },
        before = [
            function (_e, t) {
                t.state.thug = ::Tales.hostiles()[0];
                foreach (tile in ::std.Tile.iterAdjacent(_e.getTile())) {
                    if (!tile.IsEmpty) continue;
                    ::Tactical.getNavigator().teleport(t.state.thug, tile, null, null, false, 0.0);
                    break;
                }
                t.state.seen.bro <- _e;
            },
            function (_e, t) { return t.state.thug.getTile().getDistanceTo(t.state.seen.bro.getTile()) == 1; },
            function (_e, t) {
                // the old Hardened actor.getStamina(), on this thug only
                t.state.thug.getFatigueMax <- function () { return ::Math.max(this.m.CurrentProperties.Stamina, 10); };
                t.state.thug.setFatigue(t.state.thug.getFatigueMax());
                t.state.thug.setActionPoints(t.state.thug.getActionPointsMax());
                foreach (s in t.state.thug.getSkills().queryActives()) if (s.isAttack()) s.m.FatigueCost = 0;
                local b = t.state.thug.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AttackDefault);
                t.state.seen.fat <- [typeof t.state.thug.getFatigue(), typeof t.state.thug.getFatigueMax(), t.state.thug.getFatigue(), t.state.thug.getFatigueMax()];
                try { t.state.seen.score <- b.onEvaluate(t.state.thug); t.state.seen.error <- null; } catch (e) { t.state.seen.error <- e; }
                t.state.seen.skill <- b.m.Skill == null ? null : b.m.Skill.getID();
                delete t.state.thug.getFatigueMax;
            },
        ]});
    yield t.battle({entities = ::Tales.thugs(1), player = p.fn, maxFrames = 6000});
    t.probe("fatigue: types, current, max", seen.fat);
    t.probe("skill picked", seen.skill);
    t.eq(seen.error, null, "KB31: attack_default's evaluation throws");
};
