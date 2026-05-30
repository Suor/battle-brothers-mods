var Druid = {};

Druid.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
    if (_brother.druid_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.druid_perkTree);
    }
    Druid.CharacterScreenPerksModule_loadPerkTreesWithBrotherData.call(this, _brother);
};
