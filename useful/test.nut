function startswith(s, sub) {
    if (s.len() < sub.len()) return false;
    return s.slice(0, sub.len()) == sub;
}
::include <- function (script) {
    if (startswith(script, "stdlib")) script = "../../bbm/stdlib/" + script;
    return dofile(script + ".nut", true)
}
dofile("../../bbm/stdlib/scripts/!mods_preload/!stdlib.nut", true);
dofile("../../bbm/stdlib/tests/mocks.nut", true);
dofile("mocks.nut", true);
dofile("scripts/!mods_preload/z_useful.nut", true);

print("Tests OK\n");
