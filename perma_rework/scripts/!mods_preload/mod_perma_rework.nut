local def = ::PermaRework <- {
    ID = "mod_perma_rework"
    Name = "Permanent Injuries Rework"
    Version = "2.0.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/..."
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/perma-rework"
        tagPrefix = "perma-rework-"
    }
}

::include("perma_rework/rosetta_ru");

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.queue(function () {
    foreach (file in ::IO.enumerateFiles("perma_rework/hooks")) ::include(file);

    for (local i = 0; i < 8; i++) // TODO: remove after debugging
    Const.Injury.Permanent.push({
        ID = "injury.missing_hand",
        Script = "injury_permanent/missing_hand_injury"
    })

    mod.hook("scripts/items/item_container", function (q) {
        q.onShieldHit = @(__original) function (_attacker, _skill) {
            __original(_attacker, _skill);

            // TODO: smaller chances
            // Attacker dropping weapon
            if (_attacker && !_attacker.isNull() && _attacker.getSkills().hasSkill("injury.missing_finger")) {
                local main = _attacker.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
                if (main && main.m.Condition > 0 && main.m.BlockedSlotType == ::Const.ItemSlot.Offhand
                    && ::Math.rand(1, 4) == 1)
                {
                    ::Tactical.EventLog.logEx(
                        ::Const.UI.getColorizedEntityName(_attacker) + "'s weapon slips from his fingers");
                    main.drop();
                }
            }

            // Defender dropping shield
            local actor = getActor();
            if (actor == null || actor.isNull()) return;
            foreach (item in m.Items[::Const.ItemSlot.Offhand]) {
                if (item == null || item == -1 || item.isGarbage() || item.m.Condition == 0) continue;

                if (actor.getSkills().hasSkill("injury.missing_finger") && ::Math.rand(1, 10) == 1) {
                    ::Tactical.EventLog.logEx(
                        ::Const.UI.getColorizedEntityName(actor) + "'s shield slips from his fingers");
                    item.drop();
                }
            }
        }
    })
})
