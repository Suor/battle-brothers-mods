// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// The title pool against vanilla content: factor IDs exist, factor sets can happen.
// Factors of other mods (Legends, XBE, Black Pyramid, ...) are skipped: they aren't loaded here.

local function titleName(_entry) {
    return "en" in _entry ? _entry.en : _entry.names[0].en;
}

local function loadAll(_dir) {
    local out = {};
    foreach (f in ::IO.enumerateFiles(_dir)) {
        try { local s = ::new(f); out[s.getID()] <- s; } catch (e) {}
    }
    return out;
}

local function vanillaFactors() {
    local known = {};
    foreach (dir in ["scripts/skills/backgrounds", "scripts/skills/traits",
            "scripts/skills/injury_permanent", "scripts/skills/perks"])
        foreach (id, _ in loadAll(dir)) known[id] <- true;
    foreach (attr, _ in ::Nicknames.BaseAttrRanges) {
        known["attr." + attr + ".high"] <- true;
        known["attr." + attr + ".low"] <- true;
    }
    foreach (name, _ in ::Const.Items.WeaponType) known["weapon." + name.tolower()] <- true;
    foreach (f in ["type.melee", "type.ranged", "cost.high", "cost.low", "group.peaceful",
            "group.combat", "group.noble", "group.lowborn", "group.pauper"]) known[f] <- true;
    return known;
}

// IDs of mods the title pool supports on purpose, by their prefixes or exact IDs.
local OtherMods = ["trait.legend_", "background.hackflows_", "perk.hackflows.", "perk.necro.",
    "trait.elem_", "perk.elem_", "background.bladedancer", "background.aspirant", "background.shaman",
    "background.necro", "background.oathbreaker", "trait.chosen", "trait.feral"];

local function isOtherMod(_f) {
    foreach (p in OtherMods) if (_f.find(p) == 0) return true;
    return false;
}

test("every factor is a vanilla ID or a known other mod's", function (t) {
    ::NickT.resetState();
    local known = vanillaFactors();
    local unknown = {};
    foreach (e in ::Nicknames.Titles) foreach (fs in e.factors) foreach (f in fs)
        if (!(f in known) && !(f in ::Nicknames.Aliases) && !isOtherMod(f)) unknown[f] <- titleName(e);
    t.eq(unknown, {});
});

// N3, not a bug: a factor set vanilla can't produce may be there for other mods, so these are
// reports, as calc_prob.py's "-" is. setStartValuesEx() adds a trait only if no skill already
// there (background first) excludes it.
test("N3 report: factor sets vanilla can't produce", function (t) {
    ::NickT.resetState();
    local bgs = loadAll("scripts/skills/backgrounds"), traits = loadAll("scripts/skills/traits");
    local bad = [];
    foreach (e in ::Nicknames.Titles) foreach (fs in e.factors) {
        if (fs.filter(@(_, f) isOtherMod(f)).len() > 0) continue;
        foreach (a in fs) {
            if (a in bgs) foreach (b in fs)
                if (b in traits && bgs[a].isExcluded(b)) bad.push(titleName(e) + ": " + a + " excludes " + b);
            if (a in traits) foreach (b in fs)
                if (a < b && b in traits && traits[a].isExcluded(b) && traits[b].isExcluded(a))
                    bad.push(titleName(e) + ": " + a + " and " + b + " exclude each other");
        }
    }
    t.probe("count", bad.len());
    t.probe("sets", bad);
});

// Same, for the static background factors: cost, group and type follow from the background.
test("N3 report: background-bound factors the background never has", function (t) {
    ::NickT.resetState();
    local bgs = loadAll("scripts/skills/backgrounds");
    local bad = [];
    foreach (e in ::Nicknames.Titles) foreach (fs in e.factors) foreach (b in fs) {
        if (!(b in bgs)) continue;
        local bg = bgs[b];
        local c = bg.onChangeAttributes();
        local own = {};
        if (c.RangedSkill[0] > 0 && c.RangedSkill[0] - c.MeleeSkill[0] >= 10) own["type.ranged"] <- true;
        else own["type.melee"] <- true;
        if (bg.m.DailyCost >= 20) own["cost.high"] <- true;
        if (bg.m.DailyCost <= 10) own["cost.low"] <- true;
        if (bg.m.IsOffendedByViolence) own["group.peaceful"] <- true;
        if (bg.m.IsCombatBackground) own["group.combat"] <- true;
        if (bg.m.IsNoble) own["group.noble"] <- true;
        if (bg.m.IsLowborn) own["group.lowborn"] <- true;
        if (b in ::Nicknames.PauperBackgrounds) own["group.pauper"] <- true;
        foreach (f in fs) {
            local pre = f.slice(0, f.find("."));
            if ((pre == "type" || pre == "cost" || pre == "group") && !(f in own))
                bad.push(titleName(e) + ": " + b + " never has " + f);
        }
    }
    t.probe("sets", bad);
});

// A trait shifting an attribute by more than its roll range makes attr.<it>.low (or .high)
// unreachable together with it: the kind of set 0.8.0 fixed (tough + Hitpoints.low).
test("N3 report: trait + attribute sets the trait makes unreachable", function (t) {
    ::NickT.resetState();
    local traits = loadAll("scripts/skills/traits");
    local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["farmhand_background"], false);
    foreach (slot in ["Mainhand", "Offhand", "Head", "Body", "Accessory"]) {
        local item = bro.getItems().getItemAtSlot(::Const.ItemSlot[slot]);
        if (item != null) bro.getItems().unequip(item);
    }
    bro.getSkills().update();
    local bare = clone bro.getCurrentProperties();
    local bad = [];
    foreach (e in ::Nicknames.Titles) foreach (fs in e.factors) foreach (tr in fs) {
        if (!(tr in traits)) continue;
        local trait = ::new(::IO.scriptFilenameByHash(traits[tr].ClassNameHash));
        bro.getSkills().add(trait);
        bro.getSkills().update();
        local props = bro.getCurrentProperties();
        foreach (f in fs) {
            if (f.find("attr.") != 0) continue;
            local parts = ::std.Str.split(".", f);
            local d = props[parts[1]] - bare[parts[1]];
            // The roll is low..low+10, 3 talent stars lower the high bar by 2.
            if (parts[2] == "low" && d > 0 || parts[2] == "high" && d < -2)
                bad.push(titleName(e) + ": " + tr + " moves " + parts[1] + " by " + d);
        }
        bro.getSkills().remove(trait);
        bro.getSkills().update();
    }
    ::World.getTemporaryRoster().clear();
    t.probe("sets", bad);
});
