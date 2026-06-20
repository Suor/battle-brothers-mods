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

// Shield weight tiers by Fatigue penalty: bucklers sit around -4, wooden/light shields around
// -8..-10, while heaters, kites and tower shields run -14 and heavier.
local BucklerFatigueMax = 5;
local LightFatigueMax = 10;

local function isShieldAllowed(_item) {
    local mode = def.conf("shieldsAllowed");
    if (mode == "all") return true;
    if (mode == "none") return false;
    local fatigue = -_item.getStaminaModifier();  // penalties are stored negative
    if (mode == "light") return fatigue <= LightFatigueMax;
    if (mode == "bucklers") return fatigue <= BucklerFatigueMax;
    return true;
}

// Only the player's own men are restricted; enemies keep their gear so the challenge bites.
local function isPlayerBro(_actor) {
    return _actor != null && !_actor.isNull() && ::std.Util.isKindOf(_actor, "player");
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
        if (isPlayerBro(this.m.Actor) && isBanned(_item)) return false;
        return __original(_item);
    }
})
