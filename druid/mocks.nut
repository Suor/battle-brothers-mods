// Druid test mocks. Load stdlib's tests/mocks.nut first (it creates ::Const, ::Math, ::include),
// then this file, which adds the bits scripts/config/z_druid.nut needs plus a few test fakes.

::logInfo <- function (_s) { print(_s + "\n") }
::logWarning <- function (_s) { print("WARN: " + _s + "\n") }
::logError <- function (_s) { print("ERROR: " + _s + "\n") }

// z_druid.nut injects into ::Const.Perks and reads ::Const.World / ::Const.Items.
::Const.Perks <- { LookupMap = {} };
::Const.World <- {
    TerrainType = {
        Snow = 0, SnowyForest = 1, Tundra = 2, Plains = 3, Farmland = 4, Forest = 5,
        LeaveForest = 6, AutumnForest = 7, Steppe = 8, Desert = 9, Oasis = 10,
        Swamp = 11, Hills = 12, Mountains = 13, Badlands = 14
    }
};
::Const.Items <- {
    ItemType = {
        None = 0, Shield = 64, RangedWeapon = 512, MeleeWeapon = 1024,
        Weapon = 2048, Helmet = 4096, Armor = 8192
    }
};

// A fake skill container exposing only hasSkill(id), enough for ::Const.Druid.isPerkBlocked.
function makeSkills(_ids) {
    return {
        ids = _ids
        function hasSkill(_id) { return this.ids.find(_id) != null; }
    };
}

// A fake item: a type bitmask + a (negative) fatigue/stamina modifier, enough for beastformAllows.
function makeItem(_typeMask, _staminaMod = 0) {
    return {
        typeMask = _typeMask
        sm = _staminaMod
        function isItemType(_m) { return (this.typeMask & _m) != 0; }
        function getStaminaModifier() { return this.sm; }
    };
}
