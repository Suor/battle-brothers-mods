// mode: campaign seed=bbtest-battle fresh=1 launch=discord
// mods: mod_AC@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md: "Discord deep search" entries (KB5).

// Vanilla 1.5.2 has no alp_shadow script (the alp's onDeath only checks for one), so no shadows here.
local function alps(_used, _n) {
    local faction = ::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID();
    local out = [];
    for (local i = 0; i < _n; i++) out.push(::Tales.spawn("scripts/entity/tactical/enemies/alp", ::Tales.freeTile(_used), faction));
    return out;
}

// t.battle options: _steps, then _rounds rounds of AI (the bros end their turns), then the company kills the rest.
// Script errors go to _out.errors until _out.restore() is called.
local function alpBattle(t, _out, _steps, _rounds) {
    ::Tales.toughen();
    local id = t.roster()[0].getID();
    local logError = ::logError;
    ::logError = function (_m) { _out.errors.push(_m); };
    _out.restore <- @() ::logError = logError;
    local start = {};
    local steps = [function () { start.round <- ::Time.getRound(); }];
    steps.extend(_steps);
    return {spawn = "BanditRaiders", resources = 1, maxFrames = 20000,
        player = ::Tales.scripted(steps, @() ::Tactical.getEntityByID(id),
            function () {
                if (::Time.getRound() < start.round + _rounds) return false;
                _out.wildAlive <- ::Tales.hostiles().filter(@(_, e) e.getType() == ::Const.EntityType.Alp).len();
                return true;
            })};
}

test("AC-KB5: a tamed Alp against wild Alps, AI rounds", function (t) {
    local out = t.state.out <- {errors = []};
    t.state.id <- t.roster()[0].getID();
    yield t.battle(alpBattle(t, out, [function (t) {
        local used = {}, bro = ::Tactical.getEntityByID(t.state.id);
        local out = t.state.out;
        out.tame <- ::ACT.unleash(bro, ::Const.Companions.TypeList.Alp, ::Tales.freeTile(used));
        alps(used, 2);
    }], 6));
    out.restore();
    t.probe("after 6 rounds: tamed alp alive, wild alps alive", [out.tame.isAlive(), out.wildAlive]);
    t.eq(out.errors, [], "AC-KB5: script errors");
});

test("AC-KB5: a tamed Alp kills a wild Alp with Nightmare, then dies to the other", function (t) {
    local out = t.state.out <- {errors = []};
    t.state.id <- t.roster()[0].getID();
    yield t.battle(alpBattle(t, out, [function (t) {
        local used = {}, bro = ::Tactical.getEntityByID(t.state.id);
        local out = t.state.out;
        out.tame <- ::ACT.unleash(bro, ::Const.Companions.TypeList.Alp, ::Tales.freeTile(used));
        out.wild <- alps(used, 2);
        out.wild[0].kill(out.tame, out.tame.getSkills().getSkillByID("actives.nightmare"));
        out.tame.kill(out.wild[1], out.wild[1].getSkills().getSkillByID("actives.nightmare"));
        out.collar <- bro.getItems().getItemAtSlot(::Const.ItemSlot.Accessory);
        out.collar = out.collar == null ? null : out.collar.getName();
    }], 3));
    out.restore();
    t.probe("bro's accessory after the tamed alp died", out.collar);
    t.eq(out.errors, [], "AC-KB5: script errors");
});
