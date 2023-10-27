MOD_NAME = standout_enemies
TAG_NAME = standout-enemies
SOURCES = scripts
SUBDIR = scripts/\!mods_preload
STDLIB_DIR = ../../bbm/stdlib

include ../Makefile.common

test: check-compile
	cp -r $(STDLIB_DIR)/scripts .; \
	cp -r $(STDLIB_DIR)/stdlib .; \
	squirrel test.nut; \
	cd $(SUBDIR);squirrel test_mod_standout_enemies.nut; cd ../..; \
	rm -rf stdlib; \
	rm scripts/!mods_preload/!stdlib.nut

