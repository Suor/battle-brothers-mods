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

    // Make the Druid hireable: seed his background into settlement draft lists.
    // Prefer the woods (forest/lumber) and the swamps.
    mod.hookTree("scripts/entity/world/settlement", function (q) {
        local cn = q.ClassName;
        // local isBig = cn.find("large_") != null || cn.find("city_state") != null;
        // if (isBig) return;

        local num = 1;
        local isWild = cn.find("_forest_") != null || cn.find("_lumber_") != null
                    || cn.find("_swamp_") != null;
        if (isWild) num++;

        q.create = @(__original) function () {
            __original();
            for (local i = 0; i < num; i++) this.m.DraftList.push("druid_background");
        }
    })

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
                if (_entity != null && _entity.getSkills().hasSkill("background.druid")) {
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
