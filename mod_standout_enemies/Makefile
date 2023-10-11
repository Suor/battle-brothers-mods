MOD_NAME = standout_enemies
TAG_NAME = standout-enemies
SOURCES = scripts
SUBDIR = scripts/\!mods_preload
DATA_DIR = ~/.local/share/Steam/steamapps/common/Battle\ Brothers/data/
STDLIB_DIR = ../../bbm/stdlib

SHELL := /bin/bash

test:
	cp -r $(STDLIB_DIR)/scripts .; \
	cp -r $(STDLIB_DIR)/stdlib .; \
	squirrel test.nut; \
	cd $(SUBDIR);squirrel test_mod_standout_enemies.nut; cd ../..; \
	rm -rf stdlib; \
	rm scripts/!mods_preload/!stdlib.nut

zip:
	LAST_TAG=$$(git tag | grep $(TAG_NAME) | tail -1); \
	MODIFIED=$$( git diff $$LAST_TAG --quiet $(SOURCES) || echo _MODIFIED); \
	NAME=$$(echo $$LAST_TAG | perl -pE 's/-/_/g'); \
	FILENAME=mod_$$([[ "$$NAME" != "" ]] && echo $$NAME || echo $(MOD_NAME))$${MODIFIED}.zip; \
	rm $${FILENAME}; \
	zip -r $${FILENAME} $(SOURCES)

install:
	FILENAME=mod_$(MOD_NAME)_TMP.zip; \
	rm $${FILENAME}; \
	zip -r $${FILENAME} $(SOURCES); \
	cp $${FILENAME} $(DATA_DIR)$${FILENAME}; \
	rm $${FILENAME}
