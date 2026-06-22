local Player = ::std.Player, Rand = ::std.Rand;

this.druid_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
    m = {
        ExcludedDraft = null
    },
    function create()
    {
        this.m.ID = "scenario.druid";
        this.m.Name = "The Wolf and the Bear";
        this.m.Description = "[p=c][img]gfx/ui/events/event_25.png[/img][/p][p]The wild was in your blood before you had words for it. The green things and the beasts that walk beneath the canopy know their own, and they have always known you. Now two of you walk the world with the wild at your back.\n\n[color=#bcad8c]The Wolf and the Bear:[/color] You begin as a pair, both walkers of the wild paths - one who has taken the beast's shape to fight tooth and claw, and one who calls the beasts and mends his fellows' wounds.\n[color=#bcad8c]Player Characters:[/color] Don't let both the Wolf and the Bear die.\n[color=#bcad8c]Woodwise:[/color] Your band travels swiftly through forests and sees farther beneath the canopy.[/p]";
        this.m.Difficulty = 1;
        this.m.Order = 50;
        this.m.IsFixedLook = true;

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
        local roster = ::World.getPlayerRoster();

        ::World.Assets.getStash().add(::new("scripts/items/supplies/strange_meat_item"));
        ::World.Assets.getStash().add(::new("scripts/items/supplies/bread_item"));
        ::World.Assets.getStash().add(::new("scripts/items/weapons/woodcutters_axe"));

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
    }

    function onSpawnPlayer()
    {
        // Start the woods-folk band beside a forest (lumber) village if there is one; otherwise
        // fall back to the first reachable non-military town as vanilla does.
        // We don't skip size 1 villages though.
        local randomVillage = null, fallback = null;
        foreach (s in ::World.EntityManager.getSettlements())
        {
            if (s.isMilitary() || s.isIsolatedFromRoads()) continue;
            if (fallback == null) fallback = s;
            if (s.ClassName.find("_forest_") != null || s.ClassName.find("_lumber_") != null)
            {
                randomVillage = s;
                break;
            }
        }
        if (randomVillage == null) randomVillage = fallback;

        local randomVillageTile = randomVillage.getTile();
        local navSettings = ::World.getNavigator().createSettings();
        navSettings.ActionPointCosts = ::Const.World.TerrainTypeNavCost_Flat;

        do
        {
            local x = ::Math.rand(
                ::Math.max(2, randomVillageTile.SquareCoords.X - 9),
                ::Math.min(::Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 9));
            local y = ::Math.rand(
                ::Math.max(2, randomVillageTile.SquareCoords.Y - 9),
                ::Math.min(::Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 9));

            if (!::World.isValidTileSquare(x, y))
            {
            }
            else
            {
                local tile = ::World.getTileSquare(x, y);

                if (tile.IsOccupied)
                {
                }
                else if (tile.getDistanceTo(randomVillageTile) <= 6)
                {
                }
                else
                {
                    local path = ::World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

                    if (!path.isEmpty())
                    {
                        randomVillageTile = tile;
                        break;
                    }
                }
            }
        }
        while (1);

        ::World.State.m.Player = ::World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
        ::World.Assets.updateLook(11);
        ::World.getCamera().setPos(::World.State.m.Player.getPos());
    }

    function onInit() {
        ::World.Assets.m.BrothersMax = 12;
    }

    // Forest travel-speed bonus. MSU drives the movement pipeline and calls the origin's
    // getMovementSpeedMult every update (player_party.getOriginMovementSpeedMult), so we make
    // it terrain-aware here rather than touching the asset_manager's TerrainTypeSpeedMult array
    // (which MSU no longer reads).
    function getMovementSpeedMult() {
        local player = ::World.State.getPlayer();
        if (!::std.Util.isNull(player) && (player.getTile().Type in ::Const.Druid.Forest.Terrain))
            return ::Const.Druid.Forest.SpeedMult;
        return 1.0;
    }

    function onCombatFinished() {
        local roster = ::World.getPlayerRoster().getAll();
        return ::std.Array.any(roster, @(bro) bro.getFlags().get("IsPlayerCharacter"));
    }
});
