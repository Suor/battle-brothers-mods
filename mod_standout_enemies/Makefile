DATA_DIR = ~/.local/share/Steam/steamapps/common/Battle\ Brothers/data/
SUBDIR = scripts/\!mods_preload
SCRIPT = scripts/\!mods_preload/mod_standout_enemies.nut
TEST_SCRIPT = scripts/\!mods_preload/test_mod_standout_enemies.nut
LIB = scripts/\!mods_preload/!stdlib.nut

SHELL := /bin/bash

# TODO: check for stages changes in zip and sync targets

test:
	cd $(SUBDIR);squirrel test_mod_standout_enemies.nut

zip:
	LAST_TAG=$$(git tag | grep standout-enemies | tail -1); \
	HEAD_SHA=$$(git rev-parse HEAD); \
	TAG_SHA=$$(git rev-parse $$LAST_TAG); \
	MODIFIED=$$( ([[ $$HEAD_SHA = $$TAG_SHA ]] && git diff --quiet scripts) || echo _modified); \
	FILENAME=mod_$$(echo $$LAST_TAG | perl -pE 's/-/_/g')$${MODIFIED}.zip; \
	rm $${FILENAME}; \
	zip -r $${FILENAME} scripts

diff:
	diff $(DATA_DIR)$(SCRIPT) $(SCRIPT)

meld:
	meld $(DATA_DIR)$(SCRIPT) $(SCRIPT)

meld-test:
	meld $(DATA_DIR)$(TEST_SCRIPT) $(TEST_SCRIPT)

subl:
	subl $(DATA_DIR)$(SCRIPT)

sync:
	git diff --quiet scripts || { git diff scripts && exit 123; }; \
	cp $(DATA_DIR)$(SCRIPT) $(SCRIPT)
	cp $(DATA_DIR)$(TEST_SCRIPT) $(TEST_SCRIPT)
	cp $(DATA_DIR)$(LIB) $(LIB)

sync-force:
	cp $(DATA_DIR)$(SCRIPT) $(SCRIPT)
	cp $(DATA_DIR)$(TEST_SCRIPT) $(TEST_SCRIPT)
	cp $(DATA_DIR)$(LIB) $(LIB)
