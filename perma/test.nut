dofile("mocks.nut", true);
::applyPermaHooks(::AssetManager);
::applyPermaHooks(::HardenedAssetManager);

function assertEq(_got, _expected, _message) {
    if (_got != _expected) throw _message + ": got " + _got + ", expected " + _expected;
}

// A bro fighting with a two-handed weapon, a spare one-hander in the bag
function setup(_manager, _bagSlots) {
    ::Stash.Items.clear();
    _manager.m.RestoreEquipment = [];

    local bro = ::Actor("bro");
    bro.getItems().setUnlockedBagSlots(_bagSlots);
    ::Tactical.Entities = {bro = bro};
    _manager.Roster = [bro];

    local crossbow = ::Item("crossbow", ::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand);
    local sword = ::Item("sword", ::Const.ItemSlot.Mainhand);
    bro.getItems().equip(crossbow);
    bro.getItems().addToBag(sword);
    _manager.saveEquipment();

    // Switch to the one-hander mid-battle, then lose the hand
    bro.getItems().swap(crossbow, sword);
    bro.getItems().getData()[::Const.ItemSlot.Offhand][0] = -1;
    bro.addSkill("injury.missing_hand");

    return bro;
}

function slotNames(_bro) {
    local names = [];
    for (local i = 0; i < ::Const.ItemSlot.COUNT; i++) {
        foreach (item in _bro.getItems().getData()[i]) {
            names.push(item == null ? "-" : item == -1 ? "blocked" : item.getName());
        }
    }
    return names.reduce(@(a, b) a + " " + b);
}

// The two-hander goes into the bag rather than being lost to a failed re-equip
foreach (manager in [::AssetManager, ::HardenedAssetManager]) {
    local bro = setup(manager, 4);
    manager.restoreEquipment();
    assertEq(slotNames(bro), "- blocked - - - - crossbow sword - -", "Items after restore");
    assertEq(::Stash.Items.len(), 0, "Stash size");

    // No room in the bag, the two-hander lands in the stash
    bro = setup(manager, 1);
    manager.restoreEquipment();
    assertEq(slotNames(bro), "- blocked - - - - sword - - -", "Items after restore, full bag");
    assertEq(::Stash.Items.len(), 1, "Stash size, full bag");
    assertEq(::Stash.Items[0].getName(), "crossbow", "Stashed item, full bag");
}
