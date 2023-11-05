::mods_registerMod("hook_check", 1, "Hooks Checker");
::mods_queue("hook_check", "mod_hooks(>=20), >mod_reforged", function() {
    ::mods_hookNewObject("states/tactical_state", function (o) {
        logInfo("hook_check 1: hookNewObject tactical_state " + o);
    })
    ::mods_hookExactClass("states/tactical_state", function (o) {
        logInfo("hook_check 2: hookExactClass tactical_state " + o);
    })
    ::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function (o) {
        logInfo("hook_check 3: hookNewObject tooltip_events " + o);
    })
    ::mods_hookBaseClass("ai/tactical/behavior", function (o) {
        logInfo("hook_check 4: hookBaseClass behavior " + o);
    })

    ::mods_hookClass("states/world/asset_manager", function(o) {
        logInfo("hook_check 5: hookClass asset_manager " + o);
    })

    ::mods_hookNewObjectOnce("retinue/followers/recruiter_follower", function (o) {
        logInfo("hook_check 6: hookNewObjectOnce recruiter_follower " + o);
    });
    ::mods_hookClass("retinue/followers/recruiter_follower", function (o) {
        logInfo("hook_check 7: hookClass recruiter_follower " + o);
    })
    ::mods_hookExactClass("retinue/followers/recruiter_follower", function (o) {
        logInfo("hook_check 8: hookExactClass recruiter_follower " + o);
    })

    ::mods_hookNewObject("skills/perks/perk_nine_lives", function(o) {
        logInfo("hook_check 9: mods_hookNewObject perk_nine_lives " + o);
    })
    ::mods_hookExactClass("skills/perks/perk_nine_lives", function(o) {
        logInfo("hook_check 10: mods_hookExactClass perk_nine_lives " + o);
    })
    ::mods_hookNewObject("skills/effects/bleeding_effect", function(o) {
        logInfo("hook_check 11: mods_hookNewObject bleeding_effect " + o);
    })
    ::mods_hookExactClass("skills/effects/bleeding_effect", function(o) {
        logInfo("hook_check 12:(last) mods_hookExactClass bleeding_effect " + o);
    })
})
