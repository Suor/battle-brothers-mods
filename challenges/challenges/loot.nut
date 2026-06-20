local def = ::Challenges, mod = def.mh;
local Debug = ::std.Debug.with({prefix = "loot: "});

// Settings
local add = def.addPage("Loot");
add(::Challenges.SliderSetting("weaponDropChance", 1.0,
    [1.0, 0.5, 0.25, 0.1, 0.05, 0.0],
    ["100%" "50%" "25%" "10%" "5%" "0%"],
    "Weapon & Shield Drop Chance",
    "Chance for weapons and shields to drop when enemies die. "
    + "Does not affect other item types."));
add(::Challenges.SliderSetting("armorDropChance", 1.0,
    [1.0, 0.5, 0.25, 0.1, 0.05, 0.0],
    ["100%" "50%" "25%" "10%" "5%" "0%"],
    "Armor & Helmet Drop Chance",
    "Chance for armor and helmets to drop when enemies die. "
    + "Does not affect other item types."));
add(::Challenges.SliderSetting("maxItemsPerBattle", -1,
    [-1, 5, 4, 3, 2, 1, 0],
    ["off" "5" "4" "3" "2" "1" "none"],
    "Max Equipment Drops Per Battle",
    "Maximum number of weapons/shields and armor/helmets that can drop in a single battle. "
    + "Additional drops are blocked and may be compensated in gold."));
add(::Challenges.SliderSetting("lootGoldComp", 1.0,
    [1.0, 0.5, 0.0],
    ["full" "half" "none"],
    "Gold Compensation",
    "Gold received for each equipment piece that does not drop due to the settings above. "
    + "Accounts for item condition."));
add(::MSU.Class.BooleanSetting("chooseAtRandom", false, "Choose At Random",
    "If enabled loot will be capped for you behind the scenes randomly."));
add(::MSU.Class.BooleanSetting("protectNamed", true, "Protect Named Items",
    "Named and legendary items always drop regardless of other loot settings."));

local function lootStr(_item) {
    if (_item == null) return "<null>";
    local type = ::std.Util.isKindOf(_item, "weapon") ? "weapon"
        : ::std.Util.isKindOf(_item, "shield") ? "shield"
        : ::std.Util.isKindOf(_item, "armor") ? "armor"
        : ::std.Util.isKindOf(_item, "helmet") ? "helmet"
        : "?";
    return _item.ClassName + " [" + type + ", id = " + _item.getInstanceID()
        + ", value=" + _item.getValue() + ", faction=" + _item.m.LastEquippedByFaction
        + ", slot=" + _item.m.CurrentSlotType + "]";
}

// Add money to combat loot in place of blocked item drops.
local function addCompensation(_amount) {
    if (_amount <= 0) return;
    local money = ::new("scripts/items/supplies/money_item");
    money.setAmount(_amount);
    ::Tactical.CombatResultLoot.add(money);
}

// Do not prevent named and player items from dropping
local function isProtected(_item) {
    if (def.conf("protectNamed") && (
            _item.isItemType(::Const.Items.ItemType.Named) ||
            _item.isItemType(::Const.Items.ItemType.Legendary)))
        return true;
    return _item.m.LastEquippedByFaction == ::Const.Faction.Player
}

// Removes the item from whatever container holds it. By the end of gatherLoot
// the tile is irrelevant — combat is over and the map is about to be torn down.
local function removeFromContainer(_item) {
    local cont = _item.m.Container;
    if (::std.Util.isKindOf(cont, "stash_container")) cont.remove(_item);
    else if (::std.Util.isKindOf(cont, "item_container")) {
        if (_item.m.CurrentSlotType == ::Const.ItemSlot.Bag) cont.removeFromBag(_item);
        else cont.unequip(_item);
    } else {
        ::Tactical.CombatResultLoot.remove(_item);
    }
}

local function compFor(_item) {
    return ::Math.floor(_item.getValue() * def.conf("lootGoldComp") * 0.14);
}

// Remove items, return total gold compensation value.
local function removeItems(_items) {
    local money = 0;
    foreach (item in _items) {
        money += compFor(item);
        removeFromContainer(item);
    }
    return money;
}

local function updateCounts(_counts, _items) {
    foreach (item in _items) {
        if (item == null) continue;
        local cn = item.ClassName;
        if (cn in _counts) _counts[cn]++; else _counts[cn] <- 1;
    }
}

