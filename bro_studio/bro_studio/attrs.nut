local mod = ::BroStudio,
      Player = ::std.Player,
      Rand = ::std.Rand.using(::rng), // Use non-Math rng generator to preserve seeds better
      Array = ::std.Array, Text = ::std.Text, Util = ::std.Util;

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
page.add(::MSU.Class.SettingsSpacer("attrsVeteranSpacer", "35rem", "8rem"));

page.add(::MSU.Class.RangeSetting("attrsVeteran", 11, 11, 21, 1, "Veteran Level for Attributes"));
page.add(::BroStudio.SliderSetting("attrsVeteranBoostValue", "off", ["off" "slight" "classic" "high"],
    "Veteran Boost",
    "Allow veterans to get more than 1 sometimes in talented attributes"));
// Non-veterans get 0.5 per level per star on average,
// Veteran Boost allows to get certain fraction of it.
mod.VeteranBoostValues <- {
    off = 0
    slight = 0.5 / 5
    classic = 0.5 / 3
    high = 0.5 / 2
}
mod.getVeteranTalentValue <- function () {
    local label = mod.conf("attrsVeteranBoostValue");
    if (!(label in mod.VeteranBoostValues)) return 0;
    return mod.VeteranBoostValues[label];
}


// The meat
local isBackgroundUntalented = ::mods_getRegisteredMod("mod_legends")
    ? @(b) b.isBackgroundType(Const.BackgroundType.Untalented)
    : @(b) b.isUntalented()

mod.fillTalentValues <- function (_player, _num, _opts = null) {
    _opts = Util.extend({
        weighted = mod.conf("talentsWeighted")
        excluded = mod.conf("talentsExcluded")
        force = mod.conf("talentsRandomStart")
    }, _opts || {})

    local bg = _player.getBackground();
    if (!_opts.force && bg != null && isBackgroundUntalented(bg)) return;

    Player.rerollTalents(_player, _num, _opts);
}

mod.addAttributeLevelUpValues <- function (_player) {
    // do nothing if we have non-veteran attrs generated
    if (!mod.isVeteranAttrs(_player.m.Attributes)) return;

    local effectiveLevel = _player.m.Level - _player.m.LevelUps + 1;

    if (effectiveLevel <= mod.conf("attrsVeteran")) {
        _player.m.Attributes.clear();
        // only add one row at a time, this works as long as mod.conf("attrsVeteran") >= 11
        _player.fillAttributeLevelUpValues(1);
    } else {
        local talentValue = mod.getVeteranTalentValue();
        if (talentValue == 0) return;

        _player.m.Attributes = [[], [], [], [], [], [], [], []];
        local extra = function(t, bonus = 0) {
            local high = talentValue * 2 * t * (1 + bonus);
            return Rand.int(0, high * 100 + 99) / 100;
        }
        // Give rolls of 2+ on veteran levels to attrs with talents sometimes
        for (local i = 0; i < ::Const.Attributes.COUNT; i++) {
            local bonus = i == ::Const.Attributes.Initiative ? 0.5 : 0;
            _player.m.Attributes[i].insert(0, 1 + extra(_player.m.Talents[i], bonus));
        }
    }
}

mod.isVeteranAttrs <- function (attrs) {
    return attrs.len() == 0 || attrs[0].len() == 0 || Array.all(attrs, @(vals) vals[0] == 1)
}
