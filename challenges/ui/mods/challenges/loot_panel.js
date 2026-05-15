"use strict";

var TCRSLootPanel = TacticalCombatResultScreenLootPanel.prototype;

// --- Per-item gold compensation overlay (Variant 1) ---
// EIMO-style: append a static, hidden layer at slot-create time; in
// assign/remove only toggle visibility and update the label text.

var _tcCreateItemSlot = TCRSLootPanel.createItemSlot;
TCRSLootPanel.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv) {
    var slot = _tcCreateItemSlot.call(this, _owner, _index, _parentDiv, _screenDiv);
    var layer = $('<div class="challenges-gold-layer display-none"/>');
    slot.append(layer);
    var img = $('<img/>');
    img.attr('src', Path.GFX + Asset.ICON_ASSET_MONEY);
    layer.append(img);
    layer.append($('<div class="label text-font-very-small font-color-value font-shadow-outline"/>'));
    return slot;
};

function setChallengesGoldVisible(_slot, _gold) {
    var layer = _slot.find('.challenges-gold-layer:first');
    if (_gold > 0) {
        layer.find('.label:first').text(_gold.toString());
        layer.removeClass('display-none').addClass('display-block');
    } else {
        layer.removeClass('display-block').addClass('display-none');
    }
}

// --- Capped outline + gold overlay + total recalc ---

var _tcAssignItemToSlot = TCRSLootPanel.assignItemToSlot;
TCRSLootPanel.assignItemToSlot = function (_owner, _slot, _item) {
    _tcAssignItemToSlot.call(this, _owner, _slot, _item);
    var challenges = (_item !== null && _item.challenges) ? _item.challenges : null;

    // Persist on slot so updateChallengesCompTotal can read it without re-querying.
    var itemData = _slot.data('item') || {};
    itemData.challenges = challenges;
    _slot.data('item', itemData);

    if (challenges !== null && challenges.capped === true) {
        _slot.addClass('challenges-capped');
        setChallengesGoldVisible(_slot, challenges.gold);
    } else {
        _slot.removeClass('challenges-capped');
        setChallengesGoldVisible(_slot, 0);
    }
    if (this.mChallengesCompTotalLabel) this.updateChallengesCompTotal();
};

var _tcRemoveItemFromSlot = TCRSLootPanel.removeItemFromSlot;
TCRSLootPanel.removeItemFromSlot = function (_slot) {
    _tcRemoveItemFromSlot.call(this, _slot);
    _slot.removeClass('challenges-capped');
    setChallengesGoldVisible(_slot, 0);
    var itemData = _slot.data('item');
    if (itemData) itemData.challenges = null;
    if (this.mChallengesCompTotalLabel) this.updateChallengesCompTotal();
};

// --- Total compensation row below the stash bag (Variant 2) ---

var _tcCreateDIV = TCRSLootPanel.createDIV;
TCRSLootPanel.createDIV = function (_parentDiv) {
    _tcCreateDIV.call(this, _parentDiv);

    // Append directly to .column.is-middle (same parent as the stash bag),
    // not to .row.is-content — that row is bounded vertically and would
    // clip an absolutely-positioned element using a large `top` value.
    var middleColumn = this.mContainer.children('.column.is-middle');
    var container = $('<div class="challenges-comp-total-container display-none"/>');
    middleColumn.append(container);
    var img = $('<img/>');
    img.attr('src', Path.GFX + Asset.ICON_ASSET_MONEY);
    container.append(img);
    this.mChallengesCompTotalLabel = $('<div class="label text-font-small font-bold font-color-value"/>');
    container.append(this.mChallengesCompTotalLabel);
    this.mChallengesCompTotalContainer = container;
};

var _tcDestroyDIV = TCRSLootPanel.destroyDIV;
TCRSLootPanel.destroyDIV = function () {
    if (this.mChallengesCompTotalContainer) {
        this.mChallengesCompTotalContainer.remove();
        this.mChallengesCompTotalContainer = null;
        this.mChallengesCompTotalLabel = null;
    }
    _tcDestroyDIV.call(this);
};

TCRSLootPanel.updateChallengesCompTotal = function () {
    // Compensation is paid only for capped items left in the found-loot pile.
    // Items taken to the stash are kept as-is and grant no gold.
    var total = (this.mFoundLootSlots || []).reduce(function (sum, slot) {
        var data = slot.data('item');
        return data && data.challenges && data.challenges.capped
            ? sum + (data.challenges.gold || 0) : sum;
    }, 0);
    if (total > 0) {
        this.mChallengesCompTotalLabel.text(total);
        this.mChallengesCompTotalContainer.removeClass('display-none').addClass('display-block');
    } else {
        this.mChallengesCompTotalContainer.removeClass('display-block').addClass('display-none');
    }
};
