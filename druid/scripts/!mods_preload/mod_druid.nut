local def = ::Druid <- {
    ID = "mod_druid"
    Name = "Proper Druid"
    Version = "0.1.0"
    Updates = {
        nexus = ""
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/druid"
        tagPrefix = "druid-"
    }
    FakeKill = false

    // Beast body-part sprites; can't enumerate an entity's sprites, so we probe these with hasSprite().
    BodySprites = ["body", "body_blood", "head", "head_frenzy", "injury",
                   "legs_back", "legs_front", "armor"]

    // Which background script the origin scenario and (when XBE is absent) the settlement
    // draft lists should use. Overridden to XBE's druid in the queue when XBE is present.
    BackgroundScript = "druid_background"
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("mod_msu >= 1.6.0", "stdlib >= 2.1");
mod.queue(">mod_reforged", ">mod_background_perks",
          ">mod_backgrounds_and_events", ">mod_backgrounds_and_events_reforged_patch",
        function () {
    ::include("druid/rosetta_ru");

    local Util = ::std.Util, Debug = ::std.Debug.with({prefix = "druid: "});

    def.msu <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);

    local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
    if (upd.nexus != "") def.msu.Registry.addModSource(msd.NexusMods, upd.nexus);
    def.msu.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
    def.msu.Registry.setUpdateSource(msd.GitHubTags);

    if ("BgPerks" in getroottable()) {
        ::std.Table.extend(::BgPerks.chances.hackflows_druid, {
            "druid.entangle": 5
            "druid.hatch": 3
            "druid.beastform": 4
            "druid.beast_aura": 2
            "druid.beast_rage": 2
            "druid.venom": 2
        })
    }

    // Shared helpers (relocateItem, applyBeastform[Look], onBeastJoinedPack, isDruidScenario).
    ::include("druid/helpers");


    // If More Backgrounds and Events present we repurpose it's druid background.
    // We queue after the Reforged compat patch to overwrite it.
    if (::Hooks.hasMod("mod_backgrounds_and_events")) {
        def.BackgroundScript = "hackflows/druid_background";

        mod.hook("scripts/skills/backgrounds/hackflows/druid_background", function (q) {
            ::include("scripts/skills/backgrounds/druid_background");
            foreach (name, member in ::Druid.BackgroundMethods) {
                if (typeof member != "function") continue;
                if (q.contains(name, true)) q[name] = @(__original) member; // replace existing method
                else                        q[name] <- member;             // add new (e.g. Reforged-only)
            }
        })
    } else {
        // No XBE: make our own Druid hireable by seeding his background into settlement draft
        // lists. Prefer the woods (forest/lumber) and the swamps, keep out of big cities.
        mod.hookTree("scripts/entity/world/settlement", function (q) {
            local cn = q.ClassName;
            local isWild = cn.find("_forest_") != null || cn.find("_lumber_") != null
                        || cn.find("_swamp_") != null;
            local isBigCity = cn.find("city_state") != null
                           || cn.find("large_") != null && !isWild;
            local num = isWild ? 2 : isBigCity ? 0 : 1;
            if (num == 0) return;

            q.create = @(__original) function () {
                __original();
                for (local i = 0; i < num; i++) m.DraftList.push(def.BackgroundScript);
            }
        })
    }

    // The Druid earns XP and kills from his beasts, but should not fire on-kill effects.
    mod.hookTree("scripts/skills/skill", function (q) {
        q.onTargetKilled = @(__original) function (_targetEntity, _skill) {
            if (!def.FakeKill || m.ID == "special.stats_collector") {
                return __original(_targetEntity, _skill);
            }
        }
    })

    mod.hook("scripts/entity/tactical/actor", function (q) {
        q.m.druid_Summoned <- false;
        q.druid_master <- function () {
            if ("druid_master" in m && !m.druid_master.isNull()) return m.druid_master;
            return null;
        }

        // Beast Aura rides every allied animal, not just the druid's own pack: hang the receiver on
        // each animal as it hits the map (covers summons, unleashed dogs, anything). The effect
        // self-scopes - inert unless allied with an aura druid near. Idempotent against a re-place.
        q.onPlacedOnMap = @(__original) function() {
            __original();
            if (::Const.Druid.isAnimal(this) && getSkills().getSkillByID("effects.druid_beast_aura") == null)
                getSkills().add(::new("scripts/skills/effects/druid_beast_aura_effect"));
        }

        q.onActorKilled = @(__original) function(_actor, _tile, _skill) {
            local master = this.druid_master();
            if (master != null && ::std.Actor.isAlive(master)) {
                // Always lower the flag: leaving it up would silence on-kill effects for everyone.
                def.FakeKill = true;
                try { master.onActorKilled(_actor, _tile, _skill); }
                catch (err) { def.FakeKill = false; throw err; }
                def.FakeKill = false;
            }
            __original(_actor, _tile, _skill);
        }

        // Enemy beast sprites face left; flip them to face right while the summon fights for us.
        // In onFactionChanged so a charm/uncharm keeps the orientation right.
        q.onFactionChanged = @(__original) function() {
            __original();
            if (!m.druid_Summoned) return;
            local flip = isAlliedWithPlayer();
            foreach (part in ::Druid.BodySprites) {
                if (hasSprite(part)) getSprite(part).setHorizontalFlipping(flip);
            }
        }

        // A beast under an active Beast Aura feels morale like anyone - it can be shaken down to
        // Breaking and suffer for it - but the roll can never push it into Fleeing. We cap the
        // negative change so the state floors at Breaking instead of routing it off the field.
        // Fearlessness is purely by proximity: only while an aura source stands in range.
        q.checkMorale = @(__original) function( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false ) {
            if (_change < 0) {
                local aura = getSkills().getSkillByID("effects.druid_beast_aura");
                if (aura != null && aura.isAuraActive())
                    _change = Math.max(_change, Const.MoraleState.Breaking - getMoraleState());
            }
            return __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
        }

        // A falling beast stokes any allied Beast Rage: hard (OwnBeastDeath) for its own master,
        // a flicker (AllyBeastDeath) for every other raging brother on the field.
        q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType ) {
            __original(_killer, _skill, _tile, _fatalityType);
            if (!isAlliedWithPlayer() || !::Const.Druid.isAnimal(this)) return;
            if (!("State" in ::Tactical) || ::Tactical.State.isBattleEnded()) return;
            local master = this.druid_master();
            foreach (bro in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)) {
                if (!::std.Actor.isAlive(bro)) continue;
                local rage = bro.getSkills().getSkillByID("perk.druid.beast_rage");
                if (rage == null) continue;
                local own = master != null && !master.isNull() && master.getID() == bro.getID();
                rage.addRage(own ? ::Const.Druid.Rage.OwnBeastDeath : ::Const.Druid.Rage.AllyBeastDeath);
            }
        }
    })

    // Beastform's equipment ban: a transformed druid cannot equip heavy shields, helmets or body
    // armor, nor any ranged weapon (see ::Const.Druid.beastformAllows). We refuse the equip at the
    // container so it is enforced everywhere - inventory screen, tactical swaps and AI alike.
    // Beast Rage at its height also refuses a shield until the rage cools below the threshold.
    mod.hook("scripts/items/item_container", function (q) {
        q.equip = @(__original) function (_item) {
            local actor = m.Actor;
            if (_item != null && actor != null && !actor.isNull()) {
                local skills = actor.getSkills();
                if (skills.hasSkill("perk.druid.beastform")
                    && !::Const.Druid.beastformAllows(_item)) {
                    return false;
                }
                if (_item.isItemType(::Const.Items.ItemType.Shield)) {
                    local rage = skills.getSkillByID("perk.druid.beast_rage");
                    if (rage != null && rage.bansShield()) return false;
                }
            }
            return __original(_item);
        }
    })

    // Beast Aura reaches the druid's unleashed companions too: a war dog or wolf he slips from its
    // leash joins his pack - emboldened, fearless and kept to his side - just like a summoned beast.
    // druid_master records who loosed it (the rage onDeath hook credits the right brother); only then
    // does his own Beast Aura embolden it. Vanilla wardog/wolf items hold the beast in m.Entity;
    // Animal Companions' own unleash skill exposes getEntity() instead, so hook it too when AC is on.
    local unleashSkills = ["scripts/skills/actives/unleash_wardog", "scripts/skills/actives/unleash_wolf"];
    if (::Hooks.hasMod("mod_AC")) unleashSkills.push("scripts/companions/onequip/companions_unleash");
    foreach (script in unleashSkills) {
        mod.hook(script, function (q) {
            q.onUse = @(__original) function (_user, _targetTile) {
                local ok = __original(_user, _targetTile);
                if (ok && "Item" in m && m.Item != null) {
                    local beast = ("getEntity" in m.Item) ? m.Item.getEntity() : m.Item.m.Entity;
                    if (!::std.Util.isNull(beast)) {
                        beast.m.druid_master <- ::MSU.asWeakTableRef(_user);
                        if (_user.getSkills().hasSkill("perk.druid.beast_aura"))
                            ::Druid.onBeastJoinedPack(_user, beast);
                    }
                }
                return ok;
            }
        })
    }

    // Forest vision bonus for the Wolf-and-the-Bear origin: the band sees farther beneath the
    // canopy. (The matching travel-speed bonus rides MSU's origin callback - see
    // druid_scenario.getMovementSpeedMult; vision has no such origin hook, so it stays here.)
    mod.hook("scripts/entity/world/player_party", function (q) {
        q.getVisionRadius = @(__original) function () {
            local r = __original();
            if ((getTile().Type in ::Const.Druid.Forest.Terrain) && def.isDruidScenario())
                r = r * ::Const.Druid.Forest.VisionMult;
            return r;
        }
    })

    // Implicit-group exclusion safety net: never let a blocked perk be unlocked, whatever path
    // (UI dialog, DynamicPerks, AI). The character screen also greys blocked perks out: under
    // DPF natively via verifyPrerequisites on the perk defs (see z_druid.nut), otherwise via
    // the druid_blocked flag stamped below + the isPerkUnlockable override in druid.js.
    mod.hook("scripts/entity/tactical/player", function (q) {
        q.unlockPerk = @(__original) function (_id) {
            if (::Const.Druid.isPerkBlocked(_id, getSkills())) return false;
            return __original(_id);
        }
    })

    // If DynamicPerks is installed we add perks via a special perk group (see druid_pg) and its
    // verifyPrerequisites lock covers the UI. Otherwise inject our perk rows straight into the
    // background's perk tree and carry the exclusion to the UI ourselves (druid.js + druid.css).
    if (!("DynamicPerks" in getroottable())) {
        ::DynamicPerks <- "druid_placeholder"; // needed to fool mod_plan_perks

        ::Hooks.registerJS("ui/mods/druid.js");
        ::Hooks.registerCSS("ui/mods/druid.css");

        mod.hook("scripts/ui/global/data_helper", function (q) {
            // Disallow some masterties so that perk row 4 won't be too long
            local keepMasteries = {};
            foreach (w in ["axe" "spear" "polearm" "dagger" "bow" "throwing" "mace" "flail"])
                keepMasteries["perk.mastery." + w] <- true;

            q.convertEntityToUIData = @(__original) function(_entity, _activeEntity) {
                local result = __original(_entity, _activeEntity);
                if (_entity != null && _entity.getSkills().hasSkill("background.hackflows_druid")) {
                    local skills = _entity.getSkills();
                    local perks = ::Const.Perks.Perks.map(@(row) clone row);
                    perks[3] = perks[3].filter(@(_, p) p.ID in keepMasteries);
                    foreach (perk in ::Const.Perks.Druid) {
                        // Clone so the per-entity druid_blocked flag never leaks onto the shared
                        // perk definition; the JS tree reads it to grey out blocked perks. The
                        // verifyPrerequisites function must not cross the JS boundary - drop it.
                        local p = clone perk;
                        delete p.verifyPrerequisites;
                        p.druid_blocked <- ::Const.Druid.isPerkBlocked(perk.ID, skills);
                        perks[perk.Row].push(p);
                    }
                    result.druid_perkTree <- perks;
                } else {
                    result.druid_perkTree <- ::Const.Perks.Perks;
                }
                return result;
            }
        });
    }
})
