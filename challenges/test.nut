dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile(getenv("STDLIB_DIR") + "tests/helpers.nut", true);

local HooksByPath = {};
local Settings = {
    weaponDropChance = 1.0,
    armorDropChance = 1.0,
    maxItemsPerBattle = -1,
    lootGoldComp = 1.0,
    protectNamed = true
};

::Math.rand <- function (_min, _max) {
    return _max;
}

::Const.Faction <- {Player = 1};
::Const.Items <- {ItemType = {None = 0, Named = 1, Legendary = 2, Armor = 4, Helmet = 8}};
::Const.ItemSlot <- {None = -1, Mainhand = 0, Bag = 6};
::World <- {Assets = {m = {IsBlacksmithed = false}, function getStash() { return {function getItems() { return []; }} }}};
::Tactical <- {State = null, CombatResultLoot = null};

::new <- function (_script) {
    return {
        m = {ID = "supplies.money", Amount = 0, Value = 0, Container = null, CurrentSlotType = -1},
        function setAmount(_amount) {
            this.m.Amount = _amount;
            this.m.Value = _amount;
        }
        function getValue() { return this.m.Value; }
        function getAmount() { return this.m.Amount; }
    }
}

::MSU <- {
    Class = {
        function SettingsTitle(...) { return {Data = {}}; }
        function BooleanSetting(...) { return {Data = {}}; }
    }
}

::Challenges <- {
    mh = {
        function hook(_path, _func) {
            local q = {
                m = {CombatResultLoot = null, StrategicProperties = null},
                init = null,
                gatherLoot = null,
                isDroppedAsLoot = null
            };
            _func(q);
            HooksByPath[_path] <- q;
        }
    }
    function add(_elem) { return _elem; }
    function SliderSetting(...) { return {Data = {}}; }
    function conf(_name) { return Settings[_name]; }
}

dofile("challenges/loot.nut", true);

function makeContainer() {
    return {
        ClassName = "stash_container",
        Items = [],
        function add(_item) {
            this.Items.push(_item);
            _item.m.Container = this;
        }
        function remove(_item) {
            local i = this.Items.find(_item);
            if (i != null) this.Items.remove(i);
            _item.m.Container = null;
        }
        function sort() {}
        function getItems() { return this.Items; }
        function assign(_arr) { this.Items = _arr; }
    }
}

function makeItemContainer() {
    return {
        ClassName = "item_container",
        Items = [],
        function addToBag(_item) {
            this.Items.push(_item);
            _item.m.Container = this;
            _item.m.CurrentSlotType = ::Const.ItemSlot.Bag;
        }
        function removeFromBag(_item) {
            local i = this.Items.find(_item);
            if (i != null) this.Items.remove(i);
            _item.m.Container = null;
            _item.m.CurrentSlotType = ::Const.ItemSlot.None;
        }
        function unequip(_item) {
            this.removeFromBag(_item);
        }
    }
}

function makeItem(_id, _value, _type = 0, _faction = 0, _className = "weapon") {
    local self = {
        ClassName = _className,
        m = null,
        function getName() { return this.m.Name; }
        function getInstanceID() { return "abc1"}
        function getID() { return this.m.ID; }
        function getValue() { return this.m.Value; }
        function isItemType(_type) { return (this.m.ItemType & _type) != 0; }
    };
    self.m = {
        ID = _id,
        Name = _id,
        Value = _value,
        Condition = 1.0,
        ConditionMax = 1.0,
        ItemType = _type,
        LastEquippedByFaction = _faction,
        Container = null,
        CurrentSlotType = -1
    };
    return self;
}

function makeState() {
    local loot = makeContainer();
    local m = clone HooksByPath["scripts/states/tactical_state"].m;
    m.CombatResultLoot = loot;
    local state = {
        m = m,
        function isScenarioMode() { return false; }
    };
    HooksByPath["scripts/states/tactical_state"].init(function () {}).call(state);
    ::Tactical.State = state;
    ::Tactical.CombatResultLoot = loot;
    return state;
}

function moneyTotal(_items) {
    local total = 0;
    foreach (item in _items) {
        if (item.m.ID == "supplies.money") total += item.getAmount();
    }
    return total;
}

local weaponHook = HooksByPath["scripts/items/weapons/weapon"].isDroppedAsLoot;
local armorHook = HooksByPath["scripts/items/armor/armor"].isDroppedAsLoot;
local gatherLootHook = HooksByPath["scripts/states/tactical_state"].gatherLoot;

// 1. Hook is passive: returns whatever __original returned, regardless of settings.
Settings.weaponDropChance = 0.0;
Settings.maxItemsPerBattle = 0;
local item = makeItem("w", 50);
local state = makeState();
if (weaponHook(function () { return true; }).call(item) != true)
    throw "passive hook must preserve true";
if (weaponHook(function () { return false; }).call(item) != false)
    throw "passive hook must preserve false";
print("loot hook: passive return value OK\n");

// 2. Successful __original registers a candidate; repeated calls dedup.
Settings.weaponDropChance = 0.5;
state = makeState();
local hook = weaponHook(function () { return true; });
hook.call(item);
hook.call(item);
hook.call(item);
assertEq(state.m.challenges_loot, [item]);
print("loot hook: register + dedup OK\n");

// 3. Failed __original does not register.
state = makeState();
weaponHook(function () { return false; }).call(item);
assertEq(state.m.challenges_loot, []);
print("loot hook: vanilla-rejected items not tracked OK\n");

