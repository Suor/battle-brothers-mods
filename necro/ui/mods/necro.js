var Necro = {};

Necro.CharacterScreenPerksModule_loadPerkTreesWithBrotherData = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother)
{
    // console.error("brother = " + JSON.stringify(_brother.necro));
    if (_brother.necro_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.necro_perkTree);
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
