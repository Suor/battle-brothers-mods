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
        // Reuse the round regrowth perk icon, same as druid_beast_aura_effect reuses a perk icon.
        this.m.Icon = "druid/perk_regrowth.png";
        // FIX: make a regrowth mini version
        // RES: m.IconMini (and spawnIcon below) resolve brush-atlas sprites, not PNG paths; a custom
        //   regrowth mini needs brush tooling we don't have, so it stays the vanilla regeneration
        //   mini (status_effect_79 = the regen effect) for now.
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
        local actor = getContainer().getActor();
        local heal = getHealPerTurn(actor);
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
            spawnIcon("status_effect_79", actor.getTile());
            ::Tactical.EventLog.log(
                ::Const.UI.getColorizedEntityName(actor) + " heals for " + healed + " hitpoints"
            );
        }
    }
});
