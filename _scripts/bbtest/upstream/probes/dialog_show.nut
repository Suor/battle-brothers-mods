// mode: menu
// DialogScreen.show: is the screen animating right after the call (the page answered inline) or only a frame later?
local function p( _k, _f )
{
	local v;
	try { v = _f(); } catch (e) { v = "ERROR " + e; }
	::logInfo("PROBE " + _k + " = " + typeof v + " " + v);
}
::DialogScreen.show("probe", "probe", null);
p("dialog animating after show", @() ::DialogScreen.isAnimating());
p("dialog visible after show", @() ::DialogScreen.isVisible());
::Time.scheduleEvent(::TimeUnit.Real, 1, function ( _ ) {
	p("dialog animating next frame", @() ::DialogScreen.isAnimating());
}, null);
