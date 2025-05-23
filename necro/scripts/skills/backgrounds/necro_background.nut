this.necro_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "background.necro";
        this.m.Icon = "ui/backgrounds/background_39.png";
        this.m.Name = "Necromancer";

        this.m.HiringCost = 1500;
        this.m.DailyCost = 15;
        this.m.ExcludedTalents = [
            ::Const.Attributes.Initiative,
            ::Const.Attributes.RangedSkill
        ];
        this.m.Excluded = [
            "trait.impatient"
            "trait.iron_jaw"
            "trait.clubfooted"
            "trait.dumb"
            "trait.insecure"
            "trait.loyal"
            "trait.fainthearted"
            "trait.brute"
            "trait.superstitious"
        ];
        this.m.Titles = [
            "the Necro",
            "the Necromancer",
            "Dark",
            "the Dark Mage",
        ];
        this.m.Faces = ::Const.Faces.SmartMale;
        this.m.Hairs = ::Const.Hair.Necromancer;
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
                "pgc.rf_weapon": ["pg.rf_dagger"],
                "pgc.rf_armor": [],
                "pgc.rf_fighting_style": []
            }
        });
    }

    PerkTreeMultipliers = {
        "pg.necro": -1
        "pg.rf_fast": 1.5,
        "pg.rf_tough": 0.5,
        "pg.special.rf_leadership": 1.5
        "pg.special.rf_student": 1.5
        "pg.rf_axe": 0
        "pg.rf_hammer": 0.3
        "pg.rf_spear": 0.3
        "pg.rf_cleaver": 1.7
        "pg.rf_polearm": 1.7
        "pg.rf_crossbow": 1.2
        "pg.rf_heavy_armor": 0
    }
    function getPerkGroupMultiplier(_groupID, _perkTree)
    {
        return ::std.Table.get(PerkTreeMultipliers, _groupID)
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
                id = 10,
                type = "text",
                icon = "ui/icons/morale.png",
                text = "No morale check triggered upon allies dying"
            }
        ];
    }

    function onBuildDescription()
    {
        return "{Clothed in strangely colored robes, %name% appears to be more of an ambassador of the dark than a man of flesh and blood. | A curious fellow, %name% carries a slumped posture, as if he is weighted by otherworldly knowledge. | %name%\'s face is hidden well inside the dark of his cowl, a crescent of yellow teeth the only notion that a man dwells within. | Not much is known about %name%, but strange rumors of sorcery and dark arts follow him. | Wherever animals mysteriously begin to die, %name% makes an appearance. | The brooches on %name%\'s cloak seem to swirl and dance like midnight in a jug. | %name%\'s hands are rare to see, only coming out as if to portray the feelings of his face which lies hidden deep in his hood. | %name%\'s eyes could be mistaken for a cat\'s one day and for a blind man\'s the next.} {Little is known about whence he came. | From where he hails is but a mystery to most. | Some say he traveled deep into the northern foothills, returning with unspoken knowledge. | Ostensibly, the dark arts are his heritage, or so he puts on. | The man\'s past is kept from all. Maybe it\'s just uninteresting, or maybe just the opposite. | One rumor of the man says he traveled the land as a magician. | Rumors of magic surround the man, though some incredulous cynics are hardly impressed. | One rumor is that he was a conman, and another is that he\'s a sorcerer. You\'re not sure which you prefer. | With rumors of dark arts being practiced once more, the man\'s magical proclamation just might be true. | Some say he eats toads for breakfast and black cats for dinner.} {You ask %name% a lot of questions, but through some handwaves and nods, you realize you have forgotten his answers. Or did you ask the questions at all? | %name% produces a dove from his sleeve. An old trick that fancies no one - until it turns in the air, returning to him as a crow. | %name% has shown the ability to shoot smoke from his mouth. It\'s not fire, but it\'s close, and has people talking in hushed tones. | %name% floats a gold coin into the air. An amazing display that leaves the man too tired to attempt it again. | Predictions of the weather are common, but %name% is unusually accurate with his own. | %name% asks to read your palms. You decline. His presence alone is as close as you\'re willing to go. | %name% suggests that the stars are a roadmap to another world. He seems to know a lot about the heavens above. | %name% suggests that the heavens above are in fact just endless streams of beings, continuing on for eons. What a jest! | %name% points to one star in the sky and seems to suggest that is where he came from. You don\'t ask for a clarification on the matter.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [0, 0]
            Bravery = [10, 20]
            Stamina = [-5, 10]
            MeleeSkill = [0, 0]
            RangedSkill = [0, 0]
            MeleeDefense = [0, 3]
            RangedDefense = [-3, 3]
            Initiative = [-10, 0]
        };
        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/necro_raise_undead"));
        // Possess is available via perk now
    }

    function onUpdate( _properties )
    {
        this.character_background.onUpdate(_properties);
        _properties.IsAffectedByDyingAllies = false;
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 3);
        if (roll == 1) {
            items.equip(::new("scripts/items/armor/wizard_robe"));
            items.equip(::new("scripts/items/helmets/wizard_hat"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/armor/thick_dark_tunic"));
            items.equip(::new("scripts/items/helmets/dark_cowl"));

        } else {
            items.equip(::new("scripts/items/armor/ragged_dark_surcoat"));
        }
    }
});
