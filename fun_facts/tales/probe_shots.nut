// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_fun_facts stdlib@dev
// include: lib/helpers.nut

// Screenshots for the mod page: a veteran's popup and a fallen bro's obituary tooltip.
// Run with --env game, by name (not a tale_ file, so suites skip it).

local function battle(_kills, _fled = 0, _added = {}) {
    return {Id = 1, Kills = _kills, XPGained = 100, Fled = _fled, Returned = 0,
        Start = {Effects = [], Injured = false, Drugged = false, HpPct = 100}, Added = _added};
}
// Enemies' XP from vanilla's Const.Tactical.Actor
local xp = {Footman = 250, Billman = 250, Arbalester = 250, Sergeant = 350, Knight = 450, OrcYoung = 250,
    OrcWarrior = 400, Ghoul = 125, BanditRaider = 250, Direwolf = 200};
local names = {OrcYoung = "Orc Young", OrcWarrior = "Orc Warrior", BanditRaider = "Brigand Raider"};
local function kill(_type, _fatality, _isPlayer = false, _skill = null) {
    return {BattleId = 1, IsPlayer = _isPlayer, Name = _isPlayer ? _type : (_type in names ? names[_type] : _type),
        ClassName = _isPlayer ? "player" : _type, XP = _isPlayer ? 0 : xp[_type], Fatality = _fatality, Day = 1,
        Faction = 22, Skill = _skill, Self = false, Charmed = false};
}
// A battle log with these kills per battle, the given extras put on its first battles
local function battles(_kills, _extras = []) {
    local log = [];
    foreach (i, k in _kills) log.push(battle(k, i < _extras.len() ? _extras[i][0] : 0, i < _extras.len() ? _extras[i][1] : {}));
    return log;
}
local function spread(_total, _battles, _best) {
    local a = [_best], left = _total - _best;
    for (local i = 1; i < _battles; i++) {
        local k = left / (_battles - i);
        a.push(k > 4 ? 4 : k);
        left -= a.top();
    }
    return a;
}
local function times(_n, _x) {
    local a = [];
    for (local i = 0; i < _n; i++) a.push(_x);
    return a;
}
local function concat(...) {
    local a = [];
    foreach (part in vargv) a.extend(part);
    return a;
}

local function veteran() {
    local kills = concat(times(12, kill("Footman", 1)), times(6, kill("Billman", 1)), times(4, kill("OrcYoung", 3)),
        times(14, kill("Ghoul", 0)), times(6, kill("Arbalester", 0)), times(2, kill("Sergeant", 0)),
        times(3, kill("OrcWarrior", 0)), [kill("Knight", 0)]);
    local log = battles(spread(kills.len(), 38, 7), [[0, {}], [0, {net = 2, stunned = 3}], [0, {charmed = 1, stunned = 1}]]);
    return {Kills = kills, Deaths = [], Injuries = [], InjuriesDealt = [],
        BattlesLog = log, Battles = log.len(), NineLivesUses = 2, NineLivesSaves = 1, CombatsSkipped = [],
        Spent = {Hire = 1150, Wages = 4100, Food = 214.0, Parts = 38.0, Ammo = 0, Herbs = 14, Temple = [120, 85]},
        Version = 3};
}

