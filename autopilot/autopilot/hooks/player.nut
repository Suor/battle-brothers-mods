::mods_hookExactClass("entity/tactical/player", function (cls) {
    cls.isUnderAIControl <- function() {return "_autopilot" in m}

    cls.enableAIControl <- function() {
        m._oldAgent <- getAIAgent();
        local mode = m._autopilot <- {ranged = false, throwing = false};
        mode.ranged <- isArmedWithRangedWeapon();

        // Check if throwing
        local weapon = m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand);
        mode.throwing <- mode.ranged && weapon.isItemType(Const.Items.ItemType.Ammo);

        // if armed with a throwing weapon, use the melee AI instead of the ranged AI.
        mode.agent <- mode.ranged && !mode.throwing ? "military_ranged" : "military_melee";
        local agent = new("scripts/ai/tactical/agents/" + mode.agent + "_agent");

        // agent.compileKnownAllies optimizes itself to no-op for the player faction, but we need it to work
        agent.compileKnownAllies = function () {
            local instances = this.Tactical.Entities.getAllInstances();
            this.m.KnownAllies = [];
            foreach( i, faction in instances )
            {
                if (faction.len() == 0 || this.m.Actor.getFaction() != i && !this.m.Actor.isAlliedWith(i))
                {
                    continue;
                }

                foreach( entity in faction )
                {
                    if (entity.isAlive() && !entity.isDying() && entity.isPlacedOnMap())
                    {
                        this.m.KnownAllies.push(entity);
                    }
                }
            }
        }

        // Make backrow more active
        if (!mode.ranged && this.getIdealRange() == 2) {
            agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Disengage] = 2.0;
            agent.m.Properties.EngageFlankingMult = 5.0;  // Like wolfrider :)
        }
        if (mode.throwing) {
            // Prefer attacking over engaging, i.e. wandering around
            agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.EngageMelee] = 0.5;
            // TODO: separate throwing only from hybrids
            // agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.SwitchToMelee] = 0.5;
            // agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Disengage] = 2.0;
            // Otherwise is afraid of "shooting over shoulder"
            agent.m.Properties.TargetPriorityHittingAlliesMult = 1.0;
            // This guys are supposed to hit and injure
            agent.removeBehavior(Const.AI.Behavior.ID.Protect);
        }
        if (mode.ranged) {
            agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Disengage] = 5.0;
        }

        // Our behaviors
        agent.addBehavior(this.new("scripts/ai/autopilot_unbag_shield"));
        if (::Autopilot.conf("dogs")) {
            agent.addBehavior(this.new("scripts/ai/autopilot_unleash_dog"));
        }
        if (::Autopilot.conf("nets")) {
            agent.addBehavior(this.new("scripts/ai/autopilot_unbag_net"));
            agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_throw_net"));
        }

        // AC (Accessory Companions)
        if (this.getSkills().hasSkill("actives.companions_tame")) {
            agent.addBehavior(this.new("scripts/ai/autopilot_tame"));
        }

        // Military agents don't have this
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_adrenaline"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_pickup_weapon"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_line_breaker"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rally"));
        // Disabled since doesn't consult offhand/backpack at all
        // agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_throw_bomb"));

        // military doesn't have it, but bandit does
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_deathblow"));

        // If we somehow get drum, say with North Expansion mod
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_boost_stamina"));

        // Only works because we overwrite break_free.onEvaluate()
        agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.BreakFree] = 2.5;

        // Look at this for bros having scare stuff
        // TargetPriorityMoraleMult = 0.0,
        // TargetPriorityBraveryMult = 0.0,

        // Should not be needed as long as we set IsControlledByPlayer to true
        agent.removeBehavior(Const.AI.Behavior.ID.Retreat); // retreat is always chosen for players if available, so remove it

        // reduce the chance of friendly fire, affects ranged in a weird manner
        // agent.m.Properties.TargetPriorityHittingAlliesMult *= 0.2;

        this.getSkills().onSetupAI(agent); // Our new event

        // Autodetect ranged-like bros, i.e. no hide behind them and more disengage
        local hasMelee = agent.findBehavior(::Const.AI.Behavior.ID.EngageMelee);
        local hasRanged = agent.findBehavior(::Const.AI.Behavior.ID.EngageRanged);
        logInfo("ap: " + this.getName() + " melee=" + hasMelee + " ranged=" + hasRanged)
        if (hasRanged && !hasMelee) {
            logInfo("ap: mode ranged")
            mode.ranged = true;
        }

        // "actives.raise_companion"

        agent.finalizeBehaviors();
        agent.setActor(this);
        setAIAgent(agent);
    }

    cls.cancelAIControl <- function() {
        if (!isUnderAIControl()) return;

        local agent = getAIAgent();
        if(agent.ClassName != "player_agent")
        {
            if(agent.getID() != Const.AI.Agent.ID.CharmedPlayer) setAIAgent(m._oldAgent);
            local skill = getSkills().getSkillByID("effects.charmed");
            if(skill != null) skill.m.OriginalAgent = m._oldAgent;
        }
        // Return control
        // this.m.IsControlledByPlayer = true;
        delete m._oldAgent;
        delete this.m._autopilot;
    }

    local onDeath = cls.onDeath;
    cls.onDeath = function(killer, skill, tile, fatalityType) {
        // if a bro dies while under AI control it may hang around as a "ghost"
        this.cancelAIControl();
        onDeath(killer, skill, tile, fatalityType);
    }

    local onCombatFinished = cls.onCombatFinished;
    cls.onCombatFinished = function() {
        clearAutoSkills();
        cancelAIControl();
        if("_isIgnored" in m) delete m._isIgnored;
        onCombatFinished();
    }

    cls.querySwitchableItems <- function() {
        local items = [], inv = getItems();
        if (!inv.isActionAffordable([]))  return items; // if we can't afford any kind of action

        for (local itemType = Const.Items.ItemType, i = 0; i < inv.getUnlockedBagSlots(); i++)
        {
            local item = inv.getItemAtBagSlot(i);
            if(item == null) continue;
            local slot = item.getSlotType();
            if(slot == Const.ItemSlot.None || slot == Const.ItemSlot.Bag) continue;
            // TODO: check blocked slot?
            local currentItem = inv.getItemAtSlot(slot);
            if(item != null &&
                  (item.isItemType(itemType.Weapon) || item.isItemType(itemType.Tool) || item.isItemType(itemType.Shield) ||
                    item.isItemType(itemType.Accessory) || (item.isItemType(itemType.Ammo) && item.m.Ammo != 0)) &&
                  inv.isActionAffordable(currentItem != null ? [currentItem, item] : [item]))
            {
                items.append(item);
            }
        }
        return items;
    }
})
