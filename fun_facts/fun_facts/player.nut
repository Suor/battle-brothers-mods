::mods_hookExactClass("entity/tactical/player", function (o) {
    this.logInfo("ff: Hook entity/tactical/player");
    o.m.FunFacts <- null;

    local create = o.create;
    o.create = function( ... ) {
        vargv.insert(0, this);
        local ret = create.acall(vargv);
        // this.logInfo("ff: player new fun_facts");
        this.m.FunFacts = ::new("scripts/mods/fun_facts/fun_facts");
        this.m.FunFacts.setName(this.getName());
        // this.logInfo("ff: fun_facts.Version "
        //         + ("Version" in this.m.FunFacts.m ? this.m.FunFacts.m.Version : 0));
        return ret;
    }

    local setName = o.setName;
    o.setName = function(_value) {
        setName(_value);
        this.m.FunFacts.setName(_value);
    }


    local onBeforeCombatResult = o.onBeforeCombatResult;
    o.onBeforeCombatResult = function( ... ) {
        vargv.insert(0, this);
        local ret = onBeforeCombatResult.acall(vargv);
        this.m.FunFacts.onCombatEnd(this);
        return ret;
    }

    local getRosterTooltip = o.getRosterTooltip;
    o.getRosterTooltip = function( ... ) {
        vargv.insert(0, this);
        local ret = getRosterTooltip.acall(vargv);
        this.m.FunFacts.extendTooltip(ret, 6);
        return ret;
    }

    local onDeath = o.onDeath;
    // _killer, _skill, _tile, _fatalityType
    o.onDeath = function( ... ) {
        vargv.insert(0, this);
        local ret = onDeath.acall(vargv);
        if (!this.isGuest()) {
            // this.m.FunFacts.clearRanks();
            local casualties = ::Tactical.getCasualtyRoster().getAll();
            casualties[casualties.len() - 1].m.FunFacts = this.m.FunFacts;
        }
        if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode() && vargv[4] != this.Const.FatalityType.Unconscious && (vargv[2] != null && vargv[1] != null || vargv[4] == this.Const.FatalityType.Devoured || vargv[4] == this.Const.FatalityType.Kraken))
        {
            this.m.FunFacts.onCombatEnd(this);
        }
        return ret;
    }

    local onCombatStart = o.onCombatStart;
    o.onCombatStart = function () {
        // TODO: move to FunFacts
        this.m.ff_fled <- 0;
        this.m.ff_returned <- 0;
        this.m.FunFacts.onCombatStart(this);
        return onCombatStart();
    }

    local checkMorale = o.checkMorale;
    o.checkMorale = function(...) {
        local oldMoraleState = this.m.MoraleState;

        vargv.insert(0, this);
        local ret = checkMorale.acall(vargv);

        local fleeing = this.Const.MoraleState.Fleeing;
        if (oldMoraleState != fleeing && this.m.MoraleState == fleeing) {
            // this.m.FunFacts.onFled(this);
            this.m.ff_fled++;
        } else if (oldMoraleState == fleeing && this.m.MoraleState != fleeing) {
            this.m.ff_returned++;
        }
        return ret;
    }

    local onSerialize = o.onSerialize;
    o.onSerialize = function(_out) {
        this.getFlags().set("FunFacts", this.m.FunFacts.pack());
        // Q: do I need a helper to break it into parts?
        // Tags.pack(this.getFlags(), "FunFacts", this.m.FunFacts);
        return onSerialize(_out);
    }

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function (_in) {
        onDeserialize(_in);

        local packed = this.getFlags().get("FunFacts");
        if (packed) {
            this.m.FunFacts.unpack(packed);
            this.m.FunFacts.setName(this.m.Name);
            return
        }

        if (::FunFacts.Mod.Serialization.isSavedVersionAtLeast("0.1.1", _in.getMetaData())) {
            // this.logInfo("ff: player.onDeserialize saved version at least 0.1.1");
            this.m.FunFacts.onDeserialize(
                ::FunFacts.Mod.Serialization.getDeserializationEmulator("FunFacts", this.getFlags()));
            this.m.FunFacts.setName(this.m.Name);
        } else {
            this.logInfo("ff: player.onDeserialize saved version OLD");
        }
    }
});
