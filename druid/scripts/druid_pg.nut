local def = {
    m = {}
    function create()
    {
        this.m.ID = "pg.druid";
        this.m.Name = "Druid";
        this.m.Icon = "druid/background_druid.png";
        this.m.Chance = 0;
        this.m.Tree = [[], [], [], [], [], [], []];
        foreach (perk in ::Const.Perks.Druid) {
            this.m.Tree[perk.Row].push(perk.ID);
        }
    }
}

// A string value is a placeholder (ours or a sibling mod's); the real DynamicPerks is a table.
local hasDPF = ("DynamicPerks" in getroottable()) && typeof ::DynamicPerks != "string";
this.druid_pg <- hasDPF ? ::inherit(::DynamicPerks.Class.SpecialPerkGroup, def) : def;
