local Player = ::std.Player, Rand = ::std.Rand;

this.druid_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
    m = {
        WoodsFolk = null
        ExcludedDraft = null
    },
    function create()
    {
        this.m.ID = "scenario.druid";
        this.m.Name = "The Wolf and the Bear";
        this.m.Description = "[p=c][img]gfx/ui/events/event_25.png[/img][/p][p]The wild was in your blood before you had words for it. The green things and the beasts that walk beneath the canopy know their own, and they have always known you. Now two of you walk the world with the wild at your back.\n\n[color=#bcad8c]The Wolf and the Bear:[/color] You begin as a pair, both walkers of the wild paths - one who has taken the beast's shape to fight tooth and claw, and one who calls the beasts and mends his fellows' wounds.\n[color=#bcad8c]Player Characters:[/color] Don't let both the Wolf and the Bear die.\n[color=#bcad8c]Children of the Wild:[/color] You begin with rough woodsfolk rather than trained soldiers, and will hire no hunters or poachers.[/p]";
        this.m.Difficulty = 1;
        this.m.Order = 50;
        this.m.IsFixedLook = true;

        // Woodsfolk fillers - no hunters or poachers (they don't keep a druid's company).
        this.m.WoodsFolk = [
            "wildman_background"
            "fisherman_background"
        ];
        // Backgrounds a druid's warband will not recruit.
        this.m.ExcludedDraft = ["hunter_background", "poacher_background"];
    }

    function isValid()
    {
        return true;
    }

    // Hunters and poachers won't take a druid's coin.
    function onUpdateDraftList( _list )
    {
        for (local i = _list.len() - 1; i >= 0; i--) {
            if (this.m.ExcludedDraft.find(_list[i]) != null) _list.remove(i);
        }
    }

    function onSpawnAssets()
    {
        local roster = this.World.getPlayerRoster();

        this.World.Assets.getStash().add(::new("scripts/items/supplies/strange_meat_item"));
        this.World.Assets.getStash().add(::new("scripts/items/supplies/bread_item"));
        this.World.Assets.getStash().add(::new("scripts/items/weapons/woodcutters_axe"));

        // The Bear: a summoner and healer who walks the path of Nature and starts with
        // Regrowth. Resolve-leaning talents to anchor the line and weather morale.
        local bear = roster.create("scripts/entity/tactical/player");
        bear.setStartValuesEx([::Druid.BackgroundScript]);
        bear.setPlaceInFormation(4 + 9);
        bear.getSkills().add(::new("scripts/skills/traits/player_character_trait"));
        bear.getFlags().set("IsPlayerCharacter", true);
        Player.giveLevels(bear, 2); // level 1 -> level 3
        bear.setTitle("the Bear");
        Player.clearTalents(bear);
        bear.m.Talents[::Const.Attributes.Bravery] = Rand.int(2, 3);
        Player.addTalents(bear, 2, {probs = [30 40 30]});
        bear.unlockPerk("perk.druid.regrowth");

        // The Wolf: a fighter who has taken the beast's shape and starts with Beastform.
        // Melee-leaning talents for a tooth-and-claw frontliner.
        local wolf = roster.create("scripts/entity/tactical/player");
        wolf.setStartValuesEx([::Druid.BackgroundScript]);
        wolf.setPlaceInFormation(4);
        wolf.getSkills().add(::new("scripts/skills/traits/player_character_trait"));
        wolf.getFlags().set("IsPlayerCharacter", true);
        Player.giveLevels(wolf, 2); // level 1 -> level 3
        wolf.setTitle("the Wolf");
        Player.clearTalents(wolf);
        wolf.m.Talents[::Const.Attributes.MeleeSkill] = Rand.int(2, 3);
        wolf.m.Talents[::Const.Attributes.MeleeDefense] = Rand.int(1, 2);
        Player.addTalents(wolf, 1, {probs = [30 40 30]});
        wolf.unlockPerk("perk.druid.beastform");

        // Two woodsfolk to fill the line.
        for (local i = 0; i < 2; i++) {
            local bro = roster.create("scripts/entity/tactical/player");
            bro.setStartValuesEx(this.m.WoodsFolk);
            bro.setPlaceInFormation(3 + i * 2);
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
        local assets = this.World.Assets;
        assets.m.BrothersMax = 12;
        // The Wolf-and-the-Bear band travels quicker through any forests
        // Q: inline constants?
        foreach (terrain, _ in ::Const.Druid.Forest.Terrain)
            assets.m.TerrainTypeSpeedMult[terrain] *= ::Const.Druid.Forest.SpeedMult;
    }

    function onCombatFinished() {
        local roster = this.World.getPlayerRoster().getAll();
        return ::std.Array.any(roster, @(bro) bro.getFlags().get("IsPlayerCharacter"));
    }
});
