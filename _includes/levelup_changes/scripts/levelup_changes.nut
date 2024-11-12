local version = 0.1, prev = null, debug = false;
logInfo("LevelUpChanges " + version + " (<mod_name>)");
if ("LevelUpChanges" in getroottable()) {
    if (::LevelUpChanges.version >= version) return;
    prev = ::LevelUpChanges;
}
logInfo("LevelUpChanges " + version + ", prev = " + prev);
::LevelUpChanges <- {
    version = version // version to not overwrite newer versions of itself

    callbacks = []
    function onLevel(_func) {callbacks.push(_func)}
}

// TODO: handle different versions, including different js versions
::mods_registerJS("i_<mod_name>_levelup_changes.js");

::mods_hookExactClass("entity/tactical/player", function (cls) {
    if (version != ::LevelUpChanges.version) return;

    cls.addLevelUpChanges <- function (_title, _items) {
        if (_items.len() == 0) return;
        if (!("levelUpChanges" in this)) this.levelUpChanges <- [];

        local items = _items.map(function (_skill) {
            if ("id" in _skill && "icon" in _skill) return _skill;

            return {
                id = _skill.getID()
                icon = _skill.getIcon()
                tooltip = _skill.getTooltip() // TODO: do not save tooltip and icon?
                removed = false
            }
        })

        foreach (line in this.levelUpChanges) {
            if (line.title == _title) {
                line.items.extend(items);
                return;
            }
        }
        this.levelUpChanges.push({title = _title, items = items});
    }

    local updateLevel = cls.updateLevel;
    cls.updateLevel = function () {
        local prevLevel = this.m.Level;
        updateLevel();

        for (local level = prevLevel; ++level <= this.m.Level;) {
            foreach (cb in LevelUpChanges.callbacks) cb(this, level);
        }
    }
})
::mods_hookExactClass("ui/global/data_helper", function (cls) {
    if (version != ::LevelUpChanges.version) return;

    local convertEntityToUIData = cls.convertEntityToUIData;
    cls.convertEntityToUIData = function (_entity, _activeEntity) {
        local ret = convertEntityToUIData(_entity, _activeEntity);
        if (!("levelUpChanges" in _entity) || _entity.levelUpChanges.len() == 0) return ret;

        local title = null, items = [];
        foreach (line in _entity.levelUpChanges) {
            title = title ? title + ", " + line.title : line.title;
            items.extend(line.items);
        }
        ret.levelUpChanges <- {title = title, items = items}
        _entity.levelUpChanges;
        return ret;
    }
})
::mods_hookExactClass("ui/screens/tooltip/tooltip_events", function (cls) {
    if (version != ::LevelUpChanges.version) return;

    local onQueryStatusEffectTooltipData = cls.onQueryStatusEffectTooltipData;
    cls.onQueryStatusEffectTooltipData = function (_entityId, _statusEffectId) {
        local ret = onQueryStatusEffectTooltipData(_entityId, _statusEffectId);
        if (ret != null) return ret;

        local entity = ::Tactical.getEntityByID(_entityId);
        if (entity == null || !("levelUpChanges" in entity)) return null;

        foreach (line in entity.levelUpChanges) {
            foreach (skill in line.items)
                if (_statusEffectId == skill.id) return skill.tooltip;
        }
    }
})
