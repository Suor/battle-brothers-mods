local Debug = ::std.Debug.with({prefix = "bp: ", width = 160});
::BgPerks <- {
    ID = "mod_background_perks"
    Name = "Background Perks"
    Version = 0.1
};
::BgPerks.chances <- {
    ALL = {"student": 1 "gifted": 4 "hold_out": 4 "relentless": 4}

    adventurous_noble = {
        "hold_out": 5
        "shield_expert": 5
        "brawny": 5
        "fortified_mind": 5
        "rally_the_troops": 10
        "mastery.sword": 8
        "mastery.flail": 8
    }

    anatomist = {
        "crippling_strikes": 50
        "student": 20
        "gifted": 10
    }

    apprentice = {
        "student": 100
        "gifted": 25
    }

    assassin = {
        "mastery.dagger": 100
        "backstabber": 50
        "crippling_strikes": 25
    }

    barbarian = {
        "adrenaline": 25
        "relentless": 50
        "colossus": 15
    }

    bastard = {
        "backstabber": 20
        "hold_out": 20
        "rally_the_troops": 5
        "underdog": 5
        "relentless": 5
    }

    beast_slayer = {
        "bullseye": 15
        "mastery.throwing": 35
        "mastery.bow": 5
        "crippling_strikes": 15
        "relentless": 5
    }

    beggar = {
        "underdog": 100,
        "nine_lives": 10
        "bags_and_belts": 10
    }

    belly_dancer = {
        "dodge": 100
        "nimble": 35
        "quick_hands": 5
    }

    bowyer = {
        "bullseye": 25
        "quick_hands": 25
        "mastery.bow": 5
    }

    brawler = {
        "taunt": 20
        "overwhelm": 5
        "steel_brow": 5
        "relentless": 35
        "underdog": 10
        "mastery.mace": 10
        "dodge": 3
    }

    butcher = {
        "mastery.cleaver": 50
        "coup_de_grace": 20
        "crippling_strikes": 20
    }

    caravan_hand = {
        "bags_and_belts": 100
        "quick_hands": 10
        "colossus": 3
    }

    companion = {
        "gifted": 10
    }

    cultist = {
        "fearsome": 35
        "mastery.dagger": 25
        "relentless": 20
        "fortified_mind": 10
    }

    cripple = {
        "nine_lives": 50
        "hold_out": 25
        "underdog": 5
    }

    crusader = {
        "fearsome": 20
        "relentless": 20
        "fortified_mind": 20
        "mastery.sword": 15
        "reach_advantage": 10
    }

    daytaler = {
        "brawny": 5
        "colossus": 2
        "recover": 5
        "fast_adaption": 35
        "pathfinder": 2
    }

    deserter = {
        "dodge": 25
        "backstabber": 25
        "nine_lives": 25
        "footwork": 15
    }

    disowned_noble = {
        "rally_the_troops": 2
        "backstabber": 15
        "mastery.sword": 7
        "mastery.mace": 7
        "shield_expert": 4
        "duelist": 10
    }

    eunuch = {
        "taunt": 100
        "dodge": 10
        "nine_lives": 3
    }

    farmhand = {
        "colossus": 15
        "bags_and_belts": 5
    }

    fisherman = {
        "mastery.throwing": 20
        "quick_hands": 25
    }

    flagellant = {
        "mastery.flail": 50
        "indomitable": 5
        "relentless": 5
        "nine_lives": 3
    }

    gambler = {
        "nine_lives": 75
        "fast_adaption": 50
        "anticipation": 20
        "relentless": 10
    }

    gladiator = {
        "underdog": 15
        "coup_de_grace": 20
        "mastery.mace": 6
        "mastery.flail": 4
        "mastery.hammer": 2
        "mastery.axe": 3
        "mastery.cleaver": 4
        "mastery.sword": 5
        "mastery.spear": 4
        "mastery.throwing": 5
        "shield_expert": 5
        "dodge": 5
        "reach_advantage": 3
        "lone_wolf": 3
        "fast_adaption": 2
        "nine_lives": 1
    }

    gravedigger = {
        "brawny": 50
        "fortified_mind": 3
    }

    graverobber = {
        "fortified_mind": 20
        "lone_wolf": 70
    }

    hedge_knight = {
        "fearsome": 20
        "battle_forged": 50
        "brawny": 25
    }

    historian = {
        "student": 100
        "gifted": 25
        "underdog": 10
    }

    houndmaster = {
        "underdog": 40
        "relentless": 30
        "lone_wolf": 10
    }

    hunter = {
        "bullseye": 18
        "mastery.bow": 5
        "mastery.crossbow": 3
    }

    juggler = {
        "quick_hands": 100
        "nimble": 15
        "dodge": 25
        "anticipation": 5
        "head_hunter": 5
    }

    killer_on_the_run = {
        "duelist": 90
        "adrenaline": 40
        "relentless": 10
        "head_hunter": 15
        "killing_frenzy": 2
    }

    lumberjack = {
        "brawny": 15
        "mastery.axe": 50
        "colossus": 10
    }

    manhunter = {
        "pathfinder": 20
        "fearsome": 40
        "mastery.flail": 10
    }

    mason = {
        "student": 10
        "recover": 2
        "brawny": 35
        "mastery.hammer": 5
    }

    messenger = {
        "recover": 5
        "pathfinder": 50
        "footwork": 5
        "bags_and_belts": 5
    }

    militia = {
        "mastery.polearm": 15
        "mastery.spear": 15
        "shield_expert": 10
        "rotation": 50
        "steel_brow": 5
        "recover": 3
    }

    miller = {
        "brawny": 10
        "colossus": 25
        "recover": 5
    }

    miner = {
        "mastery.hammer": 50
        "steel_brow": 60
        "hold_out": 25
    }

    minstrel = {
        "taunt": 80
        "rally_the_troops": 25
        "student": 25
        "fortified_mind": 30
    }

    monk = {
        "fortified_mind": 100
        "student": 10
    }

    nomad = {
        "pathfinder": 33
        "nine_lives": 10
        "colossus": 10
        "recover": 5
        "rotation": 5
    }

    orc_slayer = {
        "fearsome": 20
        "relentless": 20
        "fortified_mind": 20
        "mastery.hammer": 10
    }

    // oathtaker
    paladin =  {
        "fortified_mind": 50
        "relentless": 15
        "hold_out": 15
        "steel_brow": 15
        "student": 10
        "fast_adaption": 3
    }

    peddler = {
        "quick_hands": 50
        "throwing": 10
        "bags_and_belts": 10
    }

    pimp = {
        "underdog": 100
        "crippling_strikes": 10
    }

    poacher = {
        "nimble": 35
        "bullseye": 12
        "quick_hands": 10
        "mastery.bow": 5
        "mastery.crossbow": 3
        "mastery.throwing": 3
    }

    raider = {
        "mastery.mace": 2
        "mastery.flail": 2
        "mastery.hammer": 2
        "mastery.axe": 4
        "mastery.cleaver": 1
        "mastery.sword": 4
        "mastery.polearm": 3
        "mastery.spear": 2
        "mastery.crossbow": 1
        "underdog": 4
        "crippling_strikes": 10
        "backstabber": 10
    }

    ratcatcher = {
        "underdog": 25
        "pathfinder": 25
        "nimble": 10
        "footwork": 25
    }

    refugee = {
        "pathfinder": 100
        "recover": 20
        "lone_wolf": 2
    }

    retired_soldier = {
        "lone_wolf": 25
        "rotation": 100
        "mastery.mace": 3
        "mastery.flail": 3
        "mastery.hammer": 3
        "mastery.axe": 3
        "mastery.cleaver": 2
        "mastery.sword": 6
        "mastery.polearm": 6
        "mastery.spear": 3
        "mastery.crossbow": 1
        "shield_expert": 5
    }

    sellsword = {
        "mastery.mace": 4
        "mastery.flail": 4
        "mastery.hammer": 4
        "mastery.axe": 5
        "mastery.cleaver": 5
        "mastery.sword": 7
        "mastery.polearm": 2
        "mastery.spear": 2
        "mastery.crossbow": 3
        "mastery.bow": 5
        "lone_wolf": 5
        "hold_out": 10
        "steel_brow": 10
    }

    servant = {
        "steel_brow": 50
        "gifted": 15
        "bags_and_belts": 10
        "quick_hands": 5
    }

    shepherd = {
        "pathfinder": 20
        "bullseye": 15
        "pathfinder": 10
    }

    slave = {
        "nine_lives": 20
        "bags_and_belts": 25
        "quick_hands": 10
        "dodge": 7
        "fast_adaption": 7
    }

    squire = {
        "student": 15
        "gifted": 7
    }

    swordmaster = {
        "mastery.sword": 100
        "duelist": 15
        "nimble": 25
        "footwork": 25
        "rotation": 5
    }

    tailor = {
        "quick_hands": 100
        "underdog": 20
        "bags_and_belts": 20
    }

    thief = {
        "quick_hands": 100
        "mastery.dagger": 25
        "crippling_strikes": 10
        "backstabber": 33
        "bags_and_belts": 10
    }

    vagabond = {
        "pathfinder": 50
        "recover": 20
        "footwork": 20
        "colossus": 7
    }

    wildman = {
        "berserk": 5
        "killing_frenzy": 5
        "hold_out": 10
        "adrenaline": 50
        "relentless": 7
        "colossus": 7
    }

    witchhunter = {
        "bullseye": 14
        "fortified_mind": 10
        "mastery.crossbow": 25
        "lone_wolf": 10
    }
}
::BgPerks.chances.assassin_southern <- ::BgPerks.chances.assassin;
::BgPerks.chances.crucified <- ::BgPerks.chances.crusader;


