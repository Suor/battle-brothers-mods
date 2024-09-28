local hmod = ::Hooks.getMod("mod_necro")

hmod.hook("scripts/states/tactical_state", function (q) {
    q.onBattleEnded = @(__original) function () {
        if (this.m.IsExitingToMenu) return;
        this.m.IsBattleEnded = true;  // Stop turns and user input

        ::logInfo("necro: onBattleEnded");
        this.necro_chopHeads(__original.bindenv(this));
    }

    q.necro_chopHeads <- function (_callback) {
        local actors = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.PlayerAnimals);
        local toKill = 0;
        ::logInfo("necro: got " + actors.len() + " animals");
        foreach (actor in actors) {
            if (!actor.necro_hasMaster()) continue;
            if (!actor.isAlive() || actor.isDying()) continue;

            if (!actor.isPlacedOnMap()) {
                this.necro_chop(actor);
                continue;
            }

            toKill++;
            local tile = actor.getTile();
            ::Tactical.CameraDirector.addMoveToTileEvent(
                0, tile, -1, this.necro_chop.bindenv(this), actor,
                ::Const.Tactical.Settings.CameraWaitForEventDelay,
                ::Const.Tactical.Settings.CameraNextEventDelay
            );
        }
        if (toKill) {
            ::Tactical.CameraDirector.addIdleEvent(0, function (_tag) {_callback()});
        } else {
            _callback()
        }
    }

    q.necro_chop <- function (_zombie) {
        ::logInfo("necro: necro_chop " + _zombie.getName());

        // Prevents morale checks in onOtherActorDeath()
        _zombie.m.XP = 0;

        _zombie.kill(null, null, ::Const.FatalityType.Decapitated);
    }
})
