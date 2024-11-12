var LevelUpChanges = {};

// Show injuries changes on level up
LevelUpChanges.CharacterScreenLeftPanelHeaderModule_createLevelUpDialogContent
    = CharacterScreenLeftPanelHeaderModule.prototype.createLevelUpDialogContent;
CharacterScreenLeftPanelHeaderModule.prototype.createLevelUpDialogContent = function ()
{
    var result = LevelUpChanges.CharacterScreenLeftPanelHeaderModule_createLevelUpDialogContent.call(this);

    var brother = this.mDataSource.getSelectedBrother();
    if (!("levelUpChanges" in brother)) return result;

    var entityId = brother[CharacterScreenIdentifier.Entity.Id];

    // TODO: move styles to a css file
    $(".levelup-popup").css({
        // TODO: get this background to levelup_changes
        "background-image": 'url("coui://gfx/ui/skin/popup_background_600x458.png")',
        "background-size": "60.0rem 45.8rem",
        "height": "36rem"
        // "height": (30 + 6 * brother.levelUpChanges.length) + "rem"
    });
    result.append('<div style="clear: left"></div>')

    var subTitleText = brother.levelUpChanges.title;
    var subTitle = $('<div class="sub-title text-font-normal font-style-italic font-color-subtitle">' + subTitleText + '</div>');
    subTitle.css("background", "none");
    result.append(subTitle);

    var changes = $('<div class="changes"></div>');
    changes.css({
        "width": "44.8rem",
        "height": "3rem",
        "position": "relative"
    })
    this.levelUpAddSkills(changes, entityId, brother.levelUpChanges.items);
    result.append(changes)

    return result;
}

CharacterScreenLeftPanelHeaderModule.prototype.levelUpAddSkills = function (_parentDiv, _entityId, _data) {
    if (_data.length == 0) return

    var container = $('<div class="skill-container" style="text-align: center"/>');

    for (var i = 0; i < _data.length; ++i) {
        var image = $('<img/>');
        image.css({
            width: "4.0rem",
            height: "4.0rem",
            margin: "0 0.1rem",
        })
        if (_data[i].removed) image.css({"border-radius": "2rem", "box-shadow": "0 0 4pt 3pt #111"})
        image.attr('src', Path.GFX + _data[i].icon);
        container.append(image);

        image.bindTooltip({ contentType: 'status-effect', entityId: _entityId, statusEffectId: _data[i].id });
    }
    _parentDiv.append(container);
}
