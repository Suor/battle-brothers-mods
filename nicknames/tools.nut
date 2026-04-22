#!/usr/bin/env squirrel
// 1. calc stats which factor is used more, by combo len, i.e.
//       background.butcher: exclusive - 25, 2-combo - 7, 3-combo - 2
// 2. test both russian and eng titles lens
// 3. sample from game somehow (parse log?) - which factors are more common
// 4. test that factors do not eat each other like (might make sense for raising prob though)
//      ["trait.huge"]                        // высокий и костлявый
//      ["trait.huge", "attr.Hitpoints.low"]  // долговязый и некрепкий
// 5. Update instructions so that traits and stuff would be understood properly (maybe case by case)
//
// TODO:
// 1. starting permanent or normal injuries
// 2. starting perks as factors
// 3. add simple existing factors like armor, offhand

::Nicknames <- {};
if (!("Hooks" in getroottable())) ::Hooks <- {function hasMod(_id) {return false}};
dofile("nicknames/titles.nut", true);

::BuiltInTitles <- {};
try { dofile("built-in.nut", true); } catch(e) {}

local titles = ::Nicknames.Titles;

// ── Known valid factors ──────────────────────────────────────────────────────

local KNOWN = {
    trait = [
        "strong", "brave", "tough", "fearless", "determined", "iron_jaw", "iron_lungs",
        "bright", "eagle_eyes", "swift", "quick", "dexterous", "sure_footing", "lucky",
        "survivor", "bloodthirsty", "loyal", "teamplayer", "athletic", "night_owl",
        "optimist", "weasel", "deathwish", "hate_undead", "hate_greenskins", "hate_beasts",
        "drunkard", "fat", "impatient", "huge", "tiny", "paranoid", "brute",
        "legend_aggressive", "legend_diurnal", "legend_light", "legend_double_tongued",
        "ailing", "asthmatic", "bleeder", "clubfooted", "clumsy", "cocky", "craven",
        "dastard", "disloyal", "dumb", "fainthearted", "fear_beasts", "fear_greenskins",
        "fear_undead", "fragile", "gluttonous", "greedy", "hesitant", "insecure",
        "irrational", "night_blind", "pessimist", "short_sighted", "superstitious",
        "legend_fear_nobles", "legend_frail", "legend_appetite_donkey", "legend_fear_dark",
        "legend_predictable", "legend_slack"
    ]
    background = [
        // vanilla
        "assassin", "farmhand", "daytaler", "sellsword", "militia", "servant", "mason", "miller",
        "poacher", "ratcatcher", "peddler", "brawler", "bowyer", "messenger", "tailor",
        "squire", "houndmaster", "vagabond", "gravedigger", "bastard", "graverobber",
        "adventurous_noble", "disowned_noble", "retired_soldier", "caravan_hand",
        "flagellant", "wildman", "witchhunter", "hedge_knight", "swordmaster",
        "apprentice", "refugee", "thief", "monk", "butcher", "shepherd", "beggar",
        "cultist", "minstrel", "juggler", "gambler", "lumberjack", "miner", "fisherman",
        "killer_on_the_run", "deserter", "hunter", "nomad", "raider", "slave",
        "gladiator", "beast_slayer", "anatomist", "bladedancer", "converted_cultist",
        "cripple", "eunuch", "historian", "manhunter", "paladin",
        // hackflows/XBE
        "hackflows_falconer", "hackflows_hangman", "hackflows_pirate", "hackflows_berserker",
        "hackflows_carpenter", "hackflows_barkeep", "hackflows_herbalist", "hackflows_con_artist",
        "hackflows_bodyguard", "hackflows_bounty_hunter", "hackflows_blacksmith", "hackflows_cook",
        "hackflows_surgeon", "hackflows_torturer", "hackflows_town_watchman", "hackflows_roofer",
        "hackflows_cobbler", "hackflows_drifter", "hackflows_lancer", "hackflows_master_archer",
        "hackflows_outlander", "hackflows_arbalester", "hackflows_druid", "hackflows_fletcher",
        "hackflows_gardener", "hackflows_locksmith", "hackflows_myrmidon", "hackflows_painter",
        "hackflows_skirmisher", "hackflows_cartographer", "hackflows_dissenter", "hackflows_leper",
        "hackflows_atilliator", "hackflows_champion", "hackflows_folk_hero", "hackflows_paladin_commander",
        // other mods
        "aspirant", "shaman", "necro", "oathbreaker"
    ]
    attr = [
        "Hitpoints.high", "Hitpoints.low", "MeleeSkill.high", "MeleeSkill.low",
        "RangedSkill.high", "RangedSkill.low", "Bravery.high", "Bravery.low",
        "Stamina.high", "Stamina.low", "Initiative.high", "Initiative.low",
        "MeleeDefense.high", "MeleeDefense.low", "RangedDefense.high", "RangedDefense.low"
    ]
    weapon = ["sword", "axe", "hammer", "spear", "dagger", "mace",
              "polearm", "bow", "crossbow", "flail", "cleaver",
              "firearm", "throwing", "sling", "staff", "musical"]
    type   = ["melee", "ranged"]
    cost   = ["high", "low"]
    group  = ["peaceful", "combat", "noble", "lowborn", "pauper"]
    perk = [
        "adrenaline", "anticipation", "bags_and_belts", "backstabber", "battle_forged",
        "berserk", "brawny", "bullseye", "colossus", "coup_de_grace", "crippling_strikes",
        "dodge", "duelist", "fast_adaption", "fearsome", "footwork", "fortified_mind",
        "gifted", "head_hunter", "hold_out", "indomitable", "killing_frenzy", "lone_wolf",
        "nine_lives", "nimble", "overwhelm", "pathfinder", "quick_hands", "reach_advantage",
        "rally_the_troops", "recover", "relentless", "rotation", "shield_expert", "steel_brow",
        "student", "taunt", "underdog",
        // NOTE: mastery perks are converted to weapon.* factors in buildFactorSet
        // hackflows perks
        "hackflows.balance", "hackflows.battle_flow", "hackflows.bloody_harvest",
        "hackflows.flesh_on_the_bones", "hackflows.full_force", "hackflows.stabilized",
        // necro perks
        "necro.blood_sucking", "necro.mind_meld", "necro.regeneration", "necro.soul_link"
    ]
    injury = [
        "brain_damage", "broken_elbow_joint", "broken_knee",
        "collapsed_lung_part", "maimed_foot", "missing_ear",
        "missing_eye", "missing_finger", "missing_hand",
        "missing_nose", "traumatized", "weakened_heart"
    ]
};

