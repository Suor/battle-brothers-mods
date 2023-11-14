SHELL := /bin/bash

.ONESHELL:
check-compile:
	@set -e;
	for d in */ ; do
		if [ "$$d" == "__pycache__/" ]; then
			continue
		fi
		echo ">>> $$d";
		make check-compile -sC $$d;
	done

cl:
	@set -e;
	for d in */ ; do
		if [ "$$d" == "__pycache__/" ]; then
			continue
		fi
		echo ">>> $$d";
		git log --pretty='%s %C(yellow)%d%Creset' $$d \
			| perl -pe "exit if /\(tag:/;"
	done

