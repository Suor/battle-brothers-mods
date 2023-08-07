// ::mods_hookExactClass("states/tactical_state", function (o)
// {
// 	local gatherBrothers = o.gatherBrothers;
// 	// _isVictory
// 	o.gatherBrothers = function( ... )
// 	{
// 		vargv.insert(0, this);
// 		local ret = gatherBrothers.acall(vargv);
// 		::FunFacts.evaluateRanks();
// 		return ret;
// 	}
// });
