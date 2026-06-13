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

    // Beastform's permanent transformation: shed any newly-forbidden gear and take the beast look.
    // Relocation follows perma's missing_hand: drop on the ground mid-battle, else to the bag, else
    // to the stash - so nothing is ever lost. (Beastform is taken in the world, so usually the bag.)
    def.relocateItem <- function (_actor, _item) {
        local items = _actor.getItems();
        items.unequip(_item);
        if ("State" in ::Tactical && !::Tactical.State.isBattleEnded() && _actor.isPlacedOnMap()) {
            _item.drop(_actor.getTile());
        } else if (items.hasEmptySlot(::Const.ItemSlot.Bag)) {
            items.addToBag(_item);
        } else {
            ::World.Assets.getStash().makeEmptySlots(1);
            ::World.Assets.getStash().add(_item);
        }
    }
    def.applyBeastform <- function (_actor) {
        local items = _actor.getItems();
        foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand, ::Const.ItemSlot.Body,
                          ::Const.ItemSlot.Head, ::Const.ItemSlot.Accessory, ::Const.ItemSlot.Ammo]) {
            local item = items.getItemAtSlot(slot);
            if (item == null || ::Const.Druid.beastformAllows(item)) continue;
            def.relocateItem(_actor, item);
        }
        def.applyBeastformLook(_actor);
    }
    // The beast look ships with the mod (brushes/druid_beast.brush + gfx/druid_beast.png, vendored
    // from Fantasy Brothers' Baku set), so no Fantasy Brothers dependency.
    def.applyBeastformLook <- function (_actor) {
        local body = _actor.getSprite("body");
        local head = _actor.getSprite("head");
        body.setBrush("druid_beast_body_0" + ::Math.rand(1, 2));
        head.setBrush("druid_beast_head_0" + ::Math.rand(1, 3));
        if (_actor.hasSprite("hair"))
            _actor.getSprite("hair").setBrush("druid_beast_hair_0" + ::Math.rand(1, 5));
        if (_actor.hasSprite("injury_body"))
            _actor.getSprite("injury_body").setBrush(body.getBrush().Name + "_injured");
        head.varyColor(0.05, 0.05, 0.05);
        body.Color = head.Color;
        _actor.setDirty(true);
    }


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

        // Beast Aura's fearless beasts feel morale like anyone - they can be shaken down to
        // Breaking and suffer for it - but the roll can never push them into Fleeing. We cap the
        // negative change so the state floors at Breaking instead of routing them off the field.
        // Fearless comes either permanently (racial.druid_fearless on the druid's own beasts) or
        // by proximity (the Beast Aura effect, while an aura source is in range).
        q.checkMorale = @(__original) function( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false ) {
            if (_change < 0) {
                local aura = getSkills().getSkillByID("effects.druid_beast_aura");
                local fearless = getSkills().hasSkill("racial.druid_fearless")
                              || (aura != null && aura.isAuraActive());
                if (fearless) _change = Math.max(_change, Const.MoraleState.Breaking - getMoraleState());
            }
            return __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
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
            q.convertEntityToUIData = @(__original) function(_entity, _activeEntity) {
                local result = __original(_entity, _activeEntity);
                if (_entity != null && _entity.getSkills().hasSkill("background.hackflows_druid")) {
                    local skills = _entity.getSkills();
                    local perks = ::Const.Perks.Perks.map(@(row) clone row);
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
