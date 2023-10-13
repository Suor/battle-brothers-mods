local mod = ::BroStudio,
      Rand = ::std.Rand.using(::rng), // Use non-Math rng generator to preserve seeds better
      Str = ::std.Str, Text = ::std.Text, Util = ::std.Util;

// Settings, Talents & Attributes page
local page = mod.addPage("Talents & Attrs");

// Talents
page.add(::MSU.Class.RangeSetting("talentsMin", 3, 0, 8, 1, "Minimum Talents",
    "A low bound on a number of talents each bro gets"));
page.add(::MSU.Class.RangeSetting("talentsMax", 3, 0, 8, 1, "Maximum Talents",
    "A high bound on a number of talents each bro gets"));
page.add(::MSU.Class.RangeSetting("talentsChance", 50, 0, 100, 1, "Talent Chance",
    "A bro will need to roll this chance to get each talent after minimum"));
// page.add(::MSU.Class.SettingsSpacer("talentsSpacer", "35rem", "8rem"));

page.add(::MSU.Class.EnumSetting("talentsExcluded", "relaxed", ["strict" "relaxed" "ignored"],
    "Excluded Talents",
    "How to treat background exclusions:\n\n" +
    Text.negative("strict") + " - never get excluded talents,\n" +
    Text.negative("relaxed") + " - get any other first, then may get excluded,\n" +
    Text.negative("ignored") + " - completely ignore the excluded list."));

page.add(::MSU.Class.BooleanSetting("talentsWeighted", false, "Weighted Talents",
    "Better chances to get talent in attributes favored by background. " +
    "Plus higher chance to get 2 or 3 stars in those attributes too.\n\n" +
    "The attributes not favored by background get talents rarer and " +
    "have lower chance for 2 or 3 stars."));
page.add(::MSU.Class.BooleanSetting("talentsRandomStart", false,
    "Randomize Starting Talents",
    "Some company origins have preset bros. " +
    "If this is checked those will be rolled by Studio instead."));
// randomStart.Data.NewCampaignOnly <- true;
// page.add(::MSU.Class.SettingsSpacer("talentsSpacer", "35rem", "8rem"));
// page.add(::MSU.Class.BooleanSetting("starsWeighted", false, "Weighted Stars",
//     "Higher chance to get 2 or 3 stars in an attribute favored by background"));

// Attributes
page.add(::MSU.Class.SettingsDivider("attrsDiv"));
page.add(::MSU.Class.SettingsTitle("attrsTitle", "Attributes"));

page.add(::MSU.Class.RangeSetting("attrsUps", 3, 1, 8, 1, "Attribute Ups",
    "Amount of attribute bros allowed to raise each level-up"));

page.add(::MSU.Class.BooleanSetting("attrsVeteranBoost", false, "Veteran Boost",
    "Allow veterans to get more than 1 sometimes in talented attributes"));


// The meat
// Average values taken from character_background.buildAttributes(),
// will use them to determine how much a change from onChangeAttributes() means.
// Q: should I use level 11 expected instead? Then might not need special treatment for defense.
mod.AttributeBase <- [55.0, 35.0, 95.0, 105, 52.0, 37.0, 2.5, 2.5]

local isBackgroundUntalented = ::mods_getRegisteredMod("mod_legends")
    ? @(b) b.isBackgroundType(Const.BackgroundType.Untalented)
    : @(b) b.isUntalented()

