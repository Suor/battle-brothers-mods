::mods_hookExactClass("states/tactical_state", function (o) {
    // local gatherBrothers = o.gatherBrothers;
    // // _isVictory
    // o.gatherBrothers = function( ... )
    // {
    //     vargv.insert(0, this);
    //     local ret = gatherBrothers.acall(vargv);
    //     ::FunFacts.evaluateRanks();
    //     return ret;
    // }

    local onBattleEnded = o.onBattleEnded;
    o.onBattleEnded = function() {
        local playerRoster = this.World.getPlayerRoster().getAll();
        foreach (bro in playerRoster) {
            if (!this.m.StrategicProperties.IsUsingSetPlayers && bro.getPlaceInFormation() > 17) {
                bro.m.FunFacts.onCombatSkipped(bro);
            }
        }
        onBattleEnded();
        ::FunFacts.incrBattleId();
    }
})
