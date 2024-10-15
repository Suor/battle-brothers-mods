::Hooks <- {
    function getMod(_id) {
        return {
            ID = _id
            function hook(_path, _func) {}
        }
    }
};
::logInfo <- function (_text) {print(_text + "\n")}

dofile("autopilot/debug.nut", true);

::actor <- {
    Name = "Lex"
    function getName() {return this.Name}
    function isAlive() {return true}
};
local aref = ActorRef(actor);
print(aref.isAlive() + "\n");
