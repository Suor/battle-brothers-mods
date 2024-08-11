this.artifact_imbued_bolts <- this.inherit("scripts/items/ammo/artifact_ammo", {
    m = {},
    function create()
    {
        this.artifact_ammo.create()
        this.m.ID = "ammo.bolts";
        this.m.Name = "Bolts";
        this.m.Description = "An quiver of bolts";
        this.m.Icon = "ammo/quiver_04.png";
        this.m.IconEmpty = "ammo/quiver_04_empty.png";
        this.m.SlotType = this.Const.ItemSlot.Ammo;
        this.m.ItemType = this.Const.Items.ItemType.Ammo;
        this.m.AmmoType = this.Const.Items.AmmoType.Bolts;
        this.m.ShowOnCharacter = true;
        this.m.ShowQuiver = true;
        this.m.Sprite = "bust_quiver_01";
        this.m.Value = 10000;
        this.m.Ammo = 15;
        this.m.AmmoMax = 15;
        this.m.IsDroppedAsLoot = true;

        this.m.campart_IconNoun = "bolts";
        this.m.campart_Effect = ::CampsAndArtifacts.choice(["ice", "poison", "shock", "bleeding"]);
        this.updateIcon();
    }
})
