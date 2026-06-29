local def = {
    m = {}
    function create()
    {
        this.m.ID = "pg.necro";
        this.m.Name = "Necromancer";
        this.m.Icon = "necro/perk_mastery.png";
        this.m.Chance = 0;
        this.m.Tree = [[], [], [], [], [], [], []];
        foreach (perk in ::Const.Perks.Necro) {
            this.m.Tree[perk.Row].push(perk.ID);
        }
    }
}

// A string value is a placeholder (ours or a sibling mod's); the real DynamicPerks is a table.
local hasDPF = ("DynamicPerks" in getroottable()) && typeof ::DynamicPerks != "string";
this.necro_pg <- hasDPF ? ::inherit(::DynamicPerks.Class.SpecialPerkGroup, def) : def;
