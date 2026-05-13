var _tcAssignItemToSlot = TacticalCombatResultScreenLootPanel.prototype.assignItemToSlot;
TacticalCombatResultScreenLootPanel.prototype.assignItemToSlot = function (_owner, _slot, _item) {
    _tcAssignItemToSlot.call(this, _owner, _slot, _item);
    if (_item !== null && _item.challenges_capped === true) {
        _slot.addClass('challenges-capped');
    } else {
        _slot.removeClass('challenges-capped');
    }
};

var _tcRemoveItemFromSlot = TacticalCombatResultScreenLootPanel.prototype.removeItemFromSlot;
TacticalCombatResultScreenLootPanel.prototype.removeItemFromSlot = function (_slot) {
    _tcRemoveItemFromSlot.call(this, _slot);
    _slot.removeClass('challenges-capped');
};
