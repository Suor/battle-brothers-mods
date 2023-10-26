var RetinueUps = {};
RetinueUps.WorldCampfireScreenMainDialogModule_createSlot
    = WorldCampfireScreenMainDialogModule.prototype.createSlot;

WorldCampfireScreen.prototype.ru_notifyBackendSlotCtrlClicked = function (_i, _callback) {
    if(this.mSQHandle !== null) {
        SQ.call(this.mSQHandle, 'ru_onSlotCtrlClicked', _i, _callback);
    }
}

WorldCampfireScreenMainDialogModule.prototype.createSlot = function (_data, _i, _content) {
    RetinueUps.WorldCampfireScreenMainDialogModule_createSlot.call(this, _data, _i, _content);

    var self = this;
    var slot = _content.children("img").last();
    slot.off("click");
    slot.click(function (event) {
        if (event.ctrlKey) {
            self.mParent.ru_notifyBackendSlotCtrlClicked(_i, function (data) {
                if (data.Result == ErrorCode.NotEnoughMoney) {
                    self.mAssets.mMoneyAsset.shakeLeftRight();
                }
                else if (data.Result != 0) {
                    console.error("Failed to promote. Error: " + data.Result);
                }
            });
        } else {
            self.mParent.notifyBackendSlotClicked(_i); // vanilla behavior
        }
    });
}
