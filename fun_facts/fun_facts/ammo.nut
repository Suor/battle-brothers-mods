::mods_hookExactClass("items/weapons/weapon", function (o) {
    local consumeAmmo = o.consumeAmmo;
    o.consumeAmmo = function () {
        consumeAmmo();
        ::FunFacts.s2ff(this).onConsumeAmmo(this.m.AmmoCost);
    }
})

::mods_hookExactClass("items/ammo/ammo", function (o) {
    local consumeAmmo = o.consumeAmmo;
    o.consumeAmmo = function () {
        consumeAmmo();
        ::FunFacts.s2ff(this).onConsumeAmmo(this.m.AmmoCost);
    }
})
