#!/usr/bin/env python3
"""Probability calculator for nicknames factor combinations.

Estimates the probability that a freshly generated recruit gets all the given
factors (see mod_nicknames.nut buildFactorSet). Models:

- background pick: uniform from per-settlement DraftList (vanilla), averaged
  over all settlement types; XBE additions per settlement + its 35% folk_hero
  push are included with mods=['xbe'].
- buildings and attached locations: each settlement's addBuilding() /
  buildAttachedLocation() calls are parsed with expected counts — branch
  probability from `if (Math.rand(1, 100) <= N)` chains, 0.5 for other
  conditions, 1.0 for DLC checks; rand(a,b) counts use the mean. World
  quotas (Const.World.Buildings.X == 0, e.g. the single arena) become
  1/(count of that settlement type); the worldgen pass guaranteeing 2-3
  fletchers/temples/kennels/taxidermists is spread over eligible types.
  onUpdateDraftList contributions (and XBE per-building/location tables,
  inheritance-aware) are mixed in as fractional draft entries.
- situations (refugees, draught, ...) are transient: a faction action rolls a
  2% gate per evaluation, goes on a 12-day cooldown after success, targets a
  random faction settlement, and the situation expires in 2-7 days. The
  steady-state share of time a given settlement carries a given situation is
  therefore ~0.1-0.6%; situation draft pushes are mixed in with that weight
  (constants below are rough estimates from add_random_situation_action.nut).
- event-recruited backgrounds (barbarian volunteer, belly dancer, the
  volunteers list, ...) are added as a small extra share of new bros, from
  each event's cooldown and rough campaign-pace constants (see below);
  scenario starting bros too — one scenario per campaign, picked uniformly.
  A scenario bro handed a fixed trait imperatively (e.g. NEM's feral wildman,
  its rolled traits wiped) is modeled as a fixed bundle: the sole source of its
  out-of-pool traits, only ever with exactly the traits added, so such a trait
  scores only when one such bro provably carries every requested factor.
- heroic (HeroicScenarioPack) and lone_chosen contribute their backgrounds,
  scenarios and (chosen-origin-gated) volunteer events; north (NEM)
  contributes its recruit events, the barbarian raiders scenario and hires at
  barbarian camps (4x barbarian + 1x wildman list) — in its origin regular
  settlements start hostile, so camps take ~3/4 of that origin's hires;
  camp-hired barbarians roll the thrall/chosen traits (special_traits).
- offp (Of Flesh and Faith Plus) contributes the oathbreaker background (via
  its rewired origin-gated one-shot event), 4 scenarios, per-origin recruit
  events, and removes the paladin draft push from watchtowers/outposts.
- weapon types honor Reforged setWeaponType() item hooks (staff_sling and
  nomad_sling become Sling|Throwing etc.).
- traits: vanilla algorithm (maxTraits = rand(rand(0,1) ? 1 : 0, 2), 10 retry
  attempts, one-directional Excluded checks) + Bro Studio extra traits
  (stdlib Player.addTraits: pool filtered by good/bad/soso, uniform; respects
  excludes since stdlib 2.6 — traits_strict=False models older stdlib).
  With mods=['reforged'] every recruit
  gets exactly 2 starting traits: Reforged overrides Modular Vanilla's
  MV_getMaxStartingTraits to 2, and MV_addTraits fills slots exactly (no
  vanilla 10-retry shortfall). Computed exactly by enumerating pick
  sequences over trait classes; mc=True switches to Monte Carlo (validation).
- permanent injuries: Bro Studio only — perma_chance for one uniform injury
  out of Const.Injury.Permanent.
- attr.X.high/low: as in buildFactorSet — high needs stars and a roll in the
  top `stars` values of the range, low needs no stars and the exact minimum.
  Talents: 3 distinct attrs out of 8 minus ExcludedTalents, stars 60/30/10%.
- cost/type/group: deterministic per background. NB: runtime DailyCost is
  base + 1 (character_background.onAdded bumps it).
- perk.X: background_perks chances (independent rolls, day-scaled), including
  blocks added after the main table (necro, shaman, ...); a perk factor also
  matches fallback perks that titles.nut aliases back to the canonical one.
- weapon.X: starting equipment parsed from each background's onAddEquipment
  (weapon arrays, rand-variable if/else chains; DLC extends assumed present),
  item types from Categories the way MSU builds WeaponType; combined with
  the mastery-perk path. Not modeled: player re-equipping, Reforged item
  changes; multiple weapon factors in one combo are treated independently.
- aliases from mod_nicknames def.Aliases are honored for backgrounds.

Known approximations (each can shift results, usually mildly):
- settlement types are weighted by expected world count (Settlements.Master
  amounts spread uniformly over each list; 3 city states) times settlement
  Size (1-3) as a proxy for how often the player hires there — city states
  end up with ~20% of hiring; scenario origins and conditional
  DraftList.push()es in settlement files are ignored;
- P(pick) is computed as E[count]/E[list length], not E[count/length];
  world quotas (e.g. limited arenas) and loops in building setup are not
  modeled — conditional addBuilding defaults to 0.5 presence;
- recruits are assumed level 1 (no veteran level-ups: no extra DailyCost,
  no stat growth);
- trait stat modifiers are ignored for attr.* factors; multiple attr factors
  are treated as independent (talents are actually 3 distinct attrs);
- background_perks fallbacks are ignored.

Usage:
    from calc_prob import calcFactorsProb
    calcFactorsProb(["background.monk", "trait.greedy"], mods=["xbe", "reforged"])

    ./calc_prob.py "background.monk + trait.greedy" --mods xbe,reforged
    ./calc_prob.py "trait.tiny + perk.dodge; trait.tiny + perk.footwork"
    ./calc_prob.py --selftest
"""
import argparse
import random
import re
import sys
from functools import lru_cache
from pathlib import Path

BBM = Path(__file__).resolve().parents[2]
VANILLA = BBM / "base/data_001/scripts"
XBE = BBM / "xbe"
REFORGED = BBM / "3rdparty/reforged"
STDLIB_PLAYER = BBM / "stdlib/stdlib/player.nut"
NICKNAMES_MAIN = Path(__file__).resolve().parent / "scripts/!mods_preload/mod_nicknames.nut"
NICKNAMES_TITLES = Path(__file__).resolve().parent / "nicknames/titles.nut"
BGPERKS_CHANCES = BBM / "mods/background_perks/background_perks/chances.nut"
BGPERKS_FALLBACKS = BBM / "mods/background_perks/background_perks/fallbacks.nut"

KNOWN_MODS = ("xbe", "reforged", "background_perks", "necro", "druid",
              "heroic", "lone_chosen", "north", "offp", "black_pyramid")
NECRO = BBM / "mods/necro"
DRUID = BBM / "mods/druid"
HEROIC = BBM / "3rdparty/HeroicScenarioPack"
LONE_CHOSEN = BBM / "3rdparty/lone_chosen"
NORTH = BBM / "3rdparty/north-expansion"
OFFP = BBM / "3rdparty/of_flesh_and_faith_plus"

# MSU derives an item's WeaponType from its Categories string
WEAPON_TYPES = {"axe", "bow", "cleaver", "crossbow", "dagger", "firearm", "flail",
                "hammer", "mace", "polearm", "sling", "spear", "sword", "staff",
                "throwing", "musical"}

BASE_ATTRS = {
    "Hitpoints": (50, 60),
    "Bravery": (30, 40),
    "Stamina": (90, 100),
    "MeleeSkill": (47, 57),
    "RangedSkill": (32, 42),
    "MeleeDefense": (0, 5),
    "RangedDefense": (0, 5),
    "Initiative": (100, 110),
}
ATTR_COUNT = 8  # Const.Attributes.COUNT
ATTR_NAMES = set(BASE_ATTRS)
STAR_LEVELS = [(1, 0.6), (2, 0.3), (3, 0.1)]
XBE_FOLK_HERO_CHANCE = 0.35

# Situation steady state, rough estimates (see docstring): spawns per
# settlement per day x uniform pick share among possible situations.
SITUATION_SPAWN_PER_DAY = 0.008
SITUATION_PICK_SHARE = 0.1
SITUATION_DEFAULT_DAYS = 30  # for ValidDays = 0 (crisis-bound, e.g. refugees)

# City states are not in Settlements.Master (spawned by compiled DLC code);
# Const.CityStateArchetypes has 3 entries.
CITY_STATES = 3

# Event-recruited backgrounds (barbarian volunteer, belly dancer, ...).
# Very rough steady state: a specific eligible event fires about once per
# SPECIFIC_EVENT_GAP days on top of its own cooldown; one-shot events
# (cooldown >= 9999 days) fire about once per campaign. Vanilla origin-gated
# events are skipped, other conditions (DLC, region, daytime) are folded into
# the gap constant. Rates convert to a per-recruit share via
# ROSTER_BROS_PER_DAY. Campaigns end (won, lost or abandoned) at a roughly
# constant daily rate with ~200 days as a practical maximum, so the average
# campaign runs about AVG_CAMPAIGN_DAYS — scenario starting bros and one-shot
# events weigh against that average-length roster. All constants are rough
# estimates.
SPECIFIC_EVENT_GAP = 75.0
AVG_CAMPAIGN_DAYS = 100.0
ROSTER_BROS_PER_DAY = 8.0
# north (NEM): in its origin every regular settlement starts hostile — camps
# are the only hiring source for the first ~50 days, and on half the path
# choices they stay the only one for the whole campaign; with ~100-day average
# campaigns camps take ~3/4 of that origin's hires. Other origins are assumed
# to never hire at camps. Rough estimate; divided by the scenario count.
NORTH_ORIGIN_CAMP_SHARE = 0.75
# A camp-hired barbarian rolls a special trait: thrall, else chosen
# (one rand(1,100) roll; NEM mod settings defaults).
NORTH_THRALL_CHANCE = 0.05
NORTH_CHOSEN_CHANCE = 0.10

