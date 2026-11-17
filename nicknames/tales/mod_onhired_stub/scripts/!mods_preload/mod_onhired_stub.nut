// Test-only: calls onHired() for the starting brothers inside nicknames' startNewCampaign hook (before its loop)
// and around it (after), recording the hired state and titles each time saw.
::OnHiredStub <- {seen = []};
local mod = ::Hooks.register("mod_onhired_stub", "1.0.0", "onHired at campaign start (bbtales)");

local function hireAll(_point) {
    local roster = ::World.getPlayerRoster().getAll();
    ::OnHiredStub.seen.push({point = _point, hired = clone ::Nicknames.loadState().hired,
        titles = roster.map(@(b) b.getTitle())});
    foreach (bro in roster) bro.onHired();
}
local function hookStart(_point) {
    mod.hook("scripts/states/world_state", function (q) {
        q.startNewCampaign = @(__original) function () { __original(); hireAll(_point); }
    });
}
// Hooks of earlier buckets are wrapped by later ones; nicknames hooks in Normal.
mod.queue(@() hookStart("before"), ::Hooks.QueueBucket.Early);
mod.queue(@() hookStart("after"), ::Hooks.QueueBucket.VeryLate);
