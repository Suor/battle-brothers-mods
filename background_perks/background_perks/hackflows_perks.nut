if (!::mods_getRegisteredMod("mod_hackflows_perks")) return;

local chances = {
    ALL = {"hackflows.flesh_on_the_bones": 1}
    assassin = {
        "hackflows.balance": 15
    }
    barbarian = {
        "hackflows.battle_flow": 10
    }
    belly_dancer = {
        "hackflows.balance": 15
    }
    brawler = {
        "hackflows.balance": 3
    }
    butcher = {
        "hackflows.bloody_harvest": 10
    }
    cripple = {
        "hackflows.flesh_on_the_bones": 9
    }
    crusader = {
        "hackflows.full_force": 10
    }
    gladiator = {
        "hackflows.flesh_on_the_bones": 4
        "hackflows.battle_flow": 3
    }
    hedge_knight = {
        "hackflows.full_force": 33
    }
    raider = {
        "hackflows.stabilized": 10
    }
    sellsword = {
        "hackflows.stabilized": 5
    }
    slave = {
        "hackflows.flesh_on_the_bones": 15
        "hackflows.balance": 7
    }
    vagabond = {
        "hackflows.flesh_on_the_bones": 4
    }
    wildman = {
        "hackflows.battle_flow": 4
    }
}


foreach (bg, perks in chances) {
    foreach (perk, chance in perks) ::BgPerks.chances[bg][perk] <- chance;
}