// ── Helpers ──────────────────────────────────────────────────────────────────

function hasVal(arr, val) {
    foreach (v in arr) if (v == val) return true;
    return false;
}

function unicodeLen(s) {
    local n = 0;
    for (local i = 0; i < s.len(); i++)
        if ((s[i] & 0xC0) != 0x80) n++;
    return n;
}

function titleLabel(t) {
    local names = "names" in t ? t.names : [{ru = t.ru, en = t.en}];
    local s = "";
    foreach (i, n in names) { if (i > 0) s += ", "; s += "'" + n.ru + "' / '" + n.en + "'"; }
    return s;
}

function sortedKey(arr, sep) {
    local sorted = clone arr;
    sorted.sort(@(a, b) a <=> b);
    local s = "";
    foreach (i, v in sorted) { if (i > 0) s += sep; s += v; }
    return s;
}

// Returns list of background.* factors in a combo (bros have only one background).
function backgroundsIn(combo) {
    local bgs = [];
    foreach (f in combo)
        if (f.len() > 11 && f.slice(0, 11) == "background.") bgs.push(f);
    return bgs;
}

// Splits a raw combo string like "background.beggar + trait.dumb" on '+', trimming whitespace.
function splitCombo(s) {
    local parts = [], cur = "";
    for (local i = 0; i < s.len(); i++) {
        if (s[i] == '+') { parts.push(cur); cur = ""; }
        else cur += s[i].tochar();
    }
    parts.push(cur);
    local out = [];
    foreach (p in parts) {
        local a = 0, b = p.len();
        while (a < b && (p[a] == ' ' || p[a] == '\t')) a++;
        while (b > a && (p[b-1] == ' ' || p[b-1] == '\t')) b--;
        out.push(p.slice(a, b));
    }
    return out;
}

