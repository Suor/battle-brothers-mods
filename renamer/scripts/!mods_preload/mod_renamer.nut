local mod = ::Renamer <- {
    ID = "mod_renamer"
    Name = "Bro Renamer"
    Version = 0.1
}
// Export this for people to tweak for their needs and mods adding backgrounds
mod.Aliases <- {
    "Caravan Hand": "Caravaner"
    "Farmhand": "Farmer"
    "Fisherman": "Fisher"
    "Hedge Knight": "Knight"
    "Adventurous Noble": "Adventurous"
    "Disowned Noble": "Disowned"
    "Killer on the Run": "Killer"
    "Retired Soldier": "Retired"
    "Indebted": "Slave"
    // Hacflows Exp, More Backgrounds and Events
    "Town Watchman": "Watchman"
    // Chosen
    "Chosen Aspirant": "Aspirant"
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20)", function() {
    local romanLookup = [[1000 "M"], [900 "CM"], [500 "D"], [400 "CD"], [100 "C"], [90 "XC"],
                         [50 "L"], [40 "XL"], [10 "X"], [9 "IX"], [5 "V"], [4 "IV"], [1 "I"]];
    local romanStr = {I = 1, V = 5, X = 10, L = 50, C = 100, D = 500, M = 1000}, romanChar = {};
    foreach (k, v in romanStr) romanChar[k[0]] <- v; // Need to convert keys to chars

    local function toRoman(num) {
        local roman = "";
        foreach (pair in romanLookup) {
            local value = pair[0], r = pair[1];
            while (num >= value) {
                roman += r;
                num -= value;
            }
        }
        return roman;
    }

    local function fromRoman(roman) {
        if (roman.len() == 0) return null;

        local num = romanChar[roman[0]];
        for (local i = 1; i < roman.len(); i ++) {
            local curr = romanChar[roman[i]], prev = romanChar[roman[i - 1]];
            num += (curr <= prev ? curr : curr - prev * 2);
        }
        return num;
    }

    local function re_find(str, re) {
        local capture = regexp(re).capture(str);
        if (!capture) return null;
        return str.slice(capture[1].begin, capture[1].end)
    }

    local function extractNumber(name) {
        local roman = re_find(name, " ([IVXLC]+)$");
        return roman ? fromRoman(roman) : 1; // If absent then he is the first
    }

    ::mods_hookNewObject("entity/tactical/player", function (obj) {
        local onHired = obj.onHired;
        obj.onHired = function() {
            // this.logInfo("br: hired " + this.getName());
            onHired();
            local bgID = this.getBackground().getID()
            local bgName = this.getBackground().getNameOnly();
            local bgAlias = bgName in mod.Aliases ? mod.Aliases[bgName] : bgName;

            local lastNum = 0;
            foreach (bro in World.getPlayerRoster().getAll()) {
                if (bro == this) continue;
                if (bro.getBackground().getID() != bgID) continue;
                local num = extractNumber(bro.getTitle());
                if (num && num > lastNum) lastNum = num;
            }
            foreach (fallen in World.Statistics.getFallen()) {
                if (fallen.Name.find(bgAlias) == null && fallen.Name.find(bgName) == null) continue;
                local num = extractNumber(fallen.Name);
                if (num && num > lastNum) lastNum = num;
            }

            this.getFlags().set("renamer_initialTitle", this.getTitle());
            this.setTitle(bgAlias + " " + toRoman(lastNum + 1));
        }
    })
})
