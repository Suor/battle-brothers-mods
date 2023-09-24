this.autopilot_unbag_net <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        NetToEquip = null
        PossibleNets = [
            "tool.throwing_net"
            "tool.reinforced_throwing_net"
        ]
    },
    function create()
    {
        this.m.ID = ::Const.AI.Behavior.ID.AP_UnbagNet;
        this.m.Order = ::Const.AI.Behavior.Order.AP_UnbagNet;
        this.behavior.create();
    }

    function onEvaluate( _entity )
    {
        // If refillable nets mod is set then net is not unequipped but stays there with ammo == 0
        local function isUseless(item) {
            return item.isItemType(Const.Items.ItemType.Ammo) && item.getAmmo() == 0;
        }

        this.m.NetToEquip = null;
        local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

        this.logInfo("unbag net 0 scoreMult=" + scoreMult);
        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        if (_entity.getCurrentProperties().IsStunned) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        this.logInfo("unbag net 1");
        // if (!this.getAgent().hasVisibleOpponent()) {
        //     return ::Const.AI.Behavior.Score.Zero;
        // }

        local hasQuickHands = _entity.getSkills().hasSkill("perk.quick_hands");
        this.logInfo("unbag net 2, quick_hands=" + hasQuickHands);

        if (!hasQuickHands && _entity.getActionPoints() < ::Const.Tactical.Settings.SwitchItemAPCost) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // Need a free offhand
        local offItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        this.logInfo("unbag net 3, offitem=" + offItem);
        if (offItem != null && !isUseless(offItem)) return ::Const.AI.Behavior.Score.Zero;

        local mainItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        this.logInfo("unbag net 4, offitem=" + mainItem);
        if (mainItem != null && mainItem.getBlockedSlotType() == this.Const.ItemSlot.Offhand) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // Find a best net
        local items = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
        this.logInfo("unbag net 5, items=" + items.len());
        if (items.len() == 0) return ::Const.AI.Behavior.Score.Zero;

        local netIds = this.m.PossibleNets;
        local nets = items.filter(@(_, item) netIds.find(item.getID()) != null && !isUseless(item));
        this.logInfo("unbag net 6, nets=" + nets.len());
        if (nets.len() == 0) return ::Const.AI.Behavior.Score.Zero;

        // Select the best net first
        nets.sort(@(a, b) a.getValue() <=> b.getValue());
        this.m.NetToEquip = nets.top();

        // If not enough fatigue to actually use then low score
        local fatigueLeft = _entity.getFatigueMax() - _entity.getFatigue();
        if (fatigueLeft < 25) score *= 0.25;  // Can't throw
        else if (fatigueLeft < 35) score *= 0.25;  // Simply tired

        // Can throw immediately
        if (_entity.getActionPoints() >= ::Const.Tactical.Settings.SwitchItemAPCost + 4
            && fatigueLeft >= 25) {
            scoreMult *= 2.0;
        } else {
            // It's better to get it out and throw next turn
            if (hasQuickHands) return ::Const.AI.Behavior.Score.Zero;
        }
        if (hasQuickHands) scoreMult *= ::Const.AI.Behavior.SwitchToQuickHandsMult;


        return ::Const.AI.Behavior.Score.AP_UnbagNet * scoreMult;
    }

    function onExecute( _entity )
    {
        if (::Const.AI.VerboseMode) {
            this.logInfo("* " + _entity.getName() + ": Unbagging net \'" + this.m.NetToEquip.getID() + "\'!");
        }

        _entity.getItems().removeFromBag(this.m.NetToEquip);

        local offItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        if (offItem != null) {
            _entity.getItems().unequip(offItem);
            _entity.getItems().addToBag(offItem);
        }

        _entity.getItems().equip(this.m.NetToEquip);

        _entity.getItems().payForAction([]);
        this.m.NetToEquip = null;
        // this.getAgent().getIntentions().IsChangingWeapons = true;
        return true;
    }
});