// ── Factor validation ─────────────────────────────────────────────────────────

// Returns {errors, warnings} for a single factor string.
function checkFactor(factor) {
    local dot = factor.find(".");
    if (dot == null) return {errors = ["no namespace dot: '" + factor + "'"], warnings = []};

    local ns  = factor.slice(0, dot);
    local val = factor.slice(dot + 1);

    if (factor in ::Nicknames.Aliases)
        return {errors = ["uses alias '" + factor + "', use '" + ::Nicknames.Aliases[factor] + "' instead"], warnings = []};

    if (!(ns in KNOWN))
        return {errors = ["unknown namespace '" + ns + "' in: '" + factor + "'"], warnings = []};

    if (!hasVal(KNOWN[ns], val))
        return {errors = ["unknown " + ns + " value '" + val + "'"], warnings = []};

    return {errors = [], warnings = []};
}

// ── Subcommands ───────────────────────────────────────────────────────────────

function cmdCheck() {
    local errors = [], warnings = [];
    local seenEn = {}, seenRu = {};
    foreach (title in titles) {
        local label = titleLabel(title);
        foreach (combo in title.factors) {
            foreach (factor in combo) {
                local r = checkFactor(factor);
                foreach (e in r.errors)   errors.push(label + ": " + e);
                foreach (w in r.warnings) warnings.push(label + ": " + w);
            }
            local bgs = backgroundsIn(combo);
            if (bgs.len() > 1)
                errors.push(label + ": combo requires multiple backgrounds (" + sortedKey(bgs, " + ") + ") — a bro has only one");
        }
        local names = "names" in title ? title.names : [{ru = title.ru, en = title.en}];
        foreach (name in names) {
            local ruLen = unicodeLen(name.ru), enLen = name.en.len();
            if (ruLen > 16) errors.push(label + ": ru too long (" + ruLen + " chars)");
            if (enLen > 16) errors.push(label + ": en too long (" + enLen + " chars)");
            if (name.en in seenEn) errors.push(label + ": duplicate en='" + name.en + "' (first: " + titleLabel(seenEn[name.en]) + ")");
            else seenEn[name.en] <- title;
            if (name.ru in seenRu) errors.push(label + ": duplicate ru='" + name.ru + "' (first: " + titleLabel(seenRu[name.ru]) + ")");
            else seenRu[name.ru] <- title;
        }
    }

    // Check for titles with identical factor sets
    local seenFactors = {};
    foreach (title in titles) {
        local combos = title.factors.map(@(combo) sortedKey(combo, "+"));
        local key = sortedKey(combos, "|");

        if (key in seenFactors)
            warnings.push(titleLabel(title) + ": same factors as " + titleLabel(seenFactors[key]));
        else
            seenFactors[key] <- title;
    }

    if (errors.len() > 0) {
        print("ERRORS (" + errors.len() + "):\n");
        foreach (e in errors) print("  " + e + "\n");
        throw "check failed with " + errors.len() + " error(s)";
    } else {
        print("No errors.\n");
    }
    if (warnings.len() > 0) {
        print("\nWarnings (" + warnings.len() + "):\n");
        foreach (w in warnings) print("  " + w + "\n");
    }
}

