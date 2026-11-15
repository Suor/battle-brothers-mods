MOD_NAME = fun_facts
TAG_NAME = fun-facts
SOURCES = fun_facts gfx scripts ui

include ../Makefile.common

check:
	@tmp=$$(mktemp -d) && cp -r fun_facts scripts $$tmp \
		&& rosetta -qc fun_facts/rosetta_ru.nut $$tmp; rc=$$?; rm -rf $$tmp; exit $$rc
