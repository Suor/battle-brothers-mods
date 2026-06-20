local def = ::Challenges, mod = def.mh;
local add = def.addPage("Followers");

// Retinue followers offered with a per-follower ban toggle. The freebie/utility followers
// (Agent, Alchemist, Brigand, Minstrel, Negotiator, Quartermaster) are left off the list - this
// is about doing without comforts, not niche bonuses. [id, short name].
def.Followers <- [
    ["follower.blacksmith", "Blacksmith"],
    ["follower.bounty_hunter", "Bounty Hunter"],
    ["follower.cartographer", "Cartographer"],
    ["follower.cook", "Cook"],
    ["follower.drill_sergeant", "Drill Sergeant"],
    ["follower.lookout", "Lookout"],
    ["follower.paymaster", "Paymaster"],
    ["follower.recruiter", "Recruiter"],
    ["follower.scavenger", "Scavenger"],
    ["follower.scout", "Scout"],
    ["follower.surgeon", "Surgeon"],
    ["follower.trader", "Trader"],
];
def.banFollowerSetting <- function (_id) { return "ban_" + _id; }

add(::MSU.Class.SettingsTitle("followersTitle", "Followers"));
foreach (f in def.Followers) {
    add(::MSU.Class.BooleanSetting(def.banFollowerSetting(f[0]), false, "No " + f[1],
        "Hides The " + f[1] + " from the retinue hire list."));
}

// Drop followers banned via their per-follower checkbox from the retinue hire list. Only known
// followers carry a setting, so modded followers are left untouched.
mod.hook("scripts/retinue/retinue_manager", function (q) {
    q.getFollowersForUI = @(__original) function () {
        local ret = __original();
        local banned = {};
        foreach (f in def.Followers)
            if (def.conf(def.banFollowerSetting(f[0]))) banned[f[0]] <- true;
        if (banned.len() == 0) return ret;
        return ret.filter(@(_, f) !(f.ID in banned));
    }
})