# Black Pyramid / Elemental Reforged assigns these in its setStartValuesEx hook
# (mod_elemental/hooks/register_traits.nut), not through the trait/perk pools:
#  1. a phobia (15% total, one element, uniform over the non-excluded ones)
#  2. an innate affinity perk (~1%): 10% to roll an element branch, then 10% to
#     gain the perk, but never for the feared element.
BP_ELEMENTS = ("fire", "ice", "thunder")
BP_FEAR_CHANCE = 0.15
BP_FEAR_EXCLUDED_BG = {
    "fire":    ("background.monk",),
    "thunder": ("background.anatomist",),
    "ice":     ("background.wildman", "background.barbarian", "background.slave_barbarian"),
}
BP_BRANCH_CHANCE = 0.10   # chance to roll an elemental branch (then uniform over 3)
BP_AFFINITY_ROLL = 0.10   # conditional chance the branch grants the innate perk
BP_AFFINITY_EXCLUDED_BG = ("background.swordmaster", "background.rf_renowned_swordmaster")
BP_AFFINITY_FACTORS = frozenset("perk.elem_%s_affinity" % e for e in BP_ELEMENTS)


# ── Squirrel source parsing helpers ──────────────────────────────────────────

def _read(path):
    return path.read_text(encoding="utf-8", errors="replace")

def _strings(text):
    return re.findall(r'"([^"]*)"', text)

def _array_block(text, head_re):
    """Return the [...] or {...} block content following the head regex, or None."""
    m = re.search(head_re, text)
    if m is None:
        return None
    start = min(i for i in (text.find("[", m.end() - 1), text.find("{", m.end() - 1))
                if i != -1)
    open, close = text[start], "]" if text[start] == "[" else "}"
    depth, i = 0, start
    while i < len(text):
        if text[i] == open:
            depth += 1
        elif text[i] == close:
            depth -= 1
            if depth == 0:
                return text[start + 1:i]
        i += 1
    return None

def _attr_mods(text):
    """Parse Attr = [a, b] pairs from an onChangeAttributes body."""
    m = re.search(r"function\s+onChangeAttributes\s*\(\s*\)", text)
    if m is None:
        return None
    body = text[m.end():m.end() + 1500]
    mods = {}
    for attr, lo, hi in re.findall(r"(\w+)\s*=\s*\[\s*(-?\d+)\s*,\s*(-?\d+)\s*\]", body):
        if attr in ATTR_NAMES:
            mods[attr] = (int(lo), int(hi))
    return mods or None


class Background:
    def __init__(self, id, script, daily_cost=0, excluded=(), excluded_talents=(),
                 flags=(), attr_mods=None, path=None):
        self.id = id                            # "background.deserter"
        self.script = script                    # "deserter_background"
        self.daily_cost = daily_cost            # base, runtime is +1
        self.excluded = set(excluded)           # excluded trait ids
        self.excluded_talents = set(excluded_talents)  # attr names, Stamina-normalized
        self.flags = set(flags)                 # of IsCombatBackground etc.
        self.attr_mods = attr_mods or {}
        self.path = path                        # source .nut, for equipment parsing

    @property
    def runtime_cost(self):
        return self.daily_cost + 1 if self.daily_cost > 0 else 0


def _parse_background_file(path):
    """Raw, unresolved fields; None means 'not set here, inherit'."""
    text = _read(path)
    m = re.search(r'm\.ID\s*=\s*"(background\.[^"]+)"', text)
    cost = re.search(r"m\.DailyCost\s*=\s*(\d+)", text)
    excluded = _array_block(text, r"m\.Excluded\s*=\s*\[")
    talents = _array_block(text, r"m\.ExcludedTalents\s*=\s*\[")
    inherit = re.search(r'inherit\(\s*"scripts/skills/backgrounds/([\w/]+)"', text)
    return {
        "path": path,
        "id": m.group(1) if m else None,
        "cost": int(cost.group(1)) if cost else None,
        "excluded": _strings(excluded) if excluded is not None else None,
        "talents": ["Stamina" if t == "Fatigue" else t for t in
                    re.findall(r"Const\.Attributes\.(\w+)", talents)]
                   if talents is not None else None,
        "flags": set(f for f in ("IsCombatBackground", "IsNoble", "IsLowborn",
                                 "IsOffendedByViolence")
                     if re.search(r"m\.%s\s*=\s*true" % f, text)),
        "attr_mods": _attr_mods(text),
        "inherit": inherit.group(1).split("/")[-1] if inherit else None,
        "has_equipment": bool(re.search(r"function\s+onAddEquipment\s*\(", text)),
    }


def _parse_backgrounds(dir):
    """Variants like nomad_ranged or the southern ones inherit a parent
    background and only override some fields — resolve the chains."""
    raws = {}
    for path in sorted(dir.glob("**/*_background.nut")):
        raws[path.stem] = _parse_background_file(path)
    out = {}
    for stem, raw in raws.items():
        merged = dict(raw)
        flags = set(raw["flags"])
        equip_path = raw["path"] if raw["has_equipment"] else None
        parent = raws.get(raw["inherit"])
        while parent is not None:
            for f in ("id", "cost", "excluded", "talents", "attr_mods"):
                if merged[f] is None:
                    merged[f] = parent[f]
            flags |= parent["flags"]
            if equip_path is None and parent["has_equipment"]:
                equip_path = parent["path"]
            parent = raws.get(parent["inherit"])
        if merged["id"] is None:  # character_background itself etc.
            continue
        out[stem] = Background(merged["id"], stem, merged["cost"] or 0,
                               merged["excluded"] or (), merged["talents"] or (),
                               flags, merged["attr_mods"], equip_path)
    return out


def _parse_draft_lists(settlements_dir):
    """settlement script name -> list of background script names (base list only)."""
    out = {}
    for path in sorted(settlements_dir.glob("*.nut")):
        block = _array_block(_read(path), r"m\.DraftList\s*=\s*\[")
        if block is not None:
            out[path.stem] = [s.split("/")[-1] for s in _strings(block)]
    return out


def _match_brace(text, i):
    """i points at '{'; return index just past the matching '}'."""
    depth = 0
    while i < len(text):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return len(text)

_CALL_RE = re.compile(
    r'addBuilding\(this\.new\("scripts/entity/world/settlements/buildings/(\w+)"\)'
    r'|buildAttachedLocation\(\s*([^,]+?),\s*"scripts/entity/world/attached_location/(\w+)"')
_IF_RE = re.compile(r"\bif\s*\(")

def _cond_prob(cond, quota_prob):
    m = re.search(r"Math\.rand\(\s*1\s*,\s*100\s*\)\s*<=\s*(\d+)", cond)
    if m:
        return int(m.group(1)) / 100.0
    # World quotas like Const.World.Buildings.Arenas == 0: only the first
    # settlement evaluating it adds the building, so for a random settlement
    # of this type the chance is 1 / (count of this type in the world).
    if re.search(r"Const\.World\.Buildings\.\w+\s*==\s*0", cond):
        return quota_prob
    if "Const.DLC" in cond:
        return 1.0
    return 0.5

def _count_expr(expr):
    expr = expr.strip()
    if re.fullmatch(r"\d+", expr):
        return int(expr)
    m = re.search(r"Math\.rand\(\s*(\d+)\s*,\s*(\d+)\s*\)", expr)
    if m:
        return (int(m.group(1)) + int(m.group(2))) / 2.0
    return 1.0

def _walk_attachments(text, mult, out, quota_prob=0.5):
    """Collect (script_stem, expected_count) from a code block, weighting
    addBuilding/buildAttachedLocation calls by if/else-if branch probability."""
    i = 0
    while i < len(text):
        m_call = _CALL_RE.search(text, i)
        m_if = _IF_RE.search(text, i)
        if m_call is None and m_if is None:
            return
        if m_if is None or (m_call is not None and m_call.start() < m_if.start()):
            if m_call.group(1):  # addBuilding
                out.append((m_call.group(1), mult))
            else:                # buildAttachedLocation
                out.append((m_call.group(3), mult * _count_expr(m_call.group(2))))
            i = m_call.end()
            continue
        # if/else-if/else chain
        remaining = 1.0
        pos = m_if.start()
        while True:
            cond_start = text.index("(", pos)
            depth, j = 0, cond_start
            while True:
                if text[j] == "(":
                    depth += 1
                elif text[j] == ")":
                    depth -= 1
                    if depth == 0:
                        break
                j += 1
            p = _cond_prob(text[cond_start + 1:j], quota_prob)
            block_start = text.index("{", j)
            block_end = _match_brace(text, block_start)
            _walk_attachments(text[block_start + 1:block_end - 1], mult * remaining * p,
                              out, quota_prob)
            remaining *= 1 - p
            m_else = re.match(r"\s*else(\s+if\s*\()?", text[block_end:])
            if m_else is None:
                i = block_end
                break
            if m_else.group(1):  # else if
                pos = block_end + m_else.end() - 1
                continue
            block_start = text.index("{", block_end)
            block_end = _match_brace(text, block_start)
            _walk_attachments(text[block_start + 1:block_end - 1], mult * remaining,
                              out, quota_prob)
            i = block_end
            break


def _parse_draft_pushes(path, inherits):
    """Background script names pushed in onUpdateDraftList, with inherit fallback."""
    text = _read(path)
    m = re.search(r"inherit\(\s*\"([^\"]+)\"", text)
    inherits[path.stem] = m.group(1).split("/")[-1] if m else None
    f = re.search(r"function\s+onUpdateDraftList\s*\([^)]*\)", text)
    if f is None:
        return None
    block_start = text.index("{", f.end())
    body = text[block_start:_match_brace(text, block_start)]
    return [s.split("/")[-1] for s in re.findall(r'push\(\s*"([^"]+)"\s*\)', body)]


def _parse_contributors(dir, inherits):
    """script stem -> list of bg script names it pushes into the draft list."""
    out = {}
    for path in sorted(dir.glob("*.nut")):
        pushes = _parse_draft_pushes(path, inherits)
        if pushes is not None:
            out[path.stem] = pushes
    # resolve inheritance for files without own onUpdateDraftList
    for stem, parent in inherits.items():
        if stem not in out:
            while parent is not None and parent not in out:
                parent = inherits.get(parent)
            if parent is not None:
                out[stem] = out[parent]
    return out


def _parse_xbe_attachment_drafts(path):
    """XBE BuildingDrafts/AttachedLocationDrafts: stem -> [bg script names]."""
    text = _read(path)
    out = {}
    for m in re.finditer(r"^\s{4}(\w+)\s*=\s*\[", text, re.M):
        block = _array_block(text[m.start():], r"=\s*\[")
        out[m.group(1)] = [s.split("/")[-1] for s in _strings(block or "")]
    return out


