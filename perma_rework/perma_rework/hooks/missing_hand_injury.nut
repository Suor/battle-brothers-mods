::PermaRework.mh.hook("scripts/skills/injury_permanent/missing_hand_injury", function (q) {
    q.onAdded = @() function () {
        local items = getContainer().getActor().getItems();

        if (items.getItemAtSlot(Const.ItemSlot.Mainhand)
            && items.getItemAtSlot(Const.ItemSlot.Mainhand).getBlockedSlotType() == Const.ItemSlot.Offhand)
        {
            local item = items.getItemAtSlot(Const.ItemSlot.Mainhand);
            items.unequip(item);
            item.drop();
        }

        if (items.getItemAtSlot(Const.ItemSlot.Offhand))
        {
            local item = items.getItemAtSlot(Const.ItemSlot.Offhand);
            items.unequip(item);
            item.drop();
        }

        // Block left hand
        items.getData()[Const.ItemSlot.Offhand][0] = -1;
    }
    q.onRemoved = @(__original) function () {
        __original();

        // Allow using left hand again
        local items = getContainer().getActor().getItems();
        items.getData()[Const.ItemSlot.Offhand][0] = null;
    }
})
