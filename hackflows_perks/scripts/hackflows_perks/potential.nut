local Text = ::std.Text;

local names = [
    "Promised Potential"
    "Promising Potential"
    "Rising Potential"
    "Realized Potential"
]
foreach (stage in [0 1 2 3]) {
    foreach (failed in [false true]) {
        if (stage == 3 && failed) continue; // no such thing
        local suffix = failed ? "_fail" : "";
        local perk = {
            ID = "perk.hackflows.potential_" + stage + suffix
            Script = "scripts/skills/perks/perk_hackflows_potential"
            Name = names[stage] + (failed ? " (Failed)" : "")
            Tooltip = "..." // Filled in later
            Icon = "hackflows_perks/potential_" + stage + suffix + ".png"
            IconDisabled = "hackflows_perks/potential_sw.png"
        }
        ::Const.Perks.LookupMap[perk.ID] <- perk;
    }
}

// TODO: support vanilla
local pp = ::Const.Perks.LookupMap["perk.rf_promised_potential"];
pp.Icon = "hackflows_perks/potential_0.png"
pp.IconDisabled = "hackflows_perks/potential_sw.png"

local setDescription = "UPD" in getroottable() ? ::UPD.setDescription
    : function (_perkID, _stringsKey, _description) {
        ::Const.Perks.findById(_perkID).Tooltip = _description;
    }

local function makeDesc(_info) {
    return ::Reforged.Mod.Tooltips.parseString(::UPD.getDescription(_info))
}

local function setupPerk(_id, _stringsKey, _info) {
    local perk = ::Const.Perks.findById(_id);
    perk.Fluff <- _info.Fluff;
    setDescription(_id, _stringsKey, makeDesc(_info));
}

local failFluff = "This character looked promising, but either due to bad luck or simply lack of talent, they have not fulfilled the potential you thought they had.";

// TODO: update perk refs
local p0desc = {
    Fluff = "The Captain said he\'d take a gamble on you, but you\'d better not disappoint!",
    Effects = [{
        Type = ::UPD.EffectType.OneTimeEffect,
        Description = [
            "Upon reaching level 5, this perk has a " + Text.positive("75%") + " chance of being replaced with [b]Promising Potential[/b] which will increase all attributes by " + Text.positive("+3") + ", and can be upgraded further at levels 8 and 11.",
            "If unsuccessful, this perk is replaced by [Failed Potential|Perk+perk_rf_failed_potential] which does nothing."
        ]
    }],
    Footer = Text.negative("This perk cannot be picked after you have spent a perk point elsewhere. This perk cannot be refunded.")
}
setupPerk("perk.rf_promised_potential", "RF_PromisedPotential", p0desc);
setupPerk("perk.hackflows.potential_0", null, p0desc);
setDescription("perk.hackflows.potential_0_fail", null, ::Const.Strings.PerkDescription.RF_FailedPotential);
Const.Perks.findById("perk.hackflows.potential_0_fail").Fluff <- failFluff;

local p1 = {
    Fluff = "You turned out to be promising, but you\'d better not disappoint!",
    Effects = [
        {
            Type = ::UPD.EffectType.Passive,
            Description = [
                "Increase all attributes by " + Text.positive("+3") + "."
            ]
        }
        {
            Type = ::UPD.EffectType.OneTimeEffect,
            Description = [
                "Upon reaching level 8, this perk has a " + Text.positive("75%") + " chance of being replaced with [b]Rising Potential[/b] which will increase this character\'s salary by " + Text.negative("50%") + ", increase all attributes by " + Text.positive("+4") + ", unlock a new weapon perk group, and can be upgraded further at lvl 11",
                "If unsuccessful, this perk stops progressing."
            ]
        }
    ]
    Footer = Text.negative("This perk cannot be refunded.")
}
local p1fail = {
    Fluff = failFluff
    Effects = p1.Effects.slice(0, -1)
    Footer = p1.Footer
}
setupPerk("perk.hackflows.potential_1", null, p1);
setupPerk("perk.hackflows.potential_1_fail", null, p1fail);

local p2 = {
    Fluff = "Your potential is rising, but you\'d better not disappoint!",
    Effects = [
        {
            Type = ::UPD.EffectType.Passive,
            Description = [
                "Increase all attributes by " + Text.positive("+7") + "."
                "Require " + Text.negative("50%") + " more daily wage.",
            ]
        }
        {
            Type = ::UPD.EffectType.OneTimeEffect,
            Description = [
                "Gain " + Text.positive("1") + " random Weapon Perk Group.",
                "Upon reaching level 11, this perk has a " + Text.positive("75%") + " chance of being replaced with [b]Realized Potential[/b] which will increase this character\'s salary by " + Text.negative("50%") + ", increase all attributes by " + Text.positive("+5") + ", unlock new perk groups and refund all perk points, including the one spent on this perk.",
                "If unsuccessful, this perk stops progressing."
            ]
        }
    ]
    Footer = Text.negative("This perk cannot be refunded.")
}
local p2fail = {
    Fluff = failFluff
    Effects = p2.Effects.slice(0, -1)
    Footer = p2.Footer
}
setupPerk("perk.hackflows.potential_2", null, p2);
setupPerk("perk.hackflows.potential_2_fail", null, p2fail);

local p3 = {
    Fluff = "From bones to brawn! This character has truly come a long way. Who was once a dreg of society is now a full-fledged mercenary.",
    Effects = [
        {
            Type = ::UPD.EffectType.Passive,
            Description = [
                "Increase all attributes by " + Text.positive("+12") + "."
                "Require " + Text.negative("100%") + " more daily wage.",
            ]
        },
        {
            Type = ::UPD.EffectType.OneTimeEffect,
            Description = [
                "Refund all spent Perk Points.",
                "Gain " + Text.positive("+1") + " Perk Point.",
                "Gain " + Text.positive("1") + " random Shared Perk Group.",
                "Gain " + Text.positive("2") + " random Weapon Perk Groups.",
            ]
        }
    ],
    Footer = Text.negative("This perk cannot be refunded.")
}
setupPerk("perk.hackflows.potential_3", null, p3);


// Replace Promised Potential with our thing
// NOTE: we keep failed and realised potentials as well as graded stuff as is to not mess
//       with proper migration
::HackflowsPerks.mh.hook("scripts/skills/perks/perk_rf_promised_potential", function (q) {
    q.onAdded = @() function () {
        local actor = getContainer().getActor();
        local skills = actor.getSkills();

        local hackflows_pot = ::new("scripts/skills/perks/perk_hackflows_potential");
        // Need to add perk to tree before adding to bro so that if perk is upgraded
        // it could be replaced correctly
        actor.getPerkTree().addPerk(hackflows_pot.getID());
        skills.add(hackflows_pot);

        actor.getPerkTree().removePerk(getID());
        removeSelf();

        // When loading game player's level will be always 1, so will need to sync it later
        ::Time.scheduleEvent(::TimeUnit.Real, 200, function (_tag) {
            hackflows_pot._syncLevel();
        }, null);
    }
})
