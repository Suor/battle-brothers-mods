MOD_NAME = bro_studio
TAG_NAME = bro-studio
SOURCES = bro_studio scripts ui
SUBDIR = scripts/\!mods_preload
STDLIB_DIR = ../../bbm/stdlib

SHELL := /bin/bash

include ../Makefile.common

test:
	@cp -r $(STDLIB_DIR)/scripts .; \
	cp -r $(STDLIB_DIR)/stdlib .; \
	squirrel test.nut; \
	rm -rf stdlib; \
	rm scripts/!mods_preload/!stdlib.nut
