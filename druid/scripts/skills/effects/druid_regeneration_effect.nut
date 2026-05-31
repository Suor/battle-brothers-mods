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
        this.m.Description = "Nature mends this character, restoring 10 hitpoints at the start of each turn.";
        this.m.Icon = "skills/status_effect_79.png";
        this.m.IconMini = "status_effect_79_mini";
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.Order = this.Const.SkillOrder.Last;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsRemovedAfterBattle = true;
        this.m.IsHidden = false;
    }

    function onTurnStart()
    {
        local actor = this.getContainer().getActor();
        local missing = actor.getHitpointsMax() - actor.getHitpoints();
        local healed = this.Math.min(missing, this.m.HealPerTurn);
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
