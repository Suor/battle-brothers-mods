import re

def extract_pairs(path):
    text = open(path).read()
    pairs = {}
    for m in re.finditer(r'en\s*=\s*"([^"]+)"[^}]*?ru\s*=\s*"([^"]+)"|ru\s*=\s*"([^"]+)"[^}]*?en\s*=\s*"([^"]+)"', text):
        if m.group(1):
            pairs[m.group(1)] = m.group(2)
        else:
            pairs[m.group(4)] = m.group(3)
    return pairs

rosetta = extract_pairs("nicknames/rosetta_ru.nut")
titles_en = set(extract_pairs("nicknames/titles.nut").keys())

missing = {en: ru for en, ru in rosetta.items() if en not in titles_en}
for en, ru in sorted(missing.items()):
    print(f"{ru} / {en}")