def _xbe_lookup(stem, table, inherits):
    """XBE hooks descendants, so additions apply to the stem or any ancestor."""
    while stem is not None:
        if stem in table:
            return table[stem]
        stem = inherits.get(stem)
    return []


def _parse_xbe_drafts():
    """XBE per-settlement additions, background script names."""
    text = _read(XBE / "hackflows/world/settlements.nut")
    out = {}
    for m in re.finditer(r"^\s{4}(\w+)\s*=\s*\[", text, re.M):
        block = _array_block(text[m.start():], r"=\s*\[")
        out[m.group(1)] = [s.split("/")[-1] for s in _strings(block or "")]
    return out


def _parse_traits():
    """trait id -> set of excluded trait ids (one-directional, as in game)."""
    pairs = re.findall(r'\[\s*"(trait\.[^"]+)"\s*,\s*"([^"]+)"\s*\]',
                       _read(VANILLA / "config/character_traits.nut"))
    excl = {}
    for id, script in pairs:
        script = script.removeprefix("scripts/")
        text = _read(VANILLA / (script + ".nut"))
        excl[id] = set(_strings(_array_block(text, r"m\.Excluded\s*=\s*\[") or ""))
    return excl


def _parse_stdlib_trait_kinds():
    text = _read(STDLIB_PLAYER)
    bad = set(_strings(_array_block(text, r"BadTraitIds\s*=\s*\[") or ""))
    soso = set(_strings(_array_block(text, r"SosoTraitIds\s*=\s*\[") or ""))
    return bad, soso


def _parse_aliases():
    block = _array_block(_read(NICKNAMES_TITLES), r"def\.Aliases\s*<-\s*\{")
    pairs = re.findall(r'"([^"]+)"\s*:\s*"([^"]+)"', block or "")
    return dict(pairs)


def _parse_weapon_items(item_dirs):
    """item path ('weapons/hand_axe') -> frozenset of weapon type names.

    Types come from the item's Categories string, the way MSU builds
    WeaponType (buildWeaponTypeFromCategories); inherit chains are followed
    for items without their own Categories (e.g. named weapons).
    """
    cats, inherits = {}, {}
    for d in item_dirs:
        if not (d / "weapons").is_dir():
            continue
        for path in sorted((d / "weapons").glob("**/*.nut")):
            text = _read(path)
            key = str(path.relative_to(d))[:-len(".nut")]
            m = re.search(r'm\.Categories\s*=\s*"([^"]*)"', text)
            im = re.search(r'inherit\(\s*"scripts/items/([^"]+)"', text)
            inherits[key] = im.group(1) if im else None
            if m:
                cats[key] = m.group(1)
    types = {}
    for key in inherits:
        k = key
        while k is not None and k not in cats:
            k = inherits.get(k)
        # MSU substring-matches WeaponType keys against the raw Categories
        # string (case-sensitive), e.g. "Throwing Weapon" -> Throwing
        cat = cats.get(k, "")
        types[key] = frozenset(w for w in WEAPON_TYPES if w.capitalize() in cat)
    return types


def _parse_reforged_weapon_types():
    """item path -> frozenset of types from Reforged setWeaponType() hooks."""
    out = {}
    hooks = REFORGED / "mod_reforged/hooks/items"
    for path in sorted(hooks.glob("weapons/**/*.nut")):
        m = re.search(r"setWeaponType\(([^)]*)\)", _read(path))
        if m:
            types = [t.lower() for t in re.findall(r"WeaponType\.(\w+)", m.group(1))]
            out[str(path.relative_to(hooks))[:-len(".nut")]] = \
                frozenset(t for t in types if t in WEAPON_TYPES)
    return out


def _parse_scenario_bros(scenario_dirs):
    """([(bg script, expected starting bros per campaign)], fixed-bro profiles, n).

    Each setStartValuesEx([...]) call in a scenario spawns one starting bro
    picking uniformly from the listed backgrounds; the scenario itself is
    assumed to be picked uniformly among all known ones.

    Some scenarios also hand a specific bros[N] a fixed trait imperatively
    (bros[N].getSkills().add(...new("scripts/skills/traits/X_trait"))), usually
    after wiping its rolled traits — e.g. NEM's barbarian raiders makes a
    wildman feral. Such bros come back as profiles (bg script, all traits added
    inline, expected count) so out-of-pool traits, unreachable through the
    generation machinery, can be modeled — see load_data.
    """
    per_scenario, raw_profiles = [], []
    for d in scenario_dirs:
        for path in sorted(d.glob("**/*_scenario.nut")):
            text = _read(path)
            bros, idx_bg = [], {}
            for m in re.finditer(
                    r"(?:bros\[(\d+)\]\s*\.\s*)?setStartValuesEx\(\s*\[", text):
                block = _array_block(text[m.start():], r"\(\s*\[")
                scripts = [s.split("/")[-1] for s in _strings(block or "")]
                if not scripts:
                    continue
                bros.append(scripts)
                if m.group(1) is not None:
                    idx_bg[int(m.group(1))] = scripts
            per_scenario.append(bros)
            idx_traits = {}
            for m in re.finditer(
                    r'bros\[(\d+)\]\s*\.\s*getSkills\(\)\s*\.\s*add\('
                    r'\s*(?:this\.)?new\(\s*"scripts/skills/traits/(\w+)_trait"', text):
                idx_traits.setdefault(int(m.group(1)), set()).add("trait." + m.group(2))
            for idx, tids in idx_traits.items():
                for bg in idx_bg.get(idx, []):
                    raw_profiles.append((bg, frozenset(tids), 1.0 / len(idx_bg[idx])))
    out = {}
    for bros in per_scenario:
        for scripts in bros:
            for s in scripts:
                out[s] = out.get(s, 0.0) + 1.0 / len(scripts) / len(per_scenario)
    n = len(per_scenario)
    profiles = [(bg, tids, count / n) for bg, tids, count in raw_profiles]
    return sorted(out.items()), profiles, n


_EQUIP_RE = re.compile(
    r'items\.equip\((?:this\.)?new\("scripts/items/([^"]+)"\)\)'
    r'|items\.equip\((?:this\.)?new\("scripts/items/"\s*\+\s*(\w+)\[')
_RAND_ASSIGN_RE = re.compile(
    r"\b(\w+)\s*=\s*(?:this\.)?Math\.rand\(\s*(\d+)\s*,\s*(\d+)\s*\)\s*;")

def _equip_cond(cond, env):
    """(probability, env for the taken branch, env for the else branch)."""
    m = re.search(r"\b(\w+)\s*==\s*(\d+)", cond)
    if m and m.group(1) in env:
        lo, hi, consumed = env[m.group(1)]
        size = max(hi - lo + 1 - consumed, 1)
        else_env = dict(env)
        else_env[m.group(1)] = (lo, hi, consumed + 1)
        return 1.0 / size, env, else_env
    m = re.search(r"\b(\w+)\s*<=\s*(\d+)", cond)
    if m and m.group(1) in env:
        lo, hi, consumed = env[m.group(1)]
        k = int(m.group(2))
        p = max(0.0, min(1.0, (k - lo + 1) / max(hi - lo + 1, 1)))
        else_env = dict(env)
        else_env[m.group(1)] = (k + 1, hi, 0)
        return p, env, else_env
    m = re.search(r"Math\.rand\(\s*1\s*,\s*100\s*\)\s*<=\s*(\d+)", cond)
    if m:
        return int(m.group(1)) / 100.0, env, env
    if "Const.DLC" in cond:
        return 1.0, env, env
    return 0.5, env, env


def _stmt_block(text, pos):
    """Body of an if/else branch starting at pos: a {...} block or, for
    brace-less branches, the single statement up to ';'. Returns (body, end)
    with end pointing right past the block."""
    m = re.match(r"\s*\{", text[pos:])
    if m:
        block_start = pos + m.end() - 1
        block_end = _match_brace(text, block_start)
        return text[block_start + 1:block_end - 1], block_end
    end = text.index(";", pos) + 1
    return text[pos:end], end


def _walk_equipment(text, mult, env, arrays, out):
    """Collect (item path or array element, prob) from an onAddEquipment body."""
    i = 0
    while i < len(text):
        m_call = _EQUIP_RE.search(text, i)
        m_if = _IF_RE.search(text, i)
        m_asg = _RAND_ASSIGN_RE.search(text, i)
        starts = [m.start() for m in (m_call, m_if, m_asg) if m is not None]
        if not starts:
            return
        first = min(starts)
        if m_asg is not None and m_asg.start() == first:
            env = dict(env)
            env[m_asg.group(1)] = (int(m_asg.group(2)), int(m_asg.group(3)), 0)
            i = m_asg.end()
            continue
        if m_call is not None and m_call.start() == first:
            if m_call.group(1):
                out.append((m_call.group(1), mult))
            else:
                elems = arrays.get(m_call.group(2), [])
                for e in elems:
                    out.append((e, mult / len(elems)))
            i = m_call.end()
            continue
        # if/else-if/else chain
        pos = m_if.start()
        while True:
            cond_start = text.index("(", pos)
            depth, j = 0, cond_start
            while True:
                if text[j] == "(":
                    depth += 1
                elif text[j] == ")":
                    depth -= 1
                    if depth == 0:
                        break
                j += 1
            p, env_if, env_else = _equip_cond(text[cond_start + 1:j], env)
            body, block_end = _stmt_block(text, j + 1)
            _walk_equipment(body, mult * p, env_if, arrays, out)
            mult *= 1 - p
            env = env_else
            m_else = re.match(r"\s*else(\s+if\s*\()?", text[block_end:])
            if m_else is None:
                i = block_end
                break
            if m_else.group(1):  # else if
                pos = block_end + m_else.end() - 1
                continue
            body, block_end = _stmt_block(text, block_end + m_else.end())
            _walk_equipment(body, mult, env, arrays, out)
            i = block_end
            break


def _bg_weapon_probs(bg, weapon_types):
    """[(frozenset of types, prob)] for the background's starting mainhand."""
    if bg.path is None:
        return []
    text = _read(bg.path)
    f = re.search(r"function\s+onAddEquipment\s*\(", text)
    if f is None:
        return []
    block_start = text.index("{", f.end())
    body = text[block_start + 1:_match_brace(text, block_start) - 1]

    # local arrays of item paths, conditional extends assumed taken
    arrays = {}
    for m in re.finditer(r"local\s+(\w+)\s*=\s*\[", body):
        arrays[m.group(1)] = _strings(_array_block(body[m.start():], r"=\s*\[") or "")
    for m in re.finditer(r"\b(\w+)\.extend\(\s*\[", body):
        if m.group(1) in arrays:
            arrays[m.group(1)] += _strings(_array_block(body[m.start():], r"\(\s*\[") or "")

    raw = []
    _walk_equipment(body, 1.0, {}, arrays, raw)
    out = []
    for path, prob in raw:
        path = path.removeprefix("scripts/items/")
        types = weapon_types.get(path)
        if types:  # weapons only; armor, shields and ammo fall out here
            out.append((types, prob))
    return out


