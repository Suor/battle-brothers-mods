DATA_DIR = ~/.local/share/Steam/steamapps/common/Battle\ Brothers/data/

SHELL := /bin/bash

# TODO: check for stages changes in zip and sync targets

zip:
	LAST_TAG=$$(git tag | grep autopilot | tail -1); \
	HEAD_SHA=$$(git rev-parse HEAD); \
	TAG_SHA=$$(git rev-parse $$LAST_TAG); \
	MODIFIED=$$( ([[ $$HEAD_SHA = $$TAG_SHA ]] && git diff --quiet scripts) || echo _MODIFIED); \
	NAME=$$(echo $$LAST_TAG | perl -pE 's/-/_/g' || echo autopilot); \
	FILENAME=mod_$$([[ "$$NAME" != "" ]] && echo $$NAME || echo autopilot)$${MODIFIED}.zip; \
	rm $${FILENAME}; \
	zip -r $${FILENAME} scripts gfx ui

