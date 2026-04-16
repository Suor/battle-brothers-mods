// Mocks for nicknames test runner.
// Load stdlib mocks first, then this file.

::Const.Attributes <- {
    Hitpoints = 0, Fatigue = 1, MeleeSkill = 2, Initiative = 3,
    RangedSkill = 4, Bravery = 5, MeleeDefense = 6, RangedDefense = 7,
    COUNT = 8
}
::Const.SkillType <- {Trait = 1, Perk = 4, PermanentInjury = 4096, All = 0xFFFF}
::Const.ItemSlot  <- {Mainhand = 0}
::Const.Items <- {
    WeaponType = {
        Sword = 0, Axe = 1, Mace = 2, Hammer = 3, Spear = 4,
        Polearm = 5, Bow = 6, Crossbow = 7, Dagger = 8,
        Cleaver = 9, Flail = 10, Throwing = 11
    }
}
::BgPerks <- {
    fallbacks = {
        "student": ["rf_promised_potential"]
        "fast_adaption": ["rf_pattern_recognition"]
    }
}
::Math.rand <- function (mn, mx) {
    return mn; // always pick first candidate in tests
}
::World <- {
    function getPlayerRoster() {return {function getAll() {return []}}}
    Statistics = {function getFallen() {return []}}
    Flags = {
        function set(_key, _vale) {}
        function getAsInt(_key) {return 0}
    }
}

local captured_onHired = null;

local mod_obj = {
    function conflictWith(...) {}
    function queue(...) {
        local func = vargv.pop();
        if (typeof func == "integer") func = vargv.pop();
        func();
    }
    function hook(_filename, _func) {
        _func({}.setdelegate({_set = @(k,v) null}))
    }
    function hookTree(_filename, _func) {
        _func({}.setdelegate({_set = @(k,v) null}))
    }
}
::Hooks <- {
    QueueBucket = {VeryLate = 4}
    function register(_id, _ver, _name) {return mod_obj}
    function hasMod(_id) {return false}
}
::include <- function(path) {
    if (path == "nicknames/rosetta_ru") return; // no-op in tests
    dofile(path + ".nut", true);
}

// Returns the captured onHired function after loading the mod
function getNicknamesOnHired() {
    return captured_onHired;
}

// Build a minimal bro mock.
// bgId: full background id, e.g. "background.hackflows_falconer"
// bgAttrs: onChangeAttributes result, e.g. {Hitpoints = [-3,-3], RangedSkill = [8,10], ...}
// traits: list of trait IDs or {id, titles} tables
// talents: array of 8 talent values (0-3)
// baseProps: override base properties
// bgDailyCost: background DailyCost (default 5 = cheap/common)
// bgTitles: vanilla .m.Titles for the background
function makeBro(bgId, bgAttrs = null, traits = [], talents = null, baseProps = null, bgDailyCost = 5, bgTitles = [], perks = [], bgProps = null, injuries = []) {
    local defaultAttrs = {
        Hitpoints = [0, 10], Bravery = [0, 10], Stamina = [0, 10],
        MeleeSkill = [0, 10], RangedSkill = [0, 10],
        MeleeDefense = [0, 10], RangedDefense = [0, 10], Initiative = [0, 10]
    };
    local attrs = bgAttrs != null ? bgAttrs : defaultAttrs;

    local defaultProps = {
        Hitpoints = 55, Bravery = 35, Stamina = 95,
        MeleeSkill = 52, RangedSkill = 37,
        MeleeDefense = 2, RangedDefense = 2, Initiative = 105
    };
    local props = baseProps != null ? baseProps : defaultProps;

    local title = "";
    return {
        _bgId     = bgId
        _traits   = traits
        _perks    = perks
        function getID()    {return "bro_test"}
        function getName()    {return "Test Bro"}
        function getTitle() {return title}
        function setTitle(t) {title = t}
        m = {
            Talents = talents != null ? talents : [0, 0, 0, 0, 0, 0, 0, 0]
        }
        b = {}
        function getSkills() {
            local traitList  = _traits;
            local perkList   = _perks;
            local injuryList = injuries;
            local bgId = _bgId;
            return {
                function hasSkill(id) {
                    if (id == bgId) return true;
                    foreach (t in traitList) {
                        local tid = typeof t == "string" ? t : t.id;
                        if (tid == id) return true;
                    }
                    foreach (p in perkList) if (p == id) return true;
                    foreach (inj in injuryList) if (inj == id) return true;
                    return false;
                }
                function query(_type) {
                    local result = [];
                    if (_type & ::Const.SkillType.Trait) result.extend(getAllSkillsOfType(::Const.SkillType.Trait));
                    if (_type & ::Const.SkillType.Perk)  result.extend(getAllSkillsOfType(::Const.SkillType.Perk));
                    if (_type & ::Const.SkillType.PermanentInjury) result.extend(getAllSkillsOfType(::Const.SkillType.PermanentInjury));
                    return result;
                }
                function getAllSkillsOfType(_type) {
                    if (_type == ::Const.SkillType.PermanentInjury) {
                        return injuryList.map(function(inj) {
                            return {function getID() {return inj}};
                        });
                    }
                    if (_type == ::Const.SkillType.Perk) {
                        return perkList.map(function(p) {
                            return {m = {Titles = []} b = {Titles = []} function getID() {return p}};
                        });
                    }
                    return traitList.map(function(t) {
                        local _id     = typeof t == "string" ? t : t.id;
                        local _titles = typeof t == "string" ? [] : t.titles;
                        return {
                            m = {Titles = _titles}
                            b = {Titles = _titles}
                            function getID() {return _id}
                        };
                    });
                }
            }
        }
        function getBackground() {
            local _attrs     = attrs;
            local _bgId      = bgId;
            local _dailyCost = bgDailyCost;
            local _bgTitles  = bgTitles;
            local _bgProps   = bgProps;
            local bg = {
                m = {
                    Titles = _bgTitles,
                    DailyCost = _dailyCost,
                    IsNoble = false,
                    IsCombatBackground = false,
                    IsLowborn = false,
                    IsOffendedByViolence = false,
                }
                function getID() {return _bgId}
                function onChangeAttributes() {return _attrs}
            };
            if (_bgProps != null) foreach (k, v in _bgProps) bg.m[k] <- v;
            return bg;
        }
        function getItems() {
            return {function getItemAtSlot(_slot) {return null}}
        }
        function getBaseProperties() {return props}
        function getCurrentProperties() {return props}
    }
}
