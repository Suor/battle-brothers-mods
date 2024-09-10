local Debug = ::std.Debug, Util = std.Util;

::mods_hookNewObject("statistics/statistics_manager", function (o) {
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
            this.m.Flags.set("FallenFunFacts." + i, ffp);
        }
        onSerialize(_out);
    }

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function( _in ) {
        onDeserialize(_in);

        foreach (i, fallen in this.m.Fallen) {
            local ffp = this.m.Flags.get("FallenFunFacts." + i);
            if (!ffp) continue;
            fallen.FunFacts <- ::new("scripts/mods/fun_facts/fun_facts");
            fallen.FunFacts.unpack(ffp);
            fallen.FunFacts.setName(fallen.Name);
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
