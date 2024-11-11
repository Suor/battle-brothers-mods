local version = 0.1, prev = null, debug = false;
logInfo("LevelUpChanges " + version + " (includes)"); // TODO: put module name
if ("LevelUpChanges" in getroottable()) {
    if (::LevelUpChanges.version >= version) return;
    prev = ::LevelUpChanges;
}
logInfo("LevelUpChanges " + version + ", prev = " + prev);
::LevelUpChanges <- {
    version = version // version to not overwrite newer versions of itself

    callbacks = []
    function onLevel(_func) {callbacks.push(_func)}

    // hooks = {}
    // function prepareHook(_obj, _method) {
    //     if (_obj in hooks && _method in hooks[_obj]) throw "Forgot to unhook " + _method;
    //     if (!(_method in _obj)) {
    //         // We are trying to hook a thing that is not there, MSU changed, unhook all and hide!
    //         unhookAll();
    //         return;
    //     }
    //     if (!(_obj in hooks)) hooks[_obj] <- {};
    //     return hooks[_obj][_method] <- _obj[_method];
    // }
    // function unhookAll() {
    //     foreach (obj, methods in hooks) {
    //         foreach (method, original in methods) obj[method] <- original;
    //     }
    //     hooks = {};
    // }
};

::mods_registerJS("i_retinue_ups_levelup_changes.js"); // TODO: set up s///;

::mods_hookExactClass("entity/tactical/player", function (cls) {
    cls.addLevelUpChanges <- function (_title, _items) {
        if (_items.len() == 0) return;
        if (!("levelUpChanges" in this)) this.levelUpChanges <- [];
        foreach (line in this.levelUpChanges) {
            if (line.title == _title) {
                line.item.extend(_items);
                return;
            }
        }
        this.levelUpChanges.push({title = _title, items = _items});
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
    local convertEntityToUIData = cls.convertEntityToUIData;
    cls.convertEntityToUIData = function (_entity, _activeEntity) {
        local ret = convertEntityToUIData(_entity, _activeEntity);
        if (!("levelUpChanges" in _entity) || _entity.levelUpChanges.len() == 0) return ret;

        ret.levelUpChanges <- _entity.levelUpChanges;
        return ret;
    }
})
::mods_hookExactClass("ui/screens/tooltip/tooltip_events", function (cls) {
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
