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
    ::include("nicknames/nicknames");

    // FIX: this requires MSU, gate it properly, and don't need this alias
    local WeaponTypeConst = ::Const.Items.WeaponType;
    local W = def.Weights;

    // Collect weapon factor names used in def.Nicknames to know what to check
    // FIX: don't need this, can cycle through the enum
    local weaponFactors = {};
    foreach (entry in def.Nicknames)
        foreach (f in entry.factors)
            if (f.find("weapon.") == 0) weaponFactors[f] <- true;

    local function buildFactorSet(bro) {
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

        // elite or cheap
        if (bro.getBackground().m.DailyCost >= 20) set["cost.high"] <- true;
        if (bro.getBackground().m.DailyCost <= 10) set["cost.low"] <- true;

        local weapon = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (weapon != null)
            foreach (f, _ in weaponFactors)
                if (weapon.isWeaponType(WeaponTypeConst[f.slice("weapon.".len())]))
                    set[f] <- true;
        return set;
    }
    local function factorWeight(f) {
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

            // 2. Collect candidates with weights
            local candidates = [];
            local factorSet = buildFactorSet(this);
            // std.Debug.log("factors for " + this.getName(), factorSet);

            // 2a. Custom nicknames from def.Nicknames; weight = product of per-factor weights
            foreach (entry in def.Nicknames) {
                local ok = true;
                foreach (f in entry.factors) if (!(f in factorSet)) { ok = false; break; }
                if (!ok) continue;
                local weight = 1.0 / entry.nicknames.len();
                // if (entry.factors.len() == 1 && entry.factors[0].find("background.") == 0)
                //     weight *= 0.5;
                foreach (f in entry.factors) weight *= factorWeight(f);
                foreach (n in entry.nicknames)
                    candidates.push({title = n, weight = weight});
            }

            // 2b. Vanilla trait .m.Titles
            foreach (skill in this.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)) {
                if (skill.getID().find("trait.") != 0) continue;
                # NOTE: using .b insead of .m - an MSU bug
                if (!("Titles" in skill.b)) continue;
                foreach (t in skill.b.Titles)
                    candidates.push({title = t, weight = W.trait / skill.b.Titles.len()});
            }

            // 2c. Vanilla background .m.Titles
            local bgTitles = this.getBackground().m.Titles;
            foreach (t in bgTitles)
                candidates.push({title = t, weight = W.background / bgTitles.len()});

            if (candidates.len() == 0) return; // shouldn't happen

            // 3. Filter out used titles
            local filtered = candidates.filter(@(_, c)
                !(c.title in usedTitles) && !isTitleUsedByFallen(c.title, fallenNames)
            );
            if (filtered.len() == 0) filtered = candidates; // allow reuse if all taken

            // std.Debug.log("cands for " + this.getName(), candidates)

            // 4. Weighted random pick
            this.setTitle(weightedRandPick(filtered).title);
        }
    });
});
