var Necro = {};

Necro.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
    // console.error("brother = " + JSON.stringify(_brother.necro));
    if (_brother.necro_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.necro_perkTree);
        this.mPerkTree.necroTree = true; // tag so we only ever restore the stock tree from our own
    } else if (this.mPerkTree && this.mPerkTree.necroTree) {
        // Leaving a necro: rebuild the stock tree so its extra rows don't linger for the next bro.
        // Keyed on our own tag, never on another mod's custom tree (druid), to avoid clobbering it.
        this.onPerkTreeLoaded(null, this.mDataSource.getPerkTrees());
    }
    Necro.CharacterScreenPerksModule_loadPerkTreesWithBrotherData.call(this, _brother);
};


// // Adds the button to show the overview screen to the perks module.
// DynamicPerks.Hooks.CharacterScreenPerksModule_createDIV = CharacterScreenPerksModule.prototype.createDIV;
// CharacterScreenPerksModule.prototype.createDIV = function (_parentDiv)
// {
//     var self = this;
//     DynamicPerks.Hooks.CharacterScreenPerksModule_createDIV.call(this, _parentDiv);
//     this.mContainer.ShowDpfScreen = $("<div class='dpf-show-overview-screen-container'/>")
//         .appendTo(this.mContainer);
//     this.mContainer.ShowDpfScreen = this.mContainer.ShowDpfScreen.createTextButton("DP", function ()
//     {
//         Screens.DynamicPerksOverviewScreen.notifyBackendToShow();
//     }, '', 6);
// }
