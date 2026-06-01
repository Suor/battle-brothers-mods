dofile("../mocks.nut", true);

::logInfo <- function (_text) {print(_text + "\n")}

dofile("autopilot/fixes.nut", true);

::actor <- {
    Name = "Lex"
    function getName() {return this.Name}
    function isAlive() {return true}
};
local aref = ActorRef(actor);
assert(aref.isAlive());

::logWarning <- function (_text) {}
::actor <- null;
for (local i = 0; i < 1; i++) {time()} // Some time for gc
assert(!aref.isAlive());

// Load after the weakref GC check above (it's timing-sensitive); this just asserts every
// behavior hook registers without tripping over the mock (e.g. q.m.PossibleSkills reads).
dofile("autopilot/better_behavior.nut", true);

print("Tests OK\n");
