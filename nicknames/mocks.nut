// Mocks for nicknames test runner.
// Load stdlib mocks first, then this file.

::Const.SkillType <- {Trait = 1}
::Const.ItemSlot  <- {Mainhand = 0}
::Const.Items <- {
    WeaponType = {
        Sword = 0, Axe = 1, Mace = 2, Hammer = 3, Spear = 4,
        Polearm = 5, Bow = 6, Crossbow = 7, Dagger = 8,
        Cleaver = 9, Flail = 10, Throwing = 11
    }
}
::Math.rand <- function (mn, mx) {
    return mn; // always pick first candidate in tests
}
::World <- {
    function getPlayerRoster() {return {function getAll() {return []}}}
    Statistics = {function getFallen() {return []}}
}

local captured_onHired = null;

local mod_obj = {
    function conflictWith(...) {}
    function queue(...) {vargv[vargv.len()-1]()}
    function hook(_filename, func) {
        local q = {setStartValuesEx = null}
        func(q);
        captured_onHired = q.setStartValuesEx;
    }
}
::Hooks <- {
    function register(_id, _ver, _name) {return mod_obj}
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
function makeBro(bgId, bgAttrs = null, traits = [], talents = null, baseProps = null, bgDailyCost = 5, bgTitles = []) {
    local defaultAttrs = {
        Hitpoints = [0, 0], Bravery = [0, 0], Stamina = [0, 0],
        MeleeSkill = [0, 0], RangedSkill = [0, 0],
        MeleeDefense = [0, 0], RangedDefense = [0, 0], Initiative = [0, 0]
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
        function getID()    {return "bro_test"}
        function getName()    {return "Test Bro"}
        function getTitle() {return title}
        function setTitle(t) {title = t}
        m = {
            Talents = talents != null ? talents : [0, 0, 0, 0, 0, 0, 0, 0]
        }
        b = {}
        function getSkills() {
            local traitList = _traits;
            local bgId = _bgId;
            return {
                function hasSkill(id) {
                    if (id == bgId) return true;
                    foreach (t in traitList) {
                        local tid = typeof t == "string" ? t : t.id;
                        if (tid == id) return true;
                    }
                    return false;
                }
                function getAllSkillsOfType(_type) {
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
            return {
                m = {Titles = _bgTitles, DailyCost = _dailyCost}
                b = {Titles = _bgTitles, DailyCost = _dailyCost}
                function getID() {return _bgId}
                function onChangeAttributes() {return _attrs}
            }
        }
        function getItems() {
            return {function getItemAtSlot(_slot) {return null}}
        }
        function getBaseProperties() {return props}
    }
}