function cmdUsage(doSort) {
    // Count per factor: how many combos of each length it appears in
    local stats = {};
    foreach (title in titles) {
        foreach (combo in title.factors) {
            local len = combo.len();
            foreach (factor in combo) {
                if (!(factor in stats)) stats[factor] <- {};
                if (!(len in stats[factor])) stats[factor][len] <- 0;
                stats[factor][len]++;
            }
        }
    }

    // Collect all combo lengths used across all factors
    local allLens = {};
    foreach (_, fstats in stats) foreach (len, _ in fstats) allLens[len] <- true;
    local lens = [];
    foreach (len, _ in allLens) lens.push(len);
    lens.sort(@(a, b) a <=> b);

    function factorTotal(f) {
        local t = 0;
        if (f in stats) foreach (_, n in stats[f]) t += n;
        if (f in ::BuiltInTitles && typeof ::BuiltInTitles[f] == "integer") t += ::BuiltInTitles[f];
        return t;
    }

    local factors = [];
    foreach (f, _ in stats) factors.push(f);

    if (doSort) {
        factors.sort(@(a, b) factorTotal(b) <=> factorTotal(a));
    } else {
        factors.sort(@(a, b) a <=> b);
    }

    local hasExternal = ::BuiltInTitles.len() > 0;

    function colHeader(len) { return len == 1 ? "exclusive" : (len + "-combo"); }
    function padR(s, w) { while (s.len() < w) s = " " + s; return s; }
    function padL(s, w) { while (s.len() < w) s += " "; return s; }

    local lenTotals = {};
    foreach (len in lens) lenTotals[len] <- 0;
    foreach (_, fstats in stats)
        foreach (len, n in fstats)
            lenTotals[len] += n;

    // Column widths
    local factorW = 6; // "factor"
    local allFactors = clone factors;
    if (hasExternal) foreach (f, n in ::BuiltInTitles) if (n != 0 && !hasVal(allFactors, f)) allFactors.push(f);
    foreach (f in allFactors) if (f.len() > factorW) factorW = f.len();

    local colW = [];
    foreach (len in lens) {
        local w = colHeader(len).len();
        if ((lenTotals[len] + "").len() > w)
            w = (lenTotals[len] + "").len();
        foreach (f in factors)
            if (len in stats[f] && (stats[f][len] + "").len() > w)
                w = (stats[f][len] + "").len();
        colW.push(w);
    }
    local extW = hasExternal ? 8 : 0; // "built-in"
    local extTotal = 0;
    if (hasExternal)
        foreach (f, n in ::BuiltInTitles) {
            if (typeof n == "integer") extTotal += n;
            if ((n + "").len() > extW) extW = (n + "").len();
        }
    if (hasExternal && (extTotal + "").len() > extW) extW = (extTotal + "").len();

    local grandTotal = extTotal;
    foreach (_, n in lenTotals) grandTotal += n;

    local totalW = 5; // "total"
    foreach (f in allFactors) if ((factorTotal(f) + "").len() > totalW) totalW = (factorTotal(f) + "").len();
    if ((grandTotal + "").len() > totalW) totalW = (grandTotal + "").len();

    // Header
    local header = padL("factor", factorW);
    foreach (i, len in lens) header += "  " + padR(colHeader(len), colW[i]);
    if (hasExternal) header += "  " + padR("built-in", extW);
    header += "  " + padR("total", totalW);
    print(header + "\n");

    // Rows: union of titles.nut factors and built-in factors, sorted
    local allSorted = clone allFactors;
    allSorted.sort(doSort
        ? @(a, b) factorTotal(b) <=> factorTotal(a)
        : @(a, b) a <=> b);

    foreach (factor in allSorted) {
        local row = padL(factor, factorW);
        foreach (i, len in lens)
            row += "  " + padR((factor in stats) && (len in stats[factor]) ? (stats[factor][len] + "") : "-", colW[i]);
        local total = factorTotal(factor);
        if (hasExternal) {
            local ext = factor in ::BuiltInTitles ? ::BuiltInTitles[factor] : null;
            row += "  " + padR(ext != null && ext != 0 ? (ext + "") : "-", extW);
        }
        row += "  " + padR(total > 0 ? (total + "") : "-", totalW);
        print(row + "\n");
    }

    local totalRow = padL("total", factorW);
    foreach (i, len in lens)
        totalRow += "  " + padR(lenTotals[len] > 0 ? (lenTotals[len] + "") : "-", colW[i]);
    if (hasExternal)
        totalRow += "  " + padR(extTotal > 0 ? (extTotal + "") : "-", extW);
    totalRow += "  " + padR(grandTotal > 0 ? (grandTotal + "") : "-", totalW);
    print(totalRow + "\n");

    // Unused: exclude factors covered by built-in titles or reachable via aliases
    local aliasTargets = {};
    foreach (_, target in ::Nicknames.Aliases) aliasTargets[target] <- true;

    local unused = [];
    foreach (ns, vals in KNOWN)
        foreach (val in vals) {
            local f = ns + "." + val;
            if (!(f in stats) && (!(f in ::BuiltInTitles) || ::BuiltInTitles[f] == 0)
                    && !(f in aliasTargets)) unused.push(f);
        }
    unused.sort(@(a, b) a <=> b);
    print("\nUnused (" + unused.len() + "):\n");
    foreach (f in unused) print("  " + f + "\n");
}

