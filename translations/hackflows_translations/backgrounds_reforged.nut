if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.4.0")) return;

local rosetta = {
    mod = {id = "mod_backgrounds_and_events_reforged_patch", version = "0.7.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_backgrounds_reforged.nut
    {
        en = "More Backgrounds and Events Reforged Patch"
        ru = "Патч совместимости XBE и Reforged"
    }
    // FILE: mod_backgrounds_reforged/hooks/folk_hero_background.nut
    {
        en = "Has access to the [Battle Fervor|Perk+perk_battle_fervor] [perk|Concept.Perk] at tier 1 of the perk tree"
        ru = "Имеет доступ к [навыку|Concept.Perk] [Боевой пыл|Perk+perk_battle_fervor] в первом ряду дерева навыков"
    }
    // FILE: mod_backgrounds_reforged/hooks/lancer_background.nut
    {
        en = "Has the [Polearm Mastery|Perk+perk_mastery_polearm] [perk|Concept.Perk] permanently for free"
        ru = "Имеет [навык|Concept.Perk] [Мастер древкового оружия|Perk+perk_mastery_polearm] постоянно и бесплатно"
    }
    // FILE: mod_backgrounds_reforged/hooks/master_archer_background.nut
    {
        en = "Has either [Bow Mastery|Perk+perk_mastery_bow] or [Crossbow Mastery|Perk+perk_mastery_crossbow] permanently for free"
        ru = "Имеет [Мастер лука|Perk+perk_mastery_bow] или [Мастер арбалета|Perk+perk_mastery_crossbow] [навык|Concept.Perk] постоянно и бесплатно"
    }
    // FILE: mod_backgrounds_reforged/hooks/paladin_commander_background.nut
    {
        en = "Has the [Exude Confidence|Perk+perk_rf_exude_confidence] [perk|Concept.Perk] permanently for free"
        ru = "Имеет [Уверенность|Perk+perk_rf_exude_confidence] [навык|Concept.Perk] постоянно и бесплатно"
    }
]
::Rosetta.add(rosetta, pairs);
