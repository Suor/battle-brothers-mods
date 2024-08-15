local effects = ::CampsAndArtifacts.AmmoEffects <- {
    fire = {
        Script = "scripts/skills/special/campart_fire_ammo"
        NamePrefix = "Flaming "
        DescSuffix = ", imbued with fire"
        Tooltip = "Sets target tile on fire"
    }
    ice = {
        Script = "scripts/skills/special/campart_ice_ammo"
        NamePrefix = "Freezing "
        DescSuffix = ", imbued with ice."
        Tooltip = "Freezes target on hit"
    }
    poison = {
        Script = "scripts/skills/special/campart_poison_ammo"
        NamePrefix = "Poisoned "
        DescSuffix = ", coated in goblin poison."
        Tooltip = "Applies goblin poison on target hit"
    }
    shock = {
        Script = "scripts/skills/special/campart_shock_ammo"
        NamePrefix = "Shocking "
        DescSuffix = ", dazing target on hit."
        Tooltip = "Applies daze on target hit"
    }
    bleeding = {
        Script = "scripts/skills/special/campart_bleeding_ammo"
        NamePrefix = "Jagged "
        DescSuffix = ", jagged to make them bleed."
        Tooltip = "Applies bleeding on target hit"
    }
}

this.artifact_ammo <- this.inherit("scripts/items/ammo/ammo", {
    m = {
        campart_IconNoun = ""
        campart_Effect = ""
        // IconVariant = null
    },
    function create()
    {
        this.ammo.create()
    }

    function getName()
    {
        return this.getEffectDesc().NamePrefix + this.m.Name;
    }

    function getDescription()
    {
        return this.m.Description + this.getEffectDesc().DescSuffix;
    }

    function updateIcon() {
        local filename = "ammo/campart_" + this.m.campart_IconNoun + "_"  + this.m.campart_Effect;
        if (this.m.campart_IconNoun == "arrows") {
            this.m.Icon = filename +".png";
            this.m.IconEmpty = filename +"_empty.png";
            if (this.m.campart_Effect == "bleeding")
                this.m.IconEmpty = "ammo/quiver_03_empty.png"
        }
        if (this.m.campart_IconNoun == "bolts"
                && (this.m.campart_Effect == "poison" || this.m.campart_Effect == "ice")) {
            this.m.Icon = filename +".png";
            this.m.IconEmpty = filename +"_empty.png";
        }
    }

    function getEffectDesc() {
        return effects[this.m.campart_Effect];
    }

    function appliesTo(_skill) {
        if (!_skill.isAttack() || !_skill.isRanged()) return false;
        local weapon = _skill.getItem();
        return weapon != null && !weapon.isNull() && weapon.getAmmoID() == this.m.ID;
    }

    function onEquip()
    {
        this.ammo.onEquip();
        this.addSkill(::new(this.getEffectDesc().Script));
    }

    function getTooltip()
    {
        local result = [
            {
                id = 1,
                type = "title",
                text = this.getName()
            },
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            }
        ];

        if (this.getIconLarge() != null)
        {
            result.push({
                id = 3,
                type = "image",
                image = this.getIconLarge(),
                isLarge = true
            });
        }
        else
        {
            result.push({
                id = 3,
                type = "image",
                image = this.getIcon()
            });
        }

        result.push({
            id = 66,
            type = "text",
            text = this.getValueString()
        });

        if (this.m.Ammo != 0)
        {
            result.push({
                id = 6,
                type = "text",
                icon = "ui/icons/ammo.png",
                text = "Contains [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] arrows"
            });
        }
        else
        {
            result.push({
                id = 6,
                type = "text",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]Is empty and useless[/color]"
            });
        }

        result.push({
            id = 7
            type = "text"
            icon = "ui/icons/special.png"
            text = this.getEffectDesc().Tooltip
        });

        return result;
    }

    function onSerialize( _out )
    {
        this.ammo.onSerialize(_out);
        _out.writeString(this.m.campart_Effect);
    }

    function onDeserialize( _in )
    {
        this.ammo.onDeserialize(_in);
        this.m.campart_Effect = _in.readString();
        this.updateIcon();
    }
})
