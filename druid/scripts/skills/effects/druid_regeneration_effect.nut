// Regrowth: a steady knit of flesh on a single ally. No countdown - it lasts until the
// Druid bestows it elsewhere (the active strips it from the previous bearer) or battle ends.
this.druid_regeneration_effect <- this.inherit("scripts/skills/skill", {
    m = {
        HealPerTurn = 10
    },
    function create()
    {
        this.m.ID = "effects.druid_regeneration";
        this.m.Name = "Regrowth";
        this.m.Description = "";  // built per-bearer in getDescription()
        this.m.Icon = "skills/status_effect_79.png";
        this.m.IconMini = "status_effect_79_mini";
        this.m.Type = ::Const.SkillType.StatusEffect;
        this.m.Order = ::Const.SkillOrder.Last;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsRemovedAfterBattle = true;
        this.m.IsHidden = false;
    }

    // Beasts and animals knit back twice as fast.
    function getHealPerTurn( _actor )
    {
        return ::Const.Druid.isAnimal(_actor) ? this.m.HealPerTurn * 2 : this.m.HealPerTurn;
    }

    // The effect always rides an actor, so the description states that actor's exact rate.
    function getDescription()
    {
        local heal = this.getHealPerTurn(this.getContainer().getActor());
        return "Nature mends this character, restoring " + heal + " hitpoints at the start of each turn.";
    }

    function onTurnStart()
    {
        local actor = this.getContainer().getActor();
        local missing = actor.getHitpointsMax() - actor.getHitpoints();
        local healed = ::Math.min(missing, this.getHealPerTurn(actor));
        if (healed <= 0) return;

        actor.setHitpoints(actor.getHitpoints() + healed);
        actor.setDirty(true);

        if (!actor.isHiddenToPlayer())
        {
            this.spawnIcon("status_effect_79", actor.getTile());
            ::Tactical.EventLog.log(
                ::Const.UI.getColorizedEntityName(actor) + " heals for " + healed + " hitpoints"
            );
        }
    }
});