function cmdStats() {
    local numTitles = 0, numFactorArrays = 0;
    foreach (title in titles) {
        numTitles += "names" in title ? title.names.len() : 1;
        numFactorArrays += title.factors.len();
    }
    print("titles: " + numTitles + "\n");
    print("factor arrays: " + numFactorArrays + "\n");
}

function writeStr(f, s) {
    if (s.len() == 0) return;
    local b = blob(s.len());
    for (local i = 0; i < s.len(); i++) b[i] = s[i];
    f.writeblob(b);
}

function readLines(path) {
    local f = file(path, "rb");
    f.seek(0, 'e'); local size = f.tell(); f.seek(0, 'b');
    local b = f.readblob(size);
    f.close();
    local lines = [], s = "", NL = 10;
    for (local i = 0; i < size; i++) {
        if (b[i] == NL) { lines.push(s); s = ""; }
        else s += b[i].tochar();
    }
    if (s.len() > 0) lines.push(s);
    return lines;
}

// Parse **Name** or **Name / EnName** entries at line starts from a markdown file.
// Returns array of {ru, en} where en may be null if not in the format.
function parseBoldTitles(filename) {
    local lines;
    try { lines = readLines(filename); } catch(e) {
        print("Cannot open '" + filename + "'\n"); return [];
    }
    local result = [];
    foreach (line in lines) {
        if (line.len() < 4 || line.slice(0, 2) != "**") continue;
        local close = line.find("**", 2);
        if (close == null) continue;
        local raw = line.slice(2, close);
        local sep = raw.find(" / ");
        local ru = sep != null ? raw.slice(0, sep) : raw;
        local en = sep != null ? raw.slice(sep + 3) : null;
        local factors = [], rest = line.slice(close + 2), k = 0;
        while (true) {
            local q1 = rest.find("`", k);
            if (q1 == null) break;
            local q2 = rest.find("`", q1 + 1);
            if (q2 == null) break;
            factors.push(rest.slice(q1 + 1, q2));
            k = q2 + 1;
        }
        result.push({ru = ru, en = en, factors = factors});
    }
    return result;
}

// Parse "quoted name" strings from built-in.nut comment sections.
// Returns norm_name -> {en = "original name", factor = "background.xxx"}.
function parseBuiltInNames() {
    local norm = {};
    local lines;
    try { lines = readLines("built-in.nut"); } catch(e) { return norm; }
    foreach (line in lines) {
        local start = line.find("[\"");
        if (start == null) continue;
        local factorEnd = line.find("\"", start + 2);
        if (factorEnd == null) continue;
        local factor = line.slice(start + 2, factorEnd);
        local ci = line.find("//");
        if (ci == null) continue;
        local k = ci;
        while (true) {
            local q1 = line.find("\"", k);
            if (q1 == null) break;
            local q2 = line.find("\"", q1 + 1);
            if (q2 == null) break;
            local en = line.slice(q1 + 1, q2);
            local s = en.tolower();
            if (s.len() > 4 && s.slice(0, 4) == "the ") s = s.slice(4);
            if (!(s in norm)) norm[s] <- {en = en, factor = factor};
            k = q2 + 1;
        }
    }
    return norm;
}

