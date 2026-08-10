local def = ::Challenges, mod = def.mh;
local add = def.addPage("Followers");

// Pandora's Hobby reworks the retinue wholesale, so we leave it alone there.
local hasPandora = ::Hooks.hasMod("mod_pandoras_hobby");

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
local settings = [];
foreach (f in def.Followers) {
    settings.push(add(::MSU.Class.BooleanSetting(def.banFollowerSetting(f[0]), false, "No " + f[1],
        "Hides the " + f[1] + " from the retinue hire list.")));
}

if (hasPandora) {
    // MSU keeps each setting's lock in the campaign save and restores it on load, wiping ours,
    // so put it back every time a world is deserialized. unlock() first, lock() stacks reasons.
    local function lockAll() {
        foreach (s in settings) {
            s.unlock();
            s.lock("Pandora's Hobby has a retinue of its own");
        }
    }
    lockAll();
    mod.hook("scripts/states/world_state", function (q) {
        q.onDeserialize = @(__original) function (_in) {
            __original(_in);
            lockAll();
        }
    })
    return;
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
