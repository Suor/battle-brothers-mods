this.autopilot_unbag_shield <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        ShieldToEquip = null
        PossibleNets = [
            "tool.throwing_net"
            "tool.reinforced_throwing_net"
        ]
    },
    function create() {
        this.m.ID = ::Const.AI.Behavior.ID.AP_UnbagShield;
        this.m.Order = ::Const.AI.Behavior.Order.AP_UnbagShield;
        this.behavior.create();
    }

    function onEvaluate( _entity ) {
        // If refillable nets mod is set then net is not unequipped but stays there with ammo == 0
        local function isUseless(item) {
            return item.isItemType(::Const.Items.ItemType.Ammo) && item.getAmmo() == 0;
        }

        this.m.ShieldToEquip = null;
        local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        if (_entity.getCurrentProperties().IsStunned) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        local hasQuickHands = _entity.getSkills().hasSkill("perk.quick_hands");

        if (!hasQuickHands && _entity.getActionPoints() < ::Const.Tactical.Settings.SwitchItemAPCost) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // Need a free offhand
        // TODO: switch out a net?
        local offItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        if (offItem != null && !isUseless(offItem)) return ::Const.AI.Behavior.Score.Zero;

        local mainItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (mainItem != null && mainItem.getBlockedSlotType() == this.Const.ItemSlot.Offhand) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // Find a best shield
        local items = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
        local shields = items.filter(@(_, item) item.isItemType(::Const.Items.ItemType.Shield));
        if (shields.len() == 0) return ::Const.AI.Behavior.Score.Zero;
        // Require no unused nets in bag
        // TODO: smarter interaction with unbag net
        local netIds = this.m.PossibleNets;
        local nets = items.filter(@(_, item) netIds.find(item.getID()) != null && !isUseless(item));
        if (nets.len() > 0) return ::Const.AI.Behavior.Score.Zero;

        // Select the best shield
        shields.sort(@(a, b) a.getValue() <=> b.getValue());
        this.m.ShieldToEquip = shields.top();

        // TODO: ZOC

        return ::Const.AI.Behavior.Score.AP_UnbagShield * scoreMult;
    }

    function onExecute( _entity ) {
        if (::Const.AI.VerboseMode) {
            this.logInfo("* " + _entity.getName() + ": Unbagging shield \'"
                              + this.m.ShieldToEquip.getID() + "\'!");
        }

        _entity.getItems().removeFromBag(this.m.ShieldToEquip);

        local offItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        if (offItem != null) {
            _entity.getItems().unequip(offItem);
            _entity.getItems().addToBag(offItem);
        }

        _entity.getItems().equip(this.m.ShieldToEquip);

        _entity.getItems().payForAction([]);
        this.m.ShieldToEquip = null;
        // this.getAgent().getIntentions().IsChangingWeapons = true;
        return true;
    }
})
