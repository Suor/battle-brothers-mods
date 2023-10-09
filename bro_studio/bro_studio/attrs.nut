local mod = ::BroStudio,
      Rand = ::std.Rand.using(::rng), // Use non Math rng generator to preserve seeds better
      Text = ::std.Text, Util = ::std.Util;

// Average values taken from character_background.buildAttributes(),
// will use them to determine how much a change from onChangeAttributes() means
// Q: should I use level 11 expected instead? Then might not need special treatment for defense.
mod.Data.AttributeBase <- [55.0, 35.0, 95.0, 105, 52.0, 37.0, 2.5, 2.5]

local minf = @(a,b) a <= b ? a : b, maxf = @(a,b) a >= b ? a : b;

mod.fillTalentValues <- function (_player, _num, _opt = null) {
    _opt = _opt || {
        talentsWeighted = mod.conf("talentsWeighted")
        starsWeighted = mod.conf("starsWeighted")
        talentsExcluded = mod.conf("talentsExcluded")
    }

    local bg = _player.getBackground();
    ::logInfo("bs: fillTalentValues " + _player.getName() + ", bg: " + bg.getNameOnly());

    // Erase anything set up prior
    _player.m.Talents = array(::Const.Attributes.COUNT, 0);

    local weights = clone mod.Data.AttributeBase;
    local excluded = bg.getExcludedTalents();
    foreach (k, v in bg.onChangeAttributes()) {
        local i = ::Const.Attributes[k == "Stamina" ? "Fatigue" : k];
        if (excluded.find(i) != null) { weights[i] = 0.001; continue; }
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
            weights[i] = minf(2.0, weights[i] + minf((attack + 1) / 2, 1.5) - 1);
    }
    if (mod.Debug) mod.Debug.log("weights", weights);

    local probsStr = array(8, "-");
    foreach (i in Rand.take(_num, [0 1 2 3 4 5 6 7], weights)) {
        local w = weights[i];
        local probs = [60 30 10];
        probs[2] *= w;           // 3 stars
        probs[1] *= (w + 1) / 2; // 2 stars
        _player.m.Talents[i] = Rand.choice([1 2 3], probs);
        if (mod.Debug) {
            local psum = probs[0] + probs[1] + probs[2];
            probsStr[i] = ::std.Str.join(".", probs.map(@(p) ::Math.round(p * 100 / psum)));
        }
    }
    if (mod.Debug) mod.Debug.log("talents probs", probsStr);
    if (mod.Debug) mod.Debug.log("talents after", talents);
}

// if(::mods_getRegisteredMod("mod_legends"))
// {
//     ::mods_hookNewObject("entity/tactical/player", function(o) {

//         local fillTalentValues = o.fillTalentValues;
//         o.fillTalentValues = function(_num, _force = false)
//         {
//             local talentmin = ::UB_GSV("MinimumTalents");
//             local talentmax = ::UB_GSV("MaximumTalents");
//             local talentchance = ::UB_GSV("TalentChance");
//             local talentignore = ::UB_GSV("IgnoreBackground");
//             local talentrandom = ::UB_GSV("RandomStartTalents");

//             local talents = talentmin + Rand.poly(talentmax - talentmin, talentchance);
//             fillTalentValues(result, talentrandom);
//         }
//     });
// }
// else
// {
::mods_hookExactClass("entity/tactical/player", function (cls) {
    local fillTalentValues = cls.fillTalentValues;
    cls.fillTalentValues = function () {
        fillTalentValues(); // Call it to consume random the same way as vanilla does

        if (this.getBackground() != null && this.getBackground().isUntalented()
            && !mod.conf("talentsRandomStart")) return;

        local min = mod.conf("talentsMin");
        local max = mod.conf("talentsMax");
        local chance = mod.conf("talentsChance");
        local num = min + Rand.poly(max - min, chance);
        mod.fillTalentValues(this, num);

        // local stats = [];

        // if(talentignore)
        // {
        //     stats = [0, 1, 2, 3, 4, 5, 6, 7];
        // }
        // else
        // {
        //     for(local i = 0; i < 8; i++)
        //     {
        //         if (this.m.Talents[i] == 0)
        //         {
        //             if (this.getBackground() != null && this.getBackground().getExcludedTalents().find(i) == null) { stats.push(i); }
        //         }
        //     }
        // }

        // local done = 0;
        // for(local i = 0; stats.len() != 0; i++)
        // {
        //     local random = this.Math.rand(0, stats.len() - 1);
        //     local stat = stats[random];
        //     this.m.Talents[stat] = Rand.choose([1 2 3], probs);
        //     stats.remove(random);

        //     done++;
        //     if(done >= talents) { break; }
        // }

    }
});


