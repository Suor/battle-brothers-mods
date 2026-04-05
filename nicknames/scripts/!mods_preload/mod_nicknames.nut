local def = ::Nicknames <- {
    ID = "mod_nicknames"
    Name = "Nicknames for Everyone"
    Version = "0.1"
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.conflictWith("mod_renamer");

// Base attribute ranges before background modifiers
local BaseAttrRanges = {
    Hitpoints = [50, 60],
    Bravery = [30, 40],
    Stamina = [90, 100],
    MeleeSkill = [47, 57],
    RangedSkill = [32, 42],
    MeleeDefense = [0, 5],
    RangedDefense = [0, 5],
    Initiative = [100, 110]
};

// Weapon nicknames by weapon type constant (filled in mod.queue once game constants are available)
def.WeaponNicknames <- {};

mod.queue(function () {
    ::include("nicknames/rosetta_ru");

    // Helpers on def so they're accessible from nicknames/nicknames.nut
    def.hasTrait <- @(bro, id) bro.getSkills().hasSkill(id);
    def.isEliteBg <- @(bro) bro.getBackground().m.DailyCost >= 20;
    def.hasWeaponType <- function(bro, wtype) {
        local weapon = bro.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
        return weapon != null && weapon.isWeaponType(wtype);
    };
    def.bgKey <- function(bro) {
        local id = bro.getBackground().getID();
        local prefix = "background.";
        if (id.find(prefix) == 0) return id.slice(prefix.len());
        return id;
    };
    def.hasBg <- @(bro, suffix) def.bgKey(bro) == suffix;
    # FIX: calc ranges for all attrs first
    def.isAttrHigh <- function(bro, attrName) {
        local br = BaseAttrRanges[attrName];
        local c = bro.getBackground().onChangeAttributes();
        return bro.getBaseProperties()[attrName] >= br[1] + c[attrName][1];
    };
    def.isAttrLow <- function(bro, attrName) {
        local br = BaseAttrRanges[attrName];
        local c = bro.getBackground().onChangeAttributes();
        return bro.getBaseProperties()[attrName] <= br[0] + c[attrName][0];
    };

    ::include("nicknames/nicknames");

    // Weighted random pick from array of {title, weight} items
    local function weightedRandPick(items) {
        local totalWeight = 0;
        foreach (c in items) totalWeight += c.weight;
        local roll = ::Math.rand(1, totalWeight);
        local cumulative = 0;
        foreach (c in items) {
            cumulative += c.weight;
            if (roll <= cumulative) return c;
        }
        return items[items.len() - 1];
    }

    // Check if title is used by any fallen bro
    // TODO: not really efficient, does not cover fired guys, may simply remember in World.Flags
    //       when a bro joins, then we won't even need to track death, kick, leave
    local function isTitleUsedByFallen(title, fallenNames) {
        foreach (name in fallenNames)
            if (name.find(title) != null) return true;
        return false;
    }

    mod.hook("scripts/entity/tactical/player", function (q) {
        q.onHired = @(__original) function () {
            __original(); // vanilla runs, may set title at 25%/10% chance

            if (this.getTitle() != "") return; // already has a title

            // 1. Build used titles set
            local usedTitles = {};
            foreach (bro in ::World.getPlayerRoster().getAll()) {
                if (bro.getID() == this.getID()) continue;
                local t = bro.getTitle();
                if (t != "") usedTitles[t] <- true;
            }
            local fallenNames = [];
            foreach (fallen in ::World.Statistics.getFallen())
                fallenNames.push(fallen.Name);

            // 2. Collect candidates with weights
            local candidates = [];

            // 2a. Combos (weight 3)
            local W = def.Weights;
            foreach (combo in def.ComboNicknames)
                if (combo.check(this))
                    foreach (n in combo.nicknames)
                        candidates.push({title = n, weight = W.Combo});

            // 2b. Trait-based (weight 2): vanilla .m.Titles + custom
            foreach (skill in this.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)) {
                std.debug(skill)
                std.debug(skill.getID())
                foreach (t in skill.m.Titles)
                    candidates.push({title = t, weight = W.Trait});
                local id = skill.getID();
                if (id in def.TraitNicknames)
                    foreach (n in def.TraitNicknames[id])
                        candidates.push({title = n, weight = W.Trait});
            }

            // 2c. Talent-based (weight 2): 3-star talents
            for (local i = 0; i < ::Const.Attributes.COUNT; i++)
                if (this.m.Talents[i] == 3 && i < def.TalentNicknames.len())
                    foreach (n in def.TalentNicknames[i])
                        candidates.push({title = n, weight = W.Talent});

            // 2d. Background-based (weight 1): vanilla .m.Titles + custom
            local bg = this.getBackground();
            foreach (t in bg.m.Titles)
                candidates.push({title = t, weight = W.Background});
            local _bgKey = def.bgKey(this);
            if (_bgKey in def.BackgroundNicknames)
                foreach (n in def.BackgroundNicknames[_bgKey])
                    candidates.push({title = n, weight = W.Background});

            // 2e. Weapon-based (weight 1)
            local weapon = this.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
            if (weapon != null)
                foreach (wtype, nicks in def.WeaponNicknames)
                    if (weapon.isWeaponType(wtype))
                        foreach (n in nicks)
                            candidates.push({title = n, weight = W.Weapon});

            // 2f. Attribute-based (weight 1): extreme values relative to background range
            foreach (ac in def.AttrNicknames) {
                if (ac.high.len() > 0 && def.isAttrHigh(this, ac.attr))
                    foreach (n in ac.high)
                        candidates.push({title = n, weight = W.Attr});
                if (ac.low.len() > 0 && def.isAttrLow(this, ac.attr))
                    foreach (n in ac.low)
                        candidates.push({title = n, weight = W.Attr});
            }

            if (candidates.len() == 0) return; // shouldn't happen

            // 3. Filter out used titles
            local filtered = candidates.filter(@(_, c)
                !(c.title in usedTitles) && !isTitleUsedByFallen(c.title, fallenNames)
            );
            if (filtered.len() == 0) filtered = candidates; // allow reuse if all taken

            // 4. Weighted random pick
            this.setTitle(weightedRandPick(filtered).title);
        }
    });
});
