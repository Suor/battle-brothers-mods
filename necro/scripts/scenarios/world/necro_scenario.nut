local Player = ::std.Player, Rand = ::std.Rand;

this.necro_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
    m = {
        MeatBackgrounds = null
        MeatClassNames = null
    },
    function create()
    {
        this.m.ID = "scenario.necro";
        this.m.Name = "Proper Necromancer";
        this.m.Description = "[p=c][img]gfx/ui/events/event_76.png[/img][/p][p]Having death always around you found a way to revert it. Somewhat.\n\n[color=#bcad8c]Player Character:[/color] This necromancer is you. Don't die, there is noone to raise you.\n[color=#bcad8c]An outcast:[/color] People wary about your craft. Starting relations are cold and people joining you expect better pay.\n[color=#bcad8c]Cannon Fodder:[/color] You have your ways of finding lots of cripples, various misfits and other corpse material for a handful of crowns. Proper mercenaries are willing to join you less. Have 25 roster slots.[/p]";
        this.m.Difficulty = 2;
        this.m.Order = 49;
        this.m.IsFixedLook = true;

        this.m.MeatBackgrounds = ["cripple_background" "beggar_background" "refugee_background"];
        if (::Hooks.hasMod("mod_backgrounds_and_events")) {
            this.m.MeatBackgrounds.extend(["hackflows/leper_background" "hackflows/drifter_background"]);
        }
        this.m.MeatClassNames = this.m.MeatBackgrounds.map(@(s) ::std.Str.cutprefix(s, "hackflows/"));
    }

    function isValid()
    {
        return true;
    }

    function onSpawnAssets()
    {
        local roster = this.World.getPlayerRoster();

        ::World.Assets.m.BusinessReputation = 0;
        ::World.Assets.addMoralReputation(-10);

        ::World.Assets.getStash().add(::new("scripts/items/supplies/smoked_ham_item"));
        ::World.Assets.getStash().add(::new("scripts/items/supplies/bread_item"));
        ::World.Assets.getStash().add(::new("scripts/items/armor/butcher_apron"));
        ::World.Assets.getStash().add(::new("scripts/items/weapons/butchers_cleaver"));
        ::World.Assets.getStash().add(::new("scripts/items/weapons/pitchfork"));

        local necro = roster.create("scripts/entity/tactical/player");
        necro.setStartValuesEx(["necro_background"]);
        necro.setPlaceInFormation(4 + 9);
        necro.getSkills().add(::new("scripts/skills/traits/player_character_trait"));
        necro.getFlags().set("IsPlayerCharacter", true);
        necro.m.XP = ::Const.LevelXP[2 - 1]; // Level 2
        necro.updateLevel();
        necro.setTitle("the Dark Master");

        // Necro talents. Give at least one combat skill talent and betters stars
        Player.clearTalents(necro);
        local combatSkill = Rand.choice([
            ::Const.Attributes.MeleeSkill
            ::Const.Attributes.MeleeDefense
            ::Const.Attributes.RangedDefense
        ], [75 25 25]);
        necro.m.Talents[combatSkill] = Rand.int(2, 3);
        Player.addTalents(necro, 2, {probs = [30 40 30]});

        // Items
        local items = necro.getItems();
        items.unequip(items.getItemAtSlot(::Const.ItemSlot.Body));
        items.unequip(items.getItemAtSlot(::Const.ItemSlot.Head));
        items.equip(::new("scripts/items/armor/wanderers_coat"));

        local student = roster.create("scripts/entity/tactical/player");
        student.setStartValuesEx(["apprentice_background"]);
        student.setPlaceInFormation(5 + 9);

        // Add some meat guys
        for (local i = 0; i < 3; i++) {
            local meat = roster.create("scripts/entity/tactical/player");
            meat.setStartValuesEx(this.m.MeatBackgrounds);
            meat.setPlaceInFormation(3 + i);
        }
    }

    function onSpawnPlayer()
    {
        local randomVillage;

        for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i++ )
        {
            randomVillage = this.World.EntityManager.getSettlements()[i];

            if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3)
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

        // Set noble houses to dislike us
        local nobles = ::World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
        foreach ( n in nobles ) {
            n.addPlayerRelation(-25.0, "Your craft is not welcome");
        }

        this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
        this.World.Assets.updateLook(11);
        this.World.getCamera().setPos(this.World.State.m.Player.getPos());
        // this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
        // {
        //     this.Music.setTrackList([
        //         "music/civilians_01.ogg"
        //     ], this.Const.Music.CrossFadeTime);
        //     this.World.Events.fire("event.paladin_commander_intro");
        // }, null);
    }

    function onInit() {
        // More people to hire, see onUpdateDraftList() though :)
        this.World.Assets.m.RosterSizeAdditionalMin += 1;
        this.World.Assets.m.RosterSizeAdditionalMax += 2;

        // More bros in total, but not in battle (some space for meat)
        this.World.Assets.m.BrothersMax = 25;
    }

    // This hook was added in this mod
    function getBroCostMult(_bro) {
        local isMeat = this.m.MeatClassNames.find(_bro.m.Background.ClassName) != null;
        return isMeat ? 0.5 : 1;
    }

    function onHired(_bro) {
        _bro.worsenMood(1.0, "Disgruntled by undead");
    }

    function onUpdateDraftList(_list) {
        // See more meat guys than proper backgrounds ;)
        local n = _list.len() / this.m.MeatBackgrounds.len();
        for (local i = 0; i < n; i++) _list.extend(this.m.MeatBackgrounds);
    }

    function onCombatFinished() {
        local roster = this.World.getPlayerRoster().getAll();
        return ::std.Array.any(roster, @(bro) bro.getFlags().get("IsPlayerCharacter"));
    }
});
