::BgPerks <- {
    ID = "mod_background_perks"
    Name = "Background Perks"
    Version = 2.3

    Debug = false // requires stdlib
    WarnOnUnlockFailure = true
}

::mods_registerMod(::BgPerks.ID, ::BgPerks.Version, ::BgPerks.Name);
::mods_queue(::BgPerks.ID, "mod_hooks(>=20)", function () {
    ::include("background_perks/chances");
    ::include("background_perks/hackflows_perks");
})

// Expose this function so that it could be called externally or patched
function BgPerks::giveFreePerks(_player) {
    local scale = 1.0 + 0.5 * Math.maxf(0, Math.minf(1, World.getTime().Days / 100.0));
    if (::mods_getRegisteredMod("mod_stupid_game")) scale += 0.5;

    local perkPoints = _player.m.PerkPoints, perkPointsSpent = _player.m.PerkPointsSpent;
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

    // Unlock them
    foreach (perk in perks) {
        local ok = _player.unlockPerk("perk." + perk);
        if (!ok && ::BgPerks.WarnOnUnlockFailure)
            logWarning("Failed to unlock perk \"" + perk + "\" for " + _player.getName())
    }

    _player.m.PerkPointsSpent = perkPointsSpent;
    _player.m.PerkPoints = perkPoints;
}


::mods_queue(::BgPerks.ID, "mod_hooks(>=20)", function() {
    local starting = false;
    ::mods_hookNewObject("entity/tactical/player", function ( o ) {
        local baseSetStartValuesEx = o.setStartValuesEx;
        o.setStartValuesEx = function ( _backgrounds ) {
            baseSetStartValuesEx(_backgrounds);
            if (!starting) ::BgPerks.giveFreePerks(this);
        };
    });

    // On setting up a new campaign all sort of things are hard coded,  typical is to  call
    // .setStartValuesEx() and assign LevelUps and call .fillAttributeLevelUpValues() later,
    // which breaks Gifted
    ::mods_hookExactClass("states/world_state", function (o) {
        local startNewCampaign = o.startNewCampaign;
        o.startNewCampaign = function() {
            starting = true;
            startNewCampaign();
            starting = false;
            local roster = World.getPlayerRoster().getAll();
            foreach (bro in roster) ::BgPerks.giveFreePerks(bro);
        }
    });
})
