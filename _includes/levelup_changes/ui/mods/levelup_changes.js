var LevelUpChanges = {};

// Show injuries changes on level up
LevelUpChanges.CharacterScreenLeftPanelHeaderModule_createLevelUpDialogContent
    = CharacterScreenLeftPanelHeaderModule.prototype.createLevelUpDialogContent;
CharacterScreenLeftPanelHeaderModule.prototype.createLevelUpDialogContent = function ()
{
    var result = LevelUpChanges.CharacterScreenLeftPanelHeaderModule_createLevelUpDialogContent.call(this);

    var brother = this.mDataSource.getSelectedBrother();
    if (!("levelUpChanges" in brother) || brother.levelUpChanges.length == 0) return result;

    var entityId = brother[CharacterScreenIdentifier.Entity.Id];

    $(".levelup-popup").css({
        "background-image": 'url("coui://gfx/ui/skin/popup_background_600x458.png")',
        "background-size": "60.0rem 45.8rem",
        "height": (30 + 6 * brother.levelUpChanges.length) + "rem"
    });
    result.append('<div style="clear: left"></div>')

    var self = this;
    brother.levelUpChanges.forEach(function (line) {
        var subTitleText = brother.levelUpChanges[0].title;
        var subTitle = $('<div class="sub-title text-font-normal font-style-italic font-color-subtitle">' + subTitleText + '</div>');
        subTitle.css("background", "none");
        result.append(subTitle);

        var changes = $('<div class="changes"></div>');
        changes.css({
            // "outline": "1px solid green",
            "width": "44.8rem",
            "height": "3rem",
            "position": "relative"
        })
        self.levelUpAddSkills(changes, entityId, line.items);
        result.append(changes)
    })

    return result;
}

CharacterScreenLeftPanelHeaderModule.prototype.levelUpAddSkills = function (_parentDiv, _entityId, _data) {
    if (_data.length == 0) return

    var container = $('<div class="skill-container" style="text-align: center"/>');

    for (var i = 0; i < _data.length; ++i) {
        var image = $('<img/>');
        image.css({
            // border: "1px solid blue",
            width: "4.0rem",
            height: "4.0rem",
            // float: "left",
            margin: "0 0.1rem",
        })
        if (_data[i].removed) image.css({"border-radius": "2rem", "box-shadow": "0 0 4pt 3pt #111"})
        image.attr('src', Path.GFX + _data[i].icon);
        container.append(image);

        // $('.overlays-container img').css({"border-radius": "1.5rem", "box-shadow": "0 0 2pt 2pt grey"})

        // if (_isSkill === true)
        // {
        //     image.bindTooltip({ contentType: 'skill', entityId: _entityId, skillId: _data[i].id });
        // }
        // else
        // {
        // console.error("bindTooltip entityId=" + _entityId + " statusEffectId=")
            image.bindTooltip({ contentType: 'status-effect', entityId: _entityId, statusEffectId: _data[i].id });
        // }
    }
    _parentDiv.append(container);
}