def _parse_titles():
    """Entries of def.Titles in nicknames/titles.nut: {label, combos}."""
    block = _array_block(_read(NICKNAMES_TITLES), r"def\.Titles\s*<-\s*\[")
    entries, i = [], 0
    while True:
        start = block.find("{", i)
        if start == -1:
            break
        end = _match_brace(block, start)
        body = block[start:end]
        i = end
        f = re.search(r"factors\s*=\s*\[", body)
        if f is None:
            continue
        fblock = _array_block(body, r"factors\s*=\s*\[")
        combos = [" + ".join(_strings(c)) for c in re.findall(r"\[([^\]]*)\]", fblock)]
        names = re.findall(r'ru\s*=\s*"([^"]+)"(?:\s*,\s*en\s*=\s*"([^"]+)")?', body)
        if not names or not combos:
            continue
        label = "%s / %s" % (names[0][0], names[0][1] or "-")
        if len(names) > 1:
            label += " (+%d)" % (len(names) - 1)
        entries.append({"label": label, "combos": combos})
    return entries


def _parse_paupers():
    block = _array_block(_read(NICKNAMES_MAIN), r"def\.PauperBackgrounds\s*<-\s*\{")
    return set(_strings(block or ""))


def _parse_permanent_injuries():
    block = _array_block(_read(VANILLA / "config/character_injuries.nut"),
                         r"Injury\.Permanent\s*<-\s*\[")
    return re.findall(r'ID\s*=\s*"(injury\.[^"]+)"', block or "")


def _parse_bgperks():
    """bg key (no prefix) -> {perk: chance%}; 'ALL' merged in by caller."""
    text = _read(BGPERKS_CHANCES)
    out = {}
    for m in re.finditer(r"^\s{4}(?:(\w+)|\"(\w+)\")\s*=\s*\{", text, re.M):
        key = m.group(1) or m.group(2)
        block = _array_block(text[m.start():], r"=\s*\{")
        chances = dict((p, int(c)) for p, c in
                       re.findall(r'"([\w.]+)"\s*:\s*(\d+)', block or ""))
        out[key] = chances
    # additions after the main table: ::BgPerks.chances.necro <- {...} blocks
    # and ::BgPerks.chances.x <- ::BgPerks.chances.y; copies
    for m in re.finditer(r"::BgPerks\.chances\.(\w+)\s*<-\s*\{", text):
        block = _array_block(text[m.start():], r"<-\s*\{")
        out[m.group(1)] = dict((p, int(c)) for p, c in
                               re.findall(r'"([\w.]+)"\s*:\s*(\d+)', block or ""))
    for src, dst in re.findall(
            r"::BgPerks\.chances\.(\w+)\s*<-\s*::BgPerks\.chances\.(\w+)\s*;", text):
        if dst in out:
            out[src] = out[dst]
    return out


def _parse_perk_fallbacks():
    """fallback perk -> canonical perk, as titles.nut aliases them
    (later entries overwrite earlier ones for a shared fallback)."""
    if not BGPERKS_FALLBACKS.exists():
        return {}
    text = _array_block(_read(BGPERKS_FALLBACKS), r"::BgPerks\.fallbacks\s*<-\s*\{") or ""
    out = {}
    for m in re.finditer(r'"([\w.]+)"\s*:\s*\[([^\]]*)\]', text):
        for fallback in _strings(m.group(2)):
            out[fallback] = m.group(1)
    return out


def _apply_reforged(backgrounds):
    hooks_dir = REFORGED / "mod_reforged/hooks/skills/backgrounds"
    by_script = dict((bg.script, bg) for bg in backgrounds.values())
    for path in sorted(hooks_dir.glob("*.nut")):
        bg = by_script.get(path.stem)
        if bg is None:
            continue
        text = _read(path)
        bg.excluded |= set(_strings(_array_block(text, r"m\.Excluded\.extend\(\s*\[") or ""))
        for t in re.findall(r"ExcludedTalents\.push\(.*?Attributes\.(\w+)", text):
            bg.excluded_talents.add("Stamina" if t == "Fatigue" else t)
        m = re.search(r"m\.DailyCost\s*=\s*(\d+)", text)
        if m:
            bg.daily_cost = int(m.group(1))
        mods = _attr_mods(text)
        if mods:
            bg.attr_mods = mods
    # new rf_* backgrounds: parse but they have no draft weight
    for script, bg in _parse_backgrounds(REFORGED / "scripts/skills/backgrounds").items():
        if script not in backgrounds:
            backgrounds[script] = bg


# ── Data assembly ────────────────────────────────────────────────────────────

class Data:
    pass

def _parse_settlement_info(settlements_dir):
    """settlement type -> {count, size, military}.

    Expected counts come from Const.World.Settlements.Master: each entry
    spawns Amount settlements picked from a list by terrain suitability —
    approximated as uniform over the list.
    """
    text = _read(VANILLA / "config/world_settlements.nut")
    lists = {}
    for m in re.finditer(r"Settlements\.(\w+)\s*<-\s*\[", text):
        block = _array_block(text[m.start():], r"<-\s*\[")
        scripts = re.findall(r'Script\s*=\s*"[^"]*/(\w+)"', block or "")
        if scripts:
            lists[m.group(1)] = scripts
    counts = {"city_state": float(CITY_STATES)}
    for amount, name in re.findall(
            r"Amount\s*=\s*(\d+),\s*List\s*=\s*this\.Const\.World\.Settlements\.(\w+)", text):
        for script in lists.get(name, []):
            counts[script] = counts.get(script, 0.0) + int(amount) / len(lists[name])
    info = {}
    for stem, count in counts.items():
        text = _read(settlements_dir / (stem + ".nut"))
        m = re.search(r"m\.Size\s*=\s*(\d+)", text)
        info[stem] = {
            "count": count,
            "size": int(m.group(1)) if m else 1,
            "military": bool(re.search(r"m\.IsMilitary\s*=\s*true", text)),
        }
    return info


# worldmap_generator.guaranteeAllBuildingsInSettlements: if fewer than 2 of a
# building spawned naturally, add up to 3 to random eligible settlements.
GUARANTEED_BUILDINGS = {
    "fletcher_building": lambda t: t["size"] >= 2,
    "temple_building": lambda t: t["size"] >= 2,
    "barber_building": lambda t: t["size"] >= 2 and not t["military"],
    "kennel_building": lambda t: t["military"],
    "taxidermist_building": lambda t: not t["military"],
}
GUARANTEED_TARGET = 3


def _parse_recruit_events(event_dirs):
    """[(bg script name, recruits per day)] from bro-granting events.

    event_dirs: [(dir, mult)] — mult scales the rate, e.g. origin-gated
    events only apply in 1/(scenario count) of campaigns."""
    out = []
    for dir, mult in event_dirs:
        for path in sorted(dir.glob("**/*_event.nut")):
            if "_origin_" in path.stem:
                continue
            text = _read(path)
            bgs = sorted(set(re.findall(r'"(\w+_background)"', text)))
            if not bgs:
                continue
            m = re.search(r"m\.Cooldown\s*=\s*([\d.]+)\s*\*", text)
            cooldown = float(m.group(1)) if m else 0.0
            rate = (1.0 / AVG_CAMPAIGN_DAYS if cooldown >= 9999
                    else 1.0 / (cooldown + SPECIFIC_EVENT_GAP))
            for bg in bgs:  # events offering a list pick one of them
                out.append((bg, rate * mult / len(bgs)))
    return out


def _situation_weights(situations_dir):
    """situation stem -> steady-state probability of being active."""
    out = {}
    for path in sorted(situations_dir.glob("*_situation.nut")):
        m = re.search(r"m\.ValidDays\s*=\s*(\d+)", _read(path))
        days = int(m.group(1)) if m else SITUATION_DEFAULT_DAYS
        out[path.stem] = SITUATION_SPAWN_PER_DAY * SITUATION_PICK_SHARE * days
    return out


