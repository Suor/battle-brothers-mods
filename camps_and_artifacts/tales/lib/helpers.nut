// Shared helpers for the Camps and Artifacts scenarios, loaded by `// include: lib/helpers.nut`.

::CAT <- {};

::CAT.artifactScripts <- function (_kind = null) {
    local seen = {}, out = [];
    foreach (a in ::Const.Items.Artifacts) {
        if (a in seen || (_kind != null && a.find(_kind) != 0)) continue;
        seen[a] <- true;
        out.push("scripts/items/" + a);
    }
    return out;
}

// The stats a save must keep, per item kind.
::CAT.itemStats <- function (_i) {
    local m = _i.m, out = {ID = _i.getID(), Name = _i.getName(), ConditionMax = m.ConditionMax};
    foreach (k in ["StaminaModifier", "RegularDamage", "RegularDamageMax", "ArmorDamageMult",
                   "ChanceToHitHead", "ShieldDamage", "AdditionalAccuracy", "DirectDamageAdd",
                   "FatigueOnSkillUse", "AmmoMax", "MeleeDefense", "RangedDefense", "Ammo",
                   "campart_Effect", "AttachedPerk", "Vision"])
        if (k in m) out[k] <- m[k];
    return out;
}

::CAT.findInStash <- function (_id, _name) {
    foreach (i in ::World.Assets.getStash().getItems())
        if (i != null && i.getID() == _id && i.getName() == _name) return i;
    return null;
}
