// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_reforged==0.9.3 mod_backgrounds_and_events==0.8 mod_backgrounds_and_events_reforged_patch==0.7.2 mod_bro_studio mod_nicknames@dev mod_msu stdlib@dev
// allow-errors: stdlib \(stdlib\) version 2\.6 is outdated for mod_bro_studio
// allow-errors: Errors occured when validating mod compatibility, the game was therefore not loaded correctly
// include: ../lib/helpers.nut

// N3 under Reforged + XBE + Bro Studio (+1 trait, permanent injuries): which title factor sets
// generation can't produce. Not part of the suite.
// Run: cd ~/projects/bbm/bbtales && ./bbtales.py -vv ../mods/nicknames/tales/probes/n3_combo.nut

local function titleName(_e) { return "en" in _e ? _e.en : _e.names[0].en; }
local function loadAll(_dir) {
    local out = {};
    foreach (f in ::IO.enumerateFiles(_dir)) {
        try { local s = ::new(f); out[s.getID()] <- s; } catch (e) {}
    }
    return out;
}
local function pre(_f) { return _f.slice(0, _f.find(".")); }

test("N3 combo probe: Bro Studio's extra trait and injury reach the factors", function (t) {
    ::NickT.resetState();
    local seen = 0, n = 30;
    local setting = @(_name) ::BroStudio.Mod.ModSettings.getSetting(_name);
    ::Tales.with(setting, {traitsNum = 1, permChance = 100}, function () {
        for (local i = 0; i < n; i++) {
            local bro = ::NickT.recruit(["sellsword_background"]);
            local fs = ::Nicknames.buildFactorSet(bro), ok = true;
            foreach (s in bro.getSkills().query(::Const.SkillType.Trait | ::Const.SkillType.PermanentInjury))
                if (s.getID().find("trait.") == 0 || s.getID().find("injury.") == 0)
                    if (!(s.getID() in fs)) ok = false;
            if (ok && bro.getSkills().query(::Const.SkillType.PermanentInjury).len() > 0) seen++;
        }
    }, true);
    t.eq(seen, n);
});

