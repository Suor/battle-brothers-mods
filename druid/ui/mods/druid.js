var Druid = {};

// Inject the druid's custom perk tree (built in data_helper.convertEntityToUIData) in place of
// the stock one whenever the brother data carries it.
Druid.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
    if (_brother.druid_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.druid_perkTree);
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
