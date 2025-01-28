local mod = ::Hooks.register("mod_fixes", "0.1.0", "Hacflow's Fixes");
mod.queue(function () {
    this.logInfo("f: loading");

    // Show how much ammo we are short of
    local function getAmmoRequired() {
        local roster = ::World.getPlayerRoster().getAll();
        local ammo = 0, d;
        foreach (bro in roster) {
            local items = bro.getItems().getAllItems();
            foreach (item in items) {
                if (!isKindOf(item, "ammo") && !isKindOf(item, "weapon")) continue;

                local d = item.getAmmoMax() - item.getAmmo();
                if (d <= 0) continue;
                ammo += d * item.getAmmoCost()
            }
        }
        return ammo.tointeger();
    }
    mod.hook("scripts/ui/screens/tooltip/tooltip_events", function (q) {
        q.general_queryUIElementTooltipData = @(__original)
            function (_entityId, _elementId, _elementOwner)
        {
            local ret = __original(_entityId, _elementId, _elementOwner);
            if (_elementId == "assets.Ammo") {
                local ammoReq = getAmmoRequired();
                if (ammoReq >= 1) {
                    ret.top().text += format("\n\nShort of %s ammo to refill.",
                                             ::std.Text.negative(ammoReq));
                }
            }
            return ret;
        }
    })

    // Show enemies immediately after game load.
    // Contributed by Darxo, refined by Enduriel.
    ::mods_hookExactClass("states/world_state", function (cls) {
        local onShow = cls.onShow;
        cls.onShow = function() {
            onShow();
            ::World.setPlayerPos(this.getPlayer().getPos())
            ::World.setPlayerVisionRadius(this.getPlayer().getVisionRadius())
        }
    })

})