// [background, level, days, battles, kills, weapon, offhand, armor, helmet, formation slot]
// Slots 0-8 are the front row, 9-17 the second: shields and one-handers ahead, two-tile weapons and bows behind.
local company = [
    [null,                         11, 0,  64, 61, "weapons/greatsword",     null,                    "armor/reinforced_mail_hauberk", "helmets/closed_flat_top_helmet", 4],
    [null,                         9,  0,  58, 37, "weapons/billhook",       null,                    "armor/scale_armor",             "helmets/kettle_hat_with_mail",   13],
    [null,                         9,  0,  55, 29, "weapons/war_bow",        null,                    "armor/mail_shirt",              "helmets/full_aketon_cap",        12],
    ["sellsword_background",       10, 81, 49, 44, "weapons/warbrand",       null,                    "armor/lamellar_harness",        "helmets/flat_top_with_mail",     3],
    ["hedge_knight_background",    10, 77, 47, 52, "weapons/longaxe",        null,                    "armor/reinforced_mail_hauberk", "helmets/closed_flat_top_helmet", 14],
    ["retired_soldier_background", 8,  69, 41, 18, "weapons/fighting_spear", "shields/heater_shield", "armor/mail_hauberk",            "helmets/nasal_helmet_with_mail", 5],
    ["militia_background",         8,  64, 40, 15, "weapons/fighting_spear", "shields/kite_shield",   "armor/scale_armor",             "helmets/kettle_hat_with_mail",   2],
    ["hunter_background",          8,  58, 36, 27, "weapons/war_bow",        null,                    "armor/mail_shirt",              "helmets/padded_kettle_hat",      11],
    ["witchhunter_background",     7,  51, 30, 19, "weapons/heavy_crossbow", null,                    "armor/padded_leather",          "helmets/full_aketon_cap",        15],
    ["squire_background",          7,  46, 28, 16, "weapons/noble_sword",    "shields/heater_shield", "armor/mail_hauberk",            "helmets/flat_top_with_mail",     6],
    ["brawler_background",         6,  39, 22, 14, "weapons/winged_mace",    "shields/kite_shield",   "armor/lamellar_harness",        "helmets/nasal_helmet_with_mail", 1],
    ["deserter_background",        6,  33, 19, 11, "weapons/military_pick",  "shields/heater_shield", "armor/scale_armor",             "helmets/kettle_hat_with_mail",   7],
];
// The wagon of a company 80 days in, after fighting a noble's army (his footmen, billmen, arbalesters):
// cheap grain in stacks, used quivers, nets and bandages, beast trophies, and the army's gear to sell or wear.
// [item, condition or ammo/amount, faction-painted]; loot armor drops at 25%+ of its condition.
local stash = [
    ["supplies/ground_grains_item", 25], ["supplies/ground_grains_item", 25], ["supplies/ground_grains_item", 25],
    ["supplies/ground_grains_item", 17], ["supplies/bread_item", 22],
    ["ammo/quiver_of_arrows", 9], ["ammo/quiver_of_arrows", 7], ["ammo/quiver_of_bolts", 8],
    ["tools/throwing_net", null], ["tools/throwing_net", null], ["accessory/bandage_item", null], ["accessory/bandage_item", null],
    ["misc/ghoul_teeth_item", null], ["misc/ghoul_teeth_item", null], ["misc/ghoul_horn_item", null],
    ["misc/werewolf_pelt_item", null], ["misc/unhold_bones_item", null],
    ["shields/faction_kite_shield", 0.62, true], ["shields/faction_kite_shield", 0.34, true], ["shields/faction_heater_shield", 0.81, true],
    ["weapons/arming_sword", 0.88], ["weapons/arming_sword", 1.0], ["weapons/falchion", 0.73], ["weapons/military_pick", 0.91],
    ["weapons/morning_star", 0.55], ["weapons/billhook", 0.79], ["weapons/pike", 1.0], ["weapons/polehammer", 0.66],
    ["weapons/crossbow", 0.84],
    ["armor/mail_shirt", 0.47], ["armor/mail_shirt", 0.71], ["armor/mail_hauberk", 0.38], ["armor/gambeson", 0.89],
    ["armor/gambeson", 0.52], ["armor/padded_surcoat", 1.0],
    ["helmets/kettle_hat_with_mail", 0.61], ["helmets/kettle_hat_with_mail", 0.27], ["helmets/nasal_helmet_with_mail", 0.77],
    ["helmets/nasal_helmet_with_mail", 0.42], ["helmets/flat_top_with_mail", 0.54], ["helmets/mail_coif", 0.96],
    ["helmets/mail_coif", 1.0], ["helmets/full_aketon_cap", 0.68]
];
local function fillStash() {
    local stashC = ::World.Assets.getStash();
    local nobles = ::World.FactionManager.getFactionsOfType(::Const.FactionType.NobleHouse);
    foreach (e in stash) {
        local item = ::new("scripts/items/" + e[0]);
        if (e.len() > 2) item.setFaction(nobles[0].getBanner());
        if (e[1] != null) {
            if (::std.Util.isKindOf(item, "ammo")) item.setAmmo(e[1]);
            else if (::std.Util.isKindOf(item, "food_item")) item.setAmount(e[1]);
            else item.setCondition(item.getConditionMax() * e[1]);
        }
        stashC.add(item);
    }
}
local mastery = {
    greatsword = "sword", warbrand = "sword", noble_sword = "sword", billhook = "polearm", war_bow = "bow",
    heavy_crossbow = "crossbow", longaxe = "axe", fighting_axe = "axe", fighting_spear = "spear",
    winged_mace = "mace", military_pick = "hammer"
};
local function perksFor(_row) {
    local weapon = ::std.Str.cutprefix(_row[5], "weapons/"), m = "perk.mastery." + mastery[weapon];
    if (weapon == "war_bow" || weapon == "heavy_crossbow")
        return ["perk.fast_adaption", "perk.recover", "perk.quick_hands", "perk.pathfinder", m, "perk.bullseye",
            "perk.footwork", "perk.anticipation", "perk.head_hunter", "perk.overwhelm"];
    local perks = ["perk.colossus", "perk.recover", "perk.steel_brow", "perk.quick_hands", m];
    if (_row[6] != null) perks.push("perk.shield_expert");
    perks.extend(["perk.battle_forged", "perk.reach_advantage", "perk.berserk", "perk.killing_frenzy", "perk.indomitable"]);
    return perks;
}
// Level up as a player would: each level three attributes by the bro's role, the rolled gains
local function levelUp(_bro, _level, _ranged) {
    _bro.m.XP = ::Const.LevelXP[_level - 1];
    _bro.updateLevel();
    local picks = _ranged ? [["rangeSkill", "fatigue", "hitpoints"], ["rangeSkill", "initiative", "rangeDefense"]]
        : [["hitpoints", "meleeSkill", "meleeDefense"], ["meleeSkill", "fatigue", "bravery"]];
    for (local i = 0; _bro.getLevelUps() > 0; i++) {
        local up = _bro.getAttributeLevelUpValues();
        local v = {hitpointsIncrease = 0, braveryIncrease = 0, maxFatigueIncrease = 0, initiativeIncrease = 0,
            meleeSkillIncrease = 0, rangeSkillIncrease = 0, meleeDefenseIncrease = 0, rangeDefenseIncrease = 0};
        foreach (a in picks[i % 2]) v[(a == "fatigue" ? "maxFatigue" : a) + "Increase"] = up[a + "Increase"];
        _bro.setAttributeLevelUpValues(v);
    }
}

// A bro's history in Fun Facts, and his vanilla lifetime stats agreeing with it
local function giveHistory(_bro, _stats) {
    ::FFT.ff(_bro).unpack(_stats);
    local best = null;
    foreach (k in _stats.Kills) if (!k.IsPlayer && (best == null || k.XP > best.XP)) best = k;
    local s = _bro.m.LifetimeStats;
    s.Battles = _stats.BattlesLog.len();
    s.Kills = _stats.Kills.len();
    s.MostPowerfulVanquished = best == null ? "" : ::Const.Strings.getArticle(best.Name) + best.Name;
}

local function setupCompany(t) {
    fillStash();
    local roster = t.roster();
    foreach (i, row in company) {
        local bro = i < roster.len() ? roster[i] : ::Tales.hire(row[0]);
        local wear = row[9] <= 8 ? [0.93, 0.72, 0.81, 0.86] : [0.97, 1.0, 0.9, 0.95];
        foreach (j, path in [row[5], row[6], row[7], row[8]]) {
            if (path == null) continue;
            local item = ::new("scripts/items/" + path);
            item.setCondition(item.getConditionMax() * (j == 0 && i % 3 == 0 ? 1.0 : wear[j] - (i % 4) * 0.04));
            ::Tales.equip(bro, item);
        }
        levelUp(bro, row[1], row[5] == "weapons/war_bow" || row[5] == "weapons/heavy_crossbow");
        foreach (perk in perksFor(row)) if (bro.getPerkPoints() > 0) bro.unlockPerk(perk);
        if (row[2] > 0) bro.m.HireTime = ::Time.getVirtualTimeF() - row[2] * ::World.getTime().SecondsPerDay;
        bro.m.LifetimeStats.Battles = row[3];
        bro.m.LifetimeStats.Kills = row[4];
        bro.m.LifetimeStats.MostPowerfulVanquished = ["a Sergeant", "an Orc Warrior", "a Knight"][i % 3];
        bro.setPlaceInFormation(row[9]);
        bro.setHitpoints(bro.getHitpointsMax());
    }
}

