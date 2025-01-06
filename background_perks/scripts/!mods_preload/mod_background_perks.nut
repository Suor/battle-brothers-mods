::BgPerks <- {
    ID = "mod_background_perks"
    Name = "Starting Perks by Background"
    Version = "2.6.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/661"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/background_perks"
        tagPrefix = "background-perks-"
    }

    Debug = false // requires stdlib
    WarnOnUnlockFailure = true
}

local mod = ::Hooks.register(::BgPerks.ID, ::BgPerks.Version, ::BgPerks.Name);

// Expose this function so that it could be called externally or patched
function BgPerks::giveFreePerks(_player) {
    local scale = 1.0 + 0.5 * Math.maxf(0, Math.minf(1, World.getTime().Days / 100.0));
    if (::Hooks.hasMod("mod_stupid_game")) scale += 0.5;

    local background_key = _player.m.Background.getID().slice("background.".len());

    // Look up chances and add common ones
    local chances = background_key in BgPerks.chances
        ? clone ::BgPerks.chances[background_key] : {};
    foreach (key, value in ::BgPerks.chances.ALL) {
        if (!(key in chances)) chances[key] <- 0;
        chances[key] += value;
    }

    // Scale chances
    local report = {};
    foreach (key, value in chances) {
        chances[key] = Math.floor(Math.pow(value * 0.01, 1.0 / scale) * 100);
        report[key] <- value + " -> " + chances[key];
    }

    // Roll
    local perks = [];
    foreach (key, value in chances) {
        local r = Math.rand(1, 100);
        report[key] += " ... " + r;
        if (r <= value) {
            perks.push(key);
            report[key] += " SUCCESS";
        }
    }

    if (::BgPerks.Debug) {
        local Debug = ::std.Debug.with({prefix = "bp: ", width = 120});
        this.logInfo("bp: *** Rollling " + _player.getName() + " background " + background_key
                + " scale " + scale);
        Debug.log("rolls", report);
        Debug.log("perks", perks);
    }

    local dynPerks = ::Hooks.hasMod("mod_dynamic_perks");

    local perkPoints = _player.m.PerkPoints, perkPointsSpent = _player.m.PerkPointsSpent;
    local perkTier = dynPerks ? _player.getPerkTier() : null;

    // Unlock them
    local function canAddPerk(_perk) {
        local id = "perk." + _perk;
        return (dynPerks && _player.getPerkTree().hasPerk(id) || !dynPerks) && !_player.hasPerk(id)
    }
    local function arrayFirst(_array, _test) {
        foreach (item in _array) if (_test(item)) return item;
        return null;
    }

    foreach (perk in perks) {
        local suffix = " \"" + perk + "\" for " + _player.getName();
        if (!canAddPerk(perk)) {
            local fallback = null;
            if (perk in BgPerks.fallbacks) {
                fallback = arrayFirst(BgPerks.fallbacks[perk], canAddPerk);
            }
            if (fallback == null) {
                if (::BgPerks.Debug)
                    ::logInfo("bp: skipping missing perk" + suffix);
                continue;
            }
            if (::BgPerks.Debug)
                ::logInfo("bp: adding perk \"" + fallback + "\" instead of" + suffix);
            perk = fallback;
        }
        local ok = _player.unlockPerk("perk." + perk);
        if (!ok && ::BgPerks.WarnOnUnlockFailure)
            logWarning("bp: failed to unlock perk" + suffix)
    }

    _player.m.PerkPointsSpent = perkPointsSpent;
    _player.m.PerkPoints = perkPoints;
    if (dynPerks) _player.setPerkTier(perkTier);
}

local starting = false;

mod.queue(">mod_reforged", function () {
    ::include("background_perks/chances");
    ::include("background_perks/fallbacks");

    // On setting up a new campaign all sort of things are hard coded,  typical is to  call
    // .setStartValuesEx() and assign LevelUps and call .fillAttributeLevelUpValues() later,
    // which breaks Gifted
    mod.hook("scripts/states/world_state", function (q) {
        q.startNewCampaign = @(__original) function () {
            starting = true;
            __original();
            starting = false;
            local roster = World.getPlayerRoster().getAll();
            foreach (bro in roster) ::BgPerks.giveFreePerks(bro);
        }
    });
})

// Need to move it to "very late" because dynamic perk trees are only build there
mod.queue(">mod_reforged", function() {
    mod.hook("scripts/entity/tactical/player", function (q) {
        logInfo("bp: setting setStartValuesEx")
        q.setStartValuesEx = @(__original) function (_backgrounds, _addTraits = true) {
            logInfo("bp: set setStartValuesEx, starting = " + starting);
            __original(_backgrounds, _addTraits);
            if (!starting) ::BgPerks.giveFreePerks(this);
        };
        logInfo("bp: set setStartValuesEx")
    });
    logInfo("bp: set hook")
}, ::Hooks.QueueBucket.VeryLate)

mod.queue(">msu", function () {
    if (!("MSU" in getroottable())) return;
    ::include("scripts/i_background_perks_hack_msu");
    ::HackMSU.setup(::BgPerks, ::BgPerks.Updates);
});