@lru_cache(maxsize=None)
def load_data(mods=KNOWN_MODS):
    unknown = set(mods) - set(KNOWN_MODS)
    if unknown:
        raise ValueError("Unknown mods %s, supported: %s" % (sorted(unknown), KNOWN_MODS))

    d = Data()
    d.mods = set(mods)
    d.backgrounds = _parse_backgrounds(VANILLA / "skills/backgrounds")
    settlements_dir = VANILLA / "entity/world/settlements"
    drafts = _parse_draft_lists(settlements_dir)

    # Draft contributions of buildings, attached locations and situations
    inherits = {}
    contributors = _parse_contributors(settlements_dir / "buildings", inherits)
    contributors.update(_parse_contributors(VANILLA / "entity/world/attached_location", inherits))
    sit_contrib = _parse_contributors(settlements_dir / "situations", {})
    sit_weights = _situation_weights(settlements_dir / "situations")

    xbe_buildings, xbe_locations = {}, {}
    if "xbe" in d.mods:
        d.backgrounds.update(_parse_backgrounds(XBE / "scripts/skills/backgrounds"))
        for town, extra in _parse_xbe_drafts().items():
            if town in drafts:
                drafts[town] = drafts[town] + extra
        xbe_buildings = _parse_xbe_attachment_drafts(XBE / "hackflows/world/buildings.nut")
        xbe_locations = _parse_xbe_attachment_drafts(XBE / "hackflows/world/attached_locations.nut")
    if "necro" in d.mods:
        # mod_necro pushes necro_background per settlement: +1 for swamp or
        # tundra, +1 for large, +1 for medium (mod_necro.nut hookTree)
        d.backgrounds.update(_parse_backgrounds(NECRO / "scripts/skills/backgrounds"))
        for town in drafts:
            num = (("_swamp_" in town or "_tundra_" in town) + town.startswith("large_")
                   + town.startswith("medium_"))
            drafts[town] = drafts[town] + ["necro_background"] * num
    if "druid" in d.mods:
        # mod_druid replaces the XBE druid background (same script stem) and
        # relies on XBE's draft entries; only without XBE does it push its
        # own: +2 in forest/lumber/swamp, +1 elsewhere, none in city states
        # and large non-wild settlements (mod_druid.nut hookTree)
        d.backgrounds.update(_parse_backgrounds(DRUID / "scripts/skills/backgrounds"))
        if "xbe" not in d.mods:
            for town in drafts:
                wild = "_forest_" in town or "_lumber_" in town or "_swamp_" in town
                big_city = town == "city_state" or town.startswith("large_") and not wild
                num = 2 if wild else 0 if big_city else 1
                drafts[town] = drafts[town] + ["druid_background"] * num
    if "heroic" in d.mods:
        d.backgrounds.update(_parse_backgrounds(HEROIC / "scripts/skills/backgrounds"))
    if "lone_chosen" in d.mods:
        d.backgrounds.update(_parse_backgrounds(LONE_CHOSEN / "scripts/skills/backgrounds"))
    if "offp" in d.mods:
        d.backgrounds.update(_parse_backgrounds(OFFP / "scripts/skills/backgrounds"))
        # OFFP removes the paladin draft push from watchtowers and outposts
        # (offp_oathtaker_spawns.nut)
        for stem in ("fortified_outpost_location", "stone_watchtower_location",
                     "wooden_watchtower_location"):
            contributors[stem] = [s for s in contributors.get(stem, ())
                                  if s != "paladin_background"]
    if "reforged" in d.mods:
        _apply_reforged(d.backgrounds)

    # Expected per-settlement draft composition: base list + expected
    # building/location contributions + active situations. P(bg) is
    # approximated as E[count]/E[length], averaged over settlement types
    # weighted by world count x settlement size (hiring-visit share).
    town_info = _parse_settlement_info(settlements_dir)
    total_weight = sum(t["count"] * t["size"]
                       for town, t in town_info.items() if town in drafts)

    town_attachments = {}
    for town in drafts:
        if town not in town_info:
            continue
        attachments = []
        _walk_attachments(_read(settlements_dir / (town + ".nut")), 1.0, attachments,
                          quota_prob=1.0 / max(town_info[town]["count"], 1.0))
        town_attachments[town] = attachments

    # guaranteeAllBuildingsInSettlements: spread the deficit of guaranteed
    # buildings over eligible settlements.
    for building, eligible in GUARANTEED_BUILDINGS.items():
        natural = sum(town_info[town]["count"] * expected
                      for town, attachments in town_attachments.items()
                      for stem, expected in attachments if stem == building)
        if natural >= 2:
            continue
        towns = [t for t in town_attachments if eligible(town_info[t])]
        eligible_count = sum(town_info[t]["count"] for t in towns)
        for town in towns:
            town_attachments[town].append(
                (building, (GUARANTEED_TARGET - natural) / eligible_count))

    # keyed by background script: scripts sharing an ID (companion_1h/2h/
    # ranged) differ in equipment and must stay separate
    d.draft_prob = dict((script, 0.0) for script in d.backgrounds)
    for town, entries in drafts.items():
        if town not in town_info:
            continue
        t = town_info[town]
        town_share = t["count"] * t["size"] / total_weight
        counts, length = {}, 0.0
        def add(script, weight=1.0):
            nonlocal length
            if script in d.backgrounds:
                counts[script] = counts.get(script, 0.0) + weight
                length += weight
        for script in entries:
            add(script)

        for stem, expected in town_attachments[town]:
            pushes = contributors.get(stem, [])
            if "xbe" in d.mods:
                table = xbe_buildings if stem.endswith("_building") else xbe_locations
                pushes = pushes + _xbe_lookup(stem, table, inherits)
            for script in pushes:
                add(script, expected)

        for sit, pushes in sit_contrib.items():
            for script in pushes:
                add(script, sit_weights.get(sit, 0.0))

        if "xbe" in d.mods:
            add("folk_hero_background", XBE_FOLK_HERO_CHANCE)

        if length:
            for script, count in counts.items():
                d.draft_prob[script] += count / length * town_share

    # Event-recruited bros and scenario starting bros on top of the roster
    # draft (~1% extra mass), then renormalize back to a distribution.
    scenario_dirs = [VANILLA / "scenarios/world"]
    if "xbe" in d.mods:
        scenario_dirs.append(XBE / "scripts/scenarios/world")
    if "reforged" in d.mods:
        scenario_dirs.append(REFORGED / "scripts/scenarios/world")
    if "necro" in d.mods:
        scenario_dirs.append(NECRO / "scripts/scenarios/world")
    if "druid" in d.mods:
        scenario_dirs.append(DRUID / "scripts/scenarios/world")
    if "heroic" in d.mods:
        scenario_dirs.append(HEROIC / "scripts/scenarios/world")
    if "lone_chosen" in d.mods:
        scenario_dirs.append(LONE_CHOSEN / "scripts/scenarios/world")
    if "north" in d.mods:
        scenario_dirs.append(NORTH / "scripts/scenarios/world")
    if "offp" in d.mods:
        scenario_dirs.append(OFFP / "scripts/scenarios/world")
    scenario_bros, scenario_profiles, n_scenarios = _parse_scenario_bros(scenario_dirs)

    # north (NEM): hiring at barbarian camps (its origin only), their draft
    # list is 4x barbarian + 1x wildman (barbarian_locations_hook.nut)
    camp_mass = 0.0
    if "north" in d.mods:
        camp_mass = NORTH_ORIGIN_CAMP_SHARE / n_scenarios
        d.draft_prob["barbarian_background"] += camp_mass * 0.8
        d.draft_prob["wildman_background"] += camp_mass * 0.2

    event_dirs = [(VANILLA / "events/events", 1.0)]
    if "north" in d.mods:
        event_dirs.append((NORTH / "scripts/events/events", 1.0))
    if "lone_chosen" in d.mods:
        # its volunteer events are gated to the chosen origin
        event_dirs.append((LONE_CHOSEN / "scripts/events/events", 1.0 / n_scenarios))
    if "offp" in d.mods:
        # recruit events sit in per-origin subdirs, each gated to its origin
        event_dirs.append((OFFP / "scripts/events", 1.0 / n_scenarios))
        # OFFP rewires the vanilla one-shot oathbreaker_event to recruit an
        # oathbreaker in its oathtakers origin (offp_oathtakers_events.nut)
        d.draft_prob["oathbreaker_background"] += (
            1.0 / AVG_CAMPAIGN_DAYS / n_scenarios / ROSTER_BROS_PER_DAY)
    for script, rate in _parse_recruit_events(event_dirs):
        if script in d.backgrounds:
            d.draft_prob[script] += rate / ROSTER_BROS_PER_DAY
    total_bros = AVG_CAMPAIGN_DAYS * ROSTER_BROS_PER_DAY
    for script, count in scenario_bros:
        if script in d.backgrounds:
            d.draft_prob[script] += count / total_bros

    # north (NEM): only camp-hired barbarians roll the thrall/chosen traits
    # (barbarian_background_hook.nut, nem_allow_* flags set at camps only)
    d.special_traits = {}
    if "north" in d.mods:
        camp_frac = camp_mass * 0.8 / d.draft_prob["barbarian_background"]
        d.special_traits["barbarian_background"] = {
            "trait.thrall": camp_frac * NORTH_THRALL_CHANCE,
            "trait.chosen": camp_frac * NORTH_CHOSEN_CHANCE}

    # Black Pyramid phobia (special_traits) + innate affinity (elem_affinity),
    # both granted at generation regardless of background — see the constants.
    d.elem_affinity = {}
    if "black_pyramid" in d.mods:
        for bg in d.backgrounds.values():
            eligible = [e for e in BP_ELEMENTS
                        if bg.id not in BP_FEAR_EXCLUDED_BG.get(e, ())]
            fear = d.special_traits.setdefault(bg.script, {})
            for e in eligible:
                fear["trait.elem_fear_" + e] = BP_FEAR_CHANCE / len(eligible)
            if bg.id in BP_AFFINITY_EXCLUDED_BG:
                continue
            aff = d.elem_affinity.setdefault(bg.script, {})
            for e in BP_ELEMENTS:
                p_feared = fear.get("trait.elem_fear_" + e, 0.0)
                aff["perk.elem_%s_affinity" % e] = (
                    BP_BRANCH_CHANCE / len(BP_ELEMENTS) * (1 - p_feared) * BP_AFFINITY_ROLL)

    d.trait_excl = _parse_traits()
    d.trait_pool = sorted(d.trait_excl)

    # Hand-crafted scenario bros (see _parse_scenario_bros) can carry traits the
    # generation machinery never produces (feral, ...). Their trait pool is
    # wiped and replaced with a fixed set, so such a bro is the ONLY source of
    # its out-of-pool traits and only ever in that exact bundle. Model each as a
    # fixed profile whose share of its background's recruits is the bro's draft
    # mass over the background total (draft_prob is still pre-normalization here,
    # like the camp fraction above).
    pool = set(d.trait_pool)
    d.scenario_fixed = []
    for script, tids, count in scenario_profiles:
        bg = d.backgrounds.get(script)
        pre = d.draft_prob.get(script, 0.0)
        if bg is None or pre <= 0.0 or tids <= pool:
            continue
        d.scenario_fixed.append((script, bg.id, tids, (count / total_bros) / pre))
    d.scenario_fixed_traits = frozenset(t for _, _, tids, _ in d.scenario_fixed
                                        for t in tids if t not in pool)

    mass = sum(d.draft_prob.values())
    for script in d.draft_prob:
        d.draft_prob[script] /= mass

    d.bad_traits, d.soso_traits = _parse_stdlib_trait_kinds()
    d.aliases = _parse_aliases()
    d.paupers = _parse_paupers()
    d.perm_injuries = _parse_permanent_injuries()
    d.bgperks = (_parse_bgperks()
                 if "background_perks" in d.mods and BGPERKS_CHANCES.exists() else {})
    d.perk_fallbacks = _parse_perk_fallbacks() if "background_perks" in d.mods else {}

    # starting weapons per background, for weapon.* factors
    item_dirs = [VANILLA / "items"]
    if "xbe" in d.mods:
        item_dirs.append(XBE / "scripts/items")
    weapon_types = _parse_weapon_items(item_dirs)
    if "reforged" in d.mods:
        weapon_types.update(_parse_reforged_weapon_types())
    d.bg_weapons = dict((bg.id, _bg_weapon_probs(bg, weapon_types))
                        for bg in d.backgrounds.values())
    return d