test("N3 combo probe: unreachable sets", function (t) {
    ::NickT.resetState();
    local bgs = loadAll("scripts/skills/backgrounds"), traits = loadAll("scripts/skills/traits");
    local injuries = loadAll("scripts/skills/injury_permanent");
    local perks = loadAll("scripts/skills/perks");
    local rollable = {};
    foreach (tr in ::Const.CharacterTraits) rollable[tr[0]] <- true;

    // Trait effects on attributes, against a bare farmhand.
    local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["farmhand_background"], false);
    foreach (s in bro.getSkills().query(::Const.SkillType.Trait | ::Const.SkillType.PermanentInjury))
        bro.getSkills().remove(s);
    foreach (slot in ["Mainhand", "Offhand", "Head", "Body", "Accessory"]) {
        local item = bro.getItems().getItemAtSlot(::Const.ItemSlot[slot]);
        if (item != null) bro.getItems().unequip(item);
    }
    bro.getSkills().update();
    local bare = clone bro.getCurrentProperties();
    local shift = {};
    local attrs = ["Hitpoints", "Bravery", "Stamina", "MeleeSkill", "RangedSkill", "MeleeDefense",
        "RangedDefense", "Initiative"];
    local function measure(_id, _script) {
        local s = ::new(_script);
        bro.getSkills().add(s);
        bro.getSkills().update();
        local p = bro.getCurrentProperties(), d = {};
        foreach (a in attrs) d[a] <- p[a] - bare[a];
        shift[_id] <- d;
        bro.getSkills().removeByID(_id);
        bro.getSkills().update();
    }
    foreach (tr in ::Const.CharacterTraits) measure(tr[0], tr[1]);
    foreach (inj in ::Const.Injury.Permanent) measure(::new("scripts/skills/" + inj.Script).getID(), "scripts/skills/" + inj.Script);
    ::World.getTemporaryRoster().clear();
    local injPool = {};
    foreach (inj in ::Const.Injury.Permanent) injPool[::new("scripts/skills/" + inj.Script).getID()] <- true;

    local function compatible(_a, _b) {  // two traits can end up together: one order passes
        return !(traits[_a].isExcluded(_b) && traits[_b].isExcluded(_a));
    }

    local absent = 0, out = {exclusion = [], notRollable = [], bgBound = [], traitAttr = [],
        traitAttrFixed = [], injury = 0, injuryNotInPool = []};
    local dead = {}, absentOnly = {};  // title: [dead sets, sets]
    local deadCount = @() out.exclusion.len() + out.bgBound.len() + out.traitAttr.len() + out.injuryNotInPool.len();
    foreach (e in ::Nicknames.Titles) foreach (fs in e.factors) {
        local name = titleName(e), skip = false, bg = null, ts = [], injs = [], before = deadCount();
        if (!(name in dead)) { dead[name] <- [0, 0]; absentOnly[name] <- true; }
        dead[name][1]++;
        foreach (f in fs) {
            local p = pre(f);
            if (p == "background") { if (!(f in bgs)) skip = true; else bg = f; }
            else if (p == "trait") { if (!(f in traits)) skip = true; else ts.push(f); }
            else if (p == "injury") { if (!(f in injuries)) skip = true; else injs.push(f); }
            else if (p == "perk" && !(f in perks) && !(f in ::Nicknames.Aliases)) skip = true;
        }
        if (skip) { absent++; dead[name][0]++; continue; }
        absentOnly[name] = false;
        if (injs.len() > 0) out.injury++;
        foreach (i in injs) if (!(i in injPool)) out.injuryNotInPool.push(name + ": " + i);
        foreach (a in ts) {
            if (!(a in rollable)) out.notRollable.push(name + ": " + a);
            if (bg != null && bgs[bg].isExcluded(a)) out.exclusion.push(name + ": " + bg + " excludes " + a);
            foreach (b in ts) if (a < b && !compatible(a, b))
                out.exclusion.push(name + ": " + a + " and " + b + " exclude each other");
        }
        if (bg != null) {
            local b = bgs[bg], c = b.onChangeAttributes(), own = {};
            if (c.RangedSkill[0] > 0 && c.RangedSkill[0] - c.MeleeSkill[0] >= 10) own["type.ranged"] <- true;
            else own["type.melee"] <- true;
            if (b.m.DailyCost >= 20) own["cost.high"] <- true;
            if (b.m.DailyCost <= 10) own["cost.low"] <- true;
            if (b.m.IsOffendedByViolence) own["group.peaceful"] <- true;
            if (b.m.IsCombatBackground) own["group.combat"] <- true;
            if (b.m.IsNoble) own["group.noble"] <- true;
            if (b.m.IsLowborn) own["group.lowborn"] <- true;
            if (bg in ::Nicknames.PauperBackgrounds) own["group.pauper"] <- true;
            foreach (f in fs) {
                local p = pre(f);
                if ((p == "type" || p == "cost" || p == "group") && !(f in own))
                    out.bgBound.push(name + ": " + bg + " never has " + f);
            }
        }
        // attr sets the set's own traits/injuries push past the roll; others in the pool may push back:
        // up to 3 traits (vanilla's 2 + Bro Studio's 1) and 1 injury.
        foreach (f in fs) {
            if (f.find("attr.") != 0) continue;
            local parts = ::std.Str.split(".", f), a = parts[1], high = parts[2] == "high";
            local d = 0;
            foreach (x in ts) if (x in shift) d += shift[x][a];
            foreach (x in injs) if (x in shift) d += shift[x][a];
            local bad = high ? d < -2 : d > 0;
            if (!bad) continue;
            // best compensation by other rollable traits compatible with the set's
            local gains = [];
            foreach (id, _ in rollable) {
                if (ts.find(id) != null || !(id in traits)) continue;
                if (bg != null && bgs[bg].isExcluded(id)) continue;
                local ok = true;
                foreach (x in ts) if (traits[x].isExcluded(id)) ok = false;
                if (ok) gains.push(high ? shift[id][a] : -shift[id][a]);
            }
            gains.sort(@(x, y) y <=> x);
            local room = 3 - ts.len(), comp = 0;
            for (local i = 0; i < room && i < gains.len(); i++) if (gains[i] > 0) comp += gains[i];
            if (injs.len() == 0 && !high) {
                local best = 0;
                foreach (id, _ in injPool) if (id in shift && -shift[id][a] > best) best = -shift[id][a];
                comp += best;
            }
            local line = name + ": " + f + " shifted " + d + ", other traits/injury make up " + comp;
            if (high ? d + comp >= -2 : d - comp <= 0) out.traitAttrFixed.push(line);
            else out.traitAttr.push(line);
        }
        if (deadCount() > before) dead[name][0]++;
    }
    local deadTitles = [];
    foreach (name, c in dead) if (c[0] == c[1] && !absentOnly[name]) deadTitles.push(name);
    t.probe("titles with every set dead (not just other mods')", deadTitles);
    t.probe("absent-mod sets", absent);
    foreach (k, v in out) t.probe(k, v);
});
