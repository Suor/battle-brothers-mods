local def = ::Useful, mod = def.mh, Text = ::std.Text, Util = ::std.Util;

// Prime 2H flails, up from 45-90-1.15
local flailValues = {RegularDamage = 55, RegularDamageMax = 95, ArmorDamageMult = 1.2};
def.hookItem("scripts/items/weapons/two_handed_flail", Util.merge(flailValues, {Value = 1700}))
def.hookItem("scripts/items/weapons/named/named_two_handed_flail", flailValues);
def.hookItem("scripts/items/weapons/artifact/artifact_two_handed_flail", flailValues);

// The rest
def.hookItem("scripts/items/weapons/two_handed_wooden_flail",
    {RegularDamage = 40, RegularDamageMax = 65, ArmorDamageMult = 0.9}); // up from 30-60-0.8
def.hookItem("scripts/items/weapons/greenskins/orc_flail_2h",
    {RegularDamage = 60, RegularDamageMax = 110, ArmorDamageMult = 1.3}); // up from 50-100-1.25


// Add extra chance to stun if master in flails
local function hookFlailSkill(q, add) {
    q.onAfterUpdate = @(__original) function (_properties) {
        __original(_properties);
        if (!("u_BaseStunChance" in this.m)) m.u_BaseStunChance <- this.m.StunChance;
        this.m.StunChance = this.m.u_BaseStunChance + (_properties.IsSpecializedInFlails ? add : 0);
    }
}

mod.hook("scripts/skills/actives/pound", function (q) {hookFlailSkill(q, 20)})
mod.hook("scripts/skills/actives/thresh", function (q) {hookFlailSkill(q, 10)})

::Const.Strings.PerkDescription.SpecFlail +=
    "\n\nPound gains " + Text.positive("+20%")
      + " and Thresh " + Text.positive("+10%") + " to stun chance.";
::Const.Perks.LookupMap["perk.mastery.flail"].Tooltip = ::Const.Strings.PerkDescription.SpecFlail;
