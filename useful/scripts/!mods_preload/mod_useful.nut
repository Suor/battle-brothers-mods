local mod = ::Useful <- {
    ID = "mod_useful"
    Name = "Useful Things"
    Version = 0.1
}
::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, null, function() {
    ::include("useful/hand_to_hand");
    ::include("useful/nets");
});
