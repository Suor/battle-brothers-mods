// "No Tryout" challenge: hide the Try-out button. We don't fake IsTryoutDone - Reforged keys its
// perk-tree reveal on it - so traits and perks stay hidden and you hire blind. We only hide while
// the button is the Try-out action (!IsTryoutDone); an already-tried-out recruit keeps his button
// (e.g. "Dismiss"). Runs after vanilla/Reforged/CR updateDetailsPanel.
(function () {
    var orig = WorldTownScreenHireDialogModule.prototype.updateDetailsPanel;
    WorldTownScreenHireDialogModule.prototype.updateDetailsPanel = function (_element) {
        orig.call(this, _element);
        var data = _element ? _element.data('entry') : null;
        if (data && !data['IsTryoutDone'] && this.mDetailsPanel.TryoutButton
                && MSU.getSettingValue("mod_challenges", "noTryout")) {
            this.mDetailsPanel.TryoutButton.removeClass('display-block').addClass('display-none');
            this.mDetailsPanel.TryoutCostsContainer.removeClass('display-block').addClass('display-none');
        }
    };
})();
