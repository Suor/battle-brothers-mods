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

// The Beast Aura package for a beast of the druid's own pack. Every such beast carries the aura
// receiver regardless; when its master actually holds Beast Aura it also arrives Confident and
// fearless and is leashed to his side. Shared by summoned beasts and unleashed war dogs/wolves.
// The master (m.druid_master) must be set on the beast before this runs.
def.emboldenBeast <- function (_user, _beast, _confident = true) {
    local skills = _beast.getSkills();
    if (skills.getSkillByID("effects.druid_beast_aura") == null)
        skills.add(::new("scripts/skills/effects/druid_beast_aura_effect"));
    if (!_user.getSkills().hasSkill("perk.druid.beast_aura")) return;

    // Confident (and, via the fearless racial, never breaking) - unlike MoraleState.Ignore the
    // beast still reacts to the battle and reaps the Confident combat bonus.
    if (!skills.hasSkill("racial.druid_fearless"))
        skills.add(::new("scripts/skills/racial/druid_fearless"));
    if (_confident) _beast.setMoraleState(::Const.MoraleState.Confident);

    // Leash: turn the beast into a bodyguard of its master, exactly as the game's own
    // zombie/direwolf bodyguard agents do - their only trick over the plain agent is the
    // ai_protect behaviour. A normal beast agent (wolf, spider...) lacks it, so add it. On its
    // own ai_protect does nothing (regular bandits carry it too); it only fires when a high-
    // TargetAttractionMult VIP ally is near - here the druid, marked by his Beast Aura (see
    // ::Const.Druid.Aura.TargetAttractionMult). The beast is emboldened after its agent was
    // built, so finalize the behaviour list as agent.create() does after onAddBehaviors().
    local agent = _beast.getAIAgent();
    if (agent != null && agent.getBehavior(::Const.AI.Behavior.ID.Protect) == null) {
        agent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_protect"));
        agent.finalizeBehaviors();
    }
}

// Adopt a freshly unleashed beast into the druid's pack. druid_master records who loosed it (the
// rage onDeath hook reads it to credit the right brother), so it's stamped for any unleash; only a
// druid's own Beast Aura then emboldens/fearless/leashes the beast - a plain houndmaster's companion
// is left untouched. The caller resolves the entity (vanilla items expose m.Entity, AC's getEntity()).
def.adoptUnleashed <- function (_user, _beast) {
    if (::std.Util.isNull(_beast)) return;
    _beast.m.druid_master <- ::MSU.asWeakTableRef(_user);
    if (_user.getSkills().hasSkill("perk.druid.beast_aura"))
        ::Druid.emboldenBeast(_user, _beast);
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
