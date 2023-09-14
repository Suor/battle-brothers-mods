local mod = ::EventsFix <- {
    ID = "mod_more_blood"
    Name = "More Blood"
    Version = 0.5
}
::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20)", function () {
    ::mods_hookExactClass("entity/tactical/actor", function (cls) {
        // cls.m.BloodSaturation *= 2;
        cls.m.DecapitateBloodAmount *= 2;
        cls.m.DeathBloodAmount *= 2;
        cls.m.BloodPoolScale *= 1.5;
    })

    local bloodEffects = [
        ::Const.Tactical.BloodEffects
        ::Const.Tactical.BloodSplatters
        ::Const.Tactical.DecapitateSplatters
        ::Const.Tactical.SmashSplatters
    ]
    foreach (i, lol in bloodEffects) {
        foreach (j, effect in lol) {
            foreach (k, d in effect) {
                d.Quantity *= 2;
                d.LifeTimeQuantity *= 2;
                d.SpawnRate *= 2;
            }
        }
    }

    local skillEffects = [
        ::Const.Tactical.GruesomeFeastParticles
        ::Const.Tactical.KrakenDevourParticles
        ::Const.Tactical.KrakenDevourVictimParticles
    ]
    foreach (j, effect in skillEffects) {
        foreach (k, d in effect) {
            d.Quantity *= 2;
            d.LifeTimeQuantity *= 2;
            d.SpawnRate *= 2;
        }
    }

    // // Later, maybe
    // // LOD
    // ::Const.Tactical.DustParticles
    // ::Const.Tactical.LichParticles

    // // LOL, double only SpawnRate
    // ::Const.Tactical.TerrainDropdownParticles

    // // LOD, double only SpawnRate
    // ::Const.Tactical.BurnParticles
    // ::Const.Tactical.FireParticles
    // ::Const.Tactical.AcidParticles
    // ::Const.Tactical.LightningParticles
    // ::Const.Tactical.SmokeParticles
    // ::Const.Tactical.ShrapnelLeftParticles
    // ::Const.Tactical.ShrapnelRightParticles

    // // LOD, double all
    // ::Const.Tactical.DarkflightStartParticles
    // ::Const.Tactical.DarkflightEndParticles
    // ::Const.Tactical.RaiseUndeadParticles
    // ::Const.Tactical.MiasmaParticles
    // ::Const.Tactical.SandGolemParticles
    // ::Const.Tactical.SpiritWalkEndParticles
    // ::Const.Tactical.FireLanceRightParticles
    // ::Const.Tactical.FireLanceLeftParticles
    // ::Const.Tactical.HandgonneRightParticles
    // ::Const.Tactical.HandgonneLeftParticles
    // ::Const.Tactical.DazeParticles
    // ::Const.Tactical.MortarFireLeftParticles
    // ::Const.Tactical.MortarFireRightParticles
    // ::Const.Tactical.MortarImpactParticles
})
