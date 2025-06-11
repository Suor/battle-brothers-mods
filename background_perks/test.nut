dofile("../mocks.nut", true);
dofile("scripts/!mods_preload/mod_background_perks.nut", true);

local background = {
    ID = "background.brawler"
    function getID() {return this.ID}
}
local player = {
    m = {
        Background = background
        PerkPoints = 0
        PerkPointsSpent = 0
    }
    function getName() {return "Hackflow"}
    function hasPerk(_id) {return false}
    function unlockPerk(_id) {return true}
    // dynamic perks
    function getPerkTier() {return 0}
    function setPerkTier(_val) {}
    function getPerkTree() {
        return {
            function hasPerk(_id) {return true}
        }
    }
}

::std.rng.reset(3);
BgPerks.giveFreePerks(player);

::std.rng.reset(3);
local player2 = {
    function getPerkTree() {
        return {function hasPerk(_id) {return _id != "perk.relentless"}}
    }
}.setdelegate(player);
BgPerks.giveFreePerks(player2);

print("Tests OK\n");
