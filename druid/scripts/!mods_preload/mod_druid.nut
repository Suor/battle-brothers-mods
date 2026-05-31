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

    // Which background script the origin scenario and (when XBE is absent) the settlement
    // draft lists should use. Overridden to XBE's druid in the queue when XBE is present.
    BackgroundScript = "druid_background"

    // The beast-summoning bits that turn a plain background into a Druid. Defined once here so
    // that both our own background and the XBE druid we hijack reuse them instead of copy-pasting.
    function addSummonActive(_background) {
        _background.m.Container.add(::new("scripts/skills/actives/druid_summon_beast"));
    }
    function summonTooltipEntry() {
        return {
            id = 10
            type = "text"
            icon = "ui/icons/special.png"
            text = "Can summon a beast fitting the battlefield to fight at his side"
        };
    }
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("mod_msu >= 1.6.0", "stdlib >= 2.1");
mod.queue(">mod_reforged", function () {
    ::include("druid/rosetta_ru");

    local Util = ::std.Util, Debug = ::std.Debug.with({prefix = "druid: "});

    def.msu <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);

    local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
    if (upd.nexus != "") def.msu.Registry.addModSource(msd.NexusMods, upd.nexus);
    def.msu.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
    def.msu.Registry.setUpdateSource(msd.GitHubTags);

    ::MSU.Skills.addEvent("onSummonBeast", function (_beast) {});

    ::Hooks.registerJS("ui/mods/druid.js");
    ::Hooks.registerCSS("ui/mods/druid.css");

    // XBE compat: it ships its own Druid under the same background.hackflows_druid ID. When it's
    // present we graft our summoning onto XBE's druid instead of adding a second one, and leave
    // drafts (and perk/bonus keying on that ID) to XBE.
    local hasXbe = ::Hooks.hasMod("mod_backgrounds_and_events");
    if (hasXbe) def.BackgroundScript = "hackflows/druid_background";

    if (hasXbe) {
        // Additive hooks only: XBE's flavour, the Reforged shim's perk tree and Background
        // Bonuses' tooltip wrapping all stay intact; we just add the summon active and its line.
        mod.hook("scripts/skills/backgrounds/hackflows/druid_background", function (q) {
            q.onAdded = @(__original) function () {
                __original();
                ::Druid.addSummonActive(this);
            }
            q.getTooltip = @(__original) function () {
                local tooltip = __original();
                tooltip.push(::Druid.summonTooltipEntry());
                return tooltip;
            }
            // Guarantee the Druid perk group. XBE's druid (via the Reforged compat shim) builds
            // its tree from a DynamicMap, so addSpecialPerkGroups() runs - but the shim never
            // returns a multiplier for pg.druid, leaving its Chance at 0. A negative multiplier
            // forces calculateChance() to 100, the same trick our own background uses.
            q.getPerkGroupMultiplier = @(__original) function (_groupID, _perkTree) {
                if (_groupID == "pg.druid") return -1;
                return __original(_groupID, _perkTree);
            }
        })
    }
    // else {
        // No XBE: make our own Druid hireable by seeding his background into settlement draft
        // lists. Prefer the woods (forest/lumber) and the swamps.
        mod.hookTree("scripts/entity/world/settlement", function (q) {
            local cn = q.ClassName;
            local num = 19;
            local isWild = cn.find("_forest_") != null || cn.find("_lumber_") != null
                        || cn.find("_swamp_") != null;
            if (isWild) num++;

            q.create = @(__original) function () {
                __original();
                for (local i = 0; i < num; i++) this.m.DraftList.push(def.BackgroundScript);
            }
        })
    // }

    // The Druid earns XP and kills from his beasts, but should not fire on-kill effects.
    mod.hookTree("scripts/skills/skill", function (q) {
        q.onTargetKilled = @(__original) function (_targetEntity, _skill) {
            if (!def.FakeKill || this.m.ID == "special.stats_collector") {
                return __original(_targetEntity, _skill);
            }
        }
    })

    mod.hook("scripts/entity/tactical/actor", function (q) {
        q.m.druid_RaisedByPlayer <- false;
        q.druid_master <- function () {
            if ("druid_master" in m && !m.druid_master.isNull()) return m.druid_master;
            return null;
        }

        q.onActorKilled = @(__original) function(_actor, _tile, _skill) {
            local master = this.druid_master();
            if (master != null && ::std.Actor.isAlive(master)) {
                def.FakeKill = true;
                master.onActorKilled(_actor, _tile, _skill);
                def.FakeKill = false;
            }
            __original(_actor, _tile, _skill);
        }

        // Pack Leader's fearless beasts feel morale like anyone - they can be shaken down to
        // Breaking and suffer for it - but the roll can never push them into Fleeing. We cap the
        // negative change so the state floors at Breaking instead of routing them off the field.
        q.checkMorale = @(__original) function( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false ) {
            if (_change < 0 && this.getSkills().hasSkill("racial.druid_fearless")) {
                _change = this.Math.max(_change, this.Const.MoraleState.Breaking - this.getMoraleState());
            }
            return __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
        }
    })

    // If DynamicPerks is installed we add perks via a special perk group (see druid_pg).
    // Otherwise inject our perk rows straight into the background's perk tree.
    if (!("DynamicPerks" in getroottable())) {
        ::DynamicPerks <- "druid_placeholder"; // needed to fool mod_plan_perks

        mod.hook("scripts/ui/global/data_helper", function (q) {
            q.convertEntityToUIData = @(__original) function(_entity, _activeEntity) {
                local result = __original(_entity, _activeEntity);
                if (_entity != null && _entity.getSkills().hasSkill("background.hackflows_druid")) {
                    local perks = ::Const.Perks.Perks.map(@(row) clone row);
                    foreach (perk in ::Const.Perks.Druid) {
                        perks[perk.Row].push(perk);
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
