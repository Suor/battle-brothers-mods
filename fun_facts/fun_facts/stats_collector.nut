::mods_hookExactClass("skills/special/stats_collector", function (o) {
// 	local onTargetHit = o.onTargetHit;
// 	o.onTargetHit = function(...) {
// 		vargv.insert(0, this);
// 		local ret = onTargetHit.acall(vargv);

// 		local funFacts = this.getContainer().getActor().m.FunFacts;
// 		vargv[0] = funFacts;
// 		funFacts.onTargetHit.acall(vargv);

// 		return ret;
// 	}
    local onNewDay = o.skill.onNewDay;
    o.skill.onNewDay = function () {
        onNewDay();
        ::FunFacts.s2ff(this).onNewDay();
    }
});
