local mod = ::Hooks.register("mod_stupid_game", "0.2.0", "Stupid Game");
mod.queue(">mod_reforged", ">mod_backgrounds_reforged", "<mod_useful", function () {
    this.logInfo("sg: loading");

    mod.hookTree("scripts/items/ammo/ammo", function (q) {
        q.create = @(__original) function () {
            __original();

            this.m.Ammo *= 3;
            this.m.AmmoMax *= 3;
        }
    })
    mod.hookTree("scripts/items/weapons/weapon", function (q) {
        q.create = @(__original) function () {
            __original();
            if (this.m.AmmoMax > 1) {
                this.m.Ammo *= 4;
                this.m.AmmoMax *= 4;
            }

        }
    })

    mod.hook("scripts/scenarios/world/raiders_scenario", function (q) {
        q.onSpawnPlayer = @(__original) function () {
            __original();

            // Restore relations
            local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
            foreach (noble in nobles) {
                local rel = noble.getPlayerRelation(), up = 50 - rel;
                if (up <= 0) continue;

                noble.addPlayerRelation(up, "You are getting better");
                foreach (s in noble.m.Settlements) {
                    if (s.getFaction() != noble.m.ID)
                    {
                        this.World.FactionManager.getFaction(s.getFaction()).addPlayerRelationEx(up * 0.5);
                    }
                }
            }
        }
    });
})