function cmdNew(filename) {
    local proposed;
    try { proposed = parseBoldTitles(filename); } catch(e) {
        print("Cannot read '" + filename + "'\n"); return;
    }

    // ru -> title entry, ru -> en, en -> title maps
    local ruToTitle = {}, ruToEn = {}, enToTitle = {};
    foreach (t in titles) {
        local names = "names" in t ? t.names : [{ru = t.ru, en = t.en}];
        foreach (n in names) {
            ruToTitle[n.ru] <- t; ruToEn[n.ru] <- n.en;
            if (n.en != null) enToTitle[n.en] <- t;
        }
    }

    local builtInNames = parseBuiltInNames();

    function normEn(s) {
        s = s.tolower();
        if (s.len() > 4 && s.slice(0, 4) == "the ") s = s.slice(4);
        return s;
    }

    function builtInInfo(entry) {
        local enForMatch = entry.en != null ? normEn(entry.en) : (entry.ru in ruToEn ? normEn(ruToEn[entry.ru]) : null);
        return (enForMatch != null && enForMatch in builtInNames) ? builtInNames[enForMatch] : null;
    }

    local multiBg = [];
    foreach (entry in proposed) {
        foreach (f in entry.factors) {
            local bgs = backgroundsIn(splitCombo(f));
            if (bgs.len() > 1)
                multiBg.push(entry.ru + ": multiple backgrounds in [" + f + "]");
        }
    }

    local inTitles = [], alsoInBuiltIn = [], notAdded = [], notAddedButBuiltIn = [];
    foreach (entry in proposed) {
        local matchedTitle = (entry.ru in ruToTitle) ? ruToTitle[entry.ru]
            : (entry.en != null && entry.en in enToTitle) ? enToTitle[entry.en] : null;
        if (matchedTitle != null) {
            local label = entry.ru;
            if (!(entry.ru in ruToTitle)) {
                local mnames = "names" in matchedTitle ? matchedTitle.names : [{ru = matchedTitle.ru, en = matchedTitle.en}];
                label = entry.ru + " (en='" + entry.en + "' matches ru='" + mnames[0].ru + "')";
            }
            inTitles.push(label);
            local info = builtInInfo(entry);
            if (info != null) alsoInBuiltIn.push({ru = entry.ru, info = info});
        } else {
            local info = builtInInfo(entry);
            if (info != null) notAddedButBuiltIn.push({ru = entry.ru, en = entry.en, factors = entry.factors, info = info});
            else notAdded.push(entry.ru);
        }
    }

    print(proposed.len() + " proposed in " + filename + "\n");
    print(inTitles.len() + " in titles.nut\n");
    function factorsStr(t) {
        local parts = [];
        foreach (combo in t.factors) parts.push("[" + sortedKey(combo, " + ") + "]");
        local s = "";
        foreach (i, p in parts) { if (i > 0) s += "; "; s += p; }
        return s;
    }

    local enMatched = [];
    foreach (label in inTitles) if (label.find("(en=") != null) enMatched.push(label);
    if (enMatched.len() > 0) {
        print("  " + enMatched.len() + " matched by en name (different ru):\n");
        foreach (label in enMatched) print("    " + label + "\n");
    }

    if (alsoInBuiltIn.len() > 0) {
        print("  " + alsoInBuiltIn.len() + " also in built-ins:\n");
        foreach (m in alsoInBuiltIn)
            print("    " + m.ru + " (\"" + ruToEn[m.ru] + "\" = \"" + m.info.en + "\" in " + m.info.factor + ")"
                + " — " + factorsStr(ruToTitle[m.ru]) + "\n");
    }
    if (notAddedButBuiltIn.len() > 0) {
        print(notAddedButBuiltIn.len() + " not added, covered by built-ins:\n");
        foreach (m in notAddedButBuiltIn) {
            local enLabel = m.en != null ? "\"" + m.en + "\"" : "?";
            local fstr = "";
            foreach (i, f in m.factors) { if (i > 0) fstr += "; "; fstr += "[" + f + "]"; }
            print("  " + m.ru + " (" + enLabel + " = \"" + m.info.en + "\" in " + m.info.factor + ")"
                + (fstr.len() > 0 ? " — " + fstr : "") + "\n");
        }
    }
    if (notAdded.len() > 0) {
        local s = "";
        foreach (i, n in notAdded) { if (i > 0) s += ", "; s += n; }
        print(notAdded.len() + " not yet added: " + s + "\n");
    } else if (notAddedButBuiltIn.len() == 0) {
        print("All added!\n");
    }
    if (multiBg.len() > 0) {
        print("\nMulti-background combos (a bro has only one background):\n");
        foreach (m in multiBg) print("  " + m + "\n");
    }
}

