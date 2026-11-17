// Test-only probe: records, while ::APProbe.on, every skill use (ok = use() returned anything but false) and
// every AI behavior picked, as {who, what, round, auto (on autopilot)}. Loads in any mod set (no dependency on autopilot).
::APProbe <- {on = false, uses = [], behaviors = []};
local mod = ::Hooks.register("mod_ap_probe", "1.0.0", "Autopilot probe (bbtales)");
mod.queue(">mod_autopilot_new", ">mod_msu", ">mod_reforged", function () {
    local round = @() ("Time" in ::getroottable()) ? ::Time.getRound() : -1;
    mod.hook("scripts/skills/skill", function (q) {
        q.use = @(__original) function (_targetTile, _forFree = false) {
            // Taken before: a used up item (a bandage) takes its skill's container with it
            local actor = this.m.Container == null || this.m.Container.isNull()
                ? null : this.m.Container.getActor();
            local ret = __original(_targetTile, _forFree);
            if (::APProbe.on) {
                ::APProbe.uses.push({who = actor == null ? null : actor.getName(), what = this.getID(),
                    round = round(), auto = actor != null && "_autopilot" in actor.m, ok = ret != false});
            }
            return ret;
        }
    });
    mod.hook("scripts/ai/tactical/agent", function (q) {
        q.pickBehavior = @(__original) function () {
            local b = __original(), e = this.m.Actor;
            if (::APProbe.on && b != null && e != null) {
                ::APProbe.behaviors.push({who = e.getName(), what = b.ClassName, round = round(),
                    auto = "_autopilot" in e.m, agent = this.ClassName});
            }
            return b;
        }
    });
});
