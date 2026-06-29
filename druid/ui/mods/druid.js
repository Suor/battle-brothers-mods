var Druid = {};

// Inject the druid's custom perk tree (built in data_helper.convertEntityToUIData) in place of
// the stock one whenever the brother data carries it.
Druid.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
    if (_brother.druid_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.druid_perkTree);
        this.mPerkTree.druidTree = true; // tag so we only ever restore the stock tree from our own
    } else if (this.mPerkTree && this.mPerkTree.druidTree) {
        // Leaving a druid: rebuild the stock tree so its extra rows don't linger for the next bro.
        // Keyed on our own tag, never on another mod's custom tree (necro), to avoid clobbering it.
        this.onPerkTreeLoaded(null, this.mDataSource.getPerkTrees());
    }
    Druid.CharacterScreenPerksModule_loadPerkTreesWithBrotherData.call(this, _brother);
    if (_brother.druid_perkTree) {
        Druid.markBlockedPerks(this.mPerkTree);
    }
};

// Grey out perks the implicit-group rule has closed off (druid_blocked, stamped per brother in
// squirrel). These are distinct from tier-locked perks - they can never be taken on this build.
Druid.markBlockedPerks = function (_perkTree) {
    for (var row = 0; row < _perkTree.length; ++row) {
        for (var i = 0; i < _perkTree[row].length; ++i) {
            var perk = _perkTree[row][i];
            if (!perk.Container) continue;
            if (perk.druid_blocked) perk.Container.addClass('druid-blocked');
            else perk.Container.removeClass('druid-blocked');
        }
    }
};

// A blocked perk is never selectable, regardless of tier or perk points.
Druid.CharacterScreenPerksModule_isPerkUnlockable = CharacterScreenPerksModule.prototype.isPerkUnlockable;
CharacterScreenPerksModule.prototype.isPerkUnlockable = function (_perk) {
    if (_perk.druid_blocked) return false;
    return Druid.CharacterScreenPerksModule_isPerkUnlockable.call(this, _perk);
};
