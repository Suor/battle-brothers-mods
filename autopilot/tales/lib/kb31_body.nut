// KNOWN_BUGS #31, shared by tale_kb31.nut, tale_kb31_vanilla.nut (no Autopilot) and tale_kb31_reforged.nut: an enemy at
// full fatigue with a 0-fatigue attack and a bro next to him evaluates ai_attack_default.

::KB31 <- function (t) {
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
                t.state.thug.setFatigue(t.state.thug.getFatigueMax());
                t.state.thug.setActionPoints(t.state.thug.getActionPointsMax());
                foreach (s in t.state.thug.getSkills().queryActives()) if (s.isAttack()) s.m.FatigueCost = 0;
                local b = t.state.thug.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AttackDefault);
                t.state.seen.error <- ::Tales.tryCall(function () { t.state.seen.score <- b.onEvaluate(t.state.thug); });
                t.state.seen.skill <- b.m.Skill == null ? null : b.m.Skill.getID();
                // the user's error needs integer fatigues; vanilla's getFatigueMax() is Math.floor(), a float
                t.state.seen.fat <- [typeof t.state.thug.getFatigue(), typeof t.state.thug.getFatigueMax()];
                t.state.seen.target <- b.m.TargetTile != null;
            },
        ]});
    yield t.battle({entities = ::Tales.thugs(1), player = p.fn, maxFrames = 6000});
    t.eq(seen.error, null, "no error");
    t.eq([seen.skill != null, seen.target], [true, true], "a skill and a target picked, so the fatigue mult was computed");
    t.probe("score, types of fatigue and max fatigue", ["score" in seen ? seen.score : null, seen.fat]);
};
