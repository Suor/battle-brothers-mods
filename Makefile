include .env
SHELL := /bin/bash

.ONESHELL:
check-compile:
	@set -e;
	for d in */ ; do
		if [ "$$d" == "__pycache__/" ]; then
			continue
		fi
		echo "--------------------------- $$d ---------------------------------";
		make check-compile -sC $$d;
	done

cl:
	@set -e;
	ignore=("__pycache__/" "_includes/" "tmp/" "hook_check/" "fix_reforged/"
			"mod_vap/" "stupid_game/" "camps_LPE/" "more_blood/" "renamer/")
	changed=""
	for d in */ ; do
		d=$${d%/} # Remove trailing slash from directory name
		if [[ " $${ignore[*]}" =~ "$$d" ]]; then continue; fi
		CHANGES=`git log --pretty='%s %C(yellow)%d%Creset' $$d \
			| perl -ne "exit if /\btag:/; print if /:/ && !/README|CHANGELOG|Makefile/"`
		UNCOMMITED="`git status --porcelain -- "$$d" | wc -l`"
		if [ $$UNCOMMITED != "0" ]; then changed="$$changed $$d ($$UNCOMMITED)"; fi
		if [ "$$CHANGES" == "" ]; then continue; fi
		echo "--------------------------- $$d ---------------------------------";
		echo "$$CHANGES";
	done
	echo "--------------------------- UNCOMMITED ---------------------------------";
	echo "$${changed## }"

log:
	@python3 _scripts/bb_log_errors.py

# Reinstalls the _TMP zips already in DATA_DIR whose sources changed since; a mod not installed stays so.
install:
	@set -e;
	installed=(); fresh=0;
	for d in */ ../stdlib/ ../rosetta/ ../xbe/ ../3rdparty/*/; do
		[ -f $$d/Makefile ] || continue;
		read -r name sources < <(make -s -C $$d --eval='vars: ; @echo $$(MOD_NAME) $$(SOURCES)' vars 2>/dev/null) || continue;
		zip=$$(ls $(DATA_DIR){mod_,}$${name}_TMP.zip 2>/dev/null | head -1);
		[ -n "$$zip" ] || continue;
		[ -n "$$(cd $$d && find $$sources -newer "$$zip" -type f -print -quit)" ] || { fresh=$$((fresh + 1)); continue; };
		echo "--------------------------- $$d ---------------------------------";
		make -sC $$d install;
		touch "$$zip";  # zip --filesync leaves an unchanged zip as it was
		installed+=($$(basename "$$zip"));
	done
	echo "Installed: $${installed[*]:-none}; up to date: $$fresh"

# log:
# 	perl -nE 'say for m~class="text">(.*?)</div>~g' ${LOG_FILE} | less
