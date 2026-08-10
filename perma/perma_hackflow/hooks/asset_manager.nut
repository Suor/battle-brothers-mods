::PermaHackflow.mh.hook("scripts/states/world/asset_manager", function (q) {
    // Vanilla drops on the floor any item it fails to put back, so never let it try to restore
    // a shield or a two-handed weapon onto a hand that is no longer there.
    q.restoreEquipment = @(__original) function () {
        foreach (store in m.RestoreEquipment) {
            local bro = ::Tactical.getEntityByID(store.ID);
            if (bro == null || !bro.isAlive()) continue;
            if (!bro.getSkills().hasSkill("injury.missing_hand")) continue;

            local free = bro.getItems().getUnlockedBagSlots();
            foreach (slot in store.Slots) if (slot.Slot == ::Const.ItemSlot.Bag) free--;

            for (local i = store.Slots.len() - 1; i >= 0; i--) {
                local slot = store.Slots[i];
                if (slot.Slot == ::Const.ItemSlot.Bag) continue;
                if (slot.Item.getSlotType() != ::Const.ItemSlot.Offhand
                    && slot.Item.getBlockedSlotType() != ::Const.ItemSlot.Offhand) continue;

                // No room in the bag? Forget the item here, vanilla will stash it as overflow
                if (free > 0) {slot.Slot = ::Const.ItemSlot.Bag; free--}
                else store.Slots.remove(i);
            }
        }
        __original();
    }
})
