::mods_hookExactClass("entity/tactical/player", function (o)
{
    o.m.FunFacts <- null;

    local create = o.create;
    o.create = function( ... )
    {
        vargv.insert(0, this);
        local ret = create.acall(vargv);
        this.logInfo("ff: player new fun_facts");
        this.m.FunFacts = ::new("scripts/mods/fun_facts/fun_facts");
        this.logInfo("ff: fun_facts.Version "
                + ("Version" in this.m.FunFacts.m ? this.m.FunFacts.m.Version : 0));
        return ret;
    }

    // TODO: move to FunFacts class
    local updateCombatStats = function (funFacts, combatStats) {
        // funFacts.m.Stats.DamageReceivedHitpoints += this.m.CombatStats.DamageReceivedHitpoints;
        // funFacts.m.Stats.DamageReceivedArmor += this.m.CombatStats.DamageReceivedArmor;
        // funFacts.m.Stats.DamageDealtHitpoints += this.m.CombatStats.DamageDealtHitpoints;
        // funFacts.m.Stats.DamageDealtArmor += this.m.CombatStats.DamageDealtArmor;
        ++funFacts.m.Stats.Battles;
    }

    local onBeforeCombatResult = o.onBeforeCombatResult;
    o.onBeforeCombatResult = function( ... )
    {
        vargv.insert(0, this);
        local ret = onBeforeCombatResult.acall(vargv);
        updateCombatStats(this.m.FunFacts,  this.m.CombatStats);
        return ret;
    }

    local getRosterTooltip = o.getRosterTooltip;
    o.getRosterTooltip = function( ... )
    {
        vargv.insert(0, this);
        local ret = getRosterTooltip.acall(vargv);
        this.m.FunFacts.extendTooltip(ret, 6);
        return ret;
    }

    local onDeath = o.onDeath;
    // _killer, _skill, _tile, _fatalityType
    o.onDeath = function( ... )
    {
        vargv.insert(0, this);
        local ret = onDeath.acall(vargv);
        if (!this.isGuest())
        {
            // this.m.FunFacts.clearRanks();
            ::Tactical.getCasualtyRoster().getAll()[::Tactical.getCasualtyRoster().getAll().len() - 1].m.FunFacts = this.m.FunFacts;
        }
        if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode() && vargv[4] != this.Const.FatalityType.Unconscious && (vargv[2] != null && vargv[1] != null || vargv[4] == this.Const.FatalityType.Devoured || vargv[4] == this.Const.FatalityType.Kraken))
        {
            updateCombatStats(this.m.FunFacts,  this.m.CombatStats);
        }
        return ret;
    }

    local onSerialize = o.onSerialize;
    o.onSerialize = function(_out) {
        this.logInfo("ff: player.onSerialize version " + ::FunFacts.Version);
        this.m.FunFacts.onSerialize(
            ::FunFacts.Mod.Serialization.getSerializationEmulator("FunFacts", this.getFlags()));
        return onSerialize(_out);
    }

    local onDeserialize = o.onDeserialize;
    o.onDeserialize = function (_in) {
        onDeserialize(_in);
        if (::FunFacts.Mod.Serialization.isSavedVersionAtLeast("0.1.1", _in.getMetaData())) {
            this.logInfo("ff: player.onDeserialize saved version at least 0.1.1");
            this.m.FunFacts.onDeserialize(
                ::FunFacts.Mod.Serialization.getDeserializationEmulator("FunFacts", this.getFlags()));
        } else {
            this.logInfo("ff: player.onDeserialize saved version OLD");
        }
    }
});
