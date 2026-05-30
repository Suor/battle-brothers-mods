local def = {
    m = {}
    function create()
    {
        this.m.ID = "pg.druid";
        this.m.Name = "Druid";
        this.m.Icon = "druid/perk_apex.png";
        this.m.Chance = 0;
        this.m.Tree = [[], [], [], [], [], [], []];
        foreach (perk in ::Const.Perks.Druid) {
            this.m.Tree[perk.Row].push(perk.ID);
        }
    }
}

this.druid_pg <- ::DynamicPerks != "druid_placeholder"
    ? ::inherit(::DynamicPerks.Class.SpecialPerkGroup, def) : def;
