DATA_DIR = ~/.local/share/Steam/steamapps/common/Battle\ Brothers/data/
SUBDIR = scripts/\!mods_preload
SCRIPT = scripts/\!mods_preload/mod_standout_enemies.nut

zip:
	FILENAME=$$(git tag | grep standout-enemies | tail -1).zip; \
	rm $${FILENAME}; \
	zip -r $${FILENAME} scripts

diff:
	diff $(DATA_DIR)$(SCRIPT) $(SCRIPT)

meld:
	meld $(DATA_DIR)$(SCRIPT) $(SCRIPT)

subl:
	subl $(DATA_DIR)$(SCRIPT)

sync:
	git diff --quiet scripts || { git diff scripts && exit 123; }; \
	cp -R $(DATA_DIR)$(SUBDIR)/* ${SUBDIR}
