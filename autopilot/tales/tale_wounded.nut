// mode: campaign seed=bbtest-battle fresh=1 launch=wounded
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Badly wounded bros are careful: they don't approach enemies while others can hold the front.

local function chose(_who, _what) {
    return ::APT.autoBehaviors(_who).filter(@(_, b) b.what == _what).len() > 0;
}
// Down to _hp of his HP with no helmet and body armor: his staying power is his HP alone.
local function wound(_bro, _hp = 0.2) {
    local items = _bro.getItems();
    foreach (slot in [::Const.ItemSlot.Head, ::Const.ItemSlot.Body]) {
        local item = items.getItemAtSlot(slot);
        if (item != null) items.unequip(item);
    }
    _bro.setHitpoints((_bro.getHitpointsMax() * _hp).tointeger());
}
// An `each` of ::APT.pilot: t.state.first[name] is whether he was careful at his first AI evaluation,
// t.state.careful[name] whether ever.
local function watchCareful(_st, t) {
    if (!("first" in t.state)) { t.state.first <- {}; t.state.careful <- {}; }
    foreach (bro in ::APT.company()) {
        if (!::Autopilot.isUnderAIControl(bro) || !("careful" in bro.m._autopilot)) continue;
        local name = bro.getName(), careful = bro.m._autopilot.careful;
        if (!(name in t.state.first)) t.state.first[name] <- careful;
        if (careful) t.state.careful[name] <- true;
    }
}
local function wasCareful(t, _name) {
    return "careful" in t.state && _name in t.state.careful;
}
local function carefulBelow(_value) {
    local old = ::Autopilot.CarefulBelow;
    ::Autopilot.CarefulBelow = _value;
    return old;
}

local function woundedMelee(t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    wound(::Tales.byName("Bertel"));
    local p = ::APT.pilot({each = watchCareful});
    return t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
}

test("a wounded melee bro stays back while healthy allies fight", function (t) {
    yield woundedMelee(t);
    t.eq([t.state.first.Bertel, chose("Bertel", "ai_engage_melee"), chose("Wendel", "ai_engage_melee")],
         [true, false, true], "Bertel careful and not engaging, Wendel engaging");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("careful off: the same wounded bro engages", function (t) {
    local old = carefulBelow(0);
    yield woundedMelee(t);
    carefulBelow(old);
    t.eq([wasCareful(t, "Bertel"), chose("Bertel", "ai_engage_melee")], [false, true], "Bertel engages");
});

test("the last bro standing still fights", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::Tales.byName("Torkel").setPlaceInFormation(18);
    ::Tales.byName("Wendel").setPlaceInFormation(19);
    wound(::Tales.byName("Bertel"));
    local p = ::APT.pilot({each = watchCareful});
    yield t.battle({entities = ::Tales.thugs(1), player = p.fn, maxFrames = 30000});
    t.eq([wasCareful(t, "Bertel"), chose("Bertel", "ai_engage_melee")], [false, true], "not careful, engages");
    t.eq(t.result.survivors.enemies, 0, "Bertel wins");
});

test("all bros wounded: none is careful, they fight", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local names = [];
    foreach (bro in ::World.getPlayerRoster().getAll()) { wound(bro); names.push(bro.getName()); }
    local p = ::APT.pilot({each = watchCareful});
    yield t.battle({entities = ::Tales.thugs(1), player = p.fn, maxFrames = 30000});
    t.eq(names.map(@(n) wasCareful(t, n)), [false, false, false], "none careful");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("a wounded bro in full armor counts as fine", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local bertel = ::Tales.byName("Bertel");
    ::Tales.equip(bertel, "scripts/items/armor/coat_of_plates");
    ::Tales.equip(bertel, "scripts/items/helmets/full_helm");
    bertel.setHitpoints((bertel.getHitpointsMax() * 0.2).tointeger());
    local p = ::APT.pilot({each = watchCareful});
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq([t.state.first.Bertel, chose("Bertel", "ai_engage_melee")], [false, true], "not careful, engages");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});
