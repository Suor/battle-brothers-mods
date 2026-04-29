this.autopilot_swap_quiver <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        QuiverToEquip = null
    },
    function create() {
        this.m.ID = ::Const.AI.Behavior.ID.AP_SwapQuiver;
        this.m.Order = ::Const.AI.Behavior.Order.AP_SwapQuiver;
        this.behavior.create();
    }

    function onEvaluate(_entity) {
        this.m.QuiverToEquip = null;
        local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return 0;
        if (_entity.getCurrentProperties().IsStunned) return 0;
        if (!_entity.getItems().isActionAffordable([])) return 0;

        if (this.queryTargetsInMeleeRange().len() != 0) return 0;

        local ammoItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Ammo);
        if (ammoItem == null || ammoItem.getAmmo() != 0) return 0;

        local items = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
        local ammoType = ammoItem.getAmmoType();
        local quivers = items.filter(
            @(_, item) item.isItemType(::Const.Items.ItemType.Ammo) && item.getAmmo() > 0
                && item.getAmmoType() == ammoType);
        if (quivers.len() == 0) return 0;

        quivers.sort(@(a, b) a.getAmmo() <=> b.getAmmo());
        this.m.QuiverToEquip = quivers.top();

        return ::Const.AI.Behavior.Score.AP_SwapQuiver * scoreMult;
    }

    function onExecute(_entity) {
        if (::Const.AI.VerboseMode) {
            this.logInfo("* " + _entity.getName() + ": Swapping quiver to '"
                              + this.m.QuiverToEquip.getID() + "'!");
        }

        _entity.getItems().removeFromBag(this.m.QuiverToEquip);

        local ammoItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Ammo);
        if (ammoItem != null) {
            _entity.getItems().unequip(ammoItem);
            _entity.getItems().addToBag(ammoItem);
        }

        _entity.getItems().equip(this.m.QuiverToEquip);
        _entity.getItems().payForAction([]);
        this.m.QuiverToEquip = null;
        return true;
    }
})
