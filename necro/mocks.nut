::logInfo <- function (_s) {
    print(_s + "\n")
}
::logWarning <- function (_s) {
    print("WARN: " + _s + "\n")
}
::Hooks <- {
    function register(_id, _version, _name) {
        return {
            function require(...) {}
            function queue(...) {}
        }
    }
    QueueBucket = {
        Late = 4
    }
}
