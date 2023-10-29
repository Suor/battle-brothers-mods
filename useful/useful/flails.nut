local Text = ::std.Text, Util = ::std.Util;

local function getMember(table, key) {
    while (!(key in table) && "SuperName" in table) table = table[table.SuperName];
    return key in table ? table[key] : null;
}

// A universal item attrs hook
local function hookItem(script, values) {
    ::mods_hookExactClass(script, function (cls) {
        local randomizeValues = getMember(cls, "randomizeValues");
        if (randomizeValues) {
            cls.randomizeValues <- function () {
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
local flailValues = {RegularDamage = 55, RegularDamageMax = 95, ArmorDamageMult = 1.2};
hookItem("items/weapons/two_handed_flail", Util.merge(flailValues, {Value = 1700}))
hookItem("items/weapons/named/named_two_handed_flail", flailValues);
hookItem("items/weapons/artifact/artifact_two_handed_flail", flailValues);

// The rest
hookItem("items/weapons/two_handed_wooden_flail",
    {RegularDamage = 40, RegularDamageMax = 65, ArmorDamageMult = 0.9}); // up from 30-60-0.8
hookItem("items/weapons/greenskins/orc_flail_2h",
    {RegularDamage = 60, RegularDamageMax = 110, ArmorDamageMult = 1.3}); // up from 50-100-1.25


// Add extra chance to stun if master in flails
local function hookFlailSkill(cls, add) {
    local onAfterUpdate = cls.onAfterUpdate;
    cls.onAfterUpdate = function (_properties) {
        if (!("u_BaseStunChance" in this.m)) this.m.u_BaseStunChance <- this.m.StunChance;
        this.m.StunChance = this.m.u_BaseStunChance + (_properties.IsSpecializedInFlails ? add : 0);
    }
}

::mods_hookExactClass("skills/actives/pound", function (cls) {hookFlailSkill(cls, 20)})
::mods_hookExactClass("skills/actives/thresh", function (cls) {hookFlailSkill(cls, 10)})

::Const.Strings.PerkDescription.SpecFlail +=
    "\n\nPound gains " + Text.positive("+20%")
      + " and Thresh " + Text.positive("+10%") + " to stun chance.";
::Const.Perks.LookupMap["perk.mastery.flail"].Tooltip = ::Const.Strings.PerkDescription.SpecFlail;
