// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_AC@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// Accessory Companions in vanilla: taming, unleashing, KNOWN_BUGS #2 and #3.

test("AC-KB2: a tamed Nachzehrer grows from a feast like a wild one", function (t) {
    ::Tales.toughen();
    local id = t.state.id <- t.roster()[0].getID();
    local out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local bro = ::Tactical.getEntityByID(t.state.id), used = {};
        local out = t.state.out;
        out.tame <- ::ACT.unleash(bro, ::Const.Companions.TypeList.Nacho, ::Tales.freeTile(used));
        out.wild <- ::Tales.spawn("scripts/entity/tactical/enemies/ghoul", ::Tales.freeTile(used), ::Const.Faction.PlayerAnimals);
        out.before <- [::ACT.ghoulState(out.tame), ::ACT.ghoulState(out.wild)];
        ::ACT.feast(out.tame);
        ::ACT.feast(out.wild);
    }, ::Tales.wait(90), function (t) {
        local out = t.state.out;
        out.after <- [::ACT.ghoulState(out.tame), ::ACT.ghoulState(out.wild)];
        delete out.tame; delete out.wild;
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    t.probe("[size, HP max, Reach] before: [tame, wild]", out.before);
    local grown = @(s) [s[0][0] - s[1][0], s[0][1] - s[1][1], s[0][2] - s[1][2]];
    local tame = [out.after[0], out.before[0]], wild = [out.after[1], out.before[1]];
    local g = [grown(tame), grown(wild)];
    t.eq([g[0][0], g[0][1]], [g[1][0], g[1][1]], "AC-KB2 growth [size, HP max]: tame vs wild");
    t.eq(g[0][2], g[1][2], "AC-KB1 Reach growth: tame vs wild");
});

// Tames a wounded hostile direwolf next to _bro (retrying on fresh ones: a ~3% roll); out.tries, out.type.
local function tameStep(_id, _out) {
    return function () {
        local bro = ::Tactical.getEntityByID(_id);
        local tame = bro.getSkills().getSkillByID("actives.companions_tame");
        _out.tries <- 0;
        local used = {};
        local beasts = ::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID();
        while (_out.tries < 150 && bro.getItems().getItemAtSlot(::Const.ItemSlot.Accessory) == null) {
            _out.tries++;
            local tile = ::Tales.freeTile(used);  // the skill doesn't check range: the UI does
            local wolf = ::Tales.spawn("scripts/entity/tactical/enemies/direwolf", tile, beasts);
            wolf.setHitpoints(1);
            _out.verify <- tame.onVerifyTarget(bro.getTile(), tile);
            _out.chance <- tame.getHitchance(wolf);
            tame.onUse(bro, tile);
        }
        local acc = bro.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
        _out.type <- acc == null ? null : acc.getType();
        local unleash = bro.getSkills().getSkillByID("actives.unleash_companion");
        _out.unleashUsable <- unleash != null && unleash.isUsable();
    };
}

test("tame a direwolf, keep it through a save, unleash it next battle", function (t) {
    ::Tales.toughen();
    local bro = t.roster()[0], id = t.state.id <- bro.getID();
    local acc = bro.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
    if (acc != null) bro.getItems().unequip(acc);
    local out = {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([tameStep(id, out)],
        @(t) ::Tactical.getEntityByID(t.state.id))});
    t.probe("tries, last chance", [out.tries, out.chance]);
    t.eq([out.verify, out.type, out.unleashUsable], [true, ::Const.Companions.TypeList.Direwolf, false],
        "[tame verifies, collar type, unleash usable the same battle]");
    t.eq(::Tales.byId(id).getItems().getItemAtSlot(::Const.ItemSlot.Accessory).getType(),
        ::Const.Companions.TypeList.Direwolf, "collar kept after battle");
    t.save("tamed");
    yield t.load("tamed");
    bro = ::Tales.byId(id);
    local collar = bro.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
    t.eq(collar.getType(), ::Const.Companions.TypeList.Direwolf, "type after load");
    local next = t.state.next <- {};
    t.state.collar <- collar;
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local b = ::Tactical.getEntityByID(t.state.id);
        local next = t.state.next;
        local skill = b.getSkills().getSkillByID("actives.unleash_companion");
        local tile = ::Tales.freeNear(b);
        next.usable <- skill.isUsable();
        next.verify <- skill.onVerifyTarget(b.getTile(), tile);
        skill.onUse(b, tile);
        local w = tile.getEntity();
        next.wolf <- [w.getFaction() == ::Const.Faction.PlayerAnimals, w.getName() == t.state.collar.m.Name, skill.isUsable()];
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    t.eq([next.usable, next.verify], [true, true], "unleash [usable, verify]");
    t.eq(next.wolf, [true, true, false], "[PlayerAnimals, named as the collar, unleash usable again]");
    local back = ::Tales.byId(id).getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
    t.eq([back != null && back.getType() == ::Const.Companions.TypeList.Direwolf, back.getEntity() == null],
        [true, true], "collar back on and leashed after battle");
});
