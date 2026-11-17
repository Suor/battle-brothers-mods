// DR-KB1 (KNOWN_BUGS.md #1), shared by tale_known_bugs.nut (vanilla) and tale_known_bugs_reforged.nut: summoned beasts
// stand idle, face the wrong way, are "both hostile and not". A druid joins the company and summons in the first
// player turn; the company then ends its turns for two rounds while the beast is watched.
// Reforged's AI may log its noise in these battles (README, Engine issues).

::DRKB1 <- {};

::DRKB1.summon <- function (t) {
    local restore = ::Tales.tolerateRfAI();
    ::Tales.toughen();
    t.state.id <- ::Tales.hireTough("druid_background", 13).getID();
    local out = t.state.out <- {beast = null, turns = 0, spent = false, tiles = {}};
    t.state.inner <- ::Tales.scripted([function (t) {
        local druid = ::Tactical.getEntityByID(t.state.id);
        local out = t.state.out;
        local tile = ::Tales.freeNear(druid);
        local skill = druid.getSkills().getSkillByID("actives.druid_summon_beast");
        out.verify <- skill.onVerifyTarget(druid.getTile(), tile);
        out.used <- skill.onUse(druid, tile);
        local beast = tile.getEntity();
        out.beast = beast;
        out.type <- beast.getName();
        out.faction <- [beast.getFaction() == ::Const.Faction.PlayerAnimals, beast.isAlliedWithPlayer(),
            beast.isAlliedWith(druid), beast.getAIAgent() != null];
        out.flipped <- beast.getSprite("body").isFlippedHorizontally();
        out.tiles[beast.getTile().ID] <- true;
    }], @(t) ::Tactical.getEntityByID(t.state.id), @() ::Tactical.TurnSequenceBar.getCurrentRound() >= 3);
    yield t.battle({spawn = "BanditRaiders", resources = 60, player = function (t) {
        local out = t.state.out;
        local b = out.beast;
        if (b != null && b.isAlive() && b.isPlacedOnMap()) {
            out.tiles[b.getTile().ID] <- true;
            if (::Tactical.TurnSequenceBar.getActiveEntity() == b) {
                out.turns = ::Math.max(out.turns, 1);
                if (b.getActionPoints() < b.getActionPointsMax()) out.spent = true;
            }
        }
        t.state.inner();
    }});
    restore();
    t.probe("beast", out.type);
    t.eq([out.verify, out.used], [true, true], "summon [verify, used]");
    t.eq(out.faction, [true, true, true, true], "[PlayerAnimals, allied with player, with druid, has AI]");
    t.eq(out.flipped, true, "body flipped to face right");
    t.eq([out.turns, out.spent], [1, true], "had a turn and spent AP in two rounds");
    t.probe("tiles visited", out.tiles.len());
    t.eq(t.result.survivors.enemies, 0, "won");
}

// The same for every beast the wilds can send, each in its own battle.
::DRKB1.everyType <- function (t) {
    local biomes = ::Const.Druid.Biomes;
    local saved = [biomes.Starter, biomes.Pools, biomes.Default];
    local types = ["wolf", "direwolf", "direwolf_high", "spider", "schrat_small", "hyena", "hyena_high", "serpent"];
    local results = {};
    local restore = ::Tales.tolerateRfAI();
    ::Tales.toughen();
    t.state.id <- ::Tales.hireTough("druid_background", 13).getID();
    foreach (type in types) {
        biomes.Starter = type; biomes.Pools = {}; biomes.Default = [type];
        local out = t.state.out <- {beast = null, spent = false};
        t.state.inner <- ::Tales.scripted([function (t) {
            local druid = ::Tactical.getEntityByID(t.state.id);
            local out = t.state.out;
            local tile = ::Tales.freeNear(druid);
            druid.getSkills().getSkillByID("actives.druid_summon_beast").onUse(druid, tile);
            local b = tile.getEntity();
            out.beast = b;
            out.state <- [b.getFaction() == ::Const.Faction.PlayerAnimals, b.isAlliedWithPlayer(),
                b.getAIAgent() != null, b.getSprite("body").isFlippedHorizontally()];
        }], @(t) ::Tactical.getEntityByID(t.state.id), @() ::Tactical.TurnSequenceBar.getCurrentRound() >= 3);
        yield t.battle({spawn = "BanditRaiders", resources = 60, player = function (t) {
            local out = t.state.out;
            local b = out.beast;
            if (b != null && b.isAlive() && ::Tactical.TurnSequenceBar.getActiveEntity() == b
                && b.getActionPoints() < b.getActionPointsMax()) out.spent = true;
            t.state.inner();
        }});
        out.state.push(out.spent);
        results[type] <- out.state;
    }
    restore();
    biomes.Starter = saved[0]; biomes.Pools = saved[1]; biomes.Default = saved[2];
    local expected = {};
    foreach (type in types) expected[type] <- [true, true, true, true, true];
    t.eq(results, expected, "[PlayerAnimals, allied, has AI, flipped, spent AP] per type");
}
