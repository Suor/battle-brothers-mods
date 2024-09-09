local hmod = ::Hooks.getMod("mod_necro")

hmod.hook("scripts/skills/actives/raise_undead", function (q) {
    q.create = @(__original) function () {
        __original();
        this.m.MaxRange = 8;
    }

    q.getTooltip <- function () {
        return [
            {
                id = 1,
                type = "title",
                text = this.getName()
            },
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            },
            {
                id = 3,
                type = "text",
                text = this.getCostString()
            }
        ];
    }

    // Overwrite for now
    q.spawnUndead = @() function (_user, _tile) {
        local p = _tile.Properties.get("Corpse");
        p.Faction = _user.getFaction();
        // START NEW CODE
        if (p.Faction == this.Const.Faction.Player)
        {
            p.Faction = this.Const.Faction.PlayerAnimals;
        }
        // END NEW CODE
        local e = this.Tactical.Entities.onResurrect(p, true);

        if (e != null)
        {
            e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
        }
    }
})