::mods_registerMod(::BgPerks.ID, ::BgPerks.Version, ::BgPerks.Name);
::mods_queue(::BgPerks.ID, "mod_hooks(>=19)", function() {

::mods_hookNewObject("entity/tactical/player", function ( o ) {
    local baseSetStartValuesEx = o.setStartValuesEx;
    o.setStartValuesEx = function ( _backgrounds ) {
        local scale = 1.0 + Math.maxf(0, Math.minf(1, this.World.getTime().Days / 100.0));
        if (::mods_getRegisteredMod("mod_stupid_game")) scale += 1.0;
        // this.logInfo("bp: " + this.getName() + " scale " + scale);

        // function unlockPerkBasedOnBackground( _perk, _chance = 100 ) {
        //     if (this.hasPerk(_perk)) return;

        //     local r = this.Math.rand(1, 100);
        //     local chance = Math.pow(_chance * 0.01, 1 / scale) * 100;
        //     this.logInfo("bp: " + this.getName() + " unlocks " + _perk + (r <= chance ? " YES": "")
        //          + " raw_chance=" + _chance + " chance=" + chance + " roll=" + r);
        //     if (r <= chance) this.unlockPerk(_perk);
        // }

        baseSetStartValuesEx(_backgrounds);
        local originalPerkPoints = this.m.PerkPoints;
        local background = this.m.Background;
        this.logInfo("bp: *** Rollling " + this.getName() + " background " + background.getID()
                + " scale " + scale);

        // Look up chances and add common ones
        local background_key = background.getID().slice("background.".len());
        local chances = clone ::BgPerks.chances[background_key];
        foreach (key, value in ::BgPerks.chances.ALL) {
            if (!(key in chances)) chances[key] <- 0;
            chances[key] += value;
        }

        // Scale chances
        local report = {};
        foreach (key, value in chances) {
            chances[key] = Math.floor(Math.pow(value * 0.01, 1.0 / scale) * 100);
            report[key] <- chances[key] + " (" + value + ")";
        }

        // Roll
        local perks = [];
        foreach (key, value in chances) {
            local r = this.Math.rand(1, 100);
            report[key] += " ... " + r;
            if (r <= value) {
                perks.push(key);
                report[key] += " SUCCESS";
            }
        }
        Debug.log("rolls", report);
        Debug.log("perks", perks);

        // Unlock them
        foreach (perk in perks) this.unlockPerk("perk." + perk);

        if (this.m.PerkPointsSpent > 0) {this.m.PerkPointsSpent = 0;}
        this.m.PerkPoints = originalPerkPoints;
    };
});

});
