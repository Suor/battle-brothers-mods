local def = ::Challenges, mod = def.mh;

// Settings
def.add(::MSU.Class.SettingsTitle("lootTitle", "Loot"));
def.add(::Challenges.SliderSetting("weaponDropChance", 1.0,
    [1.0, 0.75, 0.5, 0.25, 0.1, 0.0],
    ["100%" "75%" "50%" "25%" "10%" "0%"],
    "Weapon & Shield Drop Chance",
    "Chance for weapons and shields to drop when enemies die. "
    + "Does not affect other item types."));
def.add(::Challenges.SliderSetting("armorDropChance", 1.0,
    [1.0, 0.75, 0.5, 0.25, 0.1, 0.0],
    ["100%" "75%" "50%" "25%" "10%" "0%"],
    "Armor & Helmet Drop Chance",
    "Chance for armor and helmets to drop when enemies die. "
    + "Does not affect other item types."));
def.add(::Challenges.SliderSetting("maxItemsPerBattle", -1,
    [-1, 5, 4, 3, 2, 1, 0],
    ["off" "5" "4" "3" "2" "1" "none"],
    "Max Equipment Drops Per Battle",
    "Maximum number of weapons/shields and armor/helmets that can drop in a single battle. "
    + "Additional drops are blocked and may be compensated in gold."));
def.add(::Challenges.SliderSetting("lootGoldComp", 1.0,
    [1.0, 0.5, 0.0],
    ["full" "half" "none"],
    "Gold Compensation",
    "Gold received for each equipment piece that does not drop due to the settings above. "
    + "Accounts for item condition."));
def.add(::MSU.Class.BooleanSetting("protectNamed", true, "Protect Named Items",
    "Named and legendary items always drop regardless of other loot settings."));

// Add money to combat loot in place of a blocked item drop.
local function compensate(_item) {
    local goldComp = def.conf("lootGoldComp");
    if (goldComp <= 0.0) return;
    local amount = ::Math.floor(_item.getValue() * goldComp * 0.15);
    if (amount <= 0) return;
    local money = ::new("scripts/items/supplies/money_item");
    money.setAmount(amount);
    ::Tactical.CombatResultLoot.add(money);
}

// Returns true if this item must always drop (named/legendary protection).
local function isProtected(_item) {
    if (def.conf("protectNamed") && (
            _item.isItemType(::Const.Items.ItemType.Named) ||
            _item.isItemType(::Const.Items.ItemType.Legendary)))
        return true;
    local isPlayer = _item.m.LastEquippedByFaction == ::Const.Faction.Player;
    return isPlayer && !::Tactical.State.isScenarioMode() && ::World.Assets.m.IsBlacksmithed;
}

// Removes the item from whatever container holds it. By the end of gatherLoot
// the tile is irrelevant — combat is over and the map is about to be torn down.
local function removeFromContainer(_item) {
    local cont = _item.m.Container;
    if (::std.Util.isKindOf(cont, "stash_container")) cont.remove(_item);
    if (::std.Util.isKindOf(cont, "item_container")) {
        if (_item.m.CurrentSlotType == ::Const.ItemSlot.Bag) cont.removeFromBag(_item);
        else cont.unequip(_item);
    }
}

// Applies chance and per-battle cap to all loot. Survivors stay where
// they ended up (loot pile or a brother's bag). Rejected items are destroyed
// and replaced with money in the loot pile.
local function filterLoot(_loot) {
    if (_loot.len() == 0) return;

    local weaponChance = def.conf("weaponDropChance");
    local armorChance = def.conf("armorDropChance");
    local survived = [], rejected = [];
    foreach (item in _loot) {
        local chance = ::std.Util.isKindOf(item, "weapon") || ::std.Util.isKindOf(item, "shield")
            ? weaponChance : armorChance;
        if (chance >= 1.0 || ::std.Rand.chance(chance)) survived.push(item);
        else rejected.push(item);
    }

    local maxItems = def.conf("maxItemsPerBattle");
    if (maxItems >= 0 && survived.len() > maxItems) {
        local weights = survived.map(@(item) item.getValue());
        local kept = ::std.Rand.take(maxItems, survived, weights);
        foreach (item in survived)
            if (kept.find(item) == null) rejected.push(item);
    }

    foreach (item in rejected) {
        compensate(item);
        removeFromContainer(item);
    }
}

// Hooks

mod.hook("scripts/states/tactical_state", function (q) {
    q.m.challenges_loot <- [];

    q.init = @(__original) function () {
        this.m.challenges_loot = [];
        __original();
    }

    q.gatherLoot = @(__original) function () {
        __original();
        local props = !this.isScenarioMode() ? this.m.StrategicProperties : null;
        if (props && (props.IsArenaMode || props.IsLootingProhibited)) return;

        filterLoot(this.m.challenges_loot);
        this.m.challenges_loot = [];
        ::Tactical.CombatResultLoot.sort();
    }
})

// Register item for end-of-battle filtering.
// Dedup because item can be dropped, picked up and dropped again.
local function passiveHook(q) {
    q.isDroppedAsLoot = @(__original) function () {
        local res = __original();
        if (!res || isProtected(this)) return res;
        local loot = ::Tactical.State.m.challenges_loot;
        if (loot.find(this) == null) loot.push(this);
        return res;
    }
}

mod.hook("scripts/items/weapons/weapon", passiveHook);
mod.hook("scripts/items/shields/shield", passiveHook);
mod.hook("scripts/items/armor/armor", passiveHook);
mod.hook("scripts/items/helmets/helmet", passiveHook);
