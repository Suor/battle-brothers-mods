// Shared helpers for the AC scenarios, loaded by `// include: lib/helpers.nut`.

::ACT <- {};

// A tamed companion collar of _type, as the Tame skill makes it.
::ACT.collar <- function (_type) {
    local item = ::new("scripts/items/accessory/wardog_item");
    item.setType(_type);
    return item;
}

// Equips a collar of _type on _bro and unleashes it at _tile through the unleash skill.
::ACT.unleash <- function (_bro, _type, _tile) {
    local items = _bro.getItems();
    local old = items.getItemAtSlot(::Const.ItemSlot.Accessory);
    if (old != null) items.unequip(old);
    items.equip(::ACT.collar(_type));
    _bro.getSkills().getSkillByID("actives.unleash_companion").onUse(_bro, _tile);
    return _tile.getEntity();
}

// Feasts once with _actor (Gruesome Feast on its own tile, as the AI uses it); the growth shows
// after the skill's scheduled 500 ms.
::ACT.feast <- function (_actor) {
    _actor.getSkills().getSkillByID("actives.gruesome_feast").onUse(_actor, _actor.getTile());
}
// [size, HP max, Reach]; Reach is Reforged's, 0 without it.
::ACT.ghoulState <- function (_g) {
    local p = _g.getCurrentProperties();
    return [_g.getSize(), _g.getHitpointsMax(), "Reach" in p ? p.Reach : 0];
}
