local mod = ::RandomPerk <- {
    ID = "mod_random_perk"
    Name = "Random Perk"
    Version = 0.1
    Debug = false //::std.Debug.with({prefix = "studio: "})
}
// local Rand = ::std.Rand.using(::rng);

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20)", function() {
    ::mods_registerJS("random_perk.js");
})
