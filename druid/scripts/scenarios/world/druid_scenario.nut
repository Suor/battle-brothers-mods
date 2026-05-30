local Player = ::std.Player, Rand = ::std.Rand;

this.druid_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
    m = {
        WoodsFolk = null
    },
    function create()
    {
        this.m.ID = "scenario.druid";
        this.m.Name = "Proper Druid";
        this.m.Description = "[p=c][img]gfx/ui/events/event_25.png[/img][/p][p]You learned to speak with the green things and the beasts that walk beneath the canopy. Now you walk the world with them at your back.\n\n[color=#bcad8c]Player Character:[/color] This druid is you. Should you fall, no beast will answer for the others.\n[color=#bcad8c]Children of the Wild:[/color] You begin with rough woodsfolk rather than trained soldiers.\n[color=#bcad8c]Call of the Wild:[/color] From the first day you can summon a beast fitting the battlefield to fight at your side.[/p]";
        this.m.Difficulty = 1;
        this.m.Order = 50;
        this.m.IsFixedLook = true;

        this.m.WoodsFolk = [
            "hunter_background"
            "poacher_background"
            "wildman_background"
            "fisherman_background"
        ];
    }

    function isValid()
    {
        return true;
    }

    function onSpawnAssets()
    {
        local roster = this.World.getPlayerRoster();

        this.World.Assets.getStash().add(::new("scripts/items/supplies/strange_meat_item"));
        this.World.Assets.getStash().add(::new("scripts/items/supplies/bread_item"));
        this.World.Assets.getStash().add(::new("scripts/items/weapons/hunting_bow"));
        this.World.Assets.getStash().add(::new("scripts/items/weapons/woodcutters_axe"));

        local druid = roster.create("scripts/entity/tactical/player");
        druid.setStartValuesEx(["druid_background"]);
        druid.setPlaceInFormation(4 + 9);
        druid.getSkills().add(::new("scripts/skills/traits/player_character_trait"));
        druid.getFlags().set("IsPlayerCharacter", true);
        druid.m.XP = ::Const.LevelXP[2 - 1]; // Level 2
        druid.updateLevel();
        druid.setTitle("the Greenmantle");

        // Druid talents: at least one combat-leaning star, plus a couple more.
        Player.clearTalents(druid);
        local combatSkill = Rand.choice([
            ::Const.Attributes.MeleeSkill
            ::Const.Attributes.MeleeDefense
            ::Const.Attributes.RangedDefense
        ], [60 20 20]);
        druid.m.Talents[combatSkill] = Rand.int(2, 3);
        Player.addTalents(druid, 2, {probs = [30 40 30]});

        // Three woodsfolk to start.
        for (local i = 0; i < 3; i++) {
            local bro = roster.create("scripts/entity/tactical/player");
            bro.setStartValuesEx(this.m.WoodsFolk);
            bro.setPlaceInFormation(3 + i);
        }
    }

    function onSpawnPlayer()
    {
        local randomVillage;

        for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i++ )
        {
            randomVillage = this.World.EntityManager.getSettlements()[i];

            if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 2)
            {
                break;
            }
        }

        local randomVillageTile = randomVillage.getTile();
        local navSettings = this.World.getNavigator().createSettings();
        navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

        do
        {
            local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 8), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 8));
            local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 8), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 8));

            if (!this.World.isValidTileSquare(x, y))
            {
            }
            else
            {
                local tile = this.World.getTileSquare(x, y);

                if (tile.IsOccupied)
                {
                }
                else if (tile.getDistanceTo(randomVillageTile) <= 5)
                {
                }
                else if (!tile.HasRoad)
                {
                }
                else
                {
                    local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

                    if (!path.isEmpty())
                    {
                        randomVillageTile = tile;
                        break;
                    }
                }
            }
        }
        while (1);

        this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
        this.World.Assets.updateLook(11);
        this.World.getCamera().setPos(this.World.State.m.Player.getPos());
    }

    function onInit() {
        this.World.Assets.m.BrothersMax = 12;
    }

    function onCombatFinished() {
        local roster = this.World.getPlayerRoster().getAll();
        return ::std.Array.any(roster, @(bro) bro.getFlags().get("IsPlayerCharacter"));
    }
});
