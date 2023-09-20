MOD_NAME = brogen
TAG_NAME = brogen
SOURCES = brogen scripts
SUBDIR = scripts/\!mods_preload
DATA_DIR = ~/.local/share/Steam/steamapps/common/Battle\ Brothers/data/
STDLIB = ../../bbm/stdlib/!!stdlib.nut

SHELL := /bin/bash

test:
	squirrel test.nut

meld-std:
	meld scripts/\!mods_preload/\!stdlib_brogen.nut ../../bbm/stdlib/\!\!stdlib.nut

zip:
	LAST_TAG=$$(git tag | grep $(TAG_NAME) | tail -1); \
	MODIFIED=$$( git diff $$LAST_TAG --quiet $(SOURCES) || echo _MODIFIED); \
	NAME=$$(echo $$LAST_TAG | perl -pE 's/-/_/g'); \
	FILENAME=mod_$$([[ "$$NAME" != "" ]] && echo $$NAME || echo $(MOD_NAME))$${MODIFIED}.zip; \
	rm $${FILENAME}; \
	cp $(STDLIB) "scripts/!!stdlib_brogen.nut"; \
	zip -r $${FILENAME} $(SOURCES); \
	rm "scripts/!!stdlib_brogen.nut";

install:
	FILENAME=mod_$(MOD_NAME)_TMP.zip; \
	rm $${FILENAME}; \
	cp $(STDLIB) "scripts/!!stdlib_brogen.nut"; \
	zip -r $${FILENAME} $(SOURCES); \
	cp $${FILENAME} $(DATA_DIR)$${FILENAME}; \
	rm "scripts/!!stdlib_brogen.nut"; \
	rm $${FILENAME}
