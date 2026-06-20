// Shared Druid helpers, split out of mod_druid.nut. Loaded via ::include("druid/helpers") from
// inside the mod's queue, so ::Druid and the game globals already exist when this runs.
local def = ::Druid;

// Beastform's permanent transformation: shed any newly-forbidden gear and take the beast look.
// Relocation follows perma's missing_hand: drop on the ground mid-battle, else to the bag, else
// to the stash - so nothing is ever lost. (Beastform is taken in the world, so usually the bag.)
def.relocateItem <- function (_actor, _item) {
    local items = _actor.getItems();
    items.unequip(_item);
    if ("State" in ::Tactical && !::Tactical.State.isBattleEnded() && _actor.isPlacedOnMap()) {
        _item.drop(_actor.getTile());
    } else if (_item.isAllowedInBag() && items.hasEmptySlot(::Const.ItemSlot.Bag)) {
        items.addToBag(_item);
    } else {
        ::World.Assets.getStash().makeEmptySlots(1);
        ::World.Assets.getStash().add(_item);
    }
}
def.applyBeastform <- function (_actor) {
    local items = _actor.getItems();
    foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand, ::Const.ItemSlot.Body,
                      ::Const.ItemSlot.Head, ::Const.ItemSlot.Accessory, ::Const.ItemSlot.Ammo]) {
        local item = items.getItemAtSlot(slot);
        if (item == null || ::Const.Druid.beastformAllows(item)) continue;
        def.relocateItem(_actor, item);
    }
    def.applyBeastformLook(_actor);
}
// The beast look ships with the mod (brushes/druid_beast.brush + gfx/druid_beast.png, vendored
// from Fantasy Brothers' Baku set), so no Fantasy Brothers dependency.
def.applyBeastformLook <- function (_actor) {
    local body = _actor.getSprite("body");
    local head = _actor.getSprite("head");
    body.setBrush("druid_beast_body_0" + ::Math.rand(1, 2));
    head.setBrush("druid_beast_head_0" + ::Math.rand(1, 3));
    if (_actor.hasSprite("hair"))
        _actor.getSprite("hair").setBrush("druid_beast_hair_0" + ::Math.rand(1, 5));
    if (_actor.hasSprite("injury_body"))
        _actor.getSprite("injury_body").setBrush(body.getBrush().Name + "_injured");
    head.varyColor(0.05, 0.05, 0.05);
    body.Color = head.Color;
    _actor.setDirty(true);
}

// Make a beast part of the druid's pack: if the master holds the Beast Aura perk it arrives
// Confident and leashed to his side. Fearlessness rides the Beast Aura receiver by proximity (on
// every allied animal, actor.onPlacedOnMap). m.druid_master must already be set on the beast.
def.onBeastJoinedPack <- function (_user, _beast, _confident = true) {
    if (!_user.getSkills().hasSkill("perk.druid.beast_aura")) return;

    // Confident gives the combat bonus without MoraleState.Ignore, so the beast still reacts to
    // battle.
    if (_confident) _beast.setMoraleState(::Const.MoraleState.Confident);

    // Leash: ai_protect makes the beast guard a high-TargetAttractionMult VIP ally - the druid,
    // marked by his Beast Aura (::Const.Druid.Aura.TargetAttractionMult) - just as the game's
    // zombie/direwolf bodyguards do. Plain beast agents lack it, so add it and re-finalize the
    // behaviour list, as agent.create() does after onAddBehaviors().
    local agent = _beast.getAIAgent();
    if (agent != null && agent.getBehavior(::Const.AI.Behavior.ID.Protect) == null) {
        agent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_protect"));
        agent.finalizeBehaviors();
    }
}

// The forest bonuses (faster travel, longer sight under the canopy) belong to the Wolf-and-the-
// Bear origin only, not to any band that happens to hire a druid.
def.isDruidScenario <- function () {
    if (!("World" in getroottable()) || ::World == null || !("Assets" in ::World)) return false;
    local assets = ::World.Assets;
    if (assets == null) return false;
    local origin = assets.getOrigin();
    return origin != null && origin.getID() == "scenario.druid";
}
