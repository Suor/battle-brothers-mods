// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_fixes@dev mod_hooks mod_msu stdlib@dev

test("the Ammunition tooltip tells how much ammo is short", function (t) {
    local bro = t.roster()[0];
    local quiver = ::new("scripts/items/ammo/quiver_of_arrows");
    local old = bro.getItems().getItemAtSlot(::Const.ItemSlot.Ammo);
    if (old != null) bro.getItems().unequip(old);
    bro.getItems().equip(quiver);
    foreach (b in t.roster())
        foreach (item in b.getItems().getAllItems())
            if (::isKindOf(item, "ammo") || ::isKindOf(item, "weapon")) item.setAmmo(item.getAmmoMax());
    quiver.setAmmo(2);
    local short = (quiver.getAmmoMax() - 2) * quiver.getAmmoCost();
    local tip = ::new("scripts/ui/screens/tooltip/tooltip_events").general_queryUIElementTooltipData(null, "assets.Ammo", null);
    local text = tip.top().text;
    t.eq(text.slice(text.find("\n\n")), "\n\nShort of " + ::std.Text.negative(short) + " ammo to refill.", "the added line");
});

test("Nimble's tooltip shows the armor's total fatigue", function (t) {
    local bro = t.roster()[0];
    local perk = ::new("scripts/skills/perks/perk_nimble");
    bro.getSkills().add(perk);
    local items = bro.getItems(), fat = 0;
    foreach (slot in [::Const.ItemSlot.Body, ::Const.ItemSlot.Head]) {
        local it = items.getItemAtSlot(slot);
        if (it != null) fat += it.getStaminaModifier();
    }
    local lines = perk.getTooltip().filter(@(_, e) e.id == 108).map(@(e) e.text);
    t.eq(lines, fat == 0 ? [] : ["Total fatigue of armor weared is " + ::std.Text.negative(::Math.abs(fat))], "the line");
    t.ok(fat != 0, "the bro wears armor with fatigue");
});
