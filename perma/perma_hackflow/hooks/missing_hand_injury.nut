::PermaHackflow.mh.hook("scripts/skills/injury_permanent/missing_hand_injury", function (q) {
    q.onAdded = @() function () {
        local items = getContainer().getActor().getItems();

        // Allow adding in and out of combat
        local function dropItem(_item) {
            items.unequip(_item);
            if ("State" in this.Tactical) {_item.drop()}
            else {
                ::World.Assets.getStash().add(_item);
            }
        }

        if (items.getItemAtSlot(Const.ItemSlot.Mainhand)
            && items.getItemAtSlot(Const.ItemSlot.Mainhand).getBlockedSlotType() == Const.ItemSlot.Offhand)
        {
            local item = items.getItemAtSlot(Const.ItemSlot.Mainhand);
            dropItem(item);
        }

        if (items.getItemAtSlot(Const.ItemSlot.Offhand)) {
            local item = items.getItemAtSlot(Const.ItemSlot.Offhand);
            dropItem(item);
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
