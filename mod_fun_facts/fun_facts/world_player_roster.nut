local getPlayerRoster = ::World.getPlayerRoster;
::World.getPlayerRoster = function() {
	local playerRoster = getPlayerRoster();

	local remove = playerRoster.remove;
	playerRoster.remove = function(_player) {
		// vargv.insert(0, this);
		if (::FunFacts.LastFallen != null) {
			::FunFacts.LastFallen.FunFacts <- _player.m.FunFacts;
			::FunFacts.LastFallen = null;
		}
		local ret = remove(_player);
		// ::FunFacts.evaluateRanks();
		return ret;
	}

	// local create = playerRoster.create;
	// // _scriptName
	// playerRoster.create = function(...)
	// {
	// 	vargv.insert(0, this);
	// 	local ret = create.acall(vargv);
	// 	::FunFacts.evaluateRanks();
	// 	return ret;
	// }

	// local clear = playerRoster.clear;
	// playerRoster.clear = function(...)
	// {
	// 	vargv.insert(0, this);
	// 	local ret = clear.acall(vargv);
	// 	::FunFacts.evaluateRanks();
	// 	return ret;
	// }

	// local add = playerRoster.add;
	// // _player
	// playerRoster.add = function(...)
	// {
	// 	vargv.insert(0, this);
	// 	local ret = add.acall(vargv);
	// 	::FunFacts.evaluateRanks();
	// 	return ret;
	// }
	return playerRoster;
}
