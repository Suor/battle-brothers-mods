DATA_DIR = ~/.local/share/Steam/steamapps/common/Battle\ Brothers/data/

SHELL := /bin/bash

# TODO: check for stages changes in zip and sync targets

zip:
	LAST_TAG=$$(git tag | grep fun-facts | tail -1); \
	MODIFIED=$$( git diff $$LAST_TAG --quiet scripts || echo _modified); \
	NAME=$$(echo $$LAST_TAG | perl -pE 's/-/_/g'); \
	FILENAME=mod_$$([[ "$$NAME" != "" ]] && echo $$NAME || echo fun_facts)$${MODIFIED}.zip; \
	rm $${FILENAME}; \
	zip -r $${FILENAME} fun_facts scripts ui

install:
	FILENAME=mod_fun_facts_TMP.zip; \
	rm $${FILENAME}; \
	zip -r $${FILENAME} fun_facts scripts ui; \
	cp $${FILENAME} $(DATA_DIR)$${FILENAME}; \
	rm $${FILENAME}
