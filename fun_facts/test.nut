// dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile("../mocks.nut", true);
dofile(getenv("ROSETTA_DIR") + "load.nut", true);

dofile("scripts/!mods_preload/mod_fun_facts.nut", true);
dofile("fun_facts/rosetta_ru.nut", true);

print("Tests OK\n");
