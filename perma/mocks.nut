// Mocks for perma tests: enough of the item container and the asset manager to replay
// vanilla's post-battle equipment restore.

::Const <- {
    ItemSlot = {
        None = -1, Mainhand = 0, Offhand = 1, Body = 2, Head = 3,
        Accessory = 4, Ammo = 5, Bag = 6, Free = 6, COUNT = 7
    }
    ItemSlotSpaces = [1, 1, 1, 1, 1, 1, 4]
}

::Math <- {min = @(a, b) a <= b ? a : b}

// The game's arrays have .find(), stock Squirrel ones don't
::has <- function (_arr, _value) {
    foreach (item in _arr) if (item == _value) return true;
    return false;
}

local nextInstanceID = 0;

::Item <- class {
    Name = null;
    SlotType = null;
    BlockedSlotType = null;
    CurrentSlotType = null;
    Container = null;
    InstanceID = null;

    constructor(_name, _slotType, _blockedSlotType = null) {
        Name = _name;
        SlotType = _slotType;
        BlockedSlotType = _blockedSlotType;
        CurrentSlotType = ::Const.ItemSlot.None;
        InstanceID = "item" + (nextInstanceID++);
    }
    function getName() {return Name}
    function getSlotType() {return SlotType}
    function getBlockedSlotType() {return BlockedSlotType}
    function getCurrentSlotType() {return CurrentSlotType}
    function setCurrentSlotType(_t) {CurrentSlotType = _t}
    function getContainer() {return Container}
    function setContainer(_c) {Container = _c}
    function getInstanceID() {return InstanceID}
    function isEquipped() {
        return CurrentSlotType != ::Const.ItemSlot.None && CurrentSlotType != ::Const.ItemSlot.Bag;
    }
    function isInBag() {return CurrentSlotType == ::Const.ItemSlot.Bag}
    function onEquip() {}
    function onUnequip() {}
    function onPutIntoBag() {}
}

// A faithful-enough copy of scripts/items/item_container
::ItemContainer <- class {
    Items = null;
    UnlockedBagSlots = 4;

    constructor() {
        Items = [];
        for (local i = 0; i < ::Const.ItemSlot.COUNT; i++) {
            local slot = [];
            for (local j = 0; j < ::Const.ItemSlotSpaces[i]; j++) slot.push(null);
            Items.push(slot);
        }
    }
    function getData() {return Items}
    function getUnlockedBagSlots() {return UnlockedBagSlots}
    function setUnlockedBagSlots(_n) {UnlockedBagSlots = _n}

    function getItemAtSlot(_slotType) {
        if (_slotType == null || _slotType == ::Const.ItemSlot.None) return null;
        foreach (item in Items[_slotType]) if (item != null && item != -1) return item;
        return null;
    }
    function getItemAtBagSlot(_slot) {return Items[::Const.ItemSlot.Bag][_slot]}
    function getAllItemsAtSlot(_slotType) {
        local ret = [];
        foreach (item in Items[_slotType]) if (item != null && item != -1) ret.push(item);
        return ret;
    }

    function addToBag(_item, _slot = -1) {
        if (_item.getCurrentSlotType() != ::Const.ItemSlot.None) return false;

        local vacancy = -1;
        for (local i = 0; i < ::Math.min(Items[::Const.ItemSlot.Bag].len(), UnlockedBagSlots); i++) {
            if (Items[::Const.ItemSlot.Bag][i] == null) {vacancy = i; break}
        }
        if (vacancy == -1) return false;

        Items[::Const.ItemSlot.Bag][vacancy] = _item;
        _item.setContainer(this);
        _item.setCurrentSlotType(::Const.ItemSlot.Bag);
        _item.onPutIntoBag();
        return true;
    }
    function removeFromBag(_item) {
        if (_item.getCurrentSlotType() != ::Const.ItemSlot.Bag) return false;
        foreach (i, item in Items[::Const.ItemSlot.Bag]) {
            if (item == _item) {
                Items[::Const.ItemSlot.Bag][i] = null;
                _item.setContainer(null);
                _item.setCurrentSlotType(::Const.ItemSlot.None);
                return true;
            }
        }
        return false;
    }
    function equip(_item) {
        if (_item.getSlotType() == ::Const.ItemSlot.None) return false;
        if (_item.getCurrentSlotType() != ::Const.ItemSlot.None) return false;

        local vacancy = -1;
        foreach (i, item in Items[_item.getSlotType()]) if (item == null) {vacancy = i; break}

        local blocked = -1;
        if (_item.getBlockedSlotType() != null) {
            foreach (i, item in Items[_item.getBlockedSlotType()]) if (item == null) {blocked = i; break}
        }
        if (vacancy == -1 || (_item.getBlockedSlotType() != null && blocked == -1)) return false;

        Items[_item.getSlotType()][vacancy] = _item;
        if (_item.getBlockedSlotType() != null) Items[_item.getBlockedSlotType()][blocked] = -1;
        _item.setContainer(this);
        _item.setCurrentSlotType(_item.getSlotType());
        _item.onEquip();
        return true;
    }
    function unequip(_item) {
        if (_item == null || _item == -1) return;
        if (_item.getCurrentSlotType() == ::Const.ItemSlot.None
            || _item.getCurrentSlotType() == ::Const.ItemSlot.Bag) return false;

        foreach (i, item in Items[_item.getSlotType()]) {
            if (item != _item) continue;

            _item.onUnequip();
            _item.setContainer(null);
            _item.setCurrentSlotType(::Const.ItemSlot.None);
            Items[_item.getSlotType()][i] = null;

            if (_item.getBlockedSlotType() != null) {
                foreach (j, blocking in Items[_item.getBlockedSlotType()]) {
                    if (blocking == -1) {Items[_item.getBlockedSlotType()][j] = null; break}
                }
            }
            return true;
        }
        return false;
    }
    function swap(_itemA, _itemB) {
        if (_itemA.isEquipped()) {
            unequip(_itemA);
            if (_itemB.isInBag()) {removeFromBag(_itemB); addToBag(_itemA)}
            equip(_itemB);
        } else if (_itemB.isEquipped()) {
            unequip(_itemB);
            if (_itemA.isInBag()) {removeFromBag(_itemA); addToBag(_itemB)}
            equip(_itemA);
        }
    }
}

