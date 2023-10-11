local Debug = ::std.Debug, Util = std.Util;

::mods_hookNewObjectOnce("statistics/statistics_manager", function (o) {
    local addFallen = o.addFallen;
    // _fallen
    o.addFallen = function( ... ) {
        vargv.insert(0, this);
        local ret = addFallen.acall(vargv);
        // because legends handles this function differently I instead rely on the fact
        // that this.m.Fallen[0] is the latest dead character
        ::FunFacts.LastFallen = this.m.Fallen[0];
        return ret;
    }

    local onSerialize = o.onSerialize;
    o.onSerialize = function( _out ) {
        foreach (i, fallen in this.m.Fallen) {
            local ffp = "FunFacts" in fallen ? fallen.FunFacts.pack() : null;
            logInfo("ff: PACK FallenFunFacts." + i + " " + (ffp ? ffp.len() : "null"));
            this.m.Flags.set("FallenFunFacts." + i, ffp);
        }
        onSerialize(_out);
    }

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function( _in ) {
        onDeserialize(_in);

        foreach (i, fallen in this.m.Fallen) {
            local ffp = this.m.Flags.get("FallenFunFacts." + i);
            // logInfo("ff: UNPACK FallenFunFacts." + i + " " + (ffp ? ffp.len() : "null"));
            if (!ffp) continue;
            fallen.FunFacts <- ::new("scripts/mods/fun_facts/fun_facts");
            fallen.FunFacts.unpack(ffp);
            fallen.FunFacts.setName(fallen.Name);
        }

        logInfo("ff: statistics_manager.onDeserialize (after)")
        local doublePacked = this.m.Flags.get("FallenFunFacts");
        if (doublePacked) {
            logInfo("doublePacked " + doublePacked.len());
            local packedFacts = Util.unpack(doublePacked);
            logInfo("packedFacts.len() " + packedFacts.len());
            std.Debug.log("packedFacts", packedFacts.map(@(s) s.len()));
            foreach (i, pf in packedFacts) {
                local fallen = this.m.Fallen[i];
                fallen.FunFacts <- ::new("scripts/mods/fun_facts/fun_facts");
                fallen.FunFacts.unpack(pf);
                fallen.FunFacts.setName(fallen.Name);
            }
            this.m.Flags.remove("FallenFunFacts");
            return
        }

        // Load in an old bad way
        if (::FunFacts.Mod.Serialization.isSavedVersionAtLeast("0.1.0", _in.getMetaData())) {
            local ffIndexes = ::FunFacts.Mod.Serialization.flagDeserialize("FallenWithStats", [], null, this.m.Flags);

            foreach (i in ffIndexes) {
                local fallen = this.m.Fallen[i];
                fallen.FunFacts <- ::new("scripts/mods/fun_facts/fun_facts");
                fallen.FunFacts.onDeserialize(
                    ::FunFacts.Mod.Serialization.getDeserializationEmulator("StatsFor" + i, this.m.Flags));
                fallen.FunFacts.setName(fallen.Name);
            }
        }
    }

    o.FunFacts_getTooltipForFallen <- function( _idx ) {
        local tooltip = [
            {
                id = 1,
                type = "title",
                text = this.m.Fallen[_idx].Name,
            }
        ];
        if ("FunFacts" in this.m.Fallen[_idx]) {
            this.m.Fallen[_idx].FunFacts.extendTooltip(tooltip, 2);
        } else {
            tooltip.push({
                id = 2,
                type = "text",
                text = "Noone remembers anything fun about this dude."
            })
        }
        return tooltip;
    }
});
