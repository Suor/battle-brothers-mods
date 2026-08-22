// Where to plant a summoned or unleashed beast and how eager we are about it.
// Prefer a free tile closest to the nearest foe, so the beast lands on the line between us,
// screening the bro rather than spawning behind him.
::Autopilot.summonSpot <- function (_behavior, _entity, _skill) {
    local myTile = _entity.getTile();

    local nearest = 99, nearestTile = null;
    foreach (o in _behavior.getAgent().getKnownOpponents()) {
        local oTile = o.Actor.getTile();
        local d = myTile.getDistanceTo(oTile);
        if (d < nearest) { nearest = d; nearestTile = oTile; }
    }

    local best = null, bestDist = 99;
    foreach (tile in ::std.Tile.iterAdjacent(myTile)) {
        if (!_skill.onVerifyTarget(myTile, tile)) continue;
        local d = nearestTile == null ? 0 : tile.getDistanceTo(nearestTile);
        if (best == null || d < bestDist) { bestDist = d; best = tile; }
    }
    if (best == null) return null;

    // Do not summon too soon, so that a beast won't need to run by itself, wasting AP.
    // A closer foe means a bigger payoff for spending the single summon now.
    local ideal = _entity.getIdealRange();
    local mult = nearest > ideal ? 0 : 1.0 + (ideal - nearest).tofloat() / ideal;
    return {Tile = best, Nearest = nearest, Mult = mult};
}