::Actor <- class {
    ID = null;
    Items = null;
    Skills = null;

    constructor(_id) {
        ID = _id;
        Items = ::ItemContainer();
        Skills = [];
    }
    function getID() {return ID}
    function getItems() {return Items}
    function isAlive() {return true}
    function getSkills() {
        local skills = Skills;
        return {function hasSkill(_id) {return ::has(skills, _id)}};
    }
    function addSkill(_id) {Skills.push(_id)}
}

::Stash <- {
    Items = []
    function add(_item) {Items.push(_item); return true}
    function getItems() {return Items}
    function removeByIndex(_i) {Items.remove(_i)}
    function makeEmptySlots(_n) {}
    function clear() {Items.clear()}
}

::Tactical <- {
    Entities = {}
    function getEntityByID(_id) {return _id in Entities ? Entities[_id] : null}
}

// A copy of scripts/states/world/asset_manager save/restore, `this.` stripped
::AssetManager <- {
    m = {RestoreEquipment = []}
    Roster = []

    function saveEquipment() {
        m.RestoreEquipment = [];

        foreach (bro in Roster) {
            local store = {ID = bro.getID(), Slots = []};

            for (local i = ::Const.ItemSlot.Mainhand; i <= ::Const.ItemSlot.Ammo; i++) {
                local item = bro.getItems().getItemAtSlot(i);
                if (item != null && item != "-1") store.Slots.push({Item = item, Slot = i});
            }
            for (local i = 0; i < bro.getItems().getUnlockedBagSlots(); i++) {
                local item = bro.getItems().getItemAtBagSlot(i);
                if (item != null && item != "-1")
                    store.Slots.push({Item = item, Slot = ::Const.ItemSlot.Bag});
            }
            m.RestoreEquipment.push(store);
        }
    }

    function restoreEquipment() {
        foreach (s in m.RestoreEquipment) {
            local bro = ::Tactical.getEntityByID(s.ID);
            if (bro == null || !bro.isAlive()) continue;

            local currentItems = [];
            local itemsHandled = [];
            local overflowItems = [];

            for (local i = ::Const.ItemSlot.Mainhand; i <= ::Const.ItemSlot.Ammo; i++) {
                local item = bro.getItems().getItemAtSlot(i);
                if (item != null && item != "-1") {
                    currentItems.push({Item = item, Slot = i});
                    bro.getItems().unequip(item);
                }
            }
            for (local i = 0; i < bro.getItems().getUnlockedBagSlots(); i++) {
                local item = bro.getItems().getItemAtBagSlot(i);
                if (item != null && item != "-1") {
                    currentItems.push({Item = item, Slot = ::Const.ItemSlot.Bag});
                    bro.getItems().removeFromBag(item);
                }
            }

            foreach (item in s.Slots) {
                local itemExists = false;
                foreach (current in currentItems) {
                    if (current.Item.getInstanceID() == item.Item.getInstanceID()) {
                        itemExists = true;
                        break;
                    }
                }
                if (!itemExists) continue;

                if (item.Slot == ::Const.ItemSlot.Bag) {
                    if (!bro.getItems().addToBag(item.Item)) overflowItems.push(item.Item);
                    itemsHandled.push(item.Item.getInstanceID());
                } else {
                    if (!bro.getItems().equip(item.Item)) overflowItems.push(item.Item);
                    itemsHandled.push(item.Item.getInstanceID());
                }
            }

            foreach (item in currentItems) {
                if (::has(itemsHandled, item.Item.getInstanceID())) continue;

                if (item.Item.getCurrentSlotType() == ::Const.ItemSlot.Bag) {
                    if (!bro.getItems().addToBag(item.Item)) overflowItems.push(item.Item);
                } else if (!bro.getItems().equip(item.Item)) {
                    overflowItems.push(item.Item);
                }
            }

            foreach (item in overflowItems) {
                if (::has(itemsHandled, item.getInstanceID())) continue;
                if (::Stash.add(item) == null) bro.getItems().addToBag(item);
            }
        }

        m.RestoreEquipment = [];
    }
}

