// ::mods_hookExactClass("states/world_state", function (o)
// {
// 	local onBeforeDeserialize = o.onBeforeDeserialize;
// 	// _out
// 	o.onBeforeDeserialize = function( ... )
// 	{
// 		vargv.insert(0, this);
// 		::CareerStats.IsLoading = true;
// 		return onBeforeDeserialize.acall(vargv);
// 	}

// 	local onDeserialize = o.onDeserialize;
// 	// _in
// 	o.onDeserialize = function( ... )
// 	{
// 		vargv.insert(0, this);
// 		local ret = onDeserialize.acall(vargv);
// 		::CareerStats.IsLoading = false;
// 		::CareerStats.evaluateRanks();
// 		return ret;
// 	}

// 	local startNewCampaign = o.startNewCampaign;
// 	o.startNewCampaign = function(...)
// 	{
// 		vargv.insert(0, this);
// 		::CareerStats.IsLoading = true;
// 		local ret = startNewCampaign.acall(vargv);
// 		::CareerStats.IsLoading = false;
// 		::CareerStats.evaluateRanks();
// 		return ret;
// 	}
// });
