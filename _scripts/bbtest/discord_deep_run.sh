#!/bin/sh
cd ~/projects/bbm/mods/_scripts/bbtest
while IFS='	' read name params; do python discord_deep.py "$name" "$params" 40; done < discord_deep_queries.txt
