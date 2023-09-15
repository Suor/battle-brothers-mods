if (!::mods_getRegisteredMod("mod_hackflows_perks")) return;

local chances = {
    ALL = {"flesh_on_the_bones": 1, "test.perk": 33}
    assassin = {
        "steadfast": 15
    }
    barbarian = {
        "battle_flow": 10
    }
    belly_dancer = {
        "steadfast": 15
    }
    brawler = {
        "steadfast": 3
    }
    butcher = {
        "bloody_harvest": 10
    }
    cripple = {
        "flesh_on_the_bones": 9
    }
    crusader = {
        "full_force": 10
    }
    gladiator = {
        "flesh_on_the_bones": 4
        "battle_flow": 3
    }
    hedge_knight = {
        "full_force": 33
    }
    raider = {
        "stabilized": 10
    }
    sellsword = {
        "stabilized": 5
    }
    slave = {
        "flesh_on_the_bones": 15
        "steadfast": 7
    }
    vagabond = {
        "flesh_on_the_bones": 4
    }
    wildman = {
        "battle_flow": 4
    }
}


foreach (bg, perks in chances) {
    foreach (perk, chance in perks) ::BgPerks.chances[bg][perk] <- chance;
}
