local gt = this.getroottable();

if (!("Items" in gt.Const))
{
	gt.Const.Items <- {};
}

gt.Const.Items.Default <- {
	PlayerQuiver = "bust_quiver_01",
	PlayerNakedBody = "bust_naked_body_01",
	PlayerCorpse = "bust_naked_body_01_dead",
	ShieldDecal = "broken_shield_01",
	GenericItemName = "Generic Item",
	GenericItemIcon = "skills/passive_03.png",
	RaiseShieldOffset = this.createVec(0, 10),
	RaiseShieldDuration = 0.15,
	LowerShieldDuration = 0.4,
	RaiseWeaponDuration = 0.25,
	LowerWeaponDuration = 0.2
};
gt.Const.Items.ItemType <- {
	None = 0,
	Legendary = 1,
	Named = 2,
	Armor = 4,
	Helmet = 8,
	Shield = 16,
	Defensive = 32,
	Weapon = 64,
	OneHanded = 128,
	TwoHanded = 256,
	MeleeWeapon = 512,
	RangedWeapon = 1024,
	Ammo = 2048,
	Tool = 4096,
	Accessory = 8192,
	Usable = 16384,
	Misc = 32768,
	Loot = 65536,
	Crafting = 131072,
	Supply = 262144,
	Food = 524288,
	TradeGood = 1048576,
	Artifact = 2097152
};
gt.Const.Items.ItemFilter <- {
	Weapons = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.Accessory | this.Const.Items.ItemType.Tool | this.Const.Items.ItemType.Ammo,
	Armor = this.Const.Items.ItemType.Armor | this.Const.Items.ItemType.Helmet | this.Const.Items.ItemType.Shield,
	Misc = this.Const.Items.ItemType.Supply | this.Const.Items.ItemType.Food | this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.TradeGood | this.Const.Items.ItemType.Loot | this.Const.Items.ItemType.Crafting,
	Usable = this.Const.Items.ItemType.Usable,
	All = 1 | 2 | 4 | 8 | 16 | 32 | 64 | 128 | 256 | 512 | 1024 | 2048 | 4096 | 8192 | 16384 | 32768 | 65536 | 131072 | 262144 | 524288 | 1048576 | 2097152
};
gt.Const.Items.AmmoType <- {
	None = 0,
	Arrows = 1,
	Bolts = 2,
	Spears = 4,
	Powder = 8
};
gt.Const.Items.Property <- {
	None = 0,
	IgnoresShieldwall = 8
};
gt.Const.Items.InventoryEventType <- {
	None = 0,
	Equipped = 1,
	PlacedInBag = 2,
	PlacedInStash = 3,
	PlacedOnGround = 4
};
gt.Const.Items.Paint <- {
	None = 0,
	Black = 1,
	WhiteBlue = 2,
	WhiteGreenYellow = 3,
	OrangeRed = 4,
	Red = 5
};
gt.Const.Items.ConditionColor <- [
	"#ff1e00",
	"#ff8400",
	"#ffea00",
	"#c0ff00",
	"#ffffff"
];
gt.Const.Items.NamedArmors <- [
	"armor/named/black_leather_armor",
	"armor/named/blue_studded_mail_armor",
	"armor/named/brown_coat_of_plates_armor",
	"armor/named/golden_scale_armor",
	"armor/named/green_coat_of_plates_armor",
	"armor/named/heraldic_mail_armor"
];
gt.Const.Items.NamedHelmets <- [
	"helmets/named/golden_feathers_helmet",
	"helmets/named/heraldic_mail_helmet",
	"helmets/named/nasal_feather_helmet",
	"helmets/named/sallet_green_helmet",
	"helmets/named/wolf_helmet",
	"helmets/named/lindwurm_helmet"
];
gt.Const.Items.NamedShields <- [
	"shields/named/named_dragon_shield",
	"shields/named/named_full_metal_heater_shield",
	"shields/named/named_golden_round_shield",
	"shields/named/named_red_white_shield",
	"shields/named/named_rider_on_horse_shield",
	"shields/named/named_wing_shield"
];
gt.Const.Items.NamedBanditShields <- [
	"shields/named/named_bandit_kite_shield",
	"shields/named/named_bandit_heater_shield"
];
gt.Const.Items.NamedUndeadShields <- [
	"shields/named/named_undead_heater_shield",
	"shields/named/named_undead_kite_shield"
];
gt.Const.Items.NamedOrcShields <- [
	"shields/named/named_orc_heavy_shield"
];
gt.Const.Items.NamedSouthernShields <- [];
gt.Const.Items.NamedOrcWeapons <- [
	"weapons/named/named_orc_axe",
	"weapons/named/named_orc_cleaver"
];
gt.Const.Items.NamedGoblinWeapons <- [
	"weapons/named/named_goblin_falchion",
	"weapons/named/named_goblin_heavy_bow",
	"weapons/named/named_goblin_pike",
	"weapons/named/named_goblin_spear"
];
gt.Const.Items.NamedMeleeWeapons <- [
	"weapons/named/named_axe",
	"weapons/named/named_billhook",
	"weapons/named/named_cleaver",
	"weapons/named/named_dagger",
	"weapons/named/named_flail",
	"weapons/named/named_greataxe",
	"weapons/named/named_greatsword",
	"weapons/named/named_longaxe",
	"weapons/named/named_mace",
	"weapons/named/named_spear",
	"weapons/named/named_sword",
	"weapons/named/named_two_handed_hammer",
	"weapons/named/named_warbrand",
	"weapons/named/named_warhammer",
	"weapons/named/named_pike"
];
gt.Const.Items.NamedRangedWeapons <- [
	"weapons/named/named_crossbow",
	"weapons/named/named_javelin",
	"weapons/named/named_throwing_axe",
	"weapons/named/named_warbow"
];
gt.Const.Items.NamedWeapons <- clone this.Const.Items.NamedMeleeWeapons;
gt.Const.Items.NamedWeapons.extend(this.Const.Items.NamedRangedWeapons);
gt.Const.Items.NamedBarbarianWeapons <- [];
gt.Const.Items.NamedBarbarianHelmets <- [];
gt.Const.Items.NamedBarbarianArmors <- [];
gt.Const.Items.NamedSouthernWeapons <- [];
gt.Const.Items.NamedSouthernMeleeWeapons <- [];
gt.Const.Items.NamedSouthernHelmets <- [];
gt.Const.Items.NamedSouthernArmors <- [];
gt.Const.Items.NamedUndeadWeapons <- [
	"weapons/named/named_bladed_pike",
	"weapons/named/named_crypt_cleaver",
	"weapons/named/named_warscythe",
	"weapons/named/named_khopesh"
];
gt.Const.Items.Artifacts <- [
	"weapons/artifact/artifact_axe",
	"weapons/artifact/artifact_bardiche",
	"weapons/artifact/artifact_battle_whip",
	"weapons/artifact/artifact_billhook",
	"weapons/artifact/artifact_bladed_pike",
	"weapons/artifact/artifact_cleaver",
	"weapons/artifact/artifact_crossbow",
	"weapons/artifact/artifact_crypt_cleaver",
	"weapons/artifact/artifact_dagger",
	"weapons/artifact/artifact_qatal_dagger",
	"weapons/artifact/artifact_fencing_sword",
	"weapons/artifact/artifact_flail",
	"weapons/artifact/artifact_greataxe",
	"weapons/artifact/artifact_greatsword",
	"weapons/artifact/artifact_javelin",
	"weapons/artifact/artifact_longaxe",
	"weapons/artifact/artifact_mace",
	"weapons/artifact/artifact_orc_axe",
	"weapons/artifact/artifact_orc_cleaver",
	"weapons/artifact/artifact_pike",
	"weapons/artifact/artifact_polehammer",
	"weapons/artifact/artifact_rusty_warblade",
	"weapons/artifact/artifact_shamshir",
	"weapons/artifact/artifact_spear",
	"weapons/artifact/artifact_sword",
	"weapons/artifact/artifact_three_headed_flail",
	"weapons/artifact/artifact_throwing_axe",
	"weapons/artifact/artifact_two_handed_flail",
	"weapons/artifact/artifact_two_handed_hammer",
	"weapons/artifact/artifact_two_handed_mace",
	"weapons/artifact/artifact_two_handed_scimitar",
	"weapons/artifact/artifact_warbow",
	"weapons/artifact/artifact_handgonne",
	"weapons/artifact/artifact_warhammer",
	"weapons/artifact/artifact_warscythe",
	"weapons/artifact/artifact_swordlance",
	"shields/artifact/artifact_golden_round_shield",
	"shields/artifact/artifact_schract_shield",
	"shields/artifact/artifact_sipar_shield",
	"shields/artifact/artifact_orc_heavy_shield",
	"armor/artifact/artifact_black_leather_armor",
	"armor/artifact/artifact_blue_studded_mail_armor",
	"armor/artifact/artifact_brown_coat_of_plates_armor",
	"armor/artifact/artifact_golden_scale_armor",
	"armor/artifact/artifact_green_coat_of_plates_armor",
	"armor/artifact/artifact_lindwurm_armor",
	"armor/artifact/artifact_noble_mail_armor",
	"armor/artifact/artifact_sellswords_armor",
	"armor/artifact/artifact_leopard_armor",
	"helmets/artifact/artifact_golden_feathers_helmet",
	"helmets/artifact/artifact_heraldic_mail_helmet",
	"helmets/artifact/artifact_lindwurm_helmet",
	"helmets/artifact/artifact_metal_bull_helmet",
	"helmets/artifact/artifact_metal_nose_horn_helmet",
	"helmets/artifact/artifact_metal_skull_helmet",
	"helmets/artifact/artifact_sallet_green_helmet",
	"helmets/artifact/artifact_wolf_helmet",
	"helmets/artifact/artifact_norse_helmet",
	"ammo/artifact_powder_bag",
	"ammo/artifact_quiver_of_arrows",
	"ammo/artifact_quiver_of_bolts"
];
