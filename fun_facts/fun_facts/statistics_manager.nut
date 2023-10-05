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
        local packedFacts = this.m.Fallen.map(@(f) f.FunFacts.pack());
        local dp = Util.pack(packedFacts);
        logInfo("SAVE DOUBLE PACKED " + dp.len());
        this.m.Flags.set("FallenFunFacts", dp)
        onSerialize(_out);
    }

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function( _in ) {
        onDeserialize(_in);

        local doublePacked = this.m.Flags.get("FallenFunFacts");
        if (doublePacked) {
            local packedFacts = Util.unpack(doublePacked);
            foreach (i, pf in packedFacts) {
                local fallen = this.m.Fallen[i];
                fallen.FunFacts <- ::new("scripts/mods/fun_facts/fun_facts");
                fallen.FunFacts.unpack(pf);
                fallen.FunFacts.setName(fallen.Name);
            }
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
