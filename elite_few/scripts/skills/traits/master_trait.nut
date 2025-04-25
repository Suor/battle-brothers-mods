this.master_trait <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create()
    {
        this.character_trait.create();
        this.m.ID = "trait.master";
        this.m.Name = "Master";
        this.m.Icon = "ui/traits/trait_icon_masterbro_new.png";
        this.m.Description = "This person is one of a kind, skilled in virtually everything.";
        this.m.Order = this.Const.SkillOrder.Trait - 1;
        this.m.Titles = [];
        this.m.Excluded = [
            "trait.ailing"
            "trait.asthmatic"
            "trait.bleeder"
            // "trait.bloodthirsty" // Very useful to cut heads
            // "trait.brute" // ??? +15% damage to head -5 melee skill
            "trait.clubfooted"
            "trait.clumsy"
            "trait.cocky"
            "trait.craven"
            "trait.dastard"
            "trait.disloyal"
            "trait.dumb"
            "trait.fainthearted"
            "trait.fear_beasts"
            "trait.fear_greenskins"
            "trait.fear_undead"
            "trait.fragile"
            "trait.gluttonous"
            "trait.greedy"
            "trait.hesitant"
            "trait.insecure"
            "trait.irrational"
            "trait.night_blind"
            "trait.pessimist"
            "trait.short_sighted"
            "trait.superstitious"
            // Legends
            "trait.legend_fear_nobles"
            "trait.legend_frail"
            "trait.legend_appetite_donkey"
            "trait.legend_fear_dark"
            "trait.legend_predictable"
            "trait.legend_slack"
        ];
        if (::EliteFew.conf("excludeDubious")) this.m.Excluded.extend([
            "trait.drunkard"
            "trait.fat"
            "trait.impatient"
            "trait.huge"
            "trait.tiny"
            "trait.paranoid",
            "trait.brute", // put it here 
            // Legends
            "trait.legend_aggressive"
            "trait.legend_diurnal"
            "trait.legend_light"
            "trait.legend_double_tongued"
        ])
    }

    function getTooltip()
    {
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
                id = 10,
                type = "text",
                icon = "ui/icons/initiative.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Initiative"
            }
            {
                id = 11,
                type = "text",
                icon = "ui/icons/money.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]+9[/color] Daily wage"
            }
        ];
    }

    function onUpdate( _properties ) {
        _properties.Initiative += 5;
    }

});