# ── Per-background probabilities ─────────────────────────────────────────────

def _attr_prob(bg, attr, kind):
    lo = BASE_ATTRS[attr][0] + bg.attr_mods.get(attr, (0, 0))[0]
    hi = BASE_ATTRS[attr][1] + bg.attr_mods.get(attr, (0, 0))[1]
    n = max(hi - lo + 1, 1)
    pool = ATTR_COUNT - len(bg.excluded_talents)
    p_star = 0.0 if attr in bg.excluded_talents else min(3.0 / pool, 1.0)
    if kind == "high":
        return p_star * sum(p * min(s, n) / n for s, p in STAR_LEVELS)
    return (1 - p_star) * (1.0 / n)


def _bg_type(bg):
    melee = bg.attr_mods.get("MeleeSkill", (0, 0))[0]
    ranged = bg.attr_mods.get("RangedSkill", (0, 0))[0]
    return "ranged" if ranged > 0 and ranged - melee >= 10 else "melee"


def _bg_groups(bg, data):
    groups = set()
    if "IsOffendedByViolence" in bg.flags: groups.add("peaceful")
    if "IsCombatBackground" in bg.flags: groups.add("combat")
    if "IsNoble" in bg.flags: groups.add("noble")
    if "IsLowborn" in bg.flags: groups.add("lowborn")
    if bg.id in data.paupers: groups.add("pauper")
    return groups


def _perk_chance(bg, perk, data, days):
    key = bg.id[len("background."):]
    chances = dict(data.bgperks.get(key, {}))
    for p, c in data.bgperks.get("ALL", {}).items():
        chances[p] = chances.get(p, 0) + c
    val = chances.get(perk, 0)
    if val <= 0:
        return 0.0
    scale = 1.0 + 0.5 * min(1.0, days / 100.0)
    import math
    return math.floor((val / 100.0) ** (1.0 / scale) * 100) / 100.0


def _perk_prob(bg, perk, data, days):
    """P(perk factor matches): the perk itself or any fallback perk that
    titles.nut aliases back to it (independent rolls)."""
    keys = {perk} | set(f for f, c in data.perk_fallbacks.items() if c == perk)
    q = 1.0
    for k in keys:
        q *= 1.0 - _perk_chance(bg, k, data, days)
    return 1.0 - q


def _weapon_prob(bg, wtype, data, days):
    """P(weapon.X factor): equipped starting weapon of that type, or a
    mastery perk mapped to it (independent paths)."""
    p_equip = min(1.0, sum(prob for types, prob in data.bg_weapons.get(bg.id, [])
                           if wtype in types))
    p_mastery = _perk_prob(bg, "mastery." + wtype, data, days)
    return 1.0 - (1.0 - p_equip) * (1.0 - p_mastery)


@lru_cache(maxsize=None)
def _trait_prob_exact(wanted_rel, sigs, counts0, bg_blocks, allowed_w,
                      extra, strict, n_dist, always_fill, N):
    """Exact P(all wanted traits present) by enumerating pick sequences.

    Unwanted traits are pre-partitioned (see _trait_prob) into classes by
    (which wanted traits they block, which wanted traits block them, excluded
    by background, eligible for the Bro Studio extra) — within a class
    identity does not matter, and backgrounds inducing the same class counts
    share the cache entry.

    wanted_rel: ((trait, frozenset of wanted traits that block it), ...).
    n_dist: distribution of the starting trait count, ((m, weight), ...).
    always_fill: Modular Vanilla's MV_addTraits — every slot fills uniformly
    from the acceptable set (no vanilla 10-retry shortfall).

    A vanilla slot, conditional on acceptance, is uniform over the currently
    acceptable set (10 retries make an empty slot probability (1-A/N)^10).
    Approximation: unwanted picks do not shrink other unwanted availability
    (unwanted-to-unwanted excludes are ignored; effect is ~2-4 traits of ~55).
    """
    T = [t for t, _ in wanted_rel]
    blocked_by_w = dict(wanted_rel)
    K = len(T)
    if K == 0:
        return 1.0

    def t_ok(t, picked_w, picked_c):
        # acceptable for a vanilla slot / strict extra
        if t in picked_w or t in bg_blocks:
            return False
        if blocked_by_w[t] & picked_w:
            return False
        return not any(picked_c[i] and t in sigs[i][0] for i in range(len(sigs)))

    def c_avail(i, picked_w, picked_c, for_extra):
        blocks, blocked_by, bg_blocked, in_allowed = sigs[i]
        n = counts0[i] - picked_c[i]
        if n <= 0:
            return 0
        if for_extra and not in_allowed:
            return 0
        if for_extra and not strict:
            return n
        if bg_blocked or blocked_by & picked_w:
            return 0
        return n

    def walk(slots, extras, picked_w, picked_c):
        if len(picked_w) == K:
            return 1.0
        if slots + extras < K - len(picked_w):
            return 0.0
        for_extra = slots == 0
        next_args = (slots - 1, extras) if slots else (slots, extras - 1)

        if for_extra:
            wanted_ok = [t for t in T if t not in picked_w and t in allowed_w
                         and (not strict or t_ok(t, picked_w, picked_c))]
        else:
            wanted_ok = [t for t in T if t not in picked_w
                         and t_ok(t, picked_w, picked_c)]
        avail = [c_avail(i, picked_w, picked_c, for_extra) for i in range(len(sigs))]
        A = len(wanted_ok) + sum(avail)
        if A == 0:
            return walk(*next_args, picked_w, picked_c)
        # vanilla: uniform over acceptable with 10 retries (or exact fill
        # under Modular Vanilla); extra: uniform over the remaining pool
        p_filled = 1.0 if for_extra or always_fill else 1.0 - ((N - A) / N) ** 10

        total = (1.0 - p_filled) * walk(*next_args, picked_w, picked_c)
        for t in wanted_ok:
            total += p_filled / A * walk(*next_args, picked_w | {t}, picked_c)
        for i, n in enumerate(avail):
            if n:
                pc = list(picked_c)
                pc[i] += 1
                total += p_filled * n / A * walk(*next_args, picked_w, tuple(pc))
        return total

    zero_c = tuple(0 for _ in sigs)
    p = 0.0
    for m, w in n_dist:
        p += w * walk(m, extra, frozenset(), zero_c)
    return p


@lru_cache(maxsize=None)
def _trait_prob_mc(bg_excl, wanted, pool, excl_items, extra, strict, allowed,
                   n_dist, always_fill, n, seed):
    """Monte Carlo of vanilla trait assignment + Bro Studio extras.

    Traits are bitmask-encoded: cur is the picked set, cur_excl the union of
    Excluded lists of the background and everything picked so far.
    """
    rng = random.Random(seed)
    pool = list(pool)
    N = len(pool)
    index = dict((t, i) for i, t in enumerate(pool))
    def mask(ids):
        m = 0
        for t in ids:
            if t in index:
                m |= 1 << index[t]
        return m
    excl = dict(excl_items)
    excl_mask = [mask(excl[t]) for t in pool]
    bg_excl_mask = mask(bg_excl)
    wanted_mask = mask(wanted)
    allowed_idx = [i for i, t in enumerate(pool) if t in allowed]
    A = len(allowed_idx)

    randrange = rng.randrange
    ms, weights = zip(*n_dist)
    attempts_cap = 1000 if always_fill else 10
    hits = 0
    for _ in range(n):
        cur = 0
        cur_excl = bg_excl_mask
        m = ms[0] if len(ms) == 1 else rng.choices(ms, weights)[0]
        for _i in range(m):
            for _j in range(attempts_cap):
                r = randrange(N)
                b = 1 << r
                if (cur | cur_excl) & b:
                    continue
                cur |= b
                cur_excl |= excl_mask[r]
                break
        # Bro Studio extras: uniform without replacement from the allowed pool
        added, attempts = 0, 0
        while added < extra and attempts < 100:
            attempts += 1
            r = allowed_idx[randrange(A)]
            b = 1 << r
            if cur & b or strict and cur_excl & b:
                continue
            cur |= b
            cur_excl |= excl_mask[r]
            added += 1
        if cur & wanted_mask == wanted_mask:
            hits += 1
    return hits / n


def _trait_prob(bg, wanted, data, extra, strict, opts, n=100_000, seed=1, mc=False):
    allowed = [t for t in data.trait_pool
               if (opts.get("bad", True) or t not in data.bad_traits)
               and (opts.get("soso", True) or t not in data.soso_traits)]
    # Reforged overrides Modular Vanilla's MV_getMaxStartingTraits to a flat 2,
    # and MV_addTraits always adds exactly the requested number (no vanilla
    # 10-retry shortfall). Without Reforged: the vanilla distribution.
    if "reforged" in data.mods:
        n_dist, always_fill = ((2, 1.0),), True
    else:
        n_dist, always_fill = ((0, 1 / 6), (1, 5 / 12), (2, 5 / 12)), False

    if mc:
        excl_items = tuple(sorted((t, frozenset(e)) for t, e in data.trait_excl.items()))
        return _trait_prob_mc(frozenset(bg.excluded), frozenset(wanted),
                              tuple(data.trait_pool), excl_items, extra, strict,
                              frozenset(allowed), n_dist, always_fill, n, seed)

    # Collapse the background into class counts so that backgrounds inducing
    # the same picture share a _trait_prob_exact cache entry. The collapse
    # itself is memoized per (background, wanted, opts).
    T = tuple(sorted(wanted))
    cls_key = (bg.id, T, opts.get("bad", True), opts.get("soso", True))
    cache = getattr(data, "_cls_cache", None)
    if cache is None:
        cache = data._cls_cache = {}
    if cls_key not in cache:
        excl = data.trait_excl
        allowed_set = set(allowed)
        classes = {}
        for x in data.trait_pool:
            if x in wanted:
                continue
            sig = (frozenset(t for t in T if t in excl[x]),  # picked x blocks these
                   frozenset(t for t in T if x in excl[t]),  # these block x
                   x in bg.excluded, x in allowed_set)
            classes[sig] = classes.get(sig, 0) + 1
        sigs = tuple(sorted(classes, key=str))
        cache[cls_key] = (
            tuple((t, frozenset(w for w in T if w != t and t in excl[w])) for t in T),
            sigs, tuple(classes[s] for s in sigs),
            frozenset(t for t in T if t in bg.excluded),
            frozenset(t for t in T if t in allowed_set))
    wanted_rel, sigs, counts0, bg_blocks, allowed_w = cache[cls_key]
    return _trait_prob_exact(wanted_rel, sigs, counts0, bg_blocks, allowed_w,
                             extra, strict, n_dist, always_fill, len(data.trait_pool))


