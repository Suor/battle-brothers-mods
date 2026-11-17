// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_useful@dev stdlib@dev

// KNOWN_BUGS useful #2 on real Legends 19.4.23: the hand_to_hand / brawler_background hooks failed at load
// (`the index 'onUpdate' does not exist`) under Legends 18.x. A boot error would fail this launch.

test("US-KB2 legends: hand to hand hooks load, damage grows with the level", function (t) {
    local bro = t.roster()[0];
    local items = bro.getItems();
    foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand]) {
        local i = items.getItemAtSlot(slot);
        if (i != null) items.unequip(i);
    }
    local h2h = bro.getSkills().getSkillByID("actives.hand_to_hand");
    t.probe("onUpdate source", h2h.onUpdate.getinfos().src);
    local got = [];
    foreach (level in [1, 6, 11]) {
        bro.m.Level = level;
        bro.getSkills().update();
        local p = bro.getCurrentProperties();
        got.push([p.DamageRegularMin, p.DamageRegularMax]);
    }
    t.eq(got, [[5, 10], [15, 20], [25, 30]], "damage at levels 1, 6, 11");
});