// Applies chance and per-battle cap to all loot. Survivors stay where
// they ended up (loot pile or a brother's bag). Rejected items are destroyed
// and replaced with money in the loot pile.
local function filterLoot(_loot) {
    Debug.log("filterLoot in", _loot.map(lootStr));
    if (_loot.len() == 0) return;

    local weaponChance = def.conf("weaponDropChance");
    local armorChance = def.conf("armorDropChance");
    local survived = [], rejected = [];
    foreach (item in _loot) {
        local isWeaponLike = ::std.Util.isKindOf(item, "weapon") || ::std.Util.isKindOf(item, "shield");
        local chance = isWeaponLike ? weaponChance : armorChance;
        if (chance >= 1.0 || ::std.Rand.chance(chance)) survived.push(item);
        else rejected.push(item);
    }
    Debug.log("filterLoot chance out", rejected.map(lootStr));

    local maxItems = def.conf("maxItemsPerBattle");
    if (maxItems >= 0 && survived.len() > maxItems) {
        if (def.conf("chooseAtRandom")) {
            // Prefer taking new and different items
            local counts = {};
            updateCounts(counts, ::World.Assets.getStash().getItems());
            updateCounts(counts, survived);
            local weights = survived.map(function (_item) {
                return pow(_item.getValue() + _item.m.Value, 1.5) / counts[_item.ClassName];
            });

            Debug.log("cap", {survived = survived.map(lootStr), weights = weights})
            local kept = ::std.Rand.take(maxItems, survived, weights);
            foreach (item in survived)
                if (kept.find(item) == null) rejected.push(item);
            // rejected.extend(::std.Array.diff(survived, kept))
            Debug.log("filterLoot kept cap", kept.map(lootStr));
            _loot.resize(0);  // Nothing to decide anymore
        } else {
            Debug.log("filterLoot prepare choices", survived.map(lootStr));
            Tactical.State.m.challenges_choices = survived;
        }
    }

    Debug.log("filterLoot remove", rejected.map(lootStr));
    addCompensation(removeItems(rejected));
}

local function isChoosingLoot() {
    return !def.conf("chooseAtRandom") && def.conf("maxItemsPerBattle") >= 0
        && ("State" in Tactical) && Tactical.State
        && Tactical.State.m.challenges_choices.len() > 0;
}

// Hooks

mod.hook("scripts/states/tactical_state", function (q) {
    q.m.challenges_loot <- [];
    q.m.challenges_choices <- [];

    q.init = @(__original) function () {
        m.challenges_loot = [];
        m.challenges_choices = [];
        __original();
    }

    q.gatherLoot = @(__original) function () {
        __original();
        local props = !isScenarioMode() ? m.StrategicProperties : null;
        if (props && (props.IsArenaMode || props.IsLootingProhibited)) return;

        local result = Tactical.Entities.getCombatResult();
        local isWin = result == ::Const.Tactical.CombatResult.EnemyDestroyed
            || result == ::Const.Tactical.CombatResult.EnemyRetreated;

        if (isWin) filterLoot(m.challenges_loot);
        else removeItems(m.challenges_loot);
        m.challenges_loot = [];

        ::Tactical.CombatResultLoot.sort();
    }


})

// Hide capped items from loot, call _fn, restore them, return fresh UI data.
// Caller must check capped.len() > 0 before calling.
local function withoutCappedLoot(_fn) {
    local lootItems = ::Tactical.CombatResultLoot.getItems();
    local saved = [];
    Debug.log("WCL lootItems", lootItems.map(lootStr));

    foreach (i, item in lootItems) {
        if (item != null && ::Tactical.State.m.challenges_choices.find(item) != null) {
            saved.push(item);
            lootItems[i] = null;
        }
    }
    // Remove nulls, this is needed to EIMO smart loot, which doesn't expect nulls there
    ::Tactical.CombatResultLoot.shrink();
    Debug.log("WCL lootItems after", lootItems.map(lootStr));
    Debug.log("WCL saved", saved.map(lootStr));

    if (saved.len() == 0) return _fn();
    _fn();  // stash/loot arrays modified in place; foundLoot in result is now stale

    foreach (item in saved) ::Tactical.CombatResultLoot.add(item);
    Debug.log("WCL lootItems restore",
        ::Tactical.CombatResultLoot.getItems().map(lootStr));
    return {
        stash = ::UIDataHelper.convertStashToUIData(true),
        foundLoot = ::UIDataHelper.convertCombatResultLootToUIData()
    };
}

