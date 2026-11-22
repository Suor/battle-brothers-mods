// mode: campaign seed=bbtest-nick
// mods: mod_nicknames@dev stdlib@dev !mod_msu
// include: lib/helpers.nut

// 0.7.0: MSU is optional, it only enables weapon-type factors.

// N8, not a bug: a companion whose factors match no title stays untitled.
test("N8 report: starting brothers left untitled", function (t) {
    local untitled = [];
    foreach (bro in t.roster()) if (bro.m.Title == "") untitled.push(bro.getName());
    t.probe("untitled", untitled);
});

test("without MSU recruits are titled, weapons aren't factors", function (t) {
    ::NickT.resetState();
    t.eq(::Hooks.hasMod("mod_msu"), false, "no MSU");
    local bro = ::NickT.recruit(["sellsword_background"]);
    t.ok(bro.m.Title != "", "recruit titled");
    t.ok(::NickT.has(::NickT.titles(bro), bro.m.Title), "fits");
    local items = bro.getItems();
    local main = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
    if (main != null) items.unequip(main);
    items.equip(::new("scripts/items/weapons/arming_sword"));
    t.eq(::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "weapon."), [], "weapon factors");
    ::World.getTemporaryRoster().clear();
});
