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

this.necro_pg <- ::DynamicPerks != "necro_placeholder"
    ? ::inherit(::DynamicPerks.Class.SpecialPerkGroup, def) : def;
