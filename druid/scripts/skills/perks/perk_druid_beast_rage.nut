// Beast Rage (Beast group) - modelled on Reforged's perk_rf_feral_rage, but written for plain vanilla
// (no Reforged helpers) and with two changes from the design (plan.md, user-requests.md):
//   - damage reduction is replaced with per-stack hitpoint regeneration each turn;
//   - a melee miss also feeds the rage (+1 stack).
// Stacks build melee damage, Resolve and Initiative at the cost of Melee Defense. At the
// shield-drop threshold the druid tears off his own shield and roars.
this.perk_druid_beast_rage <- this.inherit("scripts/skills/skill", {
    m = {
        RageStacks = 0,
        ShieldDropped = false,
        SoundOnUse = [
            "sounds/enemies/orc_rage_01.wav",
            "sounds/enemies/orc_rage_02.wav",
            "sounds/enemies/orc_rage_03.wav"
        ]
    }
    function create() {
        this.m.ID = "perk.druid.beast_rage";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
        this.m.Order = ::Const.SkillOrder.Perk;
    }

    function isHidden()
    {
        return this.m.RageStacks == 0;
    }

    function getName()
    {
        return this.m.RageStacks > 1 ? this.m.Name + " (x" + this.m.RageStacks + ")" : this.m.Name;
    }

    function getDescription()
    {
        return "The taste of blood and the thrill of the kill drive this beast into a deepening fury. "
             + "Every melee hit, kill, blow taken - even a missed swing - feeds the rage, and once roused it must be fed to last.";
    }

    function getTooltip()
    {
        local R = ::Const.Druid.Rage;
        local s = this.m.RageStacks;
        return [
            { id = 1, type = "title", text = this.getName() }
            { id = 2, type = "description", text = this.getDescription() }
            {
                id = 10, type = "text", icon = "ui/icons/regular_damage.png",
                text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (s * R.PerStackDamagePct) + "%[/color] Melee Damage"
            }
            {
                id = 9, type = "text", icon = "ui/icons/health.png",
                text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (s * R.PerStackMaxHp) + "[/color] Maximum Hitpoints"
            }
            {
                id = 11, type = "text", icon = "ui/icons/special.png",
                text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (s * R.PerStackHpRegen) + "[/color] Hitpoints regenerated each turn"
            }
            {
                id = 12, type = "text", icon = "ui/icons/bravery.png",
                text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (s * R.PerStackResolve) + "[/color] Resolve"
            }
            // {
            //     id = 13, type = "text", icon = "ui/icons/initiative.png",
            //     text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (s * R.PerStackInitiative) + "[/color] Initiative"
            // }
            {
                id = 15, type = "text", icon = "ui/icons/fatigue.png",
                text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (s / 2) + "[/color] Fatigue Recovery per turn"
            }
            {
                id = 14, type = "text", icon = "ui/icons/melee_defense.png",
                text = "[color=" + ::Const.UI.Color.NegativeValue + "]" + (s * R.PerStackMeleeDefense) + "[/color] Melee Defense"
            }
        ];
    }

    function addRage( _r )
    {
        local threshold = ::Const.Druid.Rage.ShieldDropThreshold;
        local wasBelow = this.m.RageStacks < threshold;
        this.m.RageStacks += _r;
        local actor = this.getContainer().getActor();
        // Only announce when the rage boils over at full stacks - the steady drip of stacks is silent.
        if (wasBelow && this.m.RageStacks >= threshold && !actor.isHiddenToPlayer())
        {
            ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " gains rage!");
        }

        // At the height of the rage the beast tears off its own shield and roars.
        if (!this.m.ShieldDropped && this.m.RageStacks >= threshold)
        {
            this.dropShield(actor);
        }
    }

    // While the rage is at its height the beast suffers no shield in hand - the equip ban is
    // enforced by the item_container.equip hook in mod_druid.
    function bansShield()
    {
        return this.m.RageStacks >= ::Const.Druid.Rage.ShieldDropThreshold;
    }

    function dropShield( _actor )
    {
        this.m.ShieldDropped = true;
        local items = _actor.getItems();
        local shield = items.getItemAtSlot(::Const.ItemSlot.Offhand);
        local roared = false;
        if (shield != null && shield.isItemType(::Const.Items.ItemType.Shield))
        {
            items.unequip(shield);
            items.addToBag(shield);  // keep it - just out of hand for the rest of the fight
            roared = true;
        }
        if (!_actor.isHiddenToPlayer())
        {
            ::Sound.play(this.m.SoundOnUse[::Math.rand(0, this.m.SoundOnUse.len() - 1)],
                ::Const.Sound.Volume.Actor, _actor.getPos());
            if (roared)
                ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_actor) + " tears off the shield with a roar!");
        }
    }

    function onUpdate( _properties )
    {
        this.m.IsHidden = this.m.RageStacks == 0;
        local R = ::Const.Druid.Rage;
        _properties.MeleeDamageMult *= 1.0 + this.m.RageStacks * R.PerStackDamagePct / 100.0;
        _properties.Hitpoints += this.m.RageStacks * R.PerStackMaxHp;
        _properties.Bravery += this.m.RageStacks * R.PerStackResolve;
        // _properties.Initiative += this.m.RageStacks * R.PerStackInitiative;
        _properties.MeleeDefense += this.m.RageStacks * R.PerStackMeleeDefense;
        // The fury also keeps the beast's wind up - half a point of stamina regen per stack.
        _properties.FatigueRecoveryRate += this.m.RageStacks / 2;
    }

    function onTurnStart()
    {
        local R = ::Const.Druid.Rage;
        // Regenerate before the rage cools, so this turn's stacks still count.
        if (this.m.RageStacks > 0)
        {
            local actor = this.getContainer().getActor();
            local heal = this.m.RageStacks * R.PerStackHpRegen;
            local hp = actor.getHitpoints();
            local max = actor.getHitpointsMax();
            if (hp < max) actor.setHitpoints(::Math.min(max, hp + heal));
        }
        this.m.RageStacks = ::Math.max(0, this.m.RageStacks + R.StacksPerTurn);
    }

    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
    {
        if (_skill.isRanged() || !_targetEntity.isAlive() || _targetEntity.isDying()
            || _targetEntity.getTile().getDistanceTo(this.getContainer().getActor().getTile()) != 1)
            return;
        this.addRage(2);
    }

    function onTargetMissed( _skill, _targetEntity )
    {
        if (_skill == null || _skill.isRanged()) return;
        this.addRage(1);
    }

    function onTargetKilled( _targetEntity, _skill )
    {
        if (_skill != null && !_skill.isRanged()) this.addRage(3);
    }

    function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
    {
        this.addRage(1);
    }

    function onCombatFinished()
    {
        this.skill.onCombatFinished();
        this.m.RageStacks = 0;
        this.m.ShieldDropped = false;
    }
})
