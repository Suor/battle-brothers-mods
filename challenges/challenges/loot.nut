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

// Per-battle drop counter, reset at the start of each gatherLoot call.
def._lootCount <- 0;

// Add gold to player wallet for a blocked item drop (based on condition).
local function compensate(_item) {
    local goldComp = def.conf("lootGoldComp");
    if (goldComp <= 0.0) return;
    local cond = _item.m.ConditionMax > 0
        ? _item.m.Condition.tofloat() / _item.m.ConditionMax : 1.0;
    local amount = ::Math.floor(_item.m.Price * cond * goldComp);
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

// Applies cap and chance filter after vanilla isDroppedAsLoot said yes.
// Returns the final drop decision.
local function filterDrop(_item, _chance) {
    if (isProtected(_item)) return true;

    local maxItems = def.conf("maxItemsPerBattle");
    if (maxItems >= 0 && def._lootCount >= maxItems) {
        compensate(_item);
        return false;
    }

    if (_chance < 1.0 && ::Math.rand(0, 99) >= _chance * 100) {
        compensate(_item);
        return false;
    }

    def._lootCount++;
    return true;
}

// Hooks

// Reset the drop counter at battle start so isDroppedAsLoot() calls via item.drop() during
// combat don't carry over stale counts from a previous battle.
mod.hook("scripts/states/tactical_state", function (q) {
    q.init = @(__original) function () {
        def._lootCount = 0;
        __original();
    }
})

// Weapons and shields share the weaponDropChance setting.
mod.hook("scripts/items/weapons/weapon", function (q) {
    q.isDroppedAsLoot = @(__original) function () {
        if (!__original()) return false;
        return filterDrop(this, def.conf("weaponDropChance"));
    }
})

mod.hook("scripts/items/shields/shield", function (q) {
    q.isDroppedAsLoot = @(__original) function () {
        if (!__original()) return false;
        return filterDrop(this, def.conf("weaponDropChance"));
    }
})

// Armor and helmets share the armorDropChance setting.
mod.hook("scripts/items/armor/armor", function (q) {
    q.isDroppedAsLoot = @(__original) function () {
        if (!__original()) return false;
        return filterDrop(this, def.conf("armorDropChance"));
    }
})

mod.hook("scripts/items/helmets/helmet", function (q) {
    q.isDroppedAsLoot = @(__original) function () {
        if (!__original()) return false;
        return filterDrop(this, def.conf("armorDropChance"));
    }
})