// Hardened overwrites restoreEquipment(), this is its algorithm minus the same-ID replacement
// search, which never fires with no spare copies of an item around.
::HardenedAssetManager <- clone ::AssetManager;
::HardenedAssetManager.m = {RestoreEquipment = []};
::HardenedAssetManager.Roster = [];
::HardenedAssetManager.restoreEquipment = function () {
    local isEquippedIn = @(_bro, _item, _slot) ::has(_bro.getItems().getAllItemsAtSlot(_slot), _item);
    local equipToSlot = function (_bro, _item, _slot) {
        if (_slot == ::Const.ItemSlot.Bag) _bro.getItems().addToBag(_item);
        else _bro.getItems().equip(_item);
    }
    local isEqualAndEquippable = function (_item, _entry) {
        if (_item != _entry.Item) return false;
        return _entry.Slot == ::Const.ItemSlot.Bag || _item.getSlotType() == _entry.Slot;
    }

    local danglingItems = [];
    for (local i = m.RestoreEquipment.len() - 1; i >= 0; --i) {
        local snapshot = m.RestoreEquipment[i];
        local bro = ::Tactical.getEntityByID(snapshot.ID);
        if (bro == null || !bro.isAlive()) {m.RestoreEquipment.remove(i); continue}

        foreach (itemSlot, _ in ::Const.ItemSlotSpaces) {
            foreach (item in bro.getItems().getAllItemsAtSlot(itemSlot)) {
                local isAllowedToStay = false;
                foreach (slot in snapshot.Slots) {
                    if (slot.Slot == itemSlot && slot.Item == item) {isAllowedToStay = true; break}
                }
                if (isAllowedToStay) continue;

                danglingItems.push(item);
                if (itemSlot == ::Const.ItemSlot.Bag) bro.getItems().removeFromBag(item);
                else bro.getItems().unequip(item);
            }
        }
    }

    foreach (snapshot in m.RestoreEquipment) {
        local bro = ::Tactical.getEntityByID(snapshot.ID);
        for (local i = snapshot.Slots.len() - 1; i >= 0; --i) {
            local entry = snapshot.Slots[i];
            if (isEquippedIn(bro, entry.Item, entry.Slot)) continue;

            for (local j = danglingItems.len() - 1; j >= 0; --j) {
                if (!isEqualAndEquippable(danglingItems[j], entry)) continue;

                equipToSlot(bro, danglingItems[j], entry.Slot);
                snapshot.Slots.remove(i);
                danglingItems.remove(j);
                break;
            }
        }
    }

    foreach (item in danglingItems) ::Stash.add(item);

    m.RestoreEquipment = [];
}

// Minimal Modern Hooks stand-in: applies hooks straight onto a mock object
::PermaHackflow <- {
    mh = {
        Target = null
        function hook(_path, _cb) {
            local target = Target;
            // Modern Hooks lets `q.method = ...` define a wrapper for an existing method
            local q = {}.setdelegate({_set = function (_key, _value) {rawset(_key, _value)}});
            _cb(q);
            foreach (name, wrapper in q) {
                target[name] = wrapper(target[name].bindenv(target));
            }
        }
    }
}

::applyPermaHooks <- function (_target) {
    ::PermaHackflow.mh.Target = _target;
    dofile("perma_hackflow/hooks/asset_manager.nut", true);
}
