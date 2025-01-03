dofile(getenv("STDLIB_DIR") + "load.nut", true);

::Hooks <- {
    function getMod(_id) {
        return {
            // ID = _id
            function hook(_filename, _func) {
                _func({}.setdelegate({_set = @(k,v) null}))
            }
            function hookTree(_filename, _func) {
                _func({}.setdelegate({_set = @(k,v) null}))
            }
        }
    }
};
::logInfo <- function (_text) {print(_text + "\n")}

dofile("autopilot/fixes.nut", true);

::actor <- {
    Name = "Lex"
    function getName() {return this.Name}
    function isAlive() {return true}
};
local aref = ActorRef(actor);
assert(aref.isAlive());

print("Tests OK\n");
