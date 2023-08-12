DATA_DIR = ~/.local/share/Steam/steamapps/common/Battle\ Brothers/data/
SUBDIR = scripts/\!mods_preload
SCRIPT = scripts/\!mods_preload/mod_beast_loot.nut
# TEST_SCRIPT = scripts/\!mods_preload/test_mod_vap.nut

SHELL := /bin/bash

# TODO: check for stages changes in zip and sync targets

test:
	cd $(SUBDIR);squirrel test_mod_vap.nut

zip:
	LAST_TAG=$$(git tag | grep beast-loot | tail -1); \
	MODIFIED=$$( git diff $$LAST_TAG --quiet scripts || echo _modified); \
	NAME=$$(echo $$LAST_TAG | perl -pE 's/-/_/g'); \
	FILENAME=mod_$$([[ "$$NAME" != "" ]] && echo $$NAME || echo beast_loot)$${MODIFIED}.zip; \
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

sync-force:
	cp $(DATA_DIR)$(SCRIPT) $(SCRIPT)
	cp $(DATA_DIR)$(TEST_SCRIPT) $(TEST_SCRIPT)

sync-back:
	mkdir -p $(DATA_DIR)$(SUBDIR)
	cp $(SCRIPT) $(DATA_DIR)$(SCRIPT)
