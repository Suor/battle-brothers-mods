// Shared helpers for the Standout Enemies scenarios, loaded by `// include: lib/helpers.nut`.

::SET <- {};

// A sprite's look as numbers: the packed color (setBrightness changes it, nothing else is kept).
::SET.look <- function (_actor, _sprites) {
    local out = {};
    foreach (s in _sprites)
        if (_actor.hasSprite(s)) {
            local sp = _actor.getSprite(s);
            out[s] <- [sp.Color.R, sp.Color.G, sp.Color.B, sp.Saturation];
        }
    return out;
}

// A world bandit party next to the company and its troops as t.battle entities, so that the
// mod's tactical_entity_manager.setupEntity hook sees a `Party`.
::SET.partyEntities <- function (_resources) {
    local faction = ::World.FactionManager.getFactionOfType(::Const.FactionType.Bandits);
    local tile = ::World.State.getPlayer().getTile();
    local party = faction.spawnEntity(tile, "Brigands", false, ::Const.World.Spawn.BanditRaiders, _resources);
    local out = [];
    // as world_state.startCombat passes them: the troops themselves, a weak ref to the party
    foreach (tr in party.getTroops()) {
        if (tr.Script == "") continue;
        tr.Faction <- party.getFaction();
        tr.Party <- ::WeakTableRef(party);
        out.push(tr);
    }
    return {party = party, entities = out};
}
