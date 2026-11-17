// Helpers for the Autopilot tests with the real Legends mod (legends_*.nut).

::APL <- {};

// _bro raises a Legends skeleton on a free adjacent tile with Legends' own skill and a stash item.
// Returns the summoned entity or an error string.
::APL.summon <- function (_bro, _skill = "legend_spawn_skeleton_low_skill", _item = "legend_skeleton_item") {
    ::World.Assets.getStash().add(::new("scripts/items/spawns/" + _item));
    local skill = ::new("scripts/skills/actives/" + _skill);
    _bro.getSkills().add(skill);
    _bro.setActionPoints(_bro.getActionPointsMax());
    _bro.setFatigue(0);
    local target = null;
    foreach (tile in ::std.Tile.iterAdjacent(_bro.getTile()))
        if (tile.IsEmpty) { target = tile; break; }
    local before = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player).len();
    local ok = skill.use(target);
    foreach (u in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)) {
        if (::std.Util.isKindOf(u, "player")) continue;
        // sturdy, so the thugs don't kill it before its first turn
        ::Tales.toughen([u]);
        return u;
    }
    return "no summon: use() = " + ok + ", usable " + skill.isUsable() + ", faction size " + before;
}

::APL.isSummon <- @(_e) _e != null && !::std.Util.isKindOf(_e, "player");
