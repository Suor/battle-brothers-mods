// ::Hooks.DebugMode = true;
local mod = ::Necro <- {
    ID = "mod_necro"
    Name = "Proper Necro"
    Version = "0.2.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/775"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/necro"
        tagPrefix = "necro-"
    }
    FakeKill = false

    function restoreArmor(_actor, _part, _pct) {
        local slot = _part == "head" ? ::Const.ItemSlot.Head : ::Const.ItemSlot.Body;
        local piece = _actor.m.Items.getItemAtSlot(slot);
        if (piece) {
            local armor = piece.getArmor();
            local armorMax = piece.getArmorMax();
            piece.setArmor(::Math.min(armorMax,  armor + (armorMax - armor) * _pct));
        }
    }
}

local hmod = ::Hooks.register(mod.ID, mod.Version, mod.Name);
hmod.queue(function() {
    // if (::Hooks.hasMod("mod_msu")) {
    //     mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);

    //     mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods,
    //         "https://www.nexusmods.com/battlebrothers/mods/772");
    //     if ("GitHubTags" in ::MSU.System.Registry.ModSourceDomain) {
    //         mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHubTags,
    //             "https://github.com/Suor/battle-brothers-mods/tree/master/necro");
    //         mod.Mod.Registry.setUpdateSource(
    //             ::MSU.System.Registry.ModSourceDomain.GitHubTags,
    //             {Prefix = "necro-"}
    //         );
    //     }
    // }

    // ::Hooks.registerJS("ui/mods/necro.js");
    // ::Hooks.registerCSS("ui/mods/necro.css");

    ::include("necro/tactical_state");

    // Summon necros in swamp, tundra settlements and medium/large too
    hmod.hookTree("scripts/entity/world/settlement", function (q) {
        local num = 0;
        if (q.ClassName.find("_swamp_") != null || q.ClassName.find("_tundra_") != null) num++;
        if (q.ClassName.find("large_") != null) num++;
        if (q.ClassName.find("medium_") != null) num++;

        q.create = @(__original) function () {
            __original();
            for (local i = 0; i < num; i++) this.m.DraftList.push("necro_background");
        }
    })
    // Summon necros during cultist event
    hmod.hook("scripts/entity/world/settlements/situations/cultist_procession_situation",
            function (q) {
        q.onUpdateDraftList = @(__original) function (_draftList) {
            __original(_draftList);
            for (local i = 0; i < 4; i++) _draftList.push("necro_background")
        }
    })

    // Necromancer should get XP and kills from his zombies, but should not activate on kill effects
    hmod.hookTree("scripts/skills/skill", function (q) {
        q.onTargetKilled = @(__original) function (_targetEntity, _skill) {
            // If this is a fake kill for necro then only collect stats
            if (!mod.FakeKill || this.m.ID == "special.stats_collector") {
                return __original(_targetEntity, _skill);
            }
        }
    })
    hmod.hook("scripts/entity/tactical/actor", function (q) {
        q.onActorKilled = @(__original) function(_actor, _tile, _skill) {
            if ("necro_master" in this.m && !this.m.necro_master.isNull()) {
                mod.FakeKill = true;
                this.m.necro_master.onActorKilled(_actor, _tile, _skill);
                mod.FakeKill = false;
            }
            __original(_actor, _tile, _skill);
        }

        q.onResurrected = @(__original) function (_info) {
            __original(_info);

            // Track necro and original faction
            if ("necro_master" in _info) {
                this.m.necro_master <- _info.necro_master;
            }

            // // Future Flesh of Iron perk
            // mod.restoreArmor(this, "head", 0.333);
            // mod.restoreArmor(this, "body", 0.333);
            // this.getSkills().update();

            // TODO: regeneration, life steal?

            // local b = this.m.BaseProperties;
            // b.MeleeSkill += 50;
            // b.RangedSkill += 50;
            // b.DamageTotalMult *= 5;
            // b.MeleeDefense += 50;
            // b.RangedDefense += 50;
            // b.HitpointsMult *= 5;
        }

        q.necro_hasMaster <- function () {return "necro_master" in this.m}
    })

    // Want to get loot when zombies raised by us, so that necromancer won't be a loot destroyer
    hmod.hook("scripts/items/item_container", function (q) {
        q.dropAll = @(__original) function(_tile, _killer, _flip = false) {
            ::logInfo("necro: in hooked dropAll");
            if (this.m.Actor.necro_hasMaster()) {
                ::logInfo("necro: drop");

                // They dropped already once so rolls had their say,
                // use Player/Blacksmith and whatnot to maximize chance to save them
                this.onFactionChanged(::Const.Faction.Player)

                // It's just too hard to jump through all the dropAll conditions so we duplicate
                local tile = _tile, emergency = false;
                if (tile == null && this.m.Actor.isPlacedOnMap()) {
                    tile = this.m.Actor.getTile();
                    emergency = true;
                }
                if (tile == null) return;

                foreach (item in this.getAllItems()) {
                    if (item == null || item == -1) continue;
                    if (item.isChangeableInBattle() || emergency) item.drop(_tile);
                    // Items not dropped go into corpse and later collected or reused from there
                }
            } else {
                __original(_tile, _killer, _flip);
            }
        }
    })

    // if (!("DynamicPerks" in getroottable())) ::DynamicPerks <- "placeholder to fool mod_plan_perks";
    // // Add perk tree to bros data
    // hmod.hook("scripts/ui/global/data_helper", function (q) {
    //     local function set(...) {
    //         local s = {};
    //         foreach (c in vargv) s[c] <- true;
    //         return s;
    //     }
    //     local allowedMasteries = set(
    //         "perk.mastery.mace"
    //         "perk.mastery.cleaver"
    //         "perk.mastery.dagger"
    //         "perk.mastery.polearm"
    //         "perk.mastery.crossbow"
    //     )

    //     q.convertEntityToUIData = @(__original) function(_entity, _activeEntity)
    //     {
    //         local result = __original(_entity, _activeEntity);
    //         if (_entity != null && _entity.getSkills().hasSkill("background.necro")) {
    //             local perks = clone ::Const.Perks.Perks;
    //             perks[1] = clone perks[1];
    //             perks[1].push(::Const.Perks.LookupMap["perk.necro.flesh_of_iron"]);
    //             perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);
    //             perks[3].push(::Const.Perks.LookupMap["perk.necro.mastery"])
    //             result.necro_perkTree <- perks;
    //         } else {
    //             result.necro_perkTree <- ::Const.Perks.Perks;
    //         }
    //         return result;
    //     }
    // });

    hmod.hook("scripts/skills/effects/possessing_undead_effect", function (q) {
        q.m.IsRemovedAfterBattle = true;
    })
})

// TODO: switch to GithubTags from MSU 1.6.0
hmod.queue(">msu", function () {
     if (!("MSU" in getroottable())) return;
    ::include("necro/hack_msu");
    ::HackMSU.setup(mod, mod.Updates);
});
