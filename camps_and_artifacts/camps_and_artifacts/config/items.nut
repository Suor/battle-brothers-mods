// Add "Artifact" item type on top
local maxValue = -1;
foreach (_, value in ::Const.Items.ItemType) {
    if (value > maxValue) maxValue = value;
}
local artifactType = maxValue * 2;
::Const.Items.ItemType.Artifact <- artifactType;
::Const.Items.ItemFilter.All = ::Const.Items.ItemFilter.All | artifactType;

// List of artifact classes
::Const.Items.Artifacts <- [
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
    "weapons/artifact/artifact_javelin", // double it to make more throwing weapons
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
    "weapons/artifact/artifact_throwing_axe", // double it to make more throwing weapons
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

    // NOTE: these are not used anymore, replaced with more interesting ammo,
    //       scripts are kept to not break savegames
    // "ammo/artifact_powder_bag",
    // "ammo/artifact_quiver_of_arrows",
    // "ammo/artifact_quiver_of_bolts"

    "ammo/artifact_imbued_arrows"
    "ammo/artifact_imbued_arrows"
    "ammo/artifact_imbued_bolts"
    "ammo/artifact_imbued_bolts"
    // "ammo/artifact_imbued_shrapnel"
]