mod.fillTalentValues <- function (_player, _num, _opts = null) {
    _opts = Util.extend({
        weighted = mod.conf("talentsWeighted")
        excluded = mod.conf("talentsExcluded")
        force = mod.conf("talentsRandomStart")
    }, _opts || {})
    if (["strict" "relaxed" "ignored"].find(_opts.excluded) == null)
        throw "Should use excluded = \"strict\", \"relaxed\" or \"ignored\", not " + _opts.excluded;


    local bg = _player.getBackground();
    if (!_opts.force && bg != null && isBackgroundUntalented(bg)) return;
    if (mod.Debug)
        ::logInfo("studio: fillTalentValues " + _player.getName()
            + ", bg: " + (bg ? bg.getNameOnly() : "null"));

    // Erase anything set up prior
    _player.m.Talents = array(::Const.Attributes.COUNT, 0);

    local weights = _opts.weighted && bg ? mod.calcWeights(bg) : array(::Const.Attributes.COUNT, 1);
    if (mod.Debug) mod.Debug.log("weights", weights);

    // Split excluded
    local indexes = [], iWeights = [], excluded = [], eWeights = [];
    if (_opts.excluded == "ignored" || !bg) {
        indexes = [0 1 2 3 4 5 6 7];
        iWeights = weights;
    } else {
        local excludedTalents = bg.getExcludedTalents();
        foreach (i, w in weights) {
            if (excludedTalents.find(i) == null) {
                indexes.push(i); iWeights.push(w);
            } else {
                excluded.push(i); eWeights.push(w);
            }
        }
    }

    // Choose talents
    local chosen = Rand.take(_num, indexes, iWeights);
    if (_opts.excluded != "strict" && chosen.len() < _num) {
        chosen.extend(Rand.take(_num - chosen.len(), excluded, eWeights))
    }

    // Roll ralent stars
    local probsStr = array(8, "-");
    foreach (i in chosen) {
        local w = weights[i];
        local probs = [60 30 10];
        probs[2] *= w;           // 3 stars
        probs[1] *= (w + 1) / 2; // 2 stars
        _player.m.Talents[i] = Rand.choice([1 2 3], probs);
        if (mod.Debug) {
            local psum = probs[0] + probs[1] + probs[2];
            probsStr[i] = Str.join(".", probs.map(@(p) ::Math.round(p * 100 / psum)));
        }
    }
    if (mod.Debug) mod.Debug.log("talents probs", Str.join(" ", probsStr));
    if (mod.Debug) mod.Debug.log("talents after", _player.m.Talents);
}

mod.calcWeights <- function (_bg) {
    local weights = clone mod.AttributeBase;
    foreach (k, v in _bg.onChangeAttributes()) {
        local i = ::Const.Attributes[k == "Stamina" ? "Fatigue" : k];
        local isDefense = k == "MeleeDefense" || k == "RangedDefense";
        local min = isDefense ? 0.8 : 0.5,
              max = isDefense ? 1.5 : 3.0,
              exp = i == 1 || i == 5 ? 3 : 4;
        weights[i] = Util.clamp(pow((v[0] + v[1]) * 0.5 / weights[i] + 1, exp), min, max);
    }

    // Make defense talents scale up slightly with attack talents
    for (local i = 6; i < 8; i++) {
        local attack = weights[i-2];
        if (attack > 1 && weights[i] > 0.001)
            weights[i] = ::Math.minf(2.0, weights[i] + ::Math.minf(0.5, attack * 0.5 - 0.5));
    }
    return weights;
}

// Give rolls of 2 on veteran levels to attrs with talents sometimes
mod.addVeteranAttributeLevelUpValues <- function (_player) {
    // only add one row at a time, do nothing if we are in non-veteran levels
    // TODO: somehow apply changes immediately
    if(_player.m.Attributes[0].len() == 0 && mod.conf("attrsVeteranBoost")) {
        local talentValue = 1.0 / 6; // 3 stars give 0.5 on average, i.e. 50-50 for 1-2 up
        local extra = function(t, bonus = 0) {
            local high = talentValue * 2 * t * (1 + bonus);
            return ::Math.rand(0, high * 100 + 99) / 100;
        }
        for (local i = 0; i < ::Const.Attributes.COUNT; i++) {
            local bonus = i == ::Const.Attributes.Initiative ? 0.5 : 0;
            _player.m.Attributes[i].insert(0, 1 + extra(_player.m.Talents[i], bonus));
        }
    }
}
