::mods_hookNewObject("ui/screens/world/world_obituary_screen", function (o)
{
	local convertFallenToUIData = o.convertFallenToUIData;
	o.convertFallenToUIData = function(...)
	{
		vargv.insert(0, this);
		local ret = convertFallenToUIData.acall(vargv);
		ret.Fallen = clone ret.Fallen;
		foreach (idx, fallen in ret.Fallen)
		{
			if ("FunFacts" in fallen)
			{
				ret.Fallen[idx] = clone fallen;
				ret.Fallen[idx].rawdelete("FunFacts");
			}
			ret.Fallen[idx].FunFacts_Idx <- idx;
		}
		return ret;
	}
});
