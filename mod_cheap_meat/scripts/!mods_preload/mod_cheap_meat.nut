::mods_registerMod("mod_cheap_meat", 0.1);

::mods_queue("mod_cheap_meat", null, function() {
    this.logInfo("cheap_meat: run");

  	::mods_hookClass("states/world/asset_manager", function(o) {
        local resetToDefaults = o.resetToDefaults;
        o.resetToDefaults <- function()
        {
            this.logInfo("cheap_meat: override defaults");
            resetToDefaults();
            this.m.HiringCostMult *= 0.5;
            this.m.TryoutPriceMult *= 0.5;
        }
	})

    ::mods_hookNewObjectOnce("retinue/followers/recruiter_follower", function (o)
    {
        this.logInfo("cheap_meat: set recruiter effects");
        o.m.Effects = [
            "Makes you pay 33% less up front for hiring new men, and 50% less for tryouts",
            "Makes between 3 and 6 additional men available to recruit in every settlement"
        ];
    });

	::mods_hookClass("retinue/followers/recruiter_follower", function(o) {
        o.onUpdate <- function()
        {
            this.logInfo("cheap_meat: recruiter update");
            this.World.Assets.m.HiringCostMult *= 0.667;
            this.World.Assets.m.TryoutPriceMult *= 0.5;
            this.World.Assets.m.RosterSizeAdditionalMin += 3;
            this.World.Assets.m.RosterSizeAdditionalMax += 6;
        }
	})
})
