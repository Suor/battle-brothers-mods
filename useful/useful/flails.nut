local Text = ::std.Text, Util = ::std.Util;


// Hook flail attributes
local function hookWeapon(script, values) {
    ::mods_hookExactClass(script, function (cls) {
        if ("randomizeValues" in cls) {
            local randomizeValues = cls.randomizeValues;
            cls.randomizeValues = function () {
                Util.extend(this.m, values);
                randomizeValues();
            }
        } else {
            local create = cls.create;
            cls.create = function () {
                create();
                Util.extend(this.m, values);
            }
        }
    })
}

// Prime 2H flails, up from 45-90-1.15
local flailValues = {RegularDamage = 55, RegularDamageMax = 100, ArmorDamageMult = 1.2};
hookWeapon("items/weapons/two_handed_flail", Util.merge(flailValues, {Value = 1700}))
hookWeapon("items/weapons/named/named_two_handed_flail", flailValues);
hookWeapon("items/weapons/artifact/artifact_two_handed_flail", flailValues);

// The rest
hookWeapon("items/weapons/two_handed_wooden_flail",
    {RegularDamage = 40, RegularDamageMax = 70, ArmorDamageMult = 0.9}); // up from 30-60-0.8
hookWeapon("items/weapons/items/weapons/greenskins/orc_flail_2h",
    {RegularDamage = 60, RegularDamageMax = 110, ArmorDamageMult = 1.3}); // up from 50-100-1.25


// Add extra chance to stun if master in flails
local function hookFlailSkill(cls, add) {
    local onAdded = "onAdded" in cls ? cls.onAdded : cls.skill.onAdded
    cls.onAdded <- function () {
        onAdded();
        if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInFlails) {
            this.m.StunChance += add;
        }
    }
}

::mods_hookExactClass("skills/actives/pound", function (cls) {hookFlailSkill(cls, 10)})
::mods_hookExactClass("skills/actives/thresh", function (cls) {hookFlailSkill(cls, 10)})

::Const.Strings.PerkDescription.SpecFlail +=
    "\n\nPound and Thresh gain " + Text.positive("+10%") + " to stun chance.";
::Const.Perks.LookupMap["perk.mastery.flail"].Tooltip = ::Const.Strings.PerkDescription.SpecFlail;
