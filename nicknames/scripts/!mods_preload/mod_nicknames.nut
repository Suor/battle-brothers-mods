local def = ::Nicknames <- {
    ID = "mod_nicknames"
    Name = "Nicknames for Everyone"
    Version = "0.1"
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.conflictWith("mod_renamer");

// Base attribute ranges before background modifiers
local BaseAttrRanges = {
    Hitpoints = [50, 60],
    Bravery = [30, 40],
    Stamina = [90, 100],
    MeleeSkill = [47, 57],
    RangedSkill = [32, 42],
    MeleeDefense = [0, 5],
    RangedDefense = [0, 5],
    Initiative = [100, 110]
};

mod.queue(">mod_bro_studio", function () {
    ::include("nicknames/titles");
    ::include("nicknames/rosetta_auto");

    local W = def.Weights;

    def.buildFactorSet <- function(bro) {
        local set = {};

        // background and traits
        set[bro.getBackground().getID()] <- true;
        foreach (skill in bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait))
            if (skill.getID().find("trait.") == 0) set[skill.getID()] <- true;

        // talents
        foreach (name, idx in ::Const.Attributes)
            if (name != "COUNT" && bro.m.Talents[idx] == 3)
                set["talent." + name] <- true;

        // attrs
        local bgAttrs = bro.getBackground().onChangeAttributes();
        local baseProps = bro.getBaseProperties();
        local props = bro.getCurrentProperties();
        foreach (attr, br in BaseAttrRanges) {
            local low = br[0] + bgAttrs[attr][0], high =  br[1] + bgAttrs[attr][1];
            if (baseProps[attr] >= high && props[attr] >= high || props[attr] > high)
                set["attr." + attr + ".high"] <- true;
            if (baseProps[attr] <= low && props[attr] <= low || props[attr] < low)
                set["attr." + attr + ".low"] <- true;
        }

        // type: melee or ranged background
        local bgMelee = bgAttrs.MeleeSkill[0], bgRanged = bgAttrs.RangedSkill[0];
        if (bgRanged > 0 && bgRanged - bgMelee >= 10) set["type.ranged"] <- true;
        else set["type.melee"] <- true;

        // elite or cheap
        if (bro.getBackground().m.DailyCost >= 20) set["cost.high"] <- true;
        if (bro.getBackground().m.DailyCost <= 10) set["cost.low"] <- true;

        local weapon = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (weapon != null && "MSU" in getroottable())
            foreach (name, val in ::Const.Items.WeaponType)
                if (weapon.isWeaponType(val))
                    set["weapon." + name] <- true;
        return set;
    }
    def.factorWeight <- function(f) {
        local dot = f.find(".");
        local prefix = dot != null ? f.slice(0, dot) : f;
        return W[prefix];
    }

    // Weighted random pick from array of {title, weight} items
    local function weightedRandPick(items) {
        local totalWeight = 0;
        foreach (c in items) totalWeight += c.weight;
        local roll = ::std.Rand.float(0, totalWeight);
        foreach (c in items) {
            roll -= c.weight;
            if (roll <= 0) return c;
        }
        return items[items.len() - 1];
    }

    // Check if title is used by any fallen bro
    // TODO: not really efficient, does not cover fired guys, may simply remember in World.Flags
    //       when a bro joins, then we won't even need to track death, kick, leave
    local function isTitleUsedByFallen(title, fallenNames) {
        foreach (name in fallenNames)
            if (name.find(title) != null) return true;
        return false;
    }

    // Build candidates list for a bro: [{title, weight}, ...]
    def.buildCandidates <- function(bro) {
        local candidates = [];
        local factorSet = def.buildFactorSet(bro);
        std.Debug.log("factors for " + bro.getName(), factorSet);

        // 1. Titles from def.Titles; weight = sum of matched factor-set weights
        foreach (entry in def.Titles) {
            local w = 0.0;
            foreach (fset in entry.factors) {
                local ok = true;
                foreach (f in fset) if (!(f in factorSet)) { ok = false; break; }
                if (!ok) continue;
                local fw = 1.0;
                foreach (f in fset) fw *= def.factorWeight(f);
                w += fw;
            }
            if (w > 0)
                candidates.push({title = entry.en, weight = w});
        }

        // 2. Vanilla trait .m.Titles
        foreach (skill in bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)) {
            if (skill.getID().find("trait.") != 0) continue;
            # NOTE: using .b insead of .m - an MSU bug
            if (!("Titles" in skill.b)) continue;
            foreach (t in skill.b.Titles)
                candidates.push({title = t, weight = W.trait / skill.b.Titles.len()});
        }

        // 3. Vanilla background .m.Titles
        local bgTitles = bro.getBackground().m.Titles;
        foreach (t in bgTitles)
            candidates.push({title = t, weight = W.background / bgTitles.len()});

        return candidates;
    }

    mod.hook("scripts/entity/tactical/player", function (q) {
        q.setStartValuesEx = @(__original) function (_backgrounds, _addTraits = true) {
            __original(_backgrounds, _addTraits);

            // if (this.getTitle() != "") return; // already has a title

            // 1. Build used titles set
            local usedTitles = {};
            foreach (bro in ::World.getPlayerRoster().getAll()) {
                if (bro.getID() == this.getID()) continue;
                local t = bro.getTitle();
                if (t != "") usedTitles[t] <- true;
            }
            local fallenNames = [];
            foreach (fallen in ::World.Statistics.getFallen())
                fallenNames.push(fallen.Name);

            // 2. Collect candidates
            local candidates = def.buildCandidates(this);
            if (candidates.len() == 0) return; // shouldn't happen

            // 3. Filter out used titles
            local filtered = candidates.filter(@(_, c)
                !(c.title in usedTitles) && !isTitleUsedByFallen(c.title, fallenNames)
            );
            if (filtered.len() == 0) filtered = candidates; // allow reuse if all taken

            std.Debug.log("cands for " + this.getName(), candidates)

            // 4. Weighted random pick
            this.setTitle(weightedRandPick(filtered).title);
        }
    });
});
