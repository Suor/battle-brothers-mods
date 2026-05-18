#!/usr/bin/env python3
"""
Generate def.OldTitles from git diff between HEAD~1 and HEAD,
then write it into titles.nut and update rosetta_auto.nut.
"""
import re
import subprocess
import sys

TITLES_NUT = "nicknames/nicknames/titles.nut"
ROSETTA_NUT = "nicknames/nicknames/rosetta_auto.nut"

diff = subprocess.check_output(
    ["git", "diff", "HEAD~1", "HEAD", "--", TITLES_NUT],
    text=True,
)

pair_re = re.compile(r'\{ru = "([^"]+)", en = "([^"]+)"')

removed_lines = [l[1:] for l in diff.splitlines() if l.startswith("-") and not l.startswith("---")]
added_lines   = [l[1:] for l in diff.splitlines() if l.startswith("+") and not l.startswith("+++")]

removed = pair_re.findall("\n".join(removed_lines))
added   = pair_re.findall("\n".join(added_lines))

ru_to_new_en = {ru: en for ru, en in added}

old_titles = []
seen_en = set()
for ru, old_en in removed:
    new_en = ru_to_new_en.get(ru)
    if new_en and old_en != new_en and old_en not in seen_en:
        old_titles.append((old_en, ru))
        seen_en.add(old_en)

if not old_titles:
    print("No changed titles found.", file=sys.stderr)
    sys.exit(1)

print(f"Found {len(old_titles)} old title mappings.", file=sys.stderr)

# Build Squirrel block
lines = ["", "", "def.OldTitles <- ["]
for en, ru in old_titles:
    lines.append(f'    {{ru = "{ru}", en = "{en}"}}')
lines.append("];")
old_titles_block = "\n".join(lines)

# --- Update titles.nut ---
with open(TITLES_NUT, "r", encoding="utf-8") as f:
    content = f.read()

# Remove any existing def.OldTitles block first (idempotent)
content = re.sub(r'\ndef\.OldTitles <- \[.*?\];', '', content, flags=re.DOTALL)

# Insert after def.Titles <- [...];
content = re.sub(r'(^def\.Titles <- \[.*?^\];)', r'\1' + old_titles_block, content,
                 flags=re.MULTILINE | re.DOTALL)

with open(TITLES_NUT, "w", encoding="utf-8") as f:
    f.write(content)

print(f"Updated {TITLES_NUT}", file=sys.stderr)

# --- Update rosetta_auto.nut ---
OLD_TITLES_EXTEND = "pairs.extend(::Nicknames.OldTitles);"

ROSETTA_ANCHOR = '''\
foreach (entry in ::Nicknames.Titles) {
    local names = "names" in entry ? entry.names : [{en = entry.en, ru = entry.ru}];
    foreach (name in names)
        pairs.push({en = name.en, ru = name.ru});
}'''

with open(ROSETTA_NUT, "r", encoding="utf-8") as f:
    rosetta = f.read()

# Remove existing OldTitles line (idempotent)
rosetta = rosetta.replace("\n" + OLD_TITLES_EXTEND, "")

if ROSETTA_ANCHOR not in rosetta:
    print(f"ERROR: could not find expected pattern in {ROSETTA_NUT}", file=sys.stderr)
    sys.exit(1)

rosetta = rosetta.replace(ROSETTA_ANCHOR, ROSETTA_ANCHOR + "\n" + OLD_TITLES_EXTEND)

with open(ROSETTA_NUT, "w", encoding="utf-8") as f:
    f.write(rosetta)
print(f"Updated {ROSETTA_NUT}", file=sys.stderr)
