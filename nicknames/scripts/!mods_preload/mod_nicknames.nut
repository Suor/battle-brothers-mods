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

def.buildFactorSet <- function(_bro) {
    local set = {};

    // background, traits and perks
    set[_bro.getBackground().getID()] <- true;
    foreach (skill in _bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait))
        if (skill.getID().find("trait.") == 0) set[skill.getID()] <- true;
    foreach (skill in _bro.getSkills().getAllSkillsOfType(::Const.SkillType.Perk))
        if (skill.getID().find("perk.") == 0) set[skill.getID()] <- true;

    // attrs
    local changeAttrs = _bro.getBackground().onChangeAttributes();
    local props = _bro.getCurrentProperties();
    foreach (attr, br in BaseAttrRanges) {
        local low = br[0] + changeAttrs[attr][0], high =  br[1] + changeAttrs[attr][1];
        local stars = _bro.m.Talents[::Const.Attributes[attr == "Stamina" ? "Fatigue" : attr]];
        if (stars > 0 && props[attr] >= high - stars)
            set["attr." + attr + ".high"] <- true;
        if (stars == 0 && props[attr] <= low)
            set["attr." + attr + ".low"] <- true;
    }

    // type: melee or ranged background
    local bgMelee = changeAttrs.MeleeSkill[0], bgRanged = changeAttrs.RangedSkill[0];
    if (bgRanged > 0 && bgRanged - bgMelee >= 10) set["type.ranged"] <- true;
    else set["type.melee"] <- true;

    // elite or cheap
    if (_bro.getBackground().m.DailyCost >= 20) set["cost.high"] <- true;
    if (_bro.getBackground().m.DailyCost <= 10) set["cost.low"] <- true;

    local weapon = _bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    if (weapon != null && "MSU" in getroottable())
        foreach (name, val in ::Const.Items.WeaponType)
            if (weapon.isWeaponType(val))
                set["weapon." + name] <- true;

    local extra = {};
    foreach (factor, _ in set)
        if (factor in def.Aliases) extra[def.Aliases[factor]] <- true;
    foreach (canonical, _ in extra) set[canonical] <- true;
    return set;
}

def.factorWeight <- function (_f) {
    local dot = _f.find(".");
    local prefix = dot != null ? _f.slice(0, dot) : _f;
    return def.Weights[prefix];
}

// Weighted random pick from array of {title, weight} items
local function weightedRandPick(_items) {
    local totalWeight = 0;
    foreach (c in _items) totalWeight += c.weight;
    local roll = ::std.Rand.float(0, totalWeight);
    foreach (c in _items) {
        roll -= c.weight;
        if (roll <= 0) return c;
    }
    return _items.top();
}

// Check if title is used by any fallen bro
// TODO: not really efficient, does not cover fired guys, may simply remember in World.Flags
//       when a bro joins, then we won't even need to track death, kick, leave
local function isTitleUsedByFallen(_title, _fallenNames) {
    foreach (name in _fallenNames)
        if (name.find(_title) != null) return true;
    return false;
}

// Build candidates list for a bro: [{title, weight}, ...]
def.buildCandidates <- function (_bro) {
    local candidates = [];
    local factorSet = def.buildFactorSet(_bro);
    std.Debug.log("factors for " + _bro.getName(), factorSet);

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
    foreach (skill in _bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)) {
        if (skill.getID().find("trait.") != 0) continue;
        // NOTE: using .b insead of .m - an MSU bug
        // logInfo("Trait " + skill.getID())
        // std.Debug.log("m.Titles", "Titles" in skill.m ? skill.m.Titles : null)
        // std.Debug.log("b.Titles", "Titles" in skill.b ? skill.b.Titles : null)
        local titles = "b" in skill && "Titles" in skill.b ? skill.b.Titles :
                                       "Titles" in skill.m ? skill.m.Titles : null;
        if (!titles) continue;
        // TODO: remove the 0.5 factor once we have more our titles
        foreach (t in titles)
            candidates.push({title = t, weight = def.Weights.trait * 0.5});
    }

    // 3. Vanilla background .m.Titles
    local bgTitles = _bro.getBackground().m.Titles;
    foreach (t in bgTitles)
        candidates.push({title = t, weight = def.Weights.background * 0.5});

    return candidates;
}

def.fillTitle <- function (_bro) {
    // 1. Collect candidates
    local candidates = def.buildCandidates(_bro);
    if (candidates.len() == 0) return; // shouldn't happen

    // 2. Build used titles set
    local usedTitles = {};
    foreach (bro in ::World.getPlayerRoster().getAll()) {
        if (bro.getID() == _bro.getID()) continue;
        local t = bro.getTitle();
        if (t != "") usedTitles[t] <- true;
    }
    local fallenNames = [];
    foreach (fallen in ::World.Statistics.getFallen())
        fallenNames.push(fallen.Name);

    // 3. Filter out used titles
    local filtered = candidates.filter(@(_, c)
        !(c.title in usedTitles) && !isTitleUsedByFallen(c.title, fallenNames)
    );
    if (filtered.len() == 0) filtered = candidates; // allow reuse if all taken

    std.Debug.log("cands for " + _bro.getName(), candidates)

    // 4. Weighted random pick
    _bro.setTitle(weightedRandPick(filtered).title);
}


mod.queue(">mod_bro_studio", ">mod_background_perks", ">mod_elite_few", ">mod_ultrabros", function () {
    ::include("nicknames/titles");
    ::include("nicknames/rosetta_auto");

    mod.hook("scripts/entity/tactical/player", function (q) {
        // TODO: for starting guys talents and traits might be rewritten after setStartValuesEx()
        //       should only set a title in onSpawnAssets like mod_bro_studio does
        //       also might have titles assigned in scenario, should not overwrite those
        q.setStartValuesEx = @(__original) function (_backgrounds, _addTraits = true) {
            __original(_backgrounds, _addTraits);

            // if (this.getTitle() != "") return; // already has a title

            def.fillTitle(this);
        }
    });
    // Need to move it to "very late" because mod_background_perks hooks very late
}, ::Hooks.QueueBucket.VeryLate);
