// Shared helpers for the Bro Studio scenarios, loaded by `// include: lib/helpers.nut`.
::BST <- {};

::BST.setting <- @(_name) ::BroStudio.Mod.ModSettings.getSetting(_name);

// Runs _fn with the given settings, then restores them. Sets Value directly: Bro Studio's
// slider settings keep the chosen element of their Values there, outside the Range bounds.
::BST.with <- @(_values, _fn) ::Tales.with(::BST.setting, _values, _fn, true);

// Gives the bro the XP of _level at once, then takes the pending level-ups one by one the way
// the character screen does; returns each level-up's attribute increases.
::BST.levelTo <- function (_bro, _level) {
    _bro.m.XP = ::Const.LevelXP[_level - 1];
    _bro.updateLevel();
    local out = [];
    while (_bro.m.LevelUps > 0) {
        local v = _bro.getAttributeLevelUpValues();
        out.push([v.hitpointsIncrease, v.braveryIncrease, v.fatigueIncrease, v.initiativeIncrease,
                  v.meleeSkillIncrease, v.rangeSkillIncrease, v.meleeDefenseIncrease, v.rangeDefenseIncrease]);
        v.maxFatigueIncrease <- v.fatigueIncrease; // the UI sends it under this name
        _bro.setAttributeLevelUpValues(v);
    }
    return out;
}

::BST.traitIds <- function (_skills) {
    return _skills.map(@(s) s.getID());
}
