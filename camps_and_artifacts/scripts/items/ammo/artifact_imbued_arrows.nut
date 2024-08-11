this.artifact_imbued_arrows <- this.inherit("scripts/items/ammo/artifact_ammo", {
    m = {},
    function create()
    {
        this.artifact_ammo.create()
        this.m.ID = "ammo.arrows";
        this.m.Name = "Arrows";
        this.m.Description = "A quiver of arrows";
        this.m.Icon = "ammo/quiver_03.png";
        this.m.IconEmpty = "ammo/quiver_03_empty.png";
        this.m.SlotType = this.Const.ItemSlot.Ammo;
        this.m.ItemType = this.Const.Items.ItemType.Ammo;
        this.m.AmmoType = this.Const.Items.AmmoType.Arrows;
        this.m.ShowOnCharacter = true;
        this.m.ShowQuiver = true;
        this.m.Sprite = "bust_quiver_01";
        this.m.Value = 10000;
        this.m.Ammo = 15;
        this.m.AmmoMax = 15;
        this.m.IsDroppedAsLoot = true;

        this.m.campart_IconNoun = "arrows";
        this.m.campart_Effect = ::CampsAndArtifacts.choice(["fire", "ice", "poison", "bleeding"]);
        this.updateIcon();
    }
})
