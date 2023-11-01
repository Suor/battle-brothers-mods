var AutopilotNew = {};

AutopilotNew.TacticalScreenTurnSequenceBarModule_createDIV
    = TacticalScreenTurnSequenceBarModule.prototype.createDIV;
TacticalScreenTurnSequenceBarModule.prototype.createDIV = function (_parentDiv)
{
    console.error("createDIV(...)");
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


// Should not be needed
// AutopilotNew.TacticalScreenTurnSequenceBarModule_destroyDIV = TacticalScreenTurnSequenceBarModule.prototype.destroyDIV;
// TacticalScreenTurnSequenceBarModule.prototype.destroyDIV = function ()
// {
//     this.mWaitTurnAllButton.remove();
//     this.mWaitTurnAllButton = null;
//     this.mWaitTurnAllButtonContainer.remove();
//     this.mWaitTurnAllButtonContainer = null;

//     AutopilotNew.TacticalScreenTurnSequenceBarModule_destroyDIV.call(this);
// }

// AutopilotNew.TacticalScreenTurnSequenceBarModule_updateButtonBar = TacticalScreenTurnSequenceBarModule.prototype.updateButtonBar;
// TacticalScreenTurnSequenceBarModule.prototype.updateButtonBar = function (_entityData)
// {
//     AutopilotNew.TacticalScreenTurnSequenceBarModule_updateButtonBar.call(this, _entityData);

//     if (_entityData === null || typeof(_entityData) !== 'object') return;

//     if ('isWaitActionSpent' in _entityData && _entityData.isWaitActionSpent === true)
//     {
//         // This is an approximation: In 99%+ of the cases WaitAll is redundant here because everyone spend their wait or ended their turn while already in the second half of the turn
//         this.mWaitTurnAllButton.enableButton(false);
//     }
// }

AutopilotNew.TacticalScreenTurnSequenceBarModule_bindTooltips
    = TacticalScreenTurnSequenceBarModule.prototype.bindTooltips;
TacticalScreenTurnSequenceBarModule.prototype.bindTooltips = function ()
{
    console.error("bindTooltips(...)");
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
    console.error("unbindTooltips(...)");
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
    console.error("showStatsPanel(" + _show + ", " + _instant + ")");
    _instant = true; // animated version has some race issue with buttons not showing up sometimes
    // this.mStatsPanelFadeInTime = this.mStatsPanelFadeOutTime = 1000;
    var items = [this.mWaitAll, this.mShieldWall, this.mIgnore, this.mAI];
    if (_instant !== undefined && typeof(_instant) == 'boolean')
    {
        items.forEach(function (item) {
            item.container.toggleClass("display-block", _show).toggleClass("display-none", !_show);
        });
    }
    else
    {
        var self = this;
        items.forEach(function (item) {
            item.container.velocity("finish", true).velocity({ opacity: _show ? 1 : 0 },
            {
                duration: _show ? self.mStatsPanelFadeInTime : self.mStatsPanelFadeOutTime,
                easing: 'swing',
                begin: function () {
                    if (_show)
                        $(this).removeClass('display-none').addClass('display-block');
                },
                complete: function () {
                    if (!_show)
                        $(this).removeClass('display-block').addClass('display-none');
                }
            });
        })
    }
    // AutopilotNew.TacticalScreenTurnSequenceBarModule_showStatsPanel.call(this, _show, true);
    AutopilotNew.TacticalScreenTurnSequenceBarModule_showStatsPanel.call(this, _show, _instant);
}

// New Functions:
TacticalScreenTurnSequenceBarModule.prototype.setWaitTurnAllButtonVisible = function (_visible)
{
    console.error("setWaitTurnAllButtonVisible(" + _visible + ")");
    this.mWaitAll.button.enableButton(_visible);
}

TacticalScreenTurnSequenceBarModule.prototype.setAIButtonVisible = function (_visible)
{
    console.error("setAIButtonVisible(" + _visible + ")");
    this.mAI.button.enableButton(_visible);
}
