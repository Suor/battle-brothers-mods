// mode: menu
// mods: mod_camps_and_artifacts@dev stdlib@dev

// KB11 (fixed in 3.4 / 3.5.2): Item Spawner and Origin Maker create artifacts in the main menu,
// without a World.

test("CA-KB11 (fixed): every artifact is created and named without a World", function (t) {
    t.eq("Flags" in ::World, false, "no World.Flags in the menu");
    local names = [];
    foreach (a in ::Const.Items.Artifacts) {
        local item = ::new("scripts/items/" + a);
        if (a.find("ammo/") != 0) item.setName(item.createRandomName());
        names.push(item.getName() != "");
    }
    t.eq(names.filter(@(_, n) !n).len(), 0, "unnamed artifacts");
    t.eq(names.len(), ::Const.Items.Artifacts.len(), "created");
});
