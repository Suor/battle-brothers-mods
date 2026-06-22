local def = ::Challenges, mod = def.mh;
local add = def.addGear;

// Settings
add(::MSU.Class.SettingsDivider("gearDiv"));
add(::MSU.Class.SettingsTitle("gearTitle", "Gear"));
add(::Challenges.SliderSetting("shieldsAllowed", "all",
    ["all", "light", "bucklers", "none"],
    ["All" "Light" "Bucklers" "None"],
    "Allowed Shields",
    "Which shields your brothers may equip. Light also lets bucklers through; Bucklers allows only"
    + " those. Enemies keep their shields, and you can still loot and sell the banned ones."));
// Fill the column beside the slider so the two-handed checkboxes wrap onto their own row below.
add(::MSU.Class.SettingsSpacer("gearShieldsSpacer", "35rem", "8rem"));
add(::MSU.Class.BooleanSetting("noTwoHandedSwords", false, "No Two-Handed Swords",
    "Your brothers can't equip two-handed swords. You can still loot and sell them."));
add(::MSU.Class.BooleanSetting("noTwoHandedHammers", false, "No Two-Handed Hammers",
    "Your brothers can't equip two-handed hammers. You can still loot and sell them."));

local bucklers = {
    "shield.buckler": true
    "shield.legend_mummy_shield": true
}

local function isShieldAllowed(_item) {
    local mode = def.conf("shieldsAllowed");
    if (mode == "all") return true;
    if (mode == "none") return false;
    if (mode == "light") return _item.getStaminaModifier() >= -10;
    if (mode == "bucklers") return _item.getID() in bucklers;
    return true;
}

local function isBanned(_item) {
    if (_item == null) return false;
    local IT = ::Const.Items.ItemType;
    if (_item.isItemType(IT.Shield)) return !isShieldAllowed(_item);
    if (_item.isItemType(IT.TwoHanded) && _item.isItemType(IT.Weapon)) {
        local WT = ::Const.Items.WeaponType;  // added by MSU
        if (def.conf("noTwoHandedSwords") && _item.isWeaponType(WT.Sword)) return true;
        if (def.conf("noTwoHandedHammers") && _item.isWeaponType(WT.Hammer)) return true;
    }
    return false;
}

// Refuse the equip at the container so it holds everywhere - inventory screen, tactical swaps
// and AI alike - mirroring how the druid mod enforces its Beastform gear ban.
mod.hook("scripts/items/item_container", function (q) {
    q.equip = @(__original) function (_item) {
        if (::std.Util.isKindOf(m.Actor, "player") && isBanned(_item)) return false;
        return __original(_item);
    }
})
