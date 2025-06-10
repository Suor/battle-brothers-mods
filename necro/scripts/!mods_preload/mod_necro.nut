local def = ::Necro <- {
    ID = "mod_necro"
    Name = "Proper Necro"
    Version = "0.4.2"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/775"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/necro"
        tagPrefix = "necro-"
    }
    FakeKill = false

    // Q: rename to addArmorPct() ? move to stdlib?
    function restoreArmorPct(_actor, _part, _pct) {
        local slot = _part == "head" ? ::Const.ItemSlot.Head : ::Const.ItemSlot.Body;
        local piece = _actor.m.Items.getItemAtSlot(slot);
        if (!piece) return false;

        local armor = piece.getArmor(), armorMax = piece.getArmorMax();
        if (armor >= armorMax) return false;
        piece.setArmor(::Math.min(armorMax,  armor + armorMax * _pct));
        return true;
    }
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("mod_msu >= 1.6.0", "stdlib >= 2.1");
mod.queue(">mod_reforged", function () {
    ::include("necro/rosetta_ru");

    def.msu <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);

    local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
    def.msu.Registry.addModSource(msd.NexusMods, upd.nexus);
    def.msu.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
    def.msu.Registry.setUpdateSource(msd.GitHubTags);

    ::MSU.Skills.addEvent("onRaiseUndead", function (_undead) {});//, false, true);

    ::Hooks.registerJS("ui/mods/necro.js");
    ::Hooks.registerCSS("ui/mods/necro.css");
    ::include("necro/tactical_state");

    // Allow origin to adjust hiring and tryout cost and wage on per bro basis
    mod.hook("scripts/entity/tactical/player", function (q) {
        // If we set it in scenario.onUpdateHiringRoster() then it's overwritten in
        // player.onDeserialize by m.Background.adjustHiringCostBasedOnEquipment() call.
        q.getHiringCost = q.getTryoutCost = @(__original) function () {
            local cost = __original();
            local origin = ::World.Assets.getOrigin();
            return "getBroCostMult" in origin
                ? ::Math.floor(cost * origin.getBroCostMult(this)) : cost;
        }
        // There is a DailyWageMult but that is not serialized
        q.getDailyCost = @(__original) function () {
            local wage = __original();
            local origin = ::World.Assets.getOrigin();
            return "getBroWageMult" in origin
                ? ::Math.floor(wage * origin.getBroWageMult(this)) : wage;
        }
    })

    // Summon necros in swamp, tundra settlements and medium/large too
    mod.hookTree("scripts/entity/world/settlement", function (q) {
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
    mod.hook("scripts/entity/world/settlements/situations/cultist_procession_situation",
            function (q) {
        q.onUpdateDraftList = @(__original) function (_draftList) {
            __original(_draftList);
            for (local i = 0; i < 4; i++) _draftList.push("necro_background")
        }
    })

    // Necromancer should get XP and kills from his zombies, but should not activate on kill effects
    mod.hookTree("scripts/skills/skill", function (q) {
        q.onTargetKilled = @(__original) function (_targetEntity, _skill) {
            // If this is a fake kill for necro then only collect stats
            if (!def.FakeKill || this.m.ID == "special.stats_collector") {
                return __original(_targetEntity, _skill);
            }
        }
    })
    mod.hook("scripts/entity/tactical/actor", function (q) {
        q.m.necro_RaisedByPlayer <- false;
        q.necro_master <- function () {
            if ("necro_master" in m && !m.necro_master.isNull()) return m.necro_master;
            return null;
        }

        q.onActorKilled = @(__original) function(_actor, _tile, _skill) {
            if (this.necro_master()) {
                def.FakeKill = true;
                this.m.necro_master.onActorKilled(_actor, _tile, _skill);
                def.FakeKill = false;
            }
            __original(_actor, _tile, _skill);
        }
        q.onResurrected = @(__original) function (_info) {
            if (_info.Faction == ::Const.Faction.PlayerAnimals) {
                m.necro_RaisedByPlayer = true
                // Since later we always drop for player animals we need to calc IsDroppedAsLoot here
                foreach (slot in [::Const.ItemSlot.Head, ::Const.ItemSlot.Body]) {
                    local piece = _info.Items.getItemAtSlot(slot);
                    if (piece) piece.m.IsDroppedAsLoot = piece.isDroppedAsLoot();
                }
            }
            if ("necro_master" in _info) {
                m.necro_master <- _info.necro_master; // Track necro
                if (::std.Actor.isAlive(m.necro_master))
                    m.necro_master.getSkills().onRaiseUndead(this);
            }
            __original(_info);
        }

        }

        q.necro_hasMaster <- function () {return "necro_master" in this.m}
    })

    // TODO: move this thing to fixes? will need to gather zombie loot instead of chopping them.
    // Want to get loot when zombies raised by us, so that necromancer won't be a loot destroyer
    mod.hook("scripts/items/item_container", function (q) {
        // This is needed for 1.5.0 and whatever places with old style dropAll(), or not.
        q.dropAll = @(__original) function(_tile, _killer, _flip = false) {
            ::logInfo("necro: in hooked dropAll");
            if (this.m.Actor.m.necro_RaisedByPlayer) {
                ::logInfo("necro: dropAll " + m.Actor.getName());

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
        if (q.contains("canDropItems")) {
            q.canDropItems = @(__original) function (_killer) {
                if (!this.m.Actor.m.necro_RaisedByPlayer) return __original(_killer);

                ::logInfo("necro: canDropItems " + m.Actor.getName());

                // They dropped already once so rolls had their say,
                // use Player/Blacksmith and whatnot to maximize chance to save them
                this.onFactionChanged(::Const.Faction.Player)

                return true;
            }
        }
    })

    // If DynamicPerks is installed then we'll add our perks via a special perk group
    if (!("DynamicPerks" in getroottable())) {
        ::DynamicPerks <- "necro_placeholder"; // needed to fool mod_plan_perks

        // Add perk tree to bros data
        mod.hook("scripts/ui/global/data_helper", function (q) {
            local allowedMasteries = {};
            foreach (w in ["mace" "cleaver" "sword" "dagger" "polearm" "crossbow" "throwing"])
                allowedMasteries["perk.mastery." + w] <- true;

            q.convertEntityToUIData = @(__original) function(_entity, _activeEntity) {
                local result = __original(_entity, _activeEntity);
                if (_entity != null && _entity.getSkills().hasSkill("background.necro")) {
                    local perks = ::Const.Perks.Perks.map(@(row) clone row);
                    perks[2] = perks[2].filter(@(_, p) p.ID != "perk.taunt");
                    perks[3] = perks[3].filter(@(_, p) p.ID in allowedMasteries);
                    perks[5] = perks[5].filter(@(_, p) p.ID != "perk.battle_forged");
                    foreach (perk in ::Const.Perks.Necro) {
                        perks[perk.Row].push(perk);
                    }
                    result.necro_perkTree <- perks;
                } else {
                    result.necro_perkTree <- ::Const.Perks.Perks;
                }
                return result;
            }
        });
    }

    // If not removed we cannot possess at the start of next battle
    mod.hook("scripts/skills/effects/possessing_undead_effect", function (q) {
        q.m.IsRemovedAfterBattle = true;
    })
    // Fill in missing description, position, etc
    mod.hook("scripts/skills/actives/possess_undead_skill", function (q) {
        q.create = @(__original) function() {
            __original();
            this.m.Order = ::Const.SkillOrder.Any + 76;
            this.m.IsUsingHitchance = false;
            this.m.Description
                = "Possess an undead giving it extra speed, skill, defense and damage tolerance.";
        }
    })
})
