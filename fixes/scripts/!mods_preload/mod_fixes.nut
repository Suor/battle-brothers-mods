local def = ::HackFixes <- {
    ID = "mod_hackflows_fixes"
    Name = "Hackflow's Fixes"
    Version = "0.5.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/..."
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/fixes"
        tagPrefix = "fixes-"
    }

    Corpses = []
    Items = []
}
local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.queue(function () {
    if (::Hooks.hasMod("mod_msu")) {
        def.msu <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);

        local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
        // def.msu.Registry.addModSource(msd.NexusMods, upd.nexus);
        if ("GitHubTags" in msd) {
            def.msu.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
            def.msu.Registry.setUpdateSource(msd.GitHubTags);
        }
    }

    // Includes
    if (!(::Hooks.hasMod("sato_corpse_loot_fix") || ::Hooks.hasMod("mod_spawn_corpse_fix"))) {
        ::include("hackflows_fixes/corpse");
    } else {
        ::logWarning("Skipping Hackflows's Corpse Fix because some alternative is installed");
    }
    // TODO: include heal_repair and events_delayed fixes

    local function isNull(_obj) {
        return _obj == null || (_obj instanceof ::WeakTableRef && _obj.isNull());
    }

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
    mod.hook("scripts/states/world_state", function (q) {
        q.onShow = @(__original) function () {
            __original();
            ::World.setPlayerPos(this.getPlayer().getPos())
            ::World.setPlayerVisionRadius(this.getPlayer().getVisionRadius())
        }
    })

    // Despawn units, with no location of their faction
    mod.hook("scripts/factions/faction", function (q) {
        q.update = @(__original) function (_ignoreDelay = false, _isNewCampaign = false) {
            foreach (u in this.m.Units) {
                if (u.getTroops().len() == 0) continue;

                if (!_ignoreDelay && this.m.Settlements.len() != 0)
                {
                    if (u.getFlags().has("IsMercenaries")) continue;

                    if (u.isAlive() && !u.getController().hasOrders())
                    {
                        local home = this.getNearestSettlement(u.getTile());
                        if (isNull(home)) {
                            ::logWarning("fixes: bad unit: " + u.getName() + ", despawning...")
                            local despawn = ::new("scripts/ai/world/orders/despawn_order");
                            u.getController().addOrder(despawn);
                        }
                    }
                }
            }

            __original(_ignoreDelay, _isNewCampaign);
        }
    })
})

// Fix gaps and dups in ::Const.ProjectileType, could be done by say Fantasy Brotthers 4.2b
// This fixes how Reforged adds new projectile types and hence say Flaming Arrows
local pairs = [];
foreach (type, index in ::Const.ProjectileType) {
    if (type != "COUNT") pairs.push([type, index]);
}
pairs.sort(@(a, b) a[1] <=> b[1]);

// Restore it
::Const.ProjectileType.clear();
foreach (i, p in pairs) ::Const.ProjectileType[p[0]] <- i;
::Const.ProjectileType.COUNT <- ::Const.ProjectileType.len() - 1;