// The drawn cursor where a player's mouse would be: on the portrait whose tooltip is open
local function pointAt(t, _selector) {
    local at = t.js("(function (e) { var o = e.offset(); return [o.left + e.outerWidth() * 0.55, o.top + e.outerHeight() * 0.6,"
        + " $(window).width(), $(window).height()]; })($('" + _selector + "'))");
    ::UI.setCursorPosition(at[0].tointeger(), at[1].tointeger());
    t.probe("cursor", at);
}

// The character screen's slot of a bro: each portrait keeps its bro's id
local function slotOf(t, _bro) {
    return ".is-brother-slot .brother:eq(" + t.js("$('.is-brother-slot .brother').map(function () { return $(this).data('ID'); })"
        + ".get().indexOf(" + _bro.getID() + ")") + ")";
}

local function fallenStats() {
    local kills = concat(times(6, kill("Ghoul", 2)), times(9, kill("BanditRaider", 0)), times(2, kill("Direwolf", 0)));
    local log = battles(spread(kills.len(), 28, 3), [[1, {}], [2, {}]]);
    local inj = {BattleId = 1, Injury = "cut_arm", AttackerClass = "bandit_thug", AttackerName = "Brigand Thug",
        TargetClass = "bandit_thug", TargetName = "Brigand Thug", Day = 1};
    local sober = {Id = 1, Effects = [], Injured = false, Drugged = false, HpPct = 100};
    local drunk = {Id = 1, Effects = ["effects.drunk"], Injured = false, Drugged = false, HpPct = 100};
    return {Kills = kills, Injuries = times(5, inj), InjuriesDealt = times(9, inj), BattlesLog = log,
        Battles = log.len(), NineLivesUses = 0, NineLivesSaves = 0, CombatsSkipped = concat(times(5, drunk), [sober]),
        BattlesSkipped = 6, Deaths = [{BattleId = 1, IsPlayer = true, Name = "Torkel", ClassName = "player",
            XP = 150, Fatality = 0, Day = 1, Self = false}],
        Spent = {Hire = 420, Wages = 1310, Food = 120.0, Parts = 9.0, Ammo = 0, Herbs = 8, Temple = []}, Version = 3};
}

local function shotWhenStill(t, _name) {
    t.state.wait <- 0;
    return t.until(function () { t.state.wait++; return t.state.wait > 60; }, 200, "settled");
}

test("a veteran's popup", function (t) {
    setupCompany(t);
    local bro = t.roster()[4];  // the hedge knight, hired, with a longaxe
    giveHistory(bro, veteran());
    ::World.State.showCharacterScreen();
    yield t.untilJs("$('.is-brother-slot .brother').length > 0");
    local sel = slotOf(t, bro);
    t.js("$('" + sel + "').trigger('mousedown').trigger('mouseup').trigger('click')");
    yield shotWhenStill(t, "select");
    t.js("$('.tooltip-module').addClass('display-none').removeClass('display-block')");
    t.hover(sel);
    yield t.untilJs("$('.tooltip-module').hasClass('display-block')", 120);
    yield shotWhenStill(t, "bro");
    pointAt(t, sel);
    yield t.frames(2);
    t.shot("ff_bro_popup");
    t.probe("lines", t.js("$('.tooltip-module').find('.title, .text').map(function () { return $(this).text(); }).get()"));
});

