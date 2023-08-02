::mods_registerMod("mod_background_perks", 0.1, "Background Perks");
::mods_queue("mod_background_perks", "mod_hooks(>=19)", function() {

::mods_hookNewObject("entity/tactical/player", function ( o ) {
    local baseSetStartValuesEx = o.setStartValuesEx;
    o.setStartValuesEx = function ( _backgrounds ) {
        local scale = 1.0 + Math.minf(0, Math.maxf(1, this.World.getTime().Days / 50));

        function unlockPerkBasedOnBackground( _perk, _chance = 100 ) {
            if (this.hasPerk(_perk)) return;

            local r = this.Math.rand(1, 100);
            local chance = Math.pow(_chance * 0.01, 1 / scale) * 100;
            this.logInfo("bp: " + this.getName() + " unlocks " + _perk + (r <= chance ? " YES": "")
                 + " raw_chance=" + _chance + " chance=" + chance + " roll=" + r);
            if (r <= chance) this.unlockPerk(_perk);
        }

        baseSetStartValuesEx(_backgrounds);
        local originalPerkPoints = this.m.PerkPoints;
        local background = this.m.Background;
        this.logInfo("bp: Rollling " + this.getName() + " background " + background.getID());
        this.unlockPerkBasedOnBackground("perk.gifted", 4);
        this.unlockPerkBasedOnBackground("perk.hold_out", 4);
        this.unlockPerkBasedOnBackground("perk.adrenaline", 2);
        this.unlockPerkBasedOnBackground("perk.relentless", 4);

        if (background.getID() == "background.adventurous_noble")
        {
            this.unlockPerkBasedOnBackground("perk.hold_out", 5);
            this.unlockPerkBasedOnBackground("perk.shield_expert", 5);
            this.unlockPerkBasedOnBackground("perk.rally_the_troops", 10);
            this.unlockPerkBasedOnBackground("perk.mastery.sword", 8);
        }

        if (background.getID() == "background.apprentice")
        {
            this.unlockPerkBasedOnBackground("perk.student");
            this.unlockPerkBasedOnBackground("perk.gifted", 15);
        }

        if (background.getID() == "background.assassin")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.dagger");
            this.unlockPerkBasedOnBackground("perk.backstabber", 50);
        }

        if (background.getID() == "background.barbarian")
        {
            this.unlockPerkBasedOnBackground("perk.adrenaline", 50);
            this.unlockPerkBasedOnBackground("perk.relentless", 50);
        }

        if (background.getID() == "background.bastard")
        {
            this.unlockPerkBasedOnBackground("perk.backstabber", 20);
            this.unlockPerkBasedOnBackground("perk.hold_out", 20);
            this.unlockPerkBasedOnBackground("perk.rally_the_troops", 5);
            this.unlockPerkBasedOnBackground("perk.underdog", 5);
            this.unlockPerkBasedOnBackground("perk.relentless", 5);
        }

        if (background.getID() == "background.beast_slayer")
        {
            this.unlockPerkBasedOnBackground("perk.bullseye", 15);
            this.unlockPerkBasedOnBackground("perk.mastery.throwing", 35);
            this.unlockPerkBasedOnBackground("perk.mastery.bow", 5);
            this.unlockPerkBasedOnBackground("perk.crippling_strikes", 15);
            this.unlockPerkBasedOnBackground("perk.relentless", 5);
        }

        if (background.getID() == "background.beggar")
        {
            this.unlockPerkBasedOnBackground("perk.underdog");
        }

        if (background.getID() == "background.bowyer")
        {
            this.unlockPerkBasedOnBackground("perk.bullseye", 15);
            this.unlockPerkBasedOnBackground("perk.quick_hands", 25);
            this.unlockPerkBasedOnBackground("perk.mastery.bow", 5);
        }

        if (background.getID() == "background.brawler")
        {
            this.unlockPerkBasedOnBackground("perk.taunt", 20);
            this.unlockPerkBasedOnBackground("perk.overwhelm", 5);
            this.unlockPerkBasedOnBackground("perk.steel_brow", 5);
            this.unlockPerkBasedOnBackground("perk.relentless", 35);
        }

        if (background.getID() == "background.butcher")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.cleaver", 50);
            this.unlockPerkBasedOnBackground("perk.coup_de_grace", 20);
            this.unlockPerkBasedOnBackground("perk.crippling_strikes", 20);
        }

        if (background.getID() == "background.caravan_hand")
        {
            this.unlockPerkBasedOnBackground("perk.bags_and_belts");
        }

        if (background.getID() == "background.companion")
        {
            this.unlockPerkBasedOnBackground("perk.gifted", 10);
        }

        if (background.getID() == "background.cultist")
        {
            this.unlockPerkBasedOnBackground("perk.fearsome", 35);
            this.unlockPerkBasedOnBackground("perk.relentless", 20);
        }

        if (background.getID() == "background.cripple")
        {
            this.unlockPerkBasedOnBackground("perk.nine_lives", 50);
            this.unlockPerkBasedOnBackground("perk.hold_out", 25);
            this.unlockPerkBasedOnBackground("perk.underdog", 5);
        }

        if (background.getID() == "background.crusader")
        {
            this.unlockPerkBasedOnBackground("perk.fearsome", 20);
            this.unlockPerkBasedOnBackground("perk.relentless", 20);
            this.unlockPerkBasedOnBackground("perk.fortified_mind", 20);
            this.unlockPerkBasedOnBackground("perk.mastery.sword", 10);
        }

        if (background.getID() == "background.daytaler")
        {
            this.unlockPerkBasedOnBackground("perk.brawny", 5);
            this.unlockPerkBasedOnBackground("perk.colossus", 2);
            this.unlockPerkBasedOnBackground("perk.recover", 5);
            this.unlockPerkBasedOnBackground("perk.fast_adaption", 35);
        }

        if (background.getID() == "background.deserter")
        {
            this.unlockPerkBasedOnBackground("perk.dodge", 25);
            this.unlockPerkBasedOnBackground("perk.backstabber", 25);
            this.unlockPerkBasedOnBackground("perk.nine_lives", 25);
        }

        if (background.getID() == "background.disowned_noble")
        {
            this.unlockPerkBasedOnBackground("perk.rally_the_troops", 2);
            this.unlockPerkBasedOnBackground("perk.backstabber", 40);
            this.unlockPerkBasedOnBackground("perk.mastery.sword", 8);
        }

        if (background.getID() == "background.eunuch")
        {
            this.unlockPerkBasedOnBackground("perk.taunt");
        }

        if (background.getID() == "background.farmhand")
        {
            this.unlockPerkBasedOnBackground("perk.colossus", 15);
        }

        if (background.getID() == "background.fisherman")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.throwing", 20);
            this.unlockPerkBasedOnBackground("perk.quick_hands", 25);
        }

        if (background.getID() == "background.flagellant")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.flail", 50);
            this.unlockPerkBasedOnBackground("perk.indomitable", 5);
            this.unlockPerkBasedOnBackground("perk.relentless", 5);
        }

        if (background.getID() == "background.gambler")
        {
            this.unlockPerkBasedOnBackground("perk.nine_lives");
            this.unlockPerkBasedOnBackground("perk.fast_adaption", 50);
            this.unlockPerkBasedOnBackground("perk.anticipation", 10);
        }

        if (background.getID() == "background.gravedigger")
        {
            this.unlockPerkBasedOnBackground("perk.brawny", 50);
        }

        if (background.getID() == "background.graverobber")
        {
            this.unlockPerkBasedOnBackground("perk.fortified_mind", 20);
            this.unlockPerkBasedOnBackground("perk.lone_wolf", 70);
        }

        if (background.getID() == "background.hedge_knight")
        {
            this.unlockPerkBasedOnBackground("perk.fearsome", 20);
        }

        if (background.getID() == "background.historian")
        {
            this.unlockPerkBasedOnBackground("perk.student");
            this.unlockPerkBasedOnBackground("perk.underdog", 10);
        }

        if (background.getID() == "background.houndmaster")
        {
            this.unlockPerkBasedOnBackground("perk.underdog", 40);
            this.unlockPerkBasedOnBackground("perk.relentless", 30);
        }

        if (background.getID() == "background.hunter")
        {
            this.unlockPerkBasedOnBackground("perk.bullseye", 10);
            this.unlockPerkBasedOnBackground("perk.mastery.bow", 5);
        }

        if (background.getID() == "background.juggler")
        {
            this.unlockPerkBasedOnBackground("perk.quick_hands");
            this.unlockPerkBasedOnBackground("perk.nimble", 15);
            this.unlockPerkBasedOnBackground("perk.dodge", 25);
            this.unlockPerkBasedOnBackground("perk.anticipation", 5);
        }

        if (background.getID() == "background.killer_on_the_run")
        {
            this.unlockPerkBasedOnBackground("perk.duelist", 90);
            this.unlockPerkBasedOnBackground("perk.adrenaline", 40);
            this.unlockPerkBasedOnBackground("perk.relentless", 10);
        }

        if (background.getID() == "background.lumberjack")
        {
            this.unlockPerkBasedOnBackground("perk.brawny", 10);
            this.unlockPerkBasedOnBackground("perk.mastery.axe", 40);
            this.unlockPerkBasedOnBackground("perk.colossus", 5);
        }

        if (background.getID() == "background.mason")
        {
            this.unlockPerkBasedOnBackground("perk.recover", 2);
            this.unlockPerkBasedOnBackground("perk.brawny", 35);
        }

        if (background.getID() == "background.messenger")
        {
            this.unlockPerkBasedOnBackground("perk.recover", 2);
            this.unlockPerkBasedOnBackground("perk.pathfinder", 50);
        }

        if (background.getID() == "background.militia")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.polearm", 15);
            this.unlockPerkBasedOnBackground("perk.mastery.spear", 15);
            this.unlockPerkBasedOnBackground("perk.rotation", 50);
        }

        if (background.getID() == "background.miller")
        {
            this.unlockPerkBasedOnBackground("perk.brawny", 10);
            this.unlockPerkBasedOnBackground("perk.colossus", 25);
            this.unlockPerkBasedOnBackground("perk.recover", 5);
        }

        if (background.getID() == "background.miner")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.hammer", 40);
            this.unlockPerkBasedOnBackground("perk.steel_brow", 60);
            this.unlockPerkBasedOnBackground("perk.hold_out", 25);
        }

        if (background.getID() == "background.minstrel")
        {
            this.unlockPerkBasedOnBackground("perk.taunt", 80);
            this.unlockPerkBasedOnBackground("perk.rally_the_troops", 25);
            this.unlockPerkBasedOnBackground("perk.student", 25);
            this.unlockPerkBasedOnBackground("perk.fortified_mind", 30);
        }

        if (background.getID() == "background.monk")
        {
            this.unlockPerkBasedOnBackground("perk.fortified_mind");
        }

        if (background.getID() == "background.orc_slayer")
        {
            this.unlockPerkBasedOnBackground("perk.fearsome", 20);
            this.unlockPerkBasedOnBackground("perk.relentless", 20);
            this.unlockPerkBasedOnBackground("perk.fortified_mind", 20);
            this.unlockPerkBasedOnBackground("perk.mastery.hammer", 10);
        }

        if (background.getID() == "background.peddler")
        {
            this.unlockPerkBasedOnBackground("perk.quick_hands", 50);
        }

        if (background.getID() == "background.pimp")
        {
            this.unlockPerkBasedOnBackground("perk.underdog");
        }

        if (background.getID() == "background.poacher")
        {
            this.unlockPerkBasedOnBackground("perk.nimble", 35);
            this.unlockPerkBasedOnBackground("perk.bullseye", 10);
            this.unlockPerkBasedOnBackground("perk.mastery.bow", 5);
        }

        if (background.getID() == "background.raider")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.mace", 2);
            this.unlockPerkBasedOnBackground("perk.mastery.flail", 2);
            this.unlockPerkBasedOnBackground("perk.mastery.hammer", 2);
            this.unlockPerkBasedOnBackground("perk.mastery.axe", 4);
            this.unlockPerkBasedOnBackground("perk.mastery.cleaver", 1);
            this.unlockPerkBasedOnBackground("perk.mastery.sword", 4);
            this.unlockPerkBasedOnBackground("perk.mastery.polearm", 3);
            this.unlockPerkBasedOnBackground("perk.mastery.spear", 2);
            this.unlockPerkBasedOnBackground("perk.mastery.crossbow", 1);
        }

        if (background.getID() == "background.ratcatcher")
        {
            this.unlockPerkBasedOnBackground("perk.underdog", 25);
            this.unlockPerkBasedOnBackground("perk.pathfinder", 25);
            this.unlockPerkBasedOnBackground("perk.nimble", 10);
            this.unlockPerkBasedOnBackground("perk.footwork", 25);
        }

        if (background.getID() == "background.refugee")
        {
            this.unlockPerkBasedOnBackground("perk.pathfinder");
            this.unlockPerkBasedOnBackground("perk.recover", 20);
            this.unlockPerkBasedOnBackground("perk.lone_wolf", 2);
        }

        if (background.getID() == "background.retired_soldier")
        {
            this.unlockPerkBasedOnBackground("perk.lone_wolf", 25);
            this.unlockPerkBasedOnBackground("perk.rotation");
            this.unlockPerkBasedOnBackground("perk.mastery.mace", 3);
            this.unlockPerkBasedOnBackground("perk.mastery.flail", 3);
            this.unlockPerkBasedOnBackground("perk.mastery.hammer", 3);
            this.unlockPerkBasedOnBackground("perk.mastery.axe", 3);
            this.unlockPerkBasedOnBackground("perk.mastery.cleaver", 2);
            this.unlockPerkBasedOnBackground("perk.mastery.sword", 6);
            this.unlockPerkBasedOnBackground("perk.mastery.polearm", 6);
            this.unlockPerkBasedOnBackground("perk.mastery.spear", 3);
            this.unlockPerkBasedOnBackground("perk.mastery.crossbow", 1);
        }

        if (background.getID() == "background.sellsword")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.mace", 4);
            this.unlockPerkBasedOnBackground("perk.mastery.flail", 4);
            this.unlockPerkBasedOnBackground("perk.mastery.hammer", 4);
            this.unlockPerkBasedOnBackground("perk.mastery.axe", 5);
            this.unlockPerkBasedOnBackground("perk.mastery.cleaver", 5);
            this.unlockPerkBasedOnBackground("perk.mastery.sword", 5);
            this.unlockPerkBasedOnBackground("perk.mastery.polearm", 2);
            this.unlockPerkBasedOnBackground("perk.mastery.spear", 2);
            this.unlockPerkBasedOnBackground("perk.mastery.crossbow", 3);
            this.unlockPerkBasedOnBackground("perk.mastery.bow", 5);
        }

        if (background.getID() == "background.servant")
        {
            this.unlockPerkBasedOnBackground("perk.steel_brow", 50);
            this.unlockPerkBasedOnBackground("perk.gifted", 15);
            this.unlockPerkBasedOnBackground("perk.bags_and_belts", 10);
        }

        if (background.getID() == "background.shepherd")
        {
            this.unlockPerkBasedOnBackground("perk.pathfinder", 20);
            this.unlockPerkBasedOnBackground("perk.bullseye", 15);
        }

        if (background.getID() == "background.squire")
        {
            this.unlockPerkBasedOnBackground("perk.student", 10);
        }

        if (background.getID() == "background.swordmaster")
        {
            this.unlockPerkBasedOnBackground("perk.mastery.sword");
            this.unlockPerkBasedOnBackground("perk.nimble", 25);
            this.unlockPerkBasedOnBackground("perk.footwork", 25);
        }

        if (background.getID() == "background.tailor")
        {
            this.unlockPerkBasedOnBackground("perk.quick_hands");
            this.unlockPerkBasedOnBackground("perk.underdog", 20);
        }

        if (background.getID() == "background.thief")
        {
            this.unlockPerkBasedOnBackground("perk.quick_hands");
            this.unlockPerkBasedOnBackground("perk.mastery.dagger", 15);
        }

        if (background.getID() == "background.vagabond")
        {
            this.unlockPerkBasedOnBackground("perk.pathfinder", 40);
            this.unlockPerkBasedOnBackground("perk.recover", 20);
            this.unlockPerkBasedOnBackground("perk.footwork", 20);
        }

        if (background.getID() == "background.wildman")
        {
            this.unlockPerkBasedOnBackground("perk.berserk", 2);
            this.unlockPerkBasedOnBackground("perk.killing_frenzy", 2);
            this.unlockPerkBasedOnBackground("perk.adrenaline", 50);
            this.unlockPerkBasedOnBackground("perk.relentless", 5);
        }

        if (background.getID() == "background.witchhunter")
        {
            this.unlockPerkBasedOnBackground("perk.bullseye", 10);
            this.unlockPerkBasedOnBackground("perk.fortified_mind", 10);
            this.unlockPerkBasedOnBackground("perk.mastery.crossbow", 20);
        }

        if (this.m.PerkPointsSpent > 0)
        {
            this.m.PerkPointsSpent = 0;
        }

        this.m.PerkPoints = originalPerkPoints;
    };
});

});
