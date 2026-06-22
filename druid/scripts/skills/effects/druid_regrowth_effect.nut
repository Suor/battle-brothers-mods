// Regrowth: a steady knit of flesh on a single ally. No countdown - it lasts until the
// Druid bestows it elsewhere (the active strips it from the previous bearer) or battle ends.
this.druid_regrowth_effect <- this.inherit("scripts/skills/skill", {
    m = {
        HealPerTurn = 10
    },
    function create()
    {
        this.m.ID = "effects.druid_regrowth";
        this.m.Name = "Regrowth";
        this.m.Description = "";  // built per-bearer in getDescription()
        this.m.Icon = "druid/perk_regrowth.png";
        this.m.IconMini = "druid_regrowth_mini";
        this.m.Type = ::Const.SkillType.StatusEffect;
        this.m.Order = ::Const.SkillOrder.Last;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsRemovedAfterBattle = true;
        this.m.IsHidden = false;
    }

    // Beasts and animals knit back twice as fast - and so does a druid who has taken Beastform,
    // his flesh now half-beast itself.
    function getHealPerTurn( _actor )
    {
        local doubled = ::Const.Druid.isAnimal(_actor)
                     || _actor.getSkills().hasSkill("perk.druid.beastform");
        return doubled ? this.m.HealPerTurn * 2 : this.m.HealPerTurn;
    }

    // The effect always rides an actor, so the description states that actor's exact rate.
    function getDescription()
    {
        local actor = getContainer().getActor();
        local heal = ::std.Text.positive(getHealPerTurn(actor));
        if (::Const.Druid.isAnimal(actor))
            return "Nature mends this beast, restoring " + heal + " hitpoints at the start of each turn.";
        return "Nature mends this character, restoring " + heal + " hitpoints at the start of each turn.";
    }

    function onTurnStart()
    {
        local actor = getContainer().getActor();
        local missing = actor.getHitpointsMax() - actor.getHitpoints();
        local healed = ::Math.min(missing, getHealPerTurn(actor));
        if (healed <= 0) return;

        actor.setHitpoints(actor.getHitpoints() + healed);
        actor.setDirty(true);

        if (!actor.isHiddenToPlayer()) {
            spawnIcon("druid_regrowth", actor.getTile());
            ::Tactical.EventLog.log(
                ::Const.UI.getColorizedEntityName(actor) + " heals for " + healed + " hitpoints"
            );
        }
    }
});
