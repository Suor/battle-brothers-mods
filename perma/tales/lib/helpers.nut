// Shared helpers for the perma scenarios, loaded by `// include: lib/helpers.nut`.

::PeT <- {};

// Where an item is now: a slot name of the bro holding it, "bag", "stash", "tile" or "gone".
::PeT.whereIs <- function (_item) {
    local id = _item.getInstanceID();
    if (::Tales.inBattle() && _item.m.Tile != null) return "tile";
    foreach (bro in ::World.getPlayerRoster().getAll()) {
        local items = bro.getItems();
        foreach (name, slot in {mainhand = ::Const.ItemSlot.Mainhand, offhand = ::Const.ItemSlot.Offhand}) {
            local it = items.getItemAtSlot(slot);
            if (it != null && it != -1 && it.getInstanceID() == id) return name;
        }
        for (local i = 0; i < items.getUnlockedBagSlots(); i++) {
            local it = items.getItemAtBagSlot(i);
            if (it != null && it != -1 && it.getInstanceID() == id) return "bag";
        }
    }
    foreach (it in ::World.Assets.getStash().getItems()) if (it != null && it.getInstanceID() == id) return "stash";
    return "gone";
}

::PeT.loseHand <- function (_bro) {
    _bro.getSkills().add(::new("scripts/skills/injury_permanent/missing_hand_injury"));
}
