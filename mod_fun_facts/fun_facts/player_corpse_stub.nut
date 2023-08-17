::mods_hookNewObject("entity/tactical/player_corpse_stub", function (o)
{
	o.m.FunFacts <- null;

	local getRosterTooltip = o.getRosterTooltip;
	o.getRosterTooltip = function( ... )
	{
		vargv.insert(0, this);
		local ret = getRosterTooltip.acall(vargv);
		// TODO: decide on index, used to be 4
		if (this.m.FunFacts != null) this.m.FunFacts.extendTooltip(ret, 4);
		return ret;
	}
});
