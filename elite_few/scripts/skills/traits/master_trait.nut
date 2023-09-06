this.master_trait <- this.inherit("scripts/skills/traits/character_trait", {
    m = {},
    function create()
    {
        this.character_trait.create();
        this.m.ID = "trait.master";
        this.m.Name = "Master";
        this.m.Icon = "ui/traits/trait_icon_masterbro.png";
        this.m.Description = "This person is one of a kind, skilled in virtually everything.";
        this.m.Order = this.Const.SkillOrder.Trait - 1;
        this.m.Titles = [];
        this.m.Excluded = [
            "trait.ailing"
            "trait.asthmatic"
            "trait.bleeder"
            // "trait.bloodthirsty" // Very useful to cut heads
            "trait.brute" // ??? +15% damage to head -5 melee skill
            "trait.clubfooted"
            "trait.clumsy"
            "trait.cocky"
            "trait.craven"
            "trait.dastard"
            "trait.disloyal" // Actually positive :), but sounds bad
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
            "trait.drunkard" // added in this rewrite
            // Legends
            "trait.fear_nobles"
            "trait.frail"
            "trait.legend_appetite_donkey"
            "trait.legend_fear_dark"
            "trait.predictable"
            "trait.slack"
        ];
        if (::EliteFew.conf("excludeDubious")) this.m.Excluded.extend([
            "trait.fat"
            "trait.impatient"
            // Legends
            "trait.aggressive"
            "trait.legend_diurnal"
            "trait.light"
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
