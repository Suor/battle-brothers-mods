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
	ignore=("__pycache__/" "_includes/" "tmp/" "hook_check/" "fix_reforged/" "mod_vap/" "stupid_game/" "camps_LPE/")
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
	perl -nE 'say for m~class="text">(.*?)</div>~g' ${LOG_FILE} | less

