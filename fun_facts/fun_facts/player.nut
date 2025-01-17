::mods_hookExactClass("entity/tactical/player", function (o) {
    this.logInfo("ff: Hook entity/tactical/player");
    o.m.FunFacts <- null;

    local create = o.create;
    o.create = function( ... ) {
        vargv.insert(0, this);
        local ret = create.acall(vargv);
        this.m.FunFacts = ::new("scripts/mods/fun_facts/fun_facts");
        this.m.FunFacts.setPlayer(this);
        return ret;
    }

    local setName = o.setName;
    o.setName = function(_value) {
        setName(_value);
        this.m.FunFacts.setName(this.getName());
    }

    local setTitle = o.setTitle;
    o.setTitle = function(_value) {
        setTitle(_value);
        this.m.FunFacts.setName(this.getName());
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
        this.m.FunFacts.onDeath(vargv[1], vargv[4]);
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
        ::std.Flags.pack(this.getFlags(), "FunFacts", this.m.FunFacts.pack());
        return onSerialize(_out);
    }

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function (_in) {
        onDeserialize(_in);
        this.m.FunFacts.setName(this.getName());

        local ffState = ::std.Flags.unpack(this.getFlags(), "FunFacts");
        if (ffState) this.m.FunFacts.unpack(ffState);
    }
});
