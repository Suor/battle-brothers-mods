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
        "farmhand", "daytaler", "sellsword", "militia", "servant", "mason", "miller",
        "poacher", "ratcatcher", "peddler", "brawler", "bowyer", "messenger", "tailor",
        "squire", "houndmaster", "vagabond", "gravedigger", "bastard", "graverobber",
        "adventurous_noble", "disowned_noble", "retired_soldier", "caravan_hand",
        "flagellant", "wildman", "witchhunter", "hedge_knight", "swordmaster",
        "apprentice", "refugee", "thief", "monk", "butcher", "shepherd", "beggar",
        "cultist", "minstrel", "gambler", "lumberjack", "miner", "fisherman",
        "killer_on_the_run", "deserter", "hunter",
        // hackflows/XBE
        "hackflows_falconer", "hackflows_hangman", "hackflows_pirate", "hackflows_berserker",
        "hackflows_carpenter", "hackflows_barkeep", "hackflows_herbalist", "hackflows_con_artist",
        "hackflows_bodyguard", "hackflows_bounty_hunter", "hackflows_blacksmith", "hackflows_cook",
        "hackflows_surgeon", "hackflows_torturer", "hackflows_town_watchman", "hackflows_roofer",
        "hackflows_cobbler", "hackflows_drifter", "hackflows_lancer", "hackflows_master_archer",
        "hackflows_outlander", "hackflows_arbalester", "hackflows_druid", "hackflows_fletcher",
        "hackflows_gardener", "hackflows_locksmith", "hackflows_myrmidon", "hackflows_painter",
        "hackflows_skirmisher", "hackflows_cartographer", "hackflows_dissenter", "hackflows_leper",
        "hackflows_atilliator",
        // other mods
        "chosen", "aspirant", "shaman", "necro", "oathbreaker"
    ]
    attr = [
        "Hitpoints.high", "Hitpoints.low", "MeleeSkill.high", "MeleeSkill.low",
        "RangedSkill.high", "RangedSkill.low", "Bravery.high", "Bravery.low",
        "Stamina.high", "Stamina.low", "Initiative.high", "Initiative.low",
        "MeleeDefense.high", "RangedDefense.high"
    ]
    weapon = ["Sword", "Axe", "Hammer", "Spear", "Dagger", "Mace",
              "Polearm", "Bow", "Crossbow", "Flail", "Cleaver"]
    type   = ["melee", "ranged"]
    cost   = ["high", "low"]
    // perm and perk are [NOT IMPLEMENTED], validated separately
};

local NOT_IMPLEMENTED = ["perm", "perk"];

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

function titleLabel(t) { return "'" + t.ru + "' / '" + t.en + "'"; }

// ── Factor validation ─────────────────────────────────────────────────────────

// Returns {errors, warnings} for a single factor string.
function checkFactor(factor) {
    local dot = factor.find(".");
    if (dot == null) return {errors = ["no namespace dot: '" + factor + "'"], warnings = []};

    local ns  = factor.slice(0, dot);
    local val = factor.slice(dot + 1);

    if (hasVal(NOT_IMPLEMENTED, ns))
        return {errors = [], warnings = ["[NOT IMPLEMENTED] factor: '" + factor + "'"]};

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
        }
        local ruLen = unicodeLen(title.ru), enLen = title.en.len();
        if (ruLen > 16) errors.push(label + ": ru too long (" + ruLen + " chars)");
        if (enLen > 16) errors.push(label + ": en too long (" + enLen + " chars)");
        if (title.en in seenEn) errors.push(label + ": duplicate en='" + title.en + "' (first: " + titleLabel(seenEn[title.en]) + ")");
        else seenEn[title.en] <- title;
        if (title.ru in seenRu) errors.push(label + ": duplicate ru='" + title.ru + "' (first: " + titleLabel(seenRu[title.ru]) + ")");
        else seenRu[title.ru] <- title;
    }

    if (errors.len() > 0) {
        print("ERRORS (" + errors.len() + "):\n");
        foreach (e in errors) print("  " + e + "\n");
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

    // Column widths
    local factorW = 6; // "factor"
    local allFactors = clone factors;
    if (hasExternal) foreach (f, n in ::BuiltInTitles) if (n != 0 && !hasVal(allFactors, f)) allFactors.push(f);
    foreach (f in allFactors) if (f.len() > factorW) factorW = f.len();

    local colW = [];
    foreach (len in lens) {
        local w = colHeader(len).len();
        foreach (f in factors)
            if (len in stats[f] && (stats[f][len] + "").len() > w)
                w = (stats[f][len] + "").len();
        colW.push(w);
    }
    local extW = hasExternal ? 8 : 0; // "built-in"
    if (hasExternal)
        foreach (f, n in ::BuiltInTitles)
            if ((n + "").len() > extW) extW = (n + "").len();

    local totalW = 5; // "total"
    foreach (f in allFactors) if ((factorTotal(f) + "").len() > totalW) totalW = (factorTotal(f) + "").len();

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

    // Unused: exclude factors covered by built-in titles
    local unused = [];
    foreach (ns, vals in KNOWN)
        foreach (val in vals) {
            local f = ns + "." + val;
            if (!(f in stats) && (!(f in ::BuiltInTitles) || ::BuiltInTitles[f] == 0)) unused.push(f);
        }
    unused.sort(@(a, b) a <=> b);
    print("\nUnused (" + unused.len() + "):\n");
    foreach (f in unused) print("  " + f + "\n");
}

function cmdStats() {
    local numTitles = titles.len();
    local numFactorArrays = 0;
    foreach (title in titles) numFactorArrays += title.factors.len();
    print("titles: " + numTitles + "\n");
    print("factor arrays: " + numFactorArrays + "\n");
}

// ── Dispatch ──────────────────────────────────────────────────────────────────

local cmd = vargv.len() > 0 ? vargv[0] : "";
local doSort = vargv.len() > 1 && vargv[1] == "--sort";
switch (cmd) {
    case "check": cmdCheck(); break;
    case "usage": cmdUsage(doSort); break;
    case "stats": cmdStats(); break;
    default:
        print("Usage: squirrel tools.nut <command>\n");
        print("Commands:\n");
        print("  check   show errors and warnings\n");
        print("  usage   show factor combo usage stats\n");
        print("  stats   show title and factor array counts\n");
}
