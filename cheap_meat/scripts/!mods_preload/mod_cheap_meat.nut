::mods_registerMod("mod_cheap_meat", 0.2);

::mods_queue("mod_cheap_meat", null, function() {
    this.logInfo("cheap_meat: run");

    ::mods_hookNewObject("states/world/asset_manager", function (obj) {
        local resetToDefaults = obj.resetToDefaults;
        obj.resetToDefaults <- function() {
            this.logInfo("cheap_meat: override defaults");
            resetToDefaults();
            this.m.HiringCostMult *= 0.5;
            this.m.TryoutPriceMult *= 0.5;
        }
    })

    ::mods_hookNewObject("retinue/followers/recruiter_follower", function (obj) {
        this.logInfo("cheap_meat: set recruiter effects");
        obj.m.Effects = [
            "Makes you pay 33% less up front for hiring new men, and 50% less for tryouts",
            "Makes between 3 and 6 additional men available to recruit in every settlement"
        ];
    });

    ::mods_hookExactClass("retinue/followers/recruiter_follower", function(cls) {
        cls.onUpdate <- function() {
            this.logInfo("cheap_meat: recruiter update");
            this.World.Assets.m.HiringCostMult *= 0.667;
            this.World.Assets.m.TryoutPriceMult *= 0.5;
            this.World.Assets.m.RosterSizeAdditionalMin += 3;
            this.World.Assets.m.RosterSizeAdditionalMax += 6;
        }
    })
})
