local function hookFaction(cls) {
    cls = cls[cls.SuperName];

    cls.m.ca_Camps <- [];

    cls.ca_addCamp <- function (_camp) {
        _camp.addFaction(this.getID());
        _camp.updatePlayerRelation();
        this.m.ca_Camps.push(_camp);
    }
    cls.ca_getCamps <- function () {
        return this.m.ca_Camps
    }

    local function findBy(arr, func) {
        foreach (i, item in arr) {
            if (func(item)) return i;
        }
    }

    local removeSettlement = cls.removeSettlement;
    cls.removeSettlement = function (_s) {
        removeSettlement(_s);
        local i = findBy(this.m.ca_Camps, @(c) c.getID() == _s.getID());
        if (i != null) this.m.ca_Camps.remove(i);
    }

    // We store camps as settlements, but separate them after loading,
    // leaving them there confuses lots of actions and contracts trying to use them as towns.
    local onSerialize = cls.onSerialize;
    cls.onSerialize = function (_out) {
        local onlySettlements = clone this.m.Settlements;
        this.m.Settlements.extend(this.m.ca_Camps);
        onSerialize(_out);
        this.m.Settlements = onlySettlements;
    }

    local onDeserialize = cls.onDeserialize;
    cls.onDeserialize = function (_in) {
        onDeserialize(_in);
        local mixed = this.m.Settlements;
        this.m.Settlements = mixed.filter(@(_, s) ::isKindOf(s, "settlement"));
        this.m.ca_Camps = mixed.filter(@(_, s) !::isKindOf(s, "settlement"));
    }
}

::mods_hookExactClass("factions/noble_faction", hookFaction);
::mods_hookExactClass("factions/city_state_faction", hookFaction);