function cmdLoadNew(filename) {
    local proposed;
    try { proposed = parseBoldTitles(filename); } catch(e) {
        print("Cannot read '" + filename + "'\n"); return;
    }

    local ruToTitle = {}, enToTitle = {};
    foreach (t in titles) {
        local names = "names" in t ? t.names : [{ru = t.ru, en = t.en}];
        foreach (n in names) {
            ruToTitle[n.ru] <- t;
            if (n.en != null) enToTitle[n.en] <- t;
        }
    }

    local newEntries = [];
    foreach (entry in proposed) {
        if (entry.factors.len() == 0) continue;
        local matched = (entry.ru in ruToTitle) ? ruToTitle[entry.ru]
            : (entry.en != null && entry.en in enToTitle) ? enToTitle[entry.en] : null;
        if (matched == null) newEntries.push(entry);
    }

    if (newEntries.len() == 0) {
        print("No new titles to add.\n");
        return;
    }

    function quoteStr(s) { return "\"" + s + "\""; }

    local newLines = [];
    foreach (entry in newEntries) {
        local header = "    {ru = " + quoteStr(entry.ru);
        if (entry.en != null) header += ", en = " + quoteStr(entry.en);
        header += ", factors = [";
        newLines.push(header);
        foreach (raw in entry.factors) {
            local parts = splitCombo(raw);
            local s = "        [";
            foreach (i, p in parts) { if (i > 0) s += ", "; s += quoteStr(p); }
            s += "],";
            newLines.push(s);
        }
        newLines.push("    ]}");
    }

    local titlesPath = "nicknames/titles.nut";
    local content = readLines(titlesPath);

    local insertBefore = -1;
    for (local i = content.len() - 1; i >= 0; i--) {
        local line = content[i];
        local a = 0;
        while (a < line.len() && (line[a] == ' ' || line[a] == '\t')) a++;
        if (line.slice(a) == "];") { insertBefore = i; break; }
    }

    if (insertBefore < 0) {
        print("Cannot find ]; in " + titlesPath + "\n"); return;
    }

    local out = file(titlesPath, "wb");
    for (local i = 0; i < insertBefore; i++) { writeStr(out, content[i]); writeStr(out, "\n"); }
    foreach (line in newLines) { writeStr(out, line); writeStr(out, "\n"); }
    for (local i = insertBefore; i < content.len(); i++) { writeStr(out, content[i]); writeStr(out, "\n"); }
    out.close();

    print("Added " + newEntries.len() + " new titles to " + titlesPath + ":\n");
    foreach (entry in newEntries) {
        local enLabel = entry.en != null ? " / " + entry.en : "";
        print("  " + entry.ru + enLabel + "\n");
    }
}

// ── Dispatch ──────────────────────────────────────────────────────────────────

local cmd = vargv.len() > 0 ? vargv[0] : "";
local doSort = vargv.len() > 1 && vargv[1] == "--sort";
switch (cmd) {
    case "check": cmdCheck(); break;
    case "usage": cmdUsage(doSort); break;
    case "stats": cmdStats(); break;
    case "new": cmdNew(vargv.len() > 1 ? vargv[1] : "new_titles.md"); break;
    case "load-new": cmdLoadNew(vargv.len() > 1 ? vargv[1] : "new_titles.md"); break;
    default:
        print("Usage: squirrel tools.nut <command>\n");
        print("Commands:\n");
        print("  check           show errors and warnings\n");
        print("  usage           show factor combo usage stats\n");
        print("  stats           show title and factor array counts\n");
        print("  new [file]      check new_titles.md proposals vs titles.nut (default: new_titles.md)\n");
        print("  load-new [file] add new titles from new_titles.md into titles.nut (default: new_titles.md)\n");
}