# ── Public API ───────────────────────────────────────────────────────────────

def calcFactorsProb(factors, mods=KNOWN_MODS, extra_trait=1, traits_strict=True,
                    perma_chance=0.05, days=0, trait_opts=None, n_sim=200_000,
                    seed=1, mc=False, warn=None):
    """Probability that a fresh recruit has all the given factors.

    factors: list like ["background.monk", "trait.greedy"] or "a + b" string.
    mods: subset of KNOWN_MODS — overlays applied to vanilla data; without
        background_perks all perk factors are 0.
    extra_trait: number of extra traits Bro Studio adds per bro.
    traits_strict: extra traits respect Excluded lists (stdlib 2.6+ behavior;
        False models the older loose stdlib).
    perma_chance: Bro Studio permanent injury chance (fraction, e.g. 0.05).
    days: campaign day for background_perks chance scaling.
    trait_opts: {"bad": bool, "soso": bool} — Bro Studio trait pool settings.
    mc: use Monte Carlo for trait probabilities instead of the exact
        computation (cross-validation); n_sim/seed apply only then.
    warn: optional callable for warnings, default prints to stderr.
    """
    if isinstance(factors, str):
        factors = [f.strip() for f in factors.split("+")]
    factors = [f.strip() for f in factors if f.strip()]
    if warn is None:
        warn = lambda msg: print("warning: " + msg, file=sys.stderr)
    opts = trait_opts or {}
    data = load_data(tuple(sorted(set(mods))))

    bg_sets, traits, injuries, attrs, perks, weapons = [], set(), set(), [], [], []
    groups, types, costs, elem_affinity = set(), set(), set(), []
    for f in factors:
        prefix = f.split(".", 1)[0]
        if prefix == "background":
            accepted = set([f] + [src for src, dst in data.aliases.items() if dst == f])
            bg_sets.append(accepted)
        elif prefix == "trait":
            traits.add(f)
        elif prefix == "injury":
            injuries.add(f)
        elif prefix == "attr":
            _, attr, kind = f.split(".")
            attrs.append((attr, kind))
        elif f in BP_AFFINITY_FACTORS:
            elem_affinity.append(f)
        elif prefix == "perk":
            perks.append(f[len("perk."):])
        elif prefix == "weapon":
            weapons.append(f[len("weapon."):])
        elif prefix == "group":
            groups.add(f[len("group."):])
        elif prefix == "type":
            types.add(f[len("type."):])
        elif prefix == "cost":
            costs.add(f[len("cost."):])
        else:
            raise ValueError("Unknown factor: " + f)

    if len(types) > 1:
        return 0.0
    if len(injuries) > 1:
        return 0.0  # Bro Studio adds at most one permanent injury

    # Background candidates
    candidates = []
    for bg in data.backgrounds.values():
        if any(bg.id not in s for s in bg_sets):
            continue
        if not groups <= _bg_groups(bg, data):
            continue
        if types and _bg_type(bg) not in types:
            continue
        cost_tags = set()
        if bg.runtime_cost >= 20: cost_tags.add("high")
        if bg.runtime_cost <= 10: cost_tags.add("low")
        if not costs <= cost_tags:
            continue
        candidates.append(bg)

    if bg_sets:
        wanted_ids = set.intersection(*bg_sets) if len(bg_sets) > 1 else bg_sets[0]
        if wanted_ids and sum(data.draft_prob.get(bg.script, 0.0)
                              for bg in data.backgrounds.values()
                              if bg.id in wanted_ids) == 0.0:
            warn("%s never appears in draft lists (event-only background?)"
                 % " / ".join(sorted(wanted_ids)))

    p_inj = perma_chance / len(data.perm_injuries) if injuries else 1.0

    # NEM thrall/chosen: granted at hire to some backgrounds, not rolled by
    # the generation trait machinery
    special = set(t for t in traits
                  if any(t in v for v in data.special_traits.values()))
    traits = traits - special
    if len(special) > 1:
        return 0.0  # one roll per hire — thrall and chosen are exclusive

    # Traits only hand-crafted scenario bros carry (feral, ...): such a bro is a
    # fixed bundle, so a combo scores only when one provably holds every factor.
    if traits & data.scenario_fixed_traits:
        if (special or perks or weapons or attrs or elem_affinity
                or injuries or groups or costs or types):
            return 0.0  # nothing else is readable off the fixed bro
        wanted_ids = set.intersection(*bg_sets) if bg_sets else None
        total = 0.0
        for script, bg_id, tids, share in data.scenario_fixed:
            if traits <= tids and (wanted_ids is None or bg_id in wanted_ids):
                total += data.draft_prob.get(script, 0.0) * share
        return total

    bad_traits = traits - set(data.trait_pool)
    if bad_traits:
        warn("traits not in the assignable pool, probability is 0: %s"
             % ", ".join(sorted(bad_traits)))
        return 0.0

    # For MC the error of the weighted average over many backgrounds is
    # smaller than per-background error, so split the iteration budget.
    live = sum(1 for bg in candidates if data.draft_prob.get(bg.script, 0.0) > 0)
    per_bg_n = n_sim if live <= 5 else max(10_000, n_sim // live)

    total = 0.0
    for bg in candidates:
        p = data.draft_prob.get(bg.script, 0.0)
        if p == 0.0:
            continue
        if traits:
            p *= _trait_prob(bg, traits, data, extra_trait, traits_strict, opts,
                             per_bg_n, seed, mc)
        for t in special:
            p *= data.special_traits.get(bg.script, {}).get(t, 0.0)
        for attr, kind in attrs:
            p *= _attr_prob(bg, attr, kind)
        for perk in perks:
            p *= _perk_prob(bg, perk, data, days)
        for perk in elem_affinity:
            p *= data.elem_affinity.get(bg.script, {}).get(perk, 0.0)
        for wtype in weapons:
            p *= _weapon_prob(bg, wtype, data, days)
        total += p
    return total * p_inj


# ── CLI ──────────────────────────────────────────────────────────────────────

def _selftest():
    def check(name, cond):
        print(("ok  " if cond else "FAIL") + " " + name)
        return cond

    ok = True
    p_bg = calcFactorsProb(["background.farmhand"], mods=())
    ok &= check("farmhand vanilla prob in (0.01, 0.2): %.4f" % p_bg, 0.01 < p_bg < 0.2)

    p2 = calcFactorsProb(["background.farmhand", "background.monk"])
    ok &= check("two backgrounds = 0", p2 == 0.0)

    p_strict = calcFactorsProb(["trait.tiny", "trait.huge"], traits_strict=True)
    p_loose = calcFactorsProb(["trait.tiny", "trait.huge"], traits_strict=False)
    ok &= check("tiny+huge strict = 0: %.6f" % p_strict, abs(p_strict) < 1e-12)
    ok &= check("tiny+huge loose > 0: %.6f" % p_loose, p_loose > 0.0)

    # exact vs Monte Carlo cross-validation, with and without Reforged
    for mods in (("xbe", "reforged"), ("xbe",)):
        for combo in (["trait.drunkard"], ["trait.drunkard", "trait.brute"]):
            pe = calcFactorsProb(combo, mods=mods)
            pm = calcFactorsProb(combo, mods=mods, mc=True, n_sim=2_000_000)
            ok &= check("exact %.6f ~ MC %.6f for %s %s" % (pe, pm, "+".join(combo), mods),
                        abs(pe - pm) < 0.15 * max(pe, pm))

    p_rf = calcFactorsProb(["trait.drunkard", "trait.brute"])
    p_van = calcFactorsProb(["trait.drunkard", "trait.brute"], mods=("xbe",))
    ok &= check("reforged 2+1 traits beats vanilla mix: %.5f > %.5f" % (p_rf, p_van),
                p_rf > 1.5 * p_van)

    p_militia_low = calcFactorsProb(["background.militia", "cost.low"])
    ok &= check("militia (base 10, runtime 11) is not cost.low", p_militia_low == 0.0)

    p_combo = calcFactorsProb(["cost.low", "group.combat"])
    ok &= check("cost.low + group.combat > 0: %.5f" % p_combo, p_combo > 0.0)

    p_trait = calcFactorsProb(["trait.greedy"], n_sim=100_000)
    ok &= check("P(trait.greedy) in (0.005, 0.1): %.4f" % p_trait, 0.005 < p_trait < 0.1)

    p_inj = calcFactorsProb(["injury.missing_eye"], perma_chance=0.05)
    ok &= check("P(injury) == perma/11: %.5f" % p_inj, abs(p_inj - 0.05 / 11) < 1e-9)

    p_perk = calcFactorsProb(["background.apprentice", "perk.student"])
    p_apprentice = calcFactorsProb(["background.apprentice"])
    ok &= check("apprentice always has student perk", abs(p_perk - p_apprentice) < 1e-9)

    p_glad = calcFactorsProb(["background.gladiator"])
    ok &= check("gladiator > 0 via arena buildings: %.5f" % p_glad, p_glad > 0.0)

    p_as = calcFactorsProb(["background.assassin"])
    p_as_s = calcFactorsProb(["background.assassin_southern"])
    ok &= check("assassin matches assassin_southern via alias: %.5f" % p_as,
                p_as >= p_as_s > 0.0)

    p_pauper = calcFactorsProb(["group.pauper"])
    ok &= check("group.pauper > 0: %.4f" % p_pauper, p_pauper > 0.0)

    p_necro = calcFactorsProb(["perk.necro.regeneration"])
    ok &= check("perk.necro.regeneration > 0: %.6f" % p_necro, p_necro > 0.0)

    p_spear = calcFactorsProb(["background.militia", "weapon.spear"])
    p_mil = calcFactorsProb(["background.militia"])
    ok &= check("militia starts with a spear sometimes: %.5f" % p_spear,
                0.0 < p_spear < p_mil)

    p_pitchfork = calcFactorsProb(["background.farmhand", "weapon.polearm"])
    ok &= check("farmhand + polearm > 0 via pitchfork: %.6f" % p_pitchfork,
                p_pitchfork > 0.0)

    p_dancer = calcFactorsProb(["background.belly_dancer"], mods=("heroic",))
    p_dancer_v = calcFactorsProb(["background.belly_dancer"], mods=())
    ok &= check("heroic prodigal son boosts belly_dancer via alias: %.5f > %.5f"
                % (p_dancer, p_dancer_v), p_dancer > 1.1 * p_dancer_v > 0.0)

    # lone_chosen's aspirant volunteer event makes the vanilla-absent aspirant
    # background recruitable (its chosen scenario bro is the player character
    # with a hardcoded title, so it contributes no titleable recruit)
    p_asp = calcFactorsProb(["background.aspirant"], mods=("lone_chosen",))
    p_asp_v = calcFactorsProb(["background.aspirant"], mods=())
    ok &= check("lone_chosen aspirant volunteer recruitable: %.6f (vanilla %.6f)"
                % (p_asp, p_asp_v), p_asp > 0.0 and p_asp_v == 0.0)

    p_barb = calcFactorsProb(["background.barbarian"], mods=("north",))
    p_barb_v = calcFactorsProb(["background.barbarian"], mods=())
    ok &= check("north camps boost barbarian: %.5f > %.5f" % (p_barb, p_barb_v),
                p_barb > 3 * p_barb_v > 0.0)

    p_thrall = calcFactorsProb(["trait.thrall"], mods=("north",))
    p_thrall_barb = calcFactorsProb(["background.barbarian", "trait.thrall"],
                                    mods=("north",))
    ok &= check("trait.thrall only on barbarians: %.6f" % p_thrall,
                abs(p_thrall - p_thrall_barb) < 1e-12 and p_thrall > 0.0)
    p_both = calcFactorsProb(["trait.thrall", "trait.chosen"], mods=("north",))
    ok &= check("thrall + chosen exclusive = 0", p_both == 0.0)

    # NEM's barbarian raiders scenario hands one wildman starting bro a fixed
    # {feral, iron_jaw} bundle with its other traits wiped
    p_feral = calcFactorsProb(["trait.feral"], mods=("north",))
    p_feral_v = calcFactorsProb(["trait.feral"], mods=())
    ok &= check("NEM scenario feral wildman > 0: %.7f" % p_feral, p_feral > 0.0)
    ok &= check("feral is north-only = 0: %.7f" % p_feral_v, p_feral_v == 0.0)
    p_feral_wild = calcFactorsProb(["background.wildman", "trait.feral"], mods=("north",))
    ok &= check("feral only on the wildman bro: %.7f" % p_feral_wild,
                abs(p_feral_wild - p_feral) < 1e-12 and p_feral_wild > 0.0)
    p_feral_ij = calcFactorsProb(["trait.feral", "trait.iron_jaw"], mods=("north",))
    ok &= check("feral bro also always has iron_jaw", abs(p_feral_ij - p_feral) < 1e-12)
    p_feral_bt = calcFactorsProb(["trait.feral", "trait.bloodthirsty"], mods=("north",))
    ok &= check("feral bro rolls no other traits = 0", p_feral_bt == 0.0)

    p_fear = calcFactorsProb(["trait.elem_fear_fire"], mods=("black_pyramid",))
    p_fear_v = calcFactorsProb(["trait.elem_fear_fire"], mods=())
    ok &= check("black_pyramid phobia ~5%%: %.4f" % p_fear, 0.03 < p_fear < 0.06)
    ok &= check("phobia is black_pyramid-only = 0: %.6f" % p_fear_v, p_fear_v == 0.0)
    p_two_fears = calcFactorsProb(["trait.elem_fear_fire", "trait.elem_fear_ice"],
                                  mods=("black_pyramid",))
    ok &= check("one phobia per bro, two = 0", p_two_fears == 0.0)
    p_monk_fire = calcFactorsProb(["background.monk", "trait.elem_fear_fire"],
                                  mods=("black_pyramid",))
    ok &= check("monk never fears fire = 0", p_monk_fire == 0.0)
    p_aff = calcFactorsProb(["perk.elem_fire_affinity"], mods=("black_pyramid",))
    p_aff_v = calcFactorsProb(["perk.elem_fire_affinity"], mods=())
    ok &= check("black_pyramid affinity ~0.3%%: %.5f" % p_aff, 0.001 < p_aff < 0.006)
    ok &= check("affinity is black_pyramid-only = 0: %.6f" % p_aff_v, p_aff_v == 0.0)

    p_oath = calcFactorsProb(["background.oathbreaker"], mods=("offp",))
    ok &= check("offp oathbreaker > 0: %.7f" % p_oath, p_oath > 0.0)
    p_pal = calcFactorsProb(["background.paladin"], mods=("offp",))
    p_pal_v = calcFactorsProb(["background.paladin"], mods=())
    # forts' base lists and temples still draft paladins, OFFP only cuts the
    # watchtower/outpost pushes
    ok &= check("offp cuts paladin draft: %.5f < %.5f" % (p_pal, p_pal_v),
                0.0 < p_pal < 0.8 * p_pal_v)

    if not ok:
        sys.exit(1)


def _fmt(p):
    return "%.0f" % (1 / p) if p > 0 else "-"


def cmd_titles(args):
    """For every title: total chance and chance per factor combo,
    each as a 'vanilla -> modded' pair of 1-in-N numbers."""
    mods = tuple(m for m in args.mods.split(",") if m)
    modded = dict(mods=mods, extra_trait=args.extra_trait, traits_strict=args.strict,
                  perma_chance=args.perma, days=args.days)
    vanilla = dict(mods=(), extra_trait=0, perma_chance=0.0)
    silent = lambda msg: None

    memo = {}
    def probs(combo):
        if combo not in memo:
            memo[combo] = (calcFactorsProb(combo, warn=silent, **vanilla),
                           calcFactorsProb(combo, warn=silent, **modded))
        return memo[combo]

    print("// 1 in N, vanilla -> with mods, '-' = never")
    for entry in _parse_titles():
        pairs = [probs(c) for c in entry["combos"]]
        tv, tm = sum(p[0] for p in pairs), sum(p[1] for p in pairs)
        print("%-56s %6s -> %s" % (entry["label"], _fmt(tv), _fmt(tm)))
        for combo, (pv, pm) in zip(entry["combos"], pairs):
            print("    %-52s %6s -> %s" % (combo, _fmt(pv), _fmt(pm)))


def cmd_factors(args):
    """Every known factor with its 'vanilla -> modded' 1-in-N chance."""
    mods = tuple(m for m in args.mods.split(",") if m)
    modded = dict(mods=mods, extra_trait=args.extra_trait, traits_strict=args.strict,
                  perma_chance=args.perma, days=args.days)
    vanilla = dict(mods=(), extra_trait=0, perma_chance=0.0)
    silent = lambda msg: None
    data = load_data(tuple(sorted(set(mods))))

    perk_keys = set()
    for chances in data.bgperks.values():
        perk_keys |= set(chances)
    factors = (
        # alias-source variants (southern, origin, rf_*) fold into canonicals
        sorted(set(bg.id for bg in data.backgrounds.values()) - set(data.aliases))
        + sorted(data.trait_pool)
        + sorted(set(t for v in data.special_traits.values() for t in v))
        + ["attr.%s.%s" % (a, k) for a in sorted(BASE_ATTRS) for k in ("high", "low")]
        + ["type.melee", "type.ranged"]
        + ["group.combat", "group.lowborn", "group.noble", "group.pauper", "group.peaceful"]
        + ["cost.high", "cost.low"]
        + sorted(data.perm_injuries)
        + ["perk." + k for k in sorted(perk_keys) if not k.startswith("mastery.")]
        + sorted(set(p for v in data.elem_affinity.values() for p in v))
        + ["weapon." + w for w in sorted(WEAPON_TYPES)]
    )
    print("// 1 in N, vanilla -> with mods, '-' = never")
    for f in factors:
        pv = calcFactorsProb([f], warn=silent, **vanilla)
        pm = calcFactorsProb([f], warn=silent, **modded)
        print("%-44s %6s -> %s" % (f, _fmt(pv), _fmt(pm)))


def main():
    ap = argparse.ArgumentParser(description="Estimate factor combination probability")
    ap.add_argument("combo", nargs="?", help='e.g. "background.monk + trait.greedy; trait.fat"')
    ap.add_argument("--titles", action="store_true",
                    help="print vanilla/modded chances for every title in titles.nut")
    ap.add_argument("--factors", action="store_true",
                    help="print vanilla/modded chances for every known factor")
    ap.add_argument("--mods", "-m", default=",".join(KNOWN_MODS),
                    help="comma-separated overlays (default: %s); use '' for vanilla"
                         % ",".join(KNOWN_MODS))
    ap.add_argument("--extra-trait", type=int, default=1, help="Bro Studio extra traits (default 1)")
    ap.add_argument("--loose", dest="strict", action="store_false",
                    help="extra traits ignore excludes (pre-2.6 stdlib)")
    ap.add_argument("--perma", type=float, default=0.05, help="Bro Studio injury chance (default 0.05)")
    ap.add_argument("--days", type=int, default=0, help="campaign day for perk chance scaling")
    ap.add_argument("--mc", action="store_true",
                    help="use Monte Carlo instead of exact trait computation")
    ap.add_argument("-n", "--n-sim", type=int, default=200_000,
                    help="MC iterations with --mc (default 200k)")
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()

    if args.selftest:
        _selftest()
        return
    if args.titles:
        cmd_titles(args)
        return
    if args.factors:
        cmd_factors(args)
        return
    if not args.combo:
        ap.error("combo required (or --selftest / --titles / --factors)")

    mods = tuple(m for m in args.mods.split(",") if m)
    combos = [c.strip() for c in args.combo.split(";") if c.strip()]
    total = 0.0
    for combo in combos:
        p = calcFactorsProb(combo, mods=mods, extra_trait=args.extra_trait,
                            traits_strict=args.strict, perma_chance=args.perma,
                            days=args.days, n_sim=args.n_sim, seed=args.seed, mc=args.mc)
        total += p
        print("%-60s %.6f  (1 in %s)" % (combo, p, ("%.0f" % (1 / p)) if p else "inf"))
    if len(combos) > 1:
        print("%-60s %.6f  (naive sum, upper bound)" % ("ANY", total))


if __name__ == "__main__":
    main()
