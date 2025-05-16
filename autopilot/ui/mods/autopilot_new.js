var AutopilotNew = {};

// Undo reforged changes
AutopilotNew.unhook = function (clsName, hooks) {
    var cls = window[clsName], prefix = clsName + '_';
    for (var key in hooks) {
        if (key.slice(0, prefix.length) != prefix) continue; // no .startsWith() in there
        var funcName = key.split('_')[1];
        cls.prototype[funcName] = hooks[key];
    }
}
if (window.Reforged) {
    AutopilotNew.unhook("TacticalScreenTurnSequenceBarModule", Reforged.Hooks);
    TacticalScreenTurnSequenceBarModule.prototype.RF_setWaitTurnAllButtonVisible = function (_visible) {}
}


// Autopilot hooks
AutopilotNew.TacticalScreenTurnSequenceBarModule_createDIV
    = TacticalScreenTurnSequenceBarModule.prototype.createDIV;
TacticalScreenTurnSequenceBarModule.prototype.createDIV = function (_parentDiv)
{
    AutopilotNew.TacticalScreenTurnSequenceBarModule_createDIV.call(this, _parentDiv);

    // Need to move active skills left to make space for autopilot buttons
    this.mSkillsContainer.css("position", "relative").css("left", "-18.3rem")

    var self = this;
    var buttonsContainer = this.mEndTurnButtonContainer.parent();

    function button(image, backendFunc) {
        var buttonBackground = $('<div class="l-button-container"/>');
        var layout = $('<div class="l-button"/>');
        buttonBackground.append(layout);
        var callback = function () {SQ.call(self.mSQHandle, backendFunc)};
        var button = layout.createImageButton(Path.GFX + image, callback, '', 6);
        buttonsContainer.append(buttonBackground);
        return {button: button, container: buttonBackground};
    }

    this.mWaitAll = button("ui/skin/icon_wait_all.png", "onWaitTurnAllButtonPressed");
    this.mCancel = button(Asset.BUTTON_QUIT, "onCancelButtonPressed");
    this.mShieldWall = button("ui/skin/icon_shieldwall_all.png", "onShieldWallButtonPressed");
    this.mIgnore = button("ui/skin/icon_ignore_bro.png", "onIgnoreButtonPressed");
    this.mAI = button("ui/skin/icon_AI.png", "onAIButtonPressed");
}


AutopilotNew.TacticalScreenTurnSequenceBarModule_bindTooltips
    = TacticalScreenTurnSequenceBarModule.prototype.bindTooltips;
TacticalScreenTurnSequenceBarModule.prototype.bindTooltips = function ()
{
    AutopilotNew.TacticalScreenTurnSequenceBarModule_bindTooltips.call(this);
    this.mWaitAll.button.bindTooltip({
        contentType: 'ui-element',
        elementId: 'tactical-screen.turn-sequence-bar-module.WaitTurnAllButton'});
    this.mShieldWall.button.bindTooltip({
        contentType: 'ui-element',
        elementId: 'tactical-screen.turn-sequence-bar-module.ShieldWallButton'});
    this.mIgnore.button.bindTooltip({
        contentType: 'ui-element',
        elementId: 'tactical-screen.turn-sequence-bar-module.IgnoreButton'});
    this.mCancel.button.bindTooltip({
        contentType: 'ui-element',
        elementId: 'tactical-screen.turn-sequence-bar-module.CancelButton'});
    this.mAI.button.bindTooltip({
        contentType: 'ui-element',
        elementId: 'tactical-screen.turn-sequence-bar-module.AIButton'});
}

AutopilotNew.TacticalScreenTurnSequenceBarModule_unbindTooltips
    = TacticalScreenTurnSequenceBarModule.prototype.unbindTooltips;
TacticalScreenTurnSequenceBarModule.prototype.unbindTooltips = function ()
{
    this.mWaitAll.button.unbindTooltip();
    this.mShieldWall.button.unbindTooltip();
    this.mIgnore.button.unbindTooltip();
    this.mCancel.button.unbindTooltip();
    this.mAI.button.unbindTooltip();
    AutopilotNew.TacticalScreenTurnSequenceBarModule_unbindTooltips.call(this);
}

AutopilotNew.TacticalScreenTurnSequenceBarModule_showStatsPanel
    = TacticalScreenTurnSequenceBarModule.prototype.showStatsPanel;
TacticalScreenTurnSequenceBarModule.prototype.showStatsPanel = function (_show, _instant)
{
    // NOTE: animated version has some race issue with buttons not showing up sometimes
    var items = [this.mWaitAll, this.mShieldWall, this.mIgnore, this.mAI];
    items.forEach(function (item) {
        item.container.toggleClass("display-block", _show).toggleClass("display-none", !_show);
    });
    AutopilotNew.TacticalScreenTurnSequenceBarModule_showStatsPanel.call(this, _show, true);
}


AutopilotNew.TacticalScreenTurnSequenceBarModule_showEntityStatusEffectbar
    = TacticalScreenTurnSequenceBarModule.prototype.showEntityStatusEffectbar;
TacticalScreenTurnSequenceBarModule.prototype.showEntityStatusEffectbar = function (_show) {
    if (!_show) this.notifyStatusEffectTooltipsToHide();

    // The original function uses animation and forgets to toggle class in the end.
    this.mStatusEffectsContainer.css({ opacity: _show ? 1 : 0 });
    this.mStatusEffectsContainer.toggleClass("display-block", _show).toggleClass("display-none", !_show);
};

// New Functions:
TacticalScreenTurnSequenceBarModule.prototype.setWaitTurnAllButtonVisible = function (_visible)
{
    this.mWaitAll.button.enableButton(_visible);
}

TacticalScreenTurnSequenceBarModule.prototype.setAIButtonVisible = function (_visible)
{
    this.mAI.button.enableButton(_visible);
}