// 4. Protected (named/legendary) items skip registration entirely.
Settings.weaponDropChance = 0.0;
state = makeState();
local named = makeItem("named", 100, ::Const.Items.ItemType.Named);
local legendary = makeItem("leg", 200, ::Const.Items.ItemType.Legendary);
hook = weaponHook(function () { return true; });
hook.call(named);
hook.call(legendary);
assertEq(state.m.challenges_loot, []);
print("loot protect: named/legendary skip OK\n");

// 5. Chance filter at gatherLoot destroys the item wherever it ended up and
//    leaves a money pile in its place.
Settings.weaponDropChance = 0.0;
Settings.maxItemsPerBattle = -1;
Settings.lootGoldComp = 1.0;
state = makeState();
local fallen = makeItem("fallen", 60);
state.m.CombatResultLoot.add(fallen);
weaponHook(function () { return true; }).call(fallen);
gatherLootHook(function () {}).call(state);
local items = state.m.CombatResultLoot.Items;
if (items.find(fallen) != null) throw "rejected item should be removed from loot pile";
assertEq(moneyTotal(items), 9);
assertEq(state.m.challenges_loot, []);
print("loot chance: zero-chance destroys + compensates OK\n");

// 6. Cap picks the most valuable survivors via weighted Rand.take. Cheap
//    candidate is destroyed and compensated; expensive stays.
Settings.weaponDropChance = 1.0;
Settings.maxItemsPerBattle = 1;
state = makeState();
local cheap = makeItem("cheap", 10);
local expensive = makeItem("expensive", 100);
state.m.CombatResultLoot.add(cheap);
state.m.CombatResultLoot.add(expensive);
hook = weaponHook(function () { return true; });
hook.call(cheap);
hook.call(expensive);
gatherLootHook(function () {}).call(state);
items = state.m.CombatResultLoot.Items;
if (items.find(expensive) == null) throw "expensive should survive cap";
if (items.find(cheap) != null) throw "cheap should be capped out";
assertEq(moneyTotal(items), 1);
print("loot cap: weighted survivor selection OK\n");

// 7. Item carried back by a brother (so not in loot pile) is still pulled out
//    and compensated. This closes the carry-the-loot-back-yourself loophole.
Settings.weaponDropChance = 0.0;
Settings.maxItemsPerBattle = -1;
state = makeState();
local pickedUp = makeItem("picked", 80);
local broBag = makeItemContainer();
broBag.addToBag(pickedUp);
weaponHook(function () { return true; }).call(pickedUp);
gatherLootHook(function () {}).call(state);
if (broBag.Items.find(pickedUp) != null) throw "picked-up item should be pulled from bag";
assertEq(moneyTotal(state.m.CombatResultLoot.Items), 12);
print("loot pickup: removed from brother's bag OK\n");

// 8. Survivors of both filters keep their containers untouched.
Settings.weaponDropChance = 1.0;
Settings.maxItemsPerBattle = -1;
state = makeState();
local kept = makeItem("kept", 30);
state.m.CombatResultLoot.add(kept);
weaponHook(function () { return true; }).call(kept);
gatherLootHook(function () {}).call(state);
if (state.m.CombatResultLoot.Items.find(kept) == null) throw "survivor should remain";
assertEq(moneyTotal(state.m.CombatResultLoot.Items), 0);
print("loot survive: full chance keeps item, no compensation OK\n");

// 9. Armor uses armorDropChance, not weaponDropChance.
Settings.weaponDropChance = 1.0;
Settings.armorDropChance = 0.0;
Settings.maxItemsPerBattle = -1;
state = makeState();
local cuirass = makeItem("cuirass", 90, ::Const.Items.ItemType.Armor, 0, "armor");
state.m.CombatResultLoot.add(cuirass);
armorHook(function () { return true; }).call(cuirass);
gatherLootHook(function () {}).call(state);
if (state.m.CombatResultLoot.Items.find(cuirass) != null) throw "armor should be dropped by chance filter";
assertEq(moneyTotal(state.m.CombatResultLoot.Items), 13);
print("loot armor: armorDropChance applied OK\n");

// 10. Cap prefers items not already in the player's stash via stash-aware weighting.
Settings.weaponDropChance = 1.0;
Settings.armorDropChance = 1.0;
Settings.maxItemsPerBattle = 1;
state = makeState();
local stash10 = makeContainer();
::World.Assets.getStash <- function () { return stash10; }
local weaponBase = {ClassName = "weapon"};
local swordA = makeItem("sword_a", 50, 0, 0, "sword_a");
swordA.setdelegate(weaponBase);
local axeA = makeItem("axe_a", 50, 0, 0, "axe_a");
axeA.setdelegate(weaponBase);
stash10.add(makeItem("sword_a_stash", 50, 0, 0, "sword_a")); // sword_a already owned
state.m.CombatResultLoot.add(swordA);
state.m.CombatResultLoot.add(axeA);
hook = weaponHook(function () { return true; });
hook.call(swordA); // first in survived → weight halved by stash match
hook.call(axeA);   // second in survived → full weight, wins
gatherLootHook(function () {}).call(state);
items = state.m.CombatResultLoot.Items;
if (items.find(axeA) == null) throw "axe (not in stash) should survive cap";
if (items.find(swordA) != null) throw "sword (already in stash) should be capped";
print("loot cap: stash-aware weighting OK\n");

print("Tests OK\n")
