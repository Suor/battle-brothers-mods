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
    ::include("nicknames/rosetta_ru");

    # FIX: calc ranges for all attrs first
    def.isAttrHigh <- function(bro, attrName) {
        local br = BaseAttrRanges[attrName];
        local c = bro.getBackground().onChangeAttributes();
        return bro.getBaseProperties()[attrName] >= br[1] + c[attrName][1];
    };
    def.isAttrLow <- function(bro, attrName) {
        local br = BaseAttrRanges[attrName];
        local c = bro.getBackground().onChangeAttributes();
        return bro.getBaseProperties()[attrName] <= br[0] + c[attrName][0];
    };
    ::include("nicknames/nicknames");

    local WeaponTypeConst = ::Const.Items.WeaponType;
    local W = def.Weights;

    local function checkFactor(bro, f) {
        if (f.find("trait.") == 0 || f.find("background.") == 0)
            return bro.getSkills().hasSkill(f);
        if (f.find("cost.") == 0)
            return bro.getBackground().m.DailyCost >= f.slice("cost.".len()).tointeger();
        if (f.find("weapon.") == 0) {
            local weapon = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
            return weapon != null && weapon.isWeaponType(WeaponTypeConst[f.slice("weapon.".len())]);
        }
        if (f.find("talent.") == 0) {
            local idx = f.slice("talent.".len()).tointeger();
            return bro.m.Talents[idx] == 3;
        }
        // attr condition: "AttrName.high" or "AttrName.low"
        local dotPos = f.find(".");
        if (dotPos != null) {
            local dir = f.slice(dotPos + 1);
            if (dir == "high") return def.isAttrHigh(bro, f.slice(0, dotPos));
            if (dir == "low")  return def.isAttrLow(bro, f.slice(0, dotPos));
        }
        return false;
    }
    local function factorWeight(f) {
        if (f.find("trait.") == 0)      return W.Trait;
        if (f.find("background.") == 0) return W.Background;
        if (f.find("cost.") == 0)       return W.Background;
        if (f.find("weapon.") == 0)     return W.Weapon;
        if (f.find("talent.") == 0)     return W.Talent;
        return W.Attr;
    }

    // Weighted random pick from array of {title, weight} items
    local function weightedRandPick(items) {
        local totalWeight = 0;
        foreach (c in items) totalWeight += c.weight;
        local roll = ::Math.rand(1, totalWeight);
        local cumulative = 0;
        foreach (c in items) {
            cumulative += c.weight;
            if (roll <= cumulative) return c;
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

    mod.hook("scripts/entity/tactical/player", function (q) {
        q.setStartValuesEx = @(__original) function (_backgrounds, _addTraits = true) {
            __original(_backgrounds, _addTraits);

            if (this.getTitle() != "") return; // already has a title

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

            // 2. Collect candidates with weights
            local candidates = [];

            // 2a. Custom nicknames from def.Nicknames; weight = product of per-factor weights
            foreach (entry in def.Nicknames) {
                local ok = true;
                foreach (f in entry.factors) if (!checkFactor(this, f)) { ok = false; break; }
                if (!ok) continue;
                local weight = 1;
                foreach (f in entry.factors) weight *= factorWeight(f);
                foreach (n in entry.nicknames)
                    candidates.push({title = n, weight = weight});
            }

            // 2b. Vanilla trait .m.Titles
            foreach (skill in this.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)) {
                if (!("Titles" in skill.b)) {
                    std.debug(skill)
                    continue;
                }
                # NOTE: using .b insead of .m - an MSU bug
                foreach (t in skill.b.Titles)
                    candidates.push({title = t, weight = W.Trait});
            }

            // 2c. Vanilla background .m.Titles
            foreach (t in this.getBackground().m.Titles)
                candidates.push({title = t, weight = W.Background});

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
