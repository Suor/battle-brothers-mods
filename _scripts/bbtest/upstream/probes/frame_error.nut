// mode: menu
// An uncaught error in a script the game calls every frame: does the game go on?
// The background task (the tactical AI's onProcessAI runs as one) and a scheduled event, each throwing once.
::__probeThrown <- {task = false, event = false};
::Root.setBackgroundTaskCallback(function () {
	if (::__probeThrown.task) return;
	::__probeThrown.task = true;
	throw "probe error in the background task";
});
::Time.scheduleEvent(::TimeUnit.Real, 100, function ( _ ) {
	throw "probe error in a scheduled event";
}, null);
::Time.scheduleEvent(::TimeUnit.Real, 600, function ( _ ) {
	::Root.setBackgroundTaskCallback(null);
	::logInfo("PROBE alive after the errors = bool " + ::__probeThrown.task);
}, null);
