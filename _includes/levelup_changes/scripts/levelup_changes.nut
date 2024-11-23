local version = 0.1, prev = null, debug = false;
::logInfo("LevelUpChanges " + version + " (<mod_name>)");
if ("LevelUpChanges" in getroottable()) {
    if (::LevelUpChanges.version >= version) return;
    prev = ::LevelUpChanges;
}
::logInfo("LevelUpChanges " + version + ", prev = " + prev);
::LevelUpChanges <- {
    version = version // version to not overwrite newer versions of itself

    callbacks = []
    function onLevel(_func) {callbacks.push(_func)}
}

// Drop previous js file, add our file
::Hooks.JSFiles = ::Hooks.JSFiles.filter(@(_, f) f.find("_levelup_changes.js") == null);
::Hooks.registerJS("ui/mods/i_<mod_name>_levelup_changes.js");

local mod = ::Hooks.getMod("mod_<mod_name>");
mod.hook("scripts/entity/tactical/player", function (q) {
    if (version != ::LevelUpChanges.version) return;

    q.addLevelUpChanges <- function (_title, _items) {
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

    q.updateLevel = @(__original) function () {
        local prevLevel = this.m.Level;
        __original();

        for (local level = prevLevel; ++level <= this.m.Level;) {
            foreach (cb in LevelUpChanges.callbacks) cb(this, level);
        }
    }
})
mod.hook("scripts/ui/global/data_helper", function (q) {
    if (version != ::LevelUpChanges.version) return;

    // local function joinAnd(_strings) {
    //     local res = "", last = _strings.len() - 1;
    //     foreach (i, item in _strings) {
    //         local sep = i == 0 ? "" : i == last ? " and " : ", ";
    //         res += sep + item;
    //     }
    //     return res;
    // }

    q.convertEntityToUIData = @(__original) function (_entity, _activeEntity) {
        local ret = __original(_entity, _activeEntity);
        if (!("levelUpChanges" in _entity) || _entity.levelUpChanges.len() == 0) return ret;


        local title = "", items = [], last = _entity.levelUpChanges.len() - 1;
        foreach (i, line in _entity.levelUpChanges) {
            local sep = i == 0 ? "" : i == last ? " and " : ", ";
            title += sep + line.title;
            items.extend(line.items);
        }
        ret.levelUpChanges <- {title = title, items = items}
        _entity.levelUpChanges;
        return ret;
    }
})
mod.hook("scripts/ui/screens/tooltip/tooltip_events", function (q) {
    if (version != ::LevelUpChanges.version) return;

    q.onQueryStatusEffectTooltipData = @(__original) function (_entityId, _statusEffectId) {
        local ret = __original(_entityId, _statusEffectId);
        if (ret != null) return ret;

        local entity = ::Tactical.getEntityByID(_entityId);
        if (entity == null || !("levelUpChanges" in entity)) return null;

        foreach (line in entity.levelUpChanges) {
            foreach (skill in line.items)
                if (_statusEffectId == skill.id) return skill.tooltip;
        }
    }
})
