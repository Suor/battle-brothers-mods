::mods_registerMod("mod_stupid_game", 0.1, "Stupid Game");
::mods_queue("mod_stupid_game", null, function()
{
    this.logInfo("huge_quivers: loading");

    ::mods_hookBaseClass("items/ammo/ammo", function(cls) {
        local create = cls.create;
        cls.create = function() {
            create();

            this.m.Ammo *= 3;
            this.m.AmmoMax *= 3;
        }
    })

    ::mods_hookDescendants("items/weapons/weapon", function(cls) {
        local create = cls.create;
        cls.create = function() {
            create();

            this.m.Ammo *= 4;
            this.m.AmmoMax *= 4;
        }
    })

    ::mods_hookNewObject("scenarios/world/raiders_scenario", function(cls) {
        local onSpawnPlayer = cls.onSpawnPlayer;
        cls.onSpawnPlayer = function() {
            onSpawnPlayer();

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
