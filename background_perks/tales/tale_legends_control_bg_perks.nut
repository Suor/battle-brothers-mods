// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 stdlib@dev

// Control for tale_legends_bugs_bg_perks.nut: the same calls on Legends without Starting Perks by Background.

local function equipped(_bro) {
    local n = 0;
    foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand, ::Const.ItemSlot.Body, ::Const.ItemSlot.Head])
        if (_bro.getItems().getItemAtSlot(slot) != null) n++;
    return n;
}

test("control: Legends' setStartValuesEx honours gender and addEquipment", function (t) {
    local got = [];
    for (local i = 0; i < 6; i++) {
        // The original raises for a roster id it doesn't have; the engine returns null.
        local roster = null;
        try { roster = ::World.getRoster(9997); } catch (e) {}
        if (roster == null) roster = ::World.createRoster(9997);
        local bro = roster.create("scripts/entity/tactical/player");
        bro.setStartValuesEx(["monk_background"], true, 1, false);
        got.push([bro.getGender(), equipped(bro)]);
    }
    t.eq(got, array(6, [1, 0]), "[gender, equipped items]");
});
