local mod = ::CampsAndArtifacts <- {
    ID = "mod_camps_and_artifacts"
    Name = "Camps and Artifacts (Reworked)"
    Version = "3.5.1"
    Mods = {}
};
// TODO: add missing artifact versions of named stuff"
//    - named_khopesh.nut
//    - named_polemace.nut
//    - named_warbrand.nut (buff base)
// TODO: add extra:
//    - artifact bolo
//    - artifact sling?
//    - artifact 2h orc axe
//    - artifact 2h orc chain
//    - artifact goblin impaler?
//    - artifact goblin bow?
// TODO: weapon perks?
mod.choice <- function(options) {
    return options[::Math.rand(0, options.len() - 1)];
}

// If an artifact is created before the World we will need this. Item Spawner does this shit.
local NoopFlags = {
    function has(key) {return false}
    function add(key) {}
}

mod.createRandomName <- function () {
    local flags = "Flags" in ::World ? ::World.Flags : NoopFlags;
    // Try to find a unique name first
    local names = this.m.NameList.filter(@(_, n) !::World.Flags.has("camps:artifact_name:" + n));
    if (names.len() > 0) {
        local name = mod.choice(names);
        ::World.Flags.add("camps:artifact_name:" + name, true);
        return name;
    }
    // Use prefix if failed
    return mod.choice(this.m.PrefixList) + " " + mod.choice(this.m.NameList)
}


foreach (file in ::IO.enumerateFiles("camps_and_artifacts/config")) ::include(file);

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_msu(>=1.6.0)", function () {
    mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);
    mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods,
      "https://www.nexusmods.com/battlebrothers/mods/678");
    mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHubTags,
      "https://github.com/Suor/battle-brothers-mods/tree/master/camps_and_artifacts",
      {Prefix = "camps-"}
    );
    mod.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHubTags);

    mod.Mods.SatoBalance <- ::mods_getRegisteredMod("sato_balance_mod");
    mod.Mods.Reforged <- ::mods_getRegisteredMod("mod_reforged");

    // Add Artifact type and hack the func to show Artifact, not "Famed Item, Artifact"
    ::Const.Items.addNewItemType("Artifact", "Artifact");
    ::mods_hookExactClass("items/item", function (cls) {
            local getDescription = cls.getDescription;
            cls.getDescription = function () {
                if (!(this.m.ItemType & ::Const.Items.ItemType.Artifact)) return getDescription();

                local named = this.m.ItemType & ::Const.Items.ItemType.Named;
                this.m.ItemType -= named;
                local ret = getDescription();
                this.m.ItemType += named;
                return ret;
            }
    })

    ::include("camps_and_artifacts/factions/faction");
    foreach (file in ::IO.enumerateFiles("camps_and_artifacts/factions/actions")) ::include(file);
    ::include("camps_and_artifacts/entity/world/locations/orc_fortress_location");

    ::mods_hookExactClass("entity/world/location", function(cls) {
        local onSpawned = cls.onSpawned;
        cls.onSpawned = function () {
            logWarning("Spawned " + this.ClassName + " resources " + this.m.Resources);
            local nearestSettlement = 9000;
            local myTile = this.getTile();
            foreach (s in this.World.EntityManager.getSettlements()) {
                local d = myTile.getDistanceTo(s.getTile());
                if (d < nearestSettlement) nearestSettlement = d;
            }

            local scale = ((this.m.Resources + nearestSettlement * 4) / 5.0 - 37.0);
            if (scale > 0 && !this.isLocationType(this.Const.World.LocationType.Unique)) {
                local artifact_chance = scale * scale / 2;
                logWarning("camps: artifact chance " + (artifact_chance/100.0) + " scale " + scale
                     + " nearestSettlement " + nearestSettlement + " resources " + this.m.Resources);
                if (::Math.rand(1, 10000) <= artifact_chance) {
                    local artifacts = ::Const.Items.Artifacts;
                    local artifact = artifacts[::Math.rand(0, artifacts.len() - 1)];
                    this.m.Loot.add(this.new("scripts/items/" + artifact));
                    this.logWarning("Spawned an Artifact!");
                    return // no more loot
                }
            }
            onSpawned()
        }
    })

    // Make it do auto time reset
    ::mods_hookExactClass("skills/effects/chilled_effect", function (cls) {
        local onRefresh = "onRefresh" in cls ? cls.onRefresh : cls.skill.onRefresh;
        cls.onRefresh <- function () {
            onRefresh();
            this.resetTime();
        }
    })
})
