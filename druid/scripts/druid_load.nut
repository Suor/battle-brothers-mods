// A string value is a placeholder (ours or a sibling mod's); the real DynamicPerks is a table.
if (("DynamicPerks" in getroottable()) && typeof ::DynamicPerks != "string")
    ::DynamicPerks.PerkGroups.add(::new("scripts/druid_pg"));
