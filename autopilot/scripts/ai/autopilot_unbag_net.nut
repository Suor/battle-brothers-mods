this.autopilot_unbag_net <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        NetToEquip = null
        PossibleNets = [
            "tool.throwing_net"
            "tool.reinforced_throwing_net"
        ]
    },
    function create() {
        this.m.ID = ::Const.AI.Behavior.ID.AP_UnbagNet;
        this.m.Order = ::Const.AI.Behavior.Order.AP_UnbagNet;
        this.m.ActiveSkill <- ::new("scripts/skills/actives/throw_net");
        this.behavior.create();
    }

    function onEvaluate( _entity ) {
        // If refillable nets mod is set then net is not unequipped but stays there with ammo == 0
        local function isUseless(item) {
            return item.isItemType(::Const.Items.ItemType.Ammo) && item.getAmmo() == 0;
        }

        // Need this to calc ap and fatigue costs
        this.m.ActiveSkill.setContainer(_entity.getSkills());

        this.m.NetToEquip = null;
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
        local offItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        if (offItem != null && !isUseless(offItem)) return ::Const.AI.Behavior.Score.Zero;

        local mainItem = _entity.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        if (mainItem != null && mainItem.getBlockedSlotType() == this.Const.ItemSlot.Offhand) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // Find a best net
        local items = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
        if (items.len() == 0) return ::Const.AI.Behavior.Score.Zero;

        local netIds = this.m.PossibleNets;
        local nets = items.filter(@(_, item) netIds.find(item.getID()) != null && !isUseless(item));
        if (nets.len() == 0) return ::Const.AI.Behavior.Score.Zero;

        // Select the best net first
        nets.sort(@(a, b) a.getValue() <=> b.getValue());
        this.m.NetToEquip = nets.top();

        // If not enough fatigue to actually use then low score
        local fatigueLeft = _entity.getFatigueMax() - _entity.getFatigue();
        local throwFatigue = this.m.ActiveSkill.getFatigueCost();
        if (fatigueLeft < throwFatigue) scoreMult *= 0.25;  // Can't throw
        else if (fatigueLeft < throwFatigue + 10) scoreMult *= 0.5;  // Simply tired

        // Can throw immediately?
        local apLeft = _entity.getActionPoints();
        local switchAP = hasQuickHands ? 0 : ::Const.Tactical.Settings.SwitchItemAPCost;
        local throwAP = this.m.ActiveSkill.getActionPointCost();
        if (apLeft >= switchAP + throwAP && fatigueLeft >= throwFatigue && this.hasTarget()) {
            scoreMult *= 2.0;
        } else {
            // It's better to get it out and throw next turn
            if (hasQuickHands) return ::Const.AI.Behavior.Score.Zero;
        }
        if (hasQuickHands) scoreMult *= ::Const.AI.Behavior.SwitchToQuickHandsMult;

        return ::Const.AI.Behavior.Score.AP_UnbagNet * scoreMult;
    }

    function hasTarget() {
        local skill = this.m.ActiveSkill;
        local targets = this.queryTargetsInMeleeRange(skill.getMinRange(), skill.getMaxRange());
        return targets.len() > 0;
    }

    function onExecute( _entity ) {
        if (::Const.AI.VerboseMode) {
            this.logInfo("* " + _entity.getName() + ": Unbagging net \'"
                              + this.m.NetToEquip.getID() + "\'!");
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
})
