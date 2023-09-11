local mod = ::EventsFix <- {
    ID = "mod_events_delayed_fix"
    Name = "Events and Ambitions Delayed Fix"
    Version = 0.5
}
::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20)", function () {
    ::mods_hookExactClass("states/world_state", function (o) {
        local function doUpdates() {
            this.m.Events.update();
            this.m.Ambitions.update();

            if (this.Time.getRealTimeF() - this.m.LastMusicUpdate > 60.0)
            {
                this.setWorldmapMusic(true);
            }
        }

        local onUpdate = o.onUpdate;
        o.onUpdate = function() {
            onUpdate();

            // If pause, in a menu or a loading screen then don't bother
            if (this.m.IsGamePaused || this.m.IsGameAutoPaused) return;
            if (this.m.MenuStack.hasBacksteps()) return;
            if (LoadingScreen != null && (LoadingScreen.isAnimating() || LoadingScreen.isVisible()))
                return;

            if (this.m.AutoEnterLocation != null && !this.m.AutoEnterLocation.isNull())
            {
                if (!(this.m.Player.getTile().isSameTileAs(this.m.AutoEnterLocation.getTile())
                      && this.m.Player.getDistanceTo(this.m.AutoEnterLocation.get())
                         <= this.Const.World.CombatSettings.CombatPlayerDistance))
                {
                    doUpdates();
                }
            }
            else if (this.m.AutoAttack != null && !this.m.AutoAttack.isNull()
                     && this.m.AutoAttack.isAlive() && !this.m.AutoAttack.isHiddenToPlayer())
            {
                if (!(this.m.Player.getDistanceTo(this.m.AutoAttack.get())
                      <= this.Const.World.CombatSettings.CombatPlayerDistance))
                {
                    doUpdates();
                }
            }
        }
    })
})
