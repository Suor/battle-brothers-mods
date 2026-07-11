local def = ::Nicknames <- {
    ID = "mod_nicknames"
    Name = "Nicknames for Everyone"
    Version = "0.7.1"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/1013"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/nicknames"
        tagPrefix = "nicknames-"
    }

    Debug = false
    FlagPrefix = "nicknames."
    FlagState = "nicknames.state"
    HireWindow = 14
    State = null  // {generated = {title: {days = [...]}}, hired = {title: count}}
    Logs = {factors = {idx = null, items = []}, candidates = {idx = null, items = []}}
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("stdlib >= 2.5");
mod.conflictWith("mod_renamer");
mod.queue(">mod_msu", function () {
    if (!::Hooks.hasMod("mod_msu")) return;

    def.msu <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);
    local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
    def.msu.Registry.addModSource(msd.NexusMods, upd.nexus);
    if ("GitHubTags" in msd) {
        def.msu.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
        def.msu.Registry.setUpdateSource(msd.GitHubTags);
    }
});

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
    local bg = _bro.getBackground();

    // background, traits, perks and permanent injuries
    set[bg.getID()] <- true;
    foreach (skill in _bro.getSkills().query(::Const.SkillType.All)) {
        local id = skill.getID();
        if (id.find("perk.mastery.") == 0) {
            set["weapon." + id.slice("perk.mastery.".len())] <- true;
        } else if (id.find("trait.") == 0 || id.find("perk.") == 0 || id.find("injury.") == 0) {
            set[id] <- true;
        }
    }

    // attrs
    local changeAttrs = bg.onChangeAttributes();
    local props = _bro.getCurrentProperties();
    local talents = _bro.m.Talents; // may be empty for event bros (setStartValuesEx with _addTraits=false)
    foreach (attr, br in def.BaseAttrRanges) {
        local low = br[0] + changeAttrs[attr][0], high =  br[1] + changeAttrs[attr][1];
        local idx = ::Const.Attributes[attr == "Stamina" ? "Fatigue" : attr];
        local stars = idx < talents.len() ? talents[idx] : 0;
        if (stars > 0 && props[attr] >= high - stars + 1)
            set["attr." + attr + ".high"] <- true;
        if (stars == 0 && props[attr] <= low)
            set["attr." + attr + ".low"] <- true;
    }

    // type: melee or ranged background
    local bgMelee = changeAttrs.MeleeSkill[0], bgRanged = changeAttrs.RangedSkill[0];
    if (bgRanged > 0 && bgRanged - bgMelee >= 10) set["type.ranged"] <- true;
    else set["type.melee"] <- true;

    // elite or cheap
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

// State: {generated = {title: {days = [...]}}, hired = {title: count}}
// generated: titles given to generated bros, day-tagged, trimmed to def.HireWindow.
// hired: titles of bros that joined the roster (via onHired); never trimmed —
// used to compute fallen = hired - currentRoster.
def.loadState <- function () {
    if (def.State != null) return def.State;
    local s = ::std.Flags.unpack(::World.Flags, def.FlagState);
    def.State = s != null ? s : {generated = {}, hired = {}};
    if (s != null) ::std.Flags.pack(::World.Flags, def.FlagState, s); // unpack removed key, restore
    return def.State;
}

def.saveState <- function () {
    ::std.Flags.pack(::World.Flags, def.FlagState, def.State);
}

// Append today to generated[title].days, drop entries past def.HireWindow, persist.
def.recordGenerated <- function (_title, _today) {
    local generated = def.loadState().generated;
    if (!(_title in generated)) generated[_title] <- {days = []};
    generated[_title].days.push(_today);
    local cutoff = _today - def.HireWindow;
    foreach (t, rec in clone generated) {
        rec.days = rec.days.filter(@(_, d) d > cutoff);
        if (rec.days.len() == 0) delete generated[t];
    }
    def.saveState();
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
        if (w > 0) {
            if ("names" in entry)
                foreach (name in entry.names) candidates.push({title = name.en, weight = w});
            else
                candidates.push({title = entry.en, weight = w});
        }
    }

    // 2. Vanilla trait .m.Titles
    foreach (skill in _bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)) {
        if (skill.getID().find("trait.") != 0) continue;
        if (!::std.Util.isIn("Titles", skill.m)) continue;
        // TODO: remove the 0.8 factor once we have more our titles
        foreach (t in skill.m.Titles)
            candidates.push({title = t, weight = def.Weights.trait * 0.8});
    }

    // 3. Vanilla background .m.Titles
    local bg = _bro.getBackground();
    if (::std.Util.isIn("Titles", bg.m))
        foreach (t in bg.m.Titles)
            candidates.push({title = t, weight = def.Weights.background * 0.8});

    return candidates;
}

def.fillTitle <- function (_bro) {
    // 1. Collect candidates
    local candidates = def.buildCandidates(_bro);
    if (candidates.len() == 0) return; // shouldn't happen

    def.log("candidates", "full candidates for " + _bro.getName(), candidates)

    // 2. Build blocked sets: bros, set14/set7 (from generated), fallen (hired - bros)
    local bros = {};
    foreach (b in ::World.getPlayerRoster().getAll()) {
        bros[b.m.Title] <- true;
        bros[b.getTitle()] <- true; // Rosetta translated
    }
    local state = def.loadState();
    local today = ::World.getTime().Days;
    local set14 = {}, set7 = {};
    foreach (title, rec in state.generated)
        foreach (d in rec.days) {
            if (d > today - 14) set14[title] <- true;
            if (d > today - 7)  set7[title]  <- true;
        }
    local fallen = {};
    foreach (title, _ in state.hired)
        if (!(title in bros)) fallen[title] <- true;

    // 3. Cascade: pick from strictest block first, fall back when filter is empty
    local function merged(_sets) {
        local out = {};
        foreach (s in _sets) foreach (k, _ in s) out[k] <- true;
        return out;
    }
    local levels = [
        merged([set14, bros, fallen]),
        merged([set7,  bros, fallen]),
        merged([bros, fallen]),
        bros,
        {}
    ];
    local filtered;
    foreach (block in levels) {
        filtered = candidates.filter(@(_, c) !(c.title in block));
        if (filtered.len() > 0) {break;}
    }

    // 4. Apply and record
    local title = weightedRandPick(filtered).title;
    _bro.setTitle(title);
    def.recordGenerated(title, today);
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
        // Overwriting title set by setStartValuesEx() for better distribution
        if (::Hooks.hasMod("mod_legends")) {
            q.setStartValuesEx = @(__original)
                function (_backgrounds, _addTraits = true, _gender = -1, _addEquipment = true)
            {
                __original(_backgrounds, _addTraits, _gender, _addEquipment);
                if (!starting) def.fillTitle(this);
            }
        } else {
            q.setStartValuesEx = @(__original) function (_backgrounds, _addTraits = true) {
                __original(_backgrounds, _addTraits);
                if (!starting) def.fillTitle(this);
            }
        }

        q.onHired = @(__original) function () {
            __original();
            local title = this.getTitle();
            if (title == null || title == "") return;
            local state = def.loadState();
            state.hired[title] <- (title in state.hired ? state.hired[title] : 0) + 1;
            def.saveState();
        }
    });
}, ::Hooks.QueueBucket.VeryLate);
