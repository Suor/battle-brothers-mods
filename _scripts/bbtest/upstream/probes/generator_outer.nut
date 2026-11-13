// mode: menu
// A closure made inside a generator reads the generator's local: before the generator yields, and after.
local function p( _k, _f )
{
	local v;
	try { v = _f(); } catch (e) { v = "ERROR " + e; }
	::logInfo("PROBE " + _k + " = " + typeof v + " " + v);
}
local function gen()
{
	local x = 5;
	local f = @() x;
	yield f();
	yield f();
}
local g = gen();
p("closure in generator before yield", @() resume g);
p("closure in generator after yield", @() resume g);
