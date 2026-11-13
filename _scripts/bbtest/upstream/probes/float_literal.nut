// mode: menu
// A float literal against the same number parsed from a string (Modern Hooks compares versions this way).
local function p( _k, _f )
{
	local v;
	try { v = _f(); } catch (e) { v = "ERROR " + e; }
	::logInfo("PROBE " + _k + " = " + typeof v + " " + v);
}
p("2.6 == \"2.6\".tofloat()", @() 2.6 == "2.6".tofloat());
p("2.5 == \"2.5\".tofloat()", @() 2.5 == "2.5".tofloat());
p("\"2.6\".tofloat() - 2.6", @() "2.6".tofloat() - 2.6);
p("2.6 ge \"2.6\".tofloat()", @() 2.6 >= "2.6".tofloat());