// Register item for end-of-battle filtering.
local function passiveHook(q) {
    q.isDroppedAsLoot = @(__original) function () {
        local res = __original();
        local protected = isProtected(this);
        // Make tools (throwing nets, bombs, banners, ...) not equipment, even come from weapon.
        local isTool = this.isItemType(::Const.Items.ItemType.Tool);
        local loot = ::Tactical.State.m.challenges_loot;
        if (!res || protected || isTool) {
            // A previous call may have tracked this item (drop is non-deterministic
            // and item can be dropped, picked up and dropped again).
            local idx = loot.find(this);
            if (idx != null) loot.remove(idx);
            Debug.log("drop", lootStr(this) + " res=" + res + " protected=" + protected
                + " tool=" + isTool + (idx != null ? " untracked" : ""));
            return res;
        }

        // Dedup because item can be dropped, picked up and dropped again.
        local alreadyTracked = loot.find(this) != null;
        if (!alreadyTracked) loot.push(this);

        Debug.log("drop", lootStr(this) + " res=" + res + " protected=false"
            + (alreadyTracked ? " already" : " new"));
        return res;
    }
}

mod.hook("scripts/items/weapons/weapon", passiveHook);
mod.hook("scripts/items/shields/shield", passiveHook);
mod.hook("scripts/items/armor/armor", passiveHook);
mod.hook("scripts/items/helmets/helmet", passiveHook);

// Annotate item UI data with capped flag so JS shows an outline in both loot and stash.
mod.hook("scripts/ui/global/data_helper", function (q) {
    q.convertItemToUIData = @(__original) function (_item, _forceSmallIcon, _owner = null) {
        if (!isChoosingLoot()) return __original(_item, _forceSmallIcon, _owner);
        local result = __original(_item, _forceSmallIcon, _owner);
        if (result != null && ::Tactical.State.m.challenges_choices.find(_item) != null)
            result.challenges <- {capped = true, gold = compFor(_item)};
        // Debug.log("convertItemToUIData", result);
        return result;
    }
});

// Auto-loot and manual-take hooks for the non-random cap mode.
mod.hook("scripts/ui/screens/tactical/tactical_combat_result_screen", function (q) {
    local function wrapLootAll(_name) {
        return @(__original) function () {
            Debug.log(_name + " in");
            if (!isChoosingLoot()) return __original();
            local capped = ::Tactical.State.m.challenges_choices;
            Debug.log(_name + "onLootAllItemsButtonPressed capped", capped.map(lootStr));
            return withoutCappedLoot(__original);
        }
    }

    q.onLootAllItemsButtonPressed = wrapLootAll("LootAll");

    // Consume and Smart Loot overwrites any Modern style hook with their mods_hookNewObject()
    if (::Hooks.hasMod("mod_consume") || ::Hooks.hasMod("mod_smartLoot")) {
        mods_hookNewObject("ui/screens/tactical/tactical_combat_result_screen", function (o) {
            o.onLootAllItemsButtonPressed = wrapLootAll("consumeAll")(o.onLootAllItemsButtonPressed);
      });
    }

    // EIMO integration: smart loot button should also skip capped items.
    if (::Hooks.hasMod("mod_EIMO")) {
        q.eimo_onSmartLootButtonPressed = wrapLootAll("EIMO_Smart")
    }

    // Give gold compensation for capped items the player left behind.
    q.onLeaveButtonPressed = @(__original) function () {
        if (!isChoosingLoot()) return __original();
        local capped = ::Tactical.State.m.challenges_choices;
        Debug.log("onLeaveButtonPressed capped", capped.map(lootStr));

        // Q: array intersection?
        local toRemove = Tactical.CombatResultLoot.getItems().filter(
            @(_, item) item != null && capped.find(item) != null)
        local money = removeItems(toRemove);
        Debug.log("onLeaveButtonPressed money", money);
        if (money > 0) ::World.Assets.addMoney(money);
        ::Tactical.State.m.challenges_choices = [];

        return __original();
    }

    // Block taking capped items once the cap is reached.
    q.onSwapItem = @(__original) function (_data) {
        if (!isChoosingLoot()) return __original(_data);
        local capped = ::Tactical.State.m.challenges_choices;
        Debug.log("onSwapItem", _data);

        if (_data[1] == "tactical-combat-result-screen.found-loot" && _data[3] != _data[1]) {
            local sourceEntry = Tactical.CombatResultLoot.getItemAtIndex(_data[0]);
            if (sourceEntry != null && capped.find(sourceEntry.item) != null) {
                local taken = 0;
                foreach (item in ::World.Assets.getStash().getItems())
                    if (item != null && capped.find(item) != null) taken++;
                // local taken = ::std.Array.count(::World.Assets.getStash().getItems(),
                //     @(item) item != null && capped.find(item) != null);
                if (taken >= def.conf("maxItemsPerBattle"))
                    return ::Const.UI.convertErrorToUIData(::Const.UI.Error.NotEnoughStashSpace);
            }
        }
        return __original(_data);
    }
});
