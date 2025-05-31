this.necro_regeneration <- this.inherit("scripts/skills/skill", {
    m = {
        IsRemovedAfterBattle = true
        HealArmor = false
    },
    function create()
    {
        this.m.ID = "racial.necro_regeneration";
        this.m.Name = "Undead Regeneration";
        this.m.Description = "";
        this.m.Icon = "skills/status_effect_79.png";
        this.m.SoundOnUse = [
            "sounds/enemies/unhold_regenerate_01.wav",
            "sounds/enemies/unhold_regenerate_02.wav",
            "sounds/enemies/unhold_regenerate_03.wav"
        ];
        this.m.Type = this.Const.SkillType.Racial;
        this.m.Order = this.Const.SkillOrder.Last;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsHidden = true;
    }

    function onTurnStart()
    {
        ::logInfo("necro: regen onTurnStarted");
        local actor = this.getContainer().getActor();
        local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
        local healthAdded = ::Math.min(healthMissing, 10);
        // if (healthAdded <= 0) return;

        if (healthAdded > 0) actor.setHitpoints(actor.getHitpoints() + healthAdded);

        local head = false, body = false;
        if (this.m.HealArmor) {
            head = ::Necro.restoreArmorPct(actor, "head", 0.07);
            body = ::Necro.restoreArmorPct(actor, "body", 0.07);
            actor.getSkills().update();
        }
        local restoredArmor = head || body;
        if (!restoredArmor && healthAdded <= 0) return

        actor.setDirty(true);

        if (!actor.isHiddenToPlayer())
        {
            this.spawnIcon("status_effect_79", actor.getTile());

            if (this.m.SoundOnUse.len() != 0)
            {
                this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
            }

            // TODO: fix message when Flesh on the Bones is active
            if (healthAdded > 0) {
                ::Tactical.EventLog.log(
                    ::Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points"
                    + (restoredArmor ? " and restores some armor" : "")
                );
            } else {
                ::Tactical.EventLog.log(
                    ::Const.UI.getColorizedEntityName(actor) + " restores some armor"
                );
            }
        }
    }
});
