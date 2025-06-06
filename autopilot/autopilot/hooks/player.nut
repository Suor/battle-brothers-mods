local mod = ::Hooks.getMod("mod_autopilot_new");

mod.hook("scripts/entity/tactical/player", function (q) {
    q.enableAIControl <- function() {
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
        // Do not let onUpdate overwrite our weights permanently
        local onUpdate = agent.onUpdate;
        agent.onUpdate = function () {
            if (!("autopilot_mults" in this)) this.autopilot_mults <- clone m.Properties.BehaviorMult;
            m.Properties.BehaviorMult = array(m.Properties.BehaviorMult.len(), 1.0);
            onUpdate();
            for (local i = 0; i < this.autopilot_mults.len(); i++) {
                m.Properties.BehaviorMult[i] *= this.autopilot_mults[i];
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
            // This guys are supposed to hit and injure
            agent.removeBehavior(Const.AI.Behavior.ID.Protect);
        }
        if (mode.ranged) {
            agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Disengage] = 5.0;
        }

        // Our behaviors
        agent.addBehavior(this.new("scripts/ai/autopilot_attack_alternate"));
        agent.addBehavior(this.new("scripts/ai/autopilot_unbag_shield"));
        if (::Autopilot.conf("dogs")) {
            agent.addBehavior(this.new("scripts/ai/autopilot_unleash_dog"));
        }
        if (::Autopilot.conf("nets")) {
            agent.addBehavior(this.new("scripts/ai/autopilot_unbag_net"));
            agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_throw_net"));
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

        // Should not be needed as long as we set IsControlledByPlayer to true
        agent.removeBehavior(Const.AI.Behavior.ID.Retreat); // retreat is always chosen for players if available, so remove it

        // reduce the chance of friendly fire, affects ranged in a weird manner
        // agent.m.Properties.TargetPriorityHittingAlliesMult *= 0.2;

        // AC (Accessory Companions)
        if (this.getSkills().hasSkill("actives.companions_tame")) {
            agent.addBehavior(this.new("scripts/ai/autopilot_tame"));
        }

        // Necromancers
        local necroSkills = [
            "actives.raise_undead"
            "actives.possess_undead"
            "actives.raise_companion" // AC
        ]
        local skills = getSkills()
        if (::std.Array.any(necroSkills, @(s) skills.hasSkill(s))) {
            ::logInfo("ap: setting up a necro")
            agent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_raise_undead"));
            agent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_possess_undead"));
            // This adds keep safe distance behavior
            agent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_engage_ranged"));

            agent.removeBehavior(::Const.AI.Behavior.ID.Protect);

            agent.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] = 0.5;
            agent.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageRanged] = 0.5;
        }

        // Fantasy Brothers: prefer shooting to walking
        if (this.getSkills().hasSkill("actives.xxitem_rifleaa_skill")) {
            agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.EngageRanged] = 0.1;
        }

        // Load behaviors for any skills, which declare those. Mostly Reforged stuff.
        foreach (skill in this.getSkills().getSkillsByFunction(@(s) s.m.AIBehaviorID)) {
            agent.addBehavior(::new(::MSU.AI.getBehaviorScriptFromID(skill.m.AIBehaviorID)));
        }

        // Do not pick up weapons by unarmed bros
        if (this.getSkills().hasSkill("perk.legend_mastery_fist")) {
            agent.removeBehavior(Const.AI.Behavior.ID.PickupWeapon);
        }

        agent.finalizeBehaviors();
        agent.setActor(this);
        setAIAgent(agent);
    }

    // BUG? this being here and not in actor may break if non-player is added to player faction
    // Q: Move this and .enableAIControl() to actor? Maybe factor out AI "setup" code
    q.cancelAIControl <- function() {
        if (!::Autopilot.isUnderAIControl(this)) return;

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
        delete m._autopilot;
    }

    q.onDeath = @(__original) function (killer, skill, tile, fatalityType) {
        // if a bro dies while under AI control it may hang around as a "ghost"
        this.cancelAIControl();
        __original(killer, skill, tile, fatalityType);
    }

    q.onCombatFinished = @(__original) function () {
        clearAutoSkills();
        cancelAIControl();
        if("_isIgnored" in m) delete m._isIgnored;
        __original();

        foreach (skill in getSkills().m.Skills) {
            if (skill.m.IsRemovedAfterBattle) {
                ::logInfo("autopilot: Skill " + skill.getID() + " should be removed, garbage = "
                    + skill.isGarbage());
            }
        }

        // getSkills().removeByID("effects.hex_slave");
        // getSkills().removeByID("effects.charmed");
        // local charmed = this.getSkills().getSkillByID("effects.charmed");
        // if (charmed) {
            // actor.setFaction(this.m.OriginalFaction);
            // actor.getFlags().set("Charmed", false);
        // }
    }

    q.querySwitchableItems <- function() {
        local items = [], inv = getItems();

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
