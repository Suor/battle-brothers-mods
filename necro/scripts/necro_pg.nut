local def = {
    m = {}
    function create()
    {
        this.m.ID = "pg.necro";
        this.m.Name = "Necromancer";
        this.m.Icon = "necro/perk_mastery.png";
        this.m.Tree = [[], [], [], [], [], [], []];
        foreach (perk in ::Const.Perks.Necro) {
            this.m.Tree[perk.Row].push(perk.ID);
        }
    }
}

this.necro_pg <- "DynamicPerks" in getroottable()
    ? ::inherit(::DynamicPerks.Class.PerkGroup, def) : def;