// Druid background methods. Defined as a plain table so they can be either inherited into our own
// standalone background (when XBE is absent) or copied wholesale onto XBE's druid (see mod_druid.nut).
local def = {
    m = {}
    function create()
    {
        this.character_background.create();
        this.m.ID = "background.hackflows_druid";
        this.m.Icon = "druid/background_druid.png";
        this.m.Name = "Druid";

        this.m.HiringCost = 1400;
        this.m.DailyCost = 14;
        this.m.ExcludedTalents = [
            ::Const.Attributes.RangedSkill
        ];
        this.m.Excluded = [
            "trait.brute"
            "trait.clubfooted"
            "trait.cocky"
            "trait.dumb"
            "trait.fat"
            "trait.gluttonous"
            "trait.greedy"
            "trait.hate_beasts"
            "trait.impatient"
            "trait.insecure"
            "trait.night_blind",
            "trait.short_sighted"
            "trait.superstitious"
            "trait.teamplayer"
        ];
        this.m.Titles = [
            "the Druid",
            "the Hedge Witch",
            "Greenmantle",
            "the Beast Caller",
        ];
        this.m.Faces = ::Const.Faces.SmartMale;
        this.m.Hairs = ::Const.Hair.AllMale;
        this.m.HairColors = ::Const.HairColors.Old;
        this.m.Beards = ::Const.Beards.All;
        this.m.Bodies = ::Const.Bodies.Skinny;
    }

    // For Reforged
    function createPerkTreeBlueprint()
    {
        return ::new(::DynamicPerks.Class.PerkTree).init({
            DynamicMap = {
                "pgc.rf_exclusive_1": [],
                "pgc.rf_shared_1": [],
                "pgc.rf_weapon": [],
                "pgc.rf_armor": [],
                "pgc.rf_fighting_style": []
            }
        });
    }

    function getPerkGroupMultiplier(_groupID, _perkTree)
    {
        return ::std.Table.get({
            "pg.druid": -1
            "pg.rf_vigorous": 1.5
            "pg.special.rf_student": 1.5
        }, _groupID)
    }

    // Borrowed from XBE's Reforged compat shim so we fully own the tree when both are present.
    function getPerkGroupCollectionMin(_collection)
    {
        switch (_collection.getID())
        {
            case "pgc.rf_shared_1":
                return _collection.getMin() + 1;

            case "pgc.rf_fighting_style":
                return _collection.getMin() - 1;
        }
    }

    function getTooltip()
    {
        return [
            {
                id = 1,
                type = "title",
                text = this.getName()
            }
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            }
            {
                id = 10
                type = "text"
                icon = "ui/icons/special.png"
                text = "Can summon a beast fitting the battlefield to fight at his side"
            }
        ];
    }

    function onBuildDescription()
    {
        return "{Wrapped in furs and bark-dyed cloth, %name% smells of moss and old rain. | %name% speaks little to men and much to the trees, or so it seems. | Wherever %name% treads, beasts watch from the treeline and do not flee. | %name% carries no idols, yet kneels often to press an ear against the soil. | The crows seem to follow %name%, and he never shoos them away.} {He was raised at the forest's edge, far from any lord's reach. | Some say he was a hermit who learned the old green tongues. | He was driven from his village for speaking with wolves, they whisper. | None know whence he came, only that the woods opened to let him pass. | He claims the wild folk taught him, and you are not inclined to argue.} {%name% whistles a low note and a hare comes to his hand, then bounds away. | %name% lays a palm on a sick mule and by morning it stands hale. | %name% names the weather by the smell of the wind, and is seldom wrong. | %name% points to a thicket and bids you wait - moments later a stag breaks cover where he pointed.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [0, 5]
            Bravery = [5, 12]
            Stamina = [-5, 10]
            MeleeSkill = [0, 0]
            RangedSkill = [-5, 0]
            MeleeDefense = [0, 3]
            RangedDefense = [0, 5]
            Initiative = [-5, 5]
        };
        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/druid_summon_beast"));
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();

        // A stout stick or a gnarled staff cut from the woods (the latter is XBE's druid weapon).
        items.equip(::new(::Math.rand(1, 2) == 1
            ? "scripts/items/weapons/wooden_stick"
            : "scripts/items/weapons/greenskins/goblin_staff"));

        // Rough woodsfolk garb - hides, robes and sackcloth under hoods and straw hats, never plate.
        switch (::Math.rand(1, 5)) {
            case 1:
                items.equip(::new("scripts/items/armor/leather_tunic"));
                break;
            case 2:
                items.equip(::new("scripts/items/armor/monk_robe"));
                items.equip(::new("scripts/items/helmets/straw_hat"));
                break;
            case 3:
                items.equip(::new("scripts/items/armor/thick_dark_tunic"));
                items.equip(::new("scripts/items/helmets/dark_cowl"));
                break;
            case 4:  // XBE's druid armor
                items.equip(::new("scripts/items/armor/tattered_sackcloth"));
                items.equip(::new("scripts/items/helmets/straw_hat"));
                break;
            case 5:  // XBE's druid armor
                items.equip(::new("scripts/items/armor/leather_wraps"));
                break;
        }
    }
}

// Expose the methods for the XBE-overwrite path, and build the standalone background by inheritance.
::Druid.BackgroundMethods <- def;
this.druid_background <- this.inherit("scripts/skills/backgrounds/character_background", clone def);