// Settings, Talents & Attributes page
local page = mod.Mod.ModSettings.addPage("Talents & Attrs");
local function add(elem) {
    page.addElement(elem);
    elem.Data.NewCampaign <- true;
    return elem;
}

// Talents
add(::MSU.Class.RangeSetting("talentsMin", 3, 0, 8, 1, "Minimum Talents",
    "A low bound on a number of talents each bro gets"));
add(::MSU.Class.RangeSetting("talentsMax", 3, 0, 8, 1, "Maximum Talents",
    "A high bound on a number of talents each bro gets"));
add(::MSU.Class.RangeSetting("talentsChance", 50, 0, 100, 1, "Talent Chance",
    "A bro will need to roll this chance to get each talent after minimum"));
// add(::MSU.Class.SettingsSpacer("talentsSpacer", "35rem", "8rem"));

add(::MSU.Class.EnumSetting("talentsExcluded", "relaxed", ["strict" "relaxed" "ignored"],
    "Excluded Talents",
    "How to treat background exclusions:\n\n" +
    Text.negative("strict") + " - never get excluded talents,\n" +
    Text.negative("relaxed") + " - get any other first, then may get excluded,\n" +
    Text.negative("ignored") + " - completely ignore the excluded list."));

add(::MSU.Class.BooleanSetting("talentsWeighted", false, "Weighted Talents",
    "Better chances to get talent in an attributes favored by background"));
local overwriteStart = add(::MSU.Class.BooleanSetting("talentsRandomStart", false,
    "Randomize Starting Talents",
    "Some company origins have preset bros.\n" +
    "If this is checked those will be rolled by Studio instead."));
// overwriteStart.Data.NewCampaignOnly <- true;
// add(::MSU.Class.SettingsSpacer("talentsSpacer", "35rem", "8rem"));
// add(::MSU.Class.BooleanSetting("starsWeighted", false, "Weighted Stars",
//     "Higher chance to get 2 or 3 stars in an attribute favored by background"));



// Attributes
add(::MSU.Class.SettingsDivider("attrsDiv"));
add(::MSU.Class.SettingsTitle("attrsTitle", "Attributes"));

add(::MSU.Class.RangeSetting("attrsUps", 3, 1, 8, 1, "Attribute Ups",
    "Amount of attribute bros allowed to raise each level-up"));
// add(::MSU.Class.SettingsSpacer("attrsSpacer", "35rem", "8rem"));

add(::MSU.Class.BooleanSetting("attrsVeteranCheck", false, "Veteran Boost",
    "Allow veterans to get more than 1 sometimes in talented attributes"));
// add(::MSU.Class.RangeSetting("attrsVeteran", 3, 2, 5, 1, "Veteran Divisor",
//     "Non-veterans get 0.5 per level per star on average. " +
//     "Veterans will get this times less."));

// mod.Conf.getTalentValue <- function () {
//     return 0.5 / talentDiv.getValue();
// }

// add(::MSU.Class.BooleanSetting("IgnoreBackground", false, "Ignore Background", "Disables talent restrictions on all backgrounds.\n\n[color=#FFCC00]Affects new characters.[/color]"));


// add(::MSU.Class.RangeSetting("traitsNum", 0, 0, 5, 1, "Number",
//     "Will add this number of random traits after a bro is hired"));
// add(::MSU.Class.SettingsSpacer("PerksSpacer", "35rem", "8rem"));

// add(::MSU.Class.BooleanSetting("traitsSoso", true, "Add so-so traits",
//     "Allow adding traits having both significant upsides and downsides"));
// add(::MSU.Class.BooleanSetting("traitsStupid", false, "Stupid Mode",
//     "Compensate each so-so or bad trait added with a good one"));



// ::UB_AddSetting(Page, ::MSU.Class.RangeSetting("AttributeGain", 3, 1, 8, 1, "Attribute Gain", "Amount of attribute upgrades that characters receive on level-up." + effect));
// ::UB_AddSetting(Page, ::MSU.Class.RangeSetting("PerkGain", 1, 0, 5, 1, "Perk Gain", "Amount of perk points that characters receive on level-up." + effect));

// ::UB_AddSetting(Page, ::MSU.Class.SettingsDivider("PB:Div2"));
// ::UB_AddSetting(Page, ::MSU.Class.SettingsTitle("PB:Talents", "TALENTS"));


