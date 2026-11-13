// mode: menu
// World.getRoster of an id no roster has: null, or an error? (`getRoster(id) || createRoster(id)` idiom.)
// Draft, not run yet as a probe. bbtest saw `the index '9999' does not exist` raised in the original (campaign).
local function p( _k, _f )
{
	local v;
	try { v = _f(); } catch (e) { v = "ERROR " + e; }
	::logInfo("PROBE " + _k + " = " + typeof v + " " + v);
}
p("getRoster unknown id", @() ::World.getRoster(9999));
