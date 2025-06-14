::PermaHackflow.mh.hook("scripts/skills/injury_permanent/missing_hand_injury", function (q) {
    q.onAdded = @() function () {
        if (m.IsNew) {perma_dropItems(); m.IsNew = false}

        // Block left hand
        getContainer().getActor().getItems().getData()[Const.ItemSlot.Offhand][0] = -1;
    }
    q.onRemoved = @(__original) function () {
        __original();

        // Allow using left hand again
        getContainer().getActor().getItems().getData()[Const.ItemSlot.Offhand][0] = null;
    }
    q.perma_dropItems <- function () {
        local actor = getContainer().getActor();
        local items = actor.getItems();

        local item = items.getItemAtSlot(::Const.ItemSlot.Offhand);
        local main = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (!item && main && main.getBlockedSlotType() == ::Const.ItemSlot.Offhand) item = main;
        if (!item) return;

        items.unequip(item);
        if ("State" in ::Tactical && !::Tactical.State.isBattleEnded() && actor.isPlacedOnMap()) {
            item.drop();
        }
        else if (items.hasEmptySlot(::Const.ItemSlot.Bag)) {
            items.addToBag(item);
        } else {
            ::World.Assets.getStash().makeEmptySlots(1);
            ::World.Assets.getStash().add(item);
        }
    }
})
