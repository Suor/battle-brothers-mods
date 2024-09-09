var RandomPerk = {};
RandomPerk.CharacterScreenPerksModule_createPerkTreeDIV 
    = CharacterScreenPerksModule.prototype.createPerkTreeDIV;
CharacterScreenPerksModule.prototype.createPerkTreeDIV = function (_perkTree, _parentDiv) {
    RandomPerk.CharacterScreenPerksModule_createPerkTreeDIV.call(this, _perkTree, _parentDiv);
}


CharacterScreenPerksModule.prototype.createPerkTreeDIV = function (_perkTree, _parentDiv)
{
    var self = this;

    for (var row = 0; row < _perkTree.length; ++row)
    {
        var rowDIV = $('<div class="row"/>');
        rowDIV.css({ 'left' : 0, 'top': (row * 6.0) + 'rem' }); // css is retarded?
        _parentDiv.append(rowDIV);

        var centerDIV = $('<div class="center"/>');
        rowDIV.append(centerDIV);

        this.mPerkRows[row] = rowDIV;

        for (var i = 0; i < _perkTree[row].length; ++i)
        {
            var perk = _perkTree[row][i];
            perk.Unlocked = false;

            perk.Container = $('<div class="l-perk-container"/>');
            centerDIV.append(perk.Container);

            var perkSelectionImage = $('<img class="selection-image-layer display-none"/>');
            perkSelectionImage.attr('src', Path.GFX + Asset.PERK_SELECTION_FRAME);
            perk.Container.append(perkSelectionImage);

            perk.Image = $('<img class="perk-image-layer"/>');
            perk.Image.attr('src', Path.GFX + perk.IconDisabled);
            perk.Container.append(perk.Image);
        }

        centerDIV.css({ 'width': (5.0 * _perkTree[row].length) + 'rem' }); // css is retarded?
        centerDIV.css({ 'left': ((660 - centerDIV.width()) / 2) + 'px' }); // css is retarded?
    }
};
