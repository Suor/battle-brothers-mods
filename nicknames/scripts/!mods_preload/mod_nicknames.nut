local def = ::Nicknames <- {
    ID = "mod_nicknames"
    Name = "Nicknames for Everyone"
    Version = "0.1"

    Debug = true
    FlagPrefix = "nicknames."
    Logs = {factors = {idx = null, items = []}, candidates = {idx = null, items = []}}
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.conflictWith("mod_renamer");

def.PauperBackgrounds <- {
    "background.beggar": true
    "background.cripple": true
    "background.ratcatcher": true
    "background.refugee": true
    "background.vagabond": true
    "background.hackflows_leper": true
    "background.hackflows_drifter": true
};

// Base attribute ranges before background modifiers
def.BaseAttrRanges <- {
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
    foreach (skill in _bro.getSkills().query(::Const.SkillType.All)) {
        local id = skill.getID();
        if (id.find("trait.") == 0) set[id] <- true;
        else if (id.find("perk.mastery.") == 0) {
            local name = id.slice("perk.mastery.".len());
            set["weapon." + name] <- true;
        } else if (id.find("perk.") == 0) {
            set[id] <- true;
        }
    }

    // attrs
    local changeAttrs = _bro.getBackground().onChangeAttributes();
    local props = _bro.getCurrentProperties();
    foreach (attr, br in def.BaseAttrRanges) {
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
    local bg = _bro.getBackground();
    if (bg.m.DailyCost >= 20) set["cost.high"] <- true;
    if (bg.m.DailyCost <= 10) set["cost.low"] <- true;

    // group.* - groups of background
    if (bg.m.IsOffendedByViolence) set["group.peaceful"] <- true;
    if (bg.m.IsCombatBackground) set["group.combat"] <- true;
    if (bg.m.IsNoble) set["group.noble"] <- true;
    if (bg.m.IsLowborn) set["group.lowborn"] <- true;
    if (bg.getID() in def.PauperBackgrounds) set["group.pauper"] <- true;

    local weapon = _bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    if (weapon != null && "MSU" in getroottable())
        foreach (name, val in ::Const.Items.WeaponType)
            if (weapon.isWeaponType(val))
                set["weapon." + name.tolower()] <- true;

    // add aliases
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
    def.log("factors", "factors for " + _bro.getName(), factorSet);

    // 1. Titles from def.Titles; weight = sum of matched factor-set weights
    foreach (entry in def.Titles) {
        local w = 0.0;
        foreach (fset in entry.factors) {
            local fw = 1.0;
            foreach (f in fset) {
                if (!(f in factorSet)) { fw = 0.0; break; }
                fw *= def.factorWeight(f)
            }
            w += fw;
        }
        if (w > 0)
            candidates.push({title = entry.en, weight = w});
    }

    // 2. Vanilla trait .m.Titles
    foreach (skill in _bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)) {
        if (skill.getID().find("trait.") != 0) continue;
        // TODO: remove the 0.8 factor once we have more our titles
        foreach (t in skill.m.Titles)
            candidates.push({title = t, weight = def.Weights.trait * 0.8});
    }

    // 3. Vanilla background .m.Titles
    local bgTitles = _bro.getBackground().m.Titles;
    foreach (t in bgTitles)
        candidates.push({title = t, weight = def.Weights.background * 0.8});

    return candidates;
}

def.fillTitle <- function (_bro) {
    // 1. Collect candidates
    local candidates = def.buildCandidates(_bro);
    if (candidates.len() == 0) return; // shouldn't happen

    def.log("candidates", "full candidates for " + _bro.getName(), candidates)

    // 2. Build used titles set
    local inUse = {};
    foreach (bro in ::World.getPlayerRoster().getAll()) {
        inUse[bro.m.Title] <- true;
        inUse[bro.getTitle()] <- true; // Rosetta translated
    }
    local fallenNames = [];
    foreach (fallen in ::World.Statistics.getFallen())
        fallenNames.push(fallen.Name);

    // 3. Filter out used titles
    local filtered = candidates.filter(@(_, c)
        !(c.title in inUse) && !isTitleUsedByFallen(c.title, fallenNames)
    );
    if (filtered.len() == 0) filtered = candidates; // allow reuse if all taken

    // 4. Weighted random pick
    _bro.setTitle(weightedRandPick(filtered).title);
}

def.log <- function (_key, _label, _value) {
    if (!def.Debug) return;
    ::std.Debug.log(_label, _value);

    local rec = def.Logs[_key];
    if (rec.idx == null) rec.idx = ::World.Flags.getAsInt(def.FlagPrefix + _key)

    rec.idx++;
    rec.items.push({idx = rec.idx, label = _label, value = _value})
    ::std.Flags.pack(::World.Flags, def.FlagPrefix + _key + "." + (rec.idx - 1) / 100, rec.items)
    ::World.Flags.set(def.FlagPrefix + _key, rec.idx)
    if (rec.items.len() >= 100) rec.items = [];
}
def.logOut <- function () {
    foreach (key, _ in def.Logs) {
        for (local batchIdx = 0;; batchIdx++) {
            local batch = ::std.Flags.unpack(::World.Flags, def.FlagPrefix + key + "." + batchIdx);
            if (batch == null) break;

            foreach (item in batch) ::std.Debug.log("OUT: " + item.label, item.value)
            ::World.Flags.remove(def.FlagPrefix + key + "." + batchIdx);
        }
        // Start from scratch
        ::World.Flags.remove(def.FlagPrefix + _key)
        def.Logs[key] = {idx = null, items = []};
    }
}


// Hooks
local starting = false;

mod.queue(">mod_bro_studio", ">mod_background_perks", ">mod_elite_few", ">mod_ultrabros", function () {
    ::include("nicknames/titles");
    ::include("nicknames/rosetta_auto");

    // Need to handle that separately to not overwrite the scenario based title
    mod.hook("scripts/states/world_state", function (q) {
        q.startNewCampaign = @(__original) function () {
            starting = true;
            __original();
            starting = false;
            local roster = World.getPlayerRoster().getAll();
            foreach (bro in roster)
                if (bro.getTitle() == "") def.fillTitle(bro);
        }
    });
})

// Need to move it to "very late" because mod_background_perks hooks very late
mod.queue(">mod_bro_studio", ">mod_background_perks", ">mod_elite_few", ">mod_ultrabros", function () {
    mod.hook("scripts/entity/tactical/player", function (q) {
        q.setStartValuesEx = @(__original) function (_backgrounds, _addTraits = true) {
            __original(_backgrounds, _addTraits);
            // Overwriting title set by setStartValuesEx() for better distribution
            if (!starting) def.fillTitle(this);
        }
    });
}, ::Hooks.QueueBucket.VeryLate);
