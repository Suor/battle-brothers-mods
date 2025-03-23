local function getNoItemsTile() {
    local size = ::Tactical.getMapSize();
    for (local x = 0; x < size.X; x++) {
        for (local y = 0; y < size.Y; y++) {
            local tile = ::Tactical.getTileSquare(x, y);
            if (!tile.Properties.has("Corpse") && !tile.IsContainingItems) return tile;
        }
    }
    return null;
}

::HackFixes.mh.hookTree("scripts/entity/tactical/actor", function (q) {
    q.onDeath = @(__original) function (_killer, _skill, _tile, _fatalityType) {
        if (_tile != null) return __original(_killer, _skill, _tile, _fatalityType);

        // TODO: fix dead book?
        local tmpTile = getNoItemsTile();
        if (tmpTile == null) return __original(_killer, _skill, _tile, _fatalityType);

        __original(_killer, _skill, tmpTile, _fatalityType);

        // Take items
        ::HackFixes.Items.extend(tmpTile.Items);
        foreach (item in tmpTile.Items) item.m.Tile = null;
        tmpTile.Items.clear();
        tmpTile.IsContainingItems = false;

        // Take corpse
        if (tmpTile.Properties.has("Corpse")) {
            ::HackFixes.Corpses.push(tmpTile.Properties.get("Corpse"));
            tmpTile.clear(::Const.Tactical.DetailFlag.Corpse);
            Tactical.Entities.removeCorpse(tmpTile);
            tmpTile.Properties.remove("Corpse");
            tmpTile.Properties.remove("IsSpawningFlies");
        }
    }

    // // FOR TESTING
    // q.findTileToSpawnCorpse = @(__original) function(_killer) {
    //     return null;
    //     // if (::Math.rand(5) == 1) return null;
    //     // return __original(_killer)
    // }
})

::HackFixes.mh.hook("scripts/states/tactical_state", function (q) {
    q.gatherLoot = @(__original) function () {
        // Return stuff to field for it to be gathered
        local tmpTile = getNoItemsTile();
        if (tmpTile != null) {
            foreach (item in ::HackFixes.Items) {
                item.m.Tile = tmpTile;
                tmpTile.Items.push(item);
                tmpTile.IsContainingItems = true;
            }
        }

        foreach (corpse in ::HackFixes.Corpses) {
            local tmpTile = getNoItemsTile();
            if (tmpTile == null) break;

            tmpTile.Properties.set("Corpse", corpse);
            ::Tactical.Entities.addCorpse(tmpTile);
        }

        __original();
    }
})
