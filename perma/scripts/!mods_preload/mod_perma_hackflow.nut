local def = ::PermaHackflow <- {
    ID = "mod_perma_hackflow"
    Name = "Hackflows's Permanent Injuries"
    Version = "2.0.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/855"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/perma"
        tagPrefix = "perma-"
    }
}

::include("perma_hackflow/rosetta_ru");

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.queue(function () {
    foreach (file in ::IO.enumerateFiles("perma_hackflow/hooks")) ::include(file);

    // Legends have this already
    if (!::Hooks.hasMod("mod_legends")) {
        ::Const.Injury.Permanent.push({
            ID = "injury.missing_hand",
            Script = "injury_permanent/missing_hand_injury"
        })
    }

    mod.hook("scripts/items/item_container", function (q) {
        q.onShieldHit = @(__original) function (_attacker, _skill) {
            __original(_attacker, _skill);

            // Attacker dropping weapon
            if (_attacker && !_attacker.isNull() && _attacker.getSkills().hasSkill("injury.missing_finger")) {
                local main = _attacker.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
                if (main && main.m.Condition > 0 && main.m.BlockedSlotType == ::Const.ItemSlot.Offhand
                    && ::Math.rand(1, 10) == 1)
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

                if (actor.getSkills().hasSkill("injury.missing_finger") && ::Math.rand(1, 5) == 1) {
                    ::Tactical.EventLog.logEx(
                        ::Const.UI.getColorizedEntityName(actor) + "'s shield slips from his fingers");
                    item.drop();
                }
            }
        }
    })
})
