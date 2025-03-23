local def = ::Useful <- {
    ID = "mod_useful"
    Name = "Useful Things"
    Version = "0.7.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/682"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/useful"
        tagPrefix = "useful-"
    }
    Debug = ::std.Debug.with({prefix = "u: "})
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("stdlib >= 2.0");
// This file is named z_* for this to work
if (::Hooks.hasMod("tnf_refillableNet")) mod.conflictWith("tnf_refillableNet");

local Util = ::std.Util;

// A universal item attrs hook
def.hookItem <- function (script, values) {
    mod.hook(script, function (q) {def.hookItemClass(q, values)})
}
def.hookItemClass <- function (q, values) {
    // Reforged/MSU/ModularVanilla thing breaking named items
    if (q.contains("setValuesBeforeRandomize")) {
        q.setValuesBeforeRandomize = @(__original) function (_values) {
            local overrides = Util.extend(_values || {}, values);
            __original(overrides);
        }
    // Named items in vanilla
    } else if (q.contains("randomizeValues")) {
        q.randomizeValues = @(__original) function () {
            Util.extend(this.m, values);
            __original();
        }
    }

    // Normal items, can't else it, because the above are added to all items by ModularVanilla
    q.create = @(__original) function () {
        __original();
        Util.extend(this.m, values);
    }
}

mod.queue(">mod_msu", ">mod_reforged", ">sato_balance_mod", function () {
    if (::Hooks.hasMod("mod_msu")) {
        def.msu <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);

        local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
        def.msu.Registry.addModSource(msd.NexusMods, upd.nexus);
        if ("GitHubTags" in msd) {
            def.msu.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
            def.msu.Registry.setUpdateSource(msd.GitHubTags);
        }
    }

    ::include("useful/flails");
    ::include("useful/goblin");
    ::include("useful/hand_to_hand");
    ::include("useful/nets");

    def.hookItem("scripts/items/shields/special/craftable_lindwurm_shield",
        {StaminaModifier = -8}); // from -14
    // This is not used in vanilla and thus has worse base props than normal lindwurm shield
    def.hookItem("scripts/items/shields/named/named_lindwurm_shield",
        {StaminaModifier = -8, MeleeDefense = 17, Condition = 64, ConditionMax = 64});

    // Give +25 Melee def when fleeing not only retreating
    mod.hook("scripts/skills/traits/weasel_trait", function (q) {
        // TODO: update tooltip
        q.onUpdate = @(__original) function (_properties) {
            __original(_properties);
            local actor = this.getContainer().getActor();
            if (actor.getMoraleState() == ::Const.MoraleState.Fleeing) {
                _properties.MeleeDefense += 25;
            }
        }
    })
});

// tnf_resistFXResilient messes up with nets otherwise
::Hooks.__unverifiedRegister("tnf_refillableNet", 2.0, "Refillable Nets via Useful Things");
