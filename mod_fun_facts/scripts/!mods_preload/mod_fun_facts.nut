::FunFacts <- {
    ID = "mod_fun_facts"
    Name = "Fun Facts"
    Version = "0.1.0"
};
local Debug = ::std.Debug.with({prefix = "ff: "})

::mods_registerMod(::FunFacts.ID, ::FunFacts.Version, ::FunFacts.Name);
::mods_queue(::FunFacts.ID, "mod_hooks(>=17), mod_msu(>=1.2.6)", function() {
    ::FunFacts.Mod <- ::MSU.Class.Mod(::FunFacts.ID, ::FunFacts.Version, ::FunFacts.Name);
    this.logInfo("ff: loading");

    // ::mods_hookExactClass("skills/special/stats_collector", function (o) {
    //     this.logInfo("ff: setting stats_collector");
    //     local onTargetKilled = o.onTargetKilled;
    //     o.onTargetKilled = function( _targetEntity, _skill ) {
    //         onTargetKilled(_targetEntity, _skill);
    //         Debug.log("killed enemy", _targetEntity);
    //     }
    // })

    // ::mods_hookBaseClass("", function (cls) {
    //     function onAdded() {
    //         if (this.getContainer().getActor().isPlacedOnMap())
    //         {
    //             this.spawnIcon(this.m.DropIcon, this.getContainer().getActor().getTile());
    //         }

    //         if (this.m.TimeApplied == 0)
    //         {
    //             this.m.TimeApplied = this.getTime();
    //         }
    //     }
    // })

});
