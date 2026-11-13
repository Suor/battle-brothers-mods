// mode: menu
// `typeof x = y` in a condition (mod_legends 19.4.23, hunter_building.nut:73): compiles in 3.0?
local function p( _k, _f )
{
	local v;
	try { v = _f(); } catch (e) { v = "ERROR " + e; }
	::logInfo("PROBE " + _k + " = " + typeof v + " " + v);
}
p("typeof assign compiles", @() typeof ::compilestring("local _m = 1.5; if (typeof _m = \"integer\") return \"taken\"; return \"not taken\";"));
p("typeof assign result", @() ::compilestring("local _m = 1.5; if (typeof _m = \"integer\") return \"taken\"; return \"not taken\";")());