test("a fallen bro's obituary", function (t) {
    local stats = fallenStats();
    local ff = ::new("scripts/mods/fun_facts/fun_facts");
    ff.unpack(stats);
    local fallen = ::World.Statistics.getFallen();
    foreach (row in [["Gerold the Unlucky", 64, 28, 17, "Shot in the back by Torkel", ff],
                     ["Wolfram the Drunk", 31, 14, 9, "Shot in the back by Torkel", null],
                     ["Hannes", 12, 6, 2, "Impaled by a Brigand Raider", null]]) {
        local f = {Name = row[0], Time = row[1], TimeWithCompany = row[1], Battles = row[2], Kills = row[3],
            KilledBy = row[4], Expendable = false};
        if (row[5] != null) f.FunFacts <- row[5];
        fallen.push(f);
    }
    ::World.State.topbar_options_module_onObituaryButtonClicked();
    yield t.untilJs("$('.world-obituary-screen .l-row').length >= 3");
    t.js("$('.tooltip-module').addClass('display-none').removeClass('display-block')");
    t.hover(".world-obituary-screen .l-row");
    yield t.untilJs("$('.tooltip-module').hasClass('display-block')", 120);
    yield shotWhenStill(t, "obituary");
    // Vanilla's setupUITooltip placement, measured now: the engine measures the tooltip before its text wraps
    t.js("(function (r, m) { var o = r.offset(), left = o.left + r.outerWidth(true) / 2 - m.outerWidth(true) / 2,"
        + " top = o.top - m.outerHeight(true) - 4; if (top < 0) top = o.top + r.outerHeight(true) + 4;"
        + " m.css({left: left, top: top}); })($('.world-obituary-screen .l-row:first'), $('.tooltip-module'))");
    yield shotWhenStill(t, "obituary");
    pointAt(t, ".world-obituary-screen .l-row:first .name");
    yield t.frames(2);
    t.shot("ff_obituary");
});

local function archer() {
    local kills = concat(times(10, kill("BanditRaider", 0)), times(6, kill("Footman", 0)), times(4, kill("Arbalester", 0)),
        times(6, kill("Ghoul", 0)), [kill("OrcWarrior", 0)]);
    foreach (name in ["Gerold the Unlucky", "Wolfram the Drunk"])
        kills.push(kill(name, 0, true, "actives.aimed_shot"));
    local log = battles(spread(kills.len(), 44, 4));
    return {Kills = kills, Deaths = [], Injuries = [], InjuriesDealt = [],
        BattlesLog = log, Battles = log.len(), NineLivesUses = 0, NineLivesSaves = 0, CombatsSkipped = [],
        Spent = {Hire = 0, Wages = 1830, Food = 196.0, Parts = 12.0, Ammo = 412, Herbs = 6, Temple = [60]},
        Version = 3};
}

test("an archer's popup", function (t) {
    setupCompany(t);
    local bro = t.roster()[2];
    giveHistory(bro, archer());
    ::World.State.showCharacterScreen();
    yield t.untilJs("$('.is-brother-slot .brother').length > 0");
    local sel = slotOf(t, bro);
    t.js("$('" + sel + "').trigger('mousedown').trigger('mouseup').trigger('click')");
    yield shotWhenStill(t, "select");
    t.js("$('.tooltip-module').addClass('display-none').removeClass('display-block')");
    t.hover(sel);
    yield t.untilJs("$('.tooltip-module').hasClass('display-block')", 120);
    yield shotWhenStill(t, "archer");
    pointAt(t, sel);
    yield t.frames(2);
    t.shot("ff_archer_popup");
    t.probe("lines", t.js("$('.tooltip-module').find('.title, .text').map(function () { return $(this).text(); }).get()"));
});
