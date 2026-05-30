// Permanent envenomed bite for summoned beasts. Reuses the webknecht poison-coat logic
// but never depletes, so every hit that bites deep enough poisons the prey.
this.druid_venom <- this.inherit("scripts/skills/effects/spider_poison_coat_effect", {
    m = {},
    function create()
    {
        this.spider_poison_coat_effect.create();
        this.m.ID = "racial.druid_venom";
        this.m.Name = "Venom";
        this.m.Type = this.Const.SkillType.Racial;
        this.m.Order = this.Const.SkillOrder.Last;
        this.m.IsRemovedAfterBattle = true;
        this.m.IsHidden = false;
        this.m.AttacksLeft = 99;
    }

    function getDescription()
    {
        return "This beast hunts with envenomed fang and sting. A deep enough bite poisons the prey, draining their hitpoints each turn until it fades.";
    }

    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
    {
        this.spider_poison_coat_effect.onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
        this.m.AttacksLeft = 99; // never deplete
    }
});
