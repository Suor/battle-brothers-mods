local mod = ::Useful, Text = ::std.Text;

::mods_hookExactClass("items/weapons/named/named_goblin_heavy_bow", function (cls) {
    local onEquip = cls.onEquip;
    cls.onEquip = function () {
        onEquip()
        this.addSkill(::new("scripts/skills/racial/goblin_ambusher_racial"));
    }

    // Go around "grandpa bound" bug
    local getTooltip = "getTooltip" in cls ? cls.getTooltip : null;
    cls.getTooltip <- function () {
        local result = getTooltip ? getTooltip() : this.named_weapon.getTooltip();
        result.push({
            id = 8
            type = "text"
            icon = "ui/icons/special.png"
            text = "Applies goblin poison on hit"
        });
        return result;
    }

    // DirectDamageMult 0.4 makes it on par with war bow on direct damage:
    // Here:    (0.4 + 0.1) * (30 + 50) / 2 = 20  (0.1 is DirectDamageAdd)
    // War bow:        0.35 * (50 + 70) / 2 = 21
    mod.hookItemClass(cls, {Value = 4500, DirectDamageMult = 0.4,
        DirectDamageAdd = 0.1, StaminaModifier = -2})
    // The last two fix Reforged nerf
})

::mods_hookExactClass("items/weapons/named/named_goblin_spear", function (cls) {
    local onEquip = cls.onEquip;
    cls.onEquip = function () {
        onEquip();
        // Make it 3 AP Thrust and Spearwall
        foreach (skill in this.m.SkillPtrs) {
            if (skill.m.ActionPointCost >= 4) {
                skill.m.ActionPointCost--;
                if ("b" in skill) skill.b.ActionPointCost--; // fix MSU bug
            }
        }
    }

    // Go around "grandpa bound" bug
    local getTooltip = "getTooltip" in cls ? cls.getTooltip : null;
    cls.getTooltip <- function () {
        local result = getTooltip ? getTooltip() : this.named_weapon.getTooltip();
        result.push({
            id = 9
            type = "text"
            icon = "ui/icons/action_points.png"
            text = "Skills cost [b]" + Text.positive("1 AP") + "[/b] less"
        });
        return result;
    }

    // StaminaModifier -2 fixes Reforged nerf
    mod.hookItemClass(cls, {Value = 3500, StaminaModifier = -2})
})

// StaminaModifier -2 fixes Reforged nerf
mod.hookItem("items/weapons/named/named_goblin_falchion",
    {Value = 3700, AdditionalAccuracy = 10, DirectDamageAdd = 0.1, ArmorDamageMult = 0.8,
     StaminaModifier = -2})
