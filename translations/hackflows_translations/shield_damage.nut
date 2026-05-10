if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.4.0")) return;

local rosetta = {
    mod = {id = "graven_passive_shield_damage_bonus", version = "1.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/!mod_graven_passive_shield_damage_bonus.nut
    {
        en = "Passive Shield Damage Bonus"
        ru = "Пассивный бонус к урону по щитам"
    }
    // if (main != null && this.String.contains(main.m.Categories, "Axe") && user.getCurrentProperties().IsSpecializedInAxes)
    // en = "<this.String.contains(main.m.Categories, Axe)&&user.getCurrentProperties().IsSpecializedInAxes>"
    {
        // this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " has destroyed " + this.Const.UI.getColorizedEntityName(targetEntity) + "\'s shield");
        mode = "pattern"
        en = "<user:str_tag> has destroyed <target:str_tag>'s shield"
        ru = "<user> уничтожает [color=#333333]щит[/color] <target>"
    }
]
::Rosetta.add(rosetta, pairs);
