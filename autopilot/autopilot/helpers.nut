// More enemies around _tile than allies to share them with
::Autopilot.isOutnumberedAt <- function (_entity, _tile) {
    local allies = 0;
    foreach (a in ::std.Tile.iterAdjacentActors(_tile))
        if (a.getID() != _entity.getID() && a.isAlliedWith(_entity)) allies++;
    return _tile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) > allies + 1;
}
// Cost of walking to within _range of _tile this turn, null if there is no way
::Autopilot.walkCost <- function (_entity, _tile, _range = 0) {
    local nav = ::Tactical.getNavigator(), s = nav.createSettings();
    s.ActionPointCosts = _entity.getActionPointCosts();
    s.FatigueCosts = _entity.getFatigueCosts();
    s.FatigueCostFactor = 0.0;
    s.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
    s.FatigueCostPerLevel = _entity.getLevelFatigueCost();
    s.AllowZoneOfControlPassing = false;
    s.ZoneOfControlCost = 0;
    s.AlliedFactions = _entity.getAlliedFactions();
    s.Faction = _entity.getFaction();
    if (!nav.findPath(_entity.getTile(), _tile, s, _range)) return null;
    return nav.getCostForPath(_entity, s, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
}
// Vanilla's fatigue score mult for spending _fatigue
::Autopilot.fatigueScoreMult <- function (_entity, _fatigue) {
    if (_entity.getCurrentProperties().FatigueEffectMult == 0) return 1.0;
    return 0.4 + 0.6 * (1.0 - ::Math.maxf(0, _fatigue) / (_entity.getFatigueMax() - _entity.getFatigue()));
}
// AP left after walking to within _range of _tile this turn, -1 if out of reach
::Autopilot.apLeftAfterWalk <- function (_entity, _tile, _range = 0) {
    local cost = ::Autopilot.walkCost(_entity, _tile, _range);
    if (cost == null || !cost.IsComplete || cost.End.getDistanceTo(_tile) > _range) return -1;
    return _entity.getActionPoints() - cost.ActionPointsRequired;
}
