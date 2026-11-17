// mode: campaign seed=bbtest-battle fresh=1 launch=behaviors
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Autopilot's own behaviors (README "Changes from the Original Mod") in AI battles.

local function aiBattle(_t, _p, _n = 3) {
    return _t.battle({entities = ::Tales.thugs(_n), player = _p.fn, maxFrames = 30000});
}
local function did(_who, _what) {
    return ::APT.autoUses(_who).filter(@(_, u) u.what == _what).len() > 0;
}
local function chose(_who, _what) {
    return ::APT.autoBehaviors(_who).filter(@(_, b) b.what == _what).len() > 0;
}
// `before` steps of ::APT.pilot: the thug put 2 tiles off the bro whose turn it is, then waiting until he's there.
local function thugTwoOff() {
    return [function (_e, t) {
        local thug = ::Tales.hostiles()[0], home = _e.getTile();
        foreach (a in ::std.Tile.iterAdjacent(home))
            foreach (tile in ::std.Tile.iterAdjacent(a))
                if (tile.IsEmpty && tile.getDistanceTo(home) == 2) {
                    ::Tactical.getNavigator().teleport(thug, tile, null, null, false);
                    return;
                }
    }, @(_e, t) ::Tales.hostiles()[0].getTile().getDistanceTo(_e.getTile()) == 2];
}
// The Oath of Fortification: the bro can't move in round 1.
local function rooted(_bro) {
    _bro.getSkills().add(::new("scripts/skills/traits/oath_of_fortification_trait"));
    _bro.getSkills().add(::new("scripts/skills/special/oath_of_fortification_warning"));
}

test("sling in the bag: a melee bro who can't reach draws it and shoots", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::Tales.byName("Bertel").setPlaceInFormation(18);
    ::Tales.byName("Torkel").setPlaceInFormation(19);
    local wendel = ::Tales.byName("Wendel");
    rooted(wendel);
    wendel.getItems().unequip(wendel.getItems().getItemAtSlot(::Const.ItemSlot.Offhand));
    ::APT.clearBag(wendel);
    ::APT.bag(wendel, "scripts/items/weapons/staff_sling");
    local p = ::APT.pilot({before = thugTwoOff()});
    yield aiBattle(t, p, 1);
    t.probe("Wendel's behaviors", ::Tales.uniq(::APT.autoBehaviors("Wendel").map(@(b) b.what), true));
    t.eq([chose("Wendel", "ai_switchto_ranged"), did("Wendel", "actives.sling_stone")], [true, true], "drawn and shot");
    t.eq(p.st.stuck, [], "no stuck turn");
});

// Wendel alone (the others in reserve), under the Oath of Fortification (can't move in round 1), against one thug
// put 2 tiles off on his first turn: out of his spear's reach, in the net's, so unbagging and throwing the net is the
// AI's only choice but idling, whatever the rolls.
test("throw nets: a net in the bag is taken out and thrown", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::Tales.byName("Bertel").setPlaceInFormation(18);
    ::Tales.byName("Torkel").setPlaceInFormation(19);
    local wendel = ::Tales.byName("Wendel");
    rooted(wendel);
    wendel.getItems().unequip(wendel.getItems().getItemAtSlot(::Const.ItemSlot.Offhand));
    ::APT.clearBag(wendel);
    ::APT.bag(wendel, "scripts/items/tools/throwing_net");
    local p = ::APT.pilot({before = thugTwoOff()});
    yield aiBattle(t, p, 1);
    t.eq(::APT.autoBehaviors("Wendel").filter(@(_, b) b.round == 1).map(@(b) b.what),
         ["autopilot_unbag_net", "ai_attack_throw_net", "ai_idle"], "Wendel's first turn");
    t.eq([chose("Wendel", "autopilot_unbag_net"), did("Wendel", "actives.throw_net")], [true, true],
         "unbagged and thrown");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("'Throw Nets' off: the net stays in the bag", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.setting("nets", false);
    local wendel = ::Tales.byName("Wendel");
    wendel.getItems().unequip(wendel.getItems().getItemAtSlot(::Const.ItemSlot.Offhand));
    ::APT.clearBag(wendel);
    ::APT.bag(wendel, "scripts/items/tools/throwing_net");
    local p = ::APT.pilot();
    yield aiBattle(t, p);
    ::APT.resetSettings();
    t.eq([chose("Wendel", "autopilot_unbag_net"), did("Wendel", "actives.throw_net")], [false, false],
         "neither unbagged nor thrown");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("unbag shield: a one-handed bro straps on the shield from his bag", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local bertel = t.state.bertel <- ::Tales.byName("Bertel");
    ::Tales.equip(bertel, "scripts/items/weapons/hand_axe");
    ::APT.clearBag(bertel);
    ::APT.bag(bertel, "scripts/items/shields/wooden_shield");
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({each = function (_st, t) {
        local off = t.state.bertel.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        if (!("shield" in t.state.seen) && off != null) t.state.seen.shield <- off.getID();
        if (!("when" in t.state.seen) && off != null) t.state.seen.when <- {skillsBefore = ::APT.autoUses("Bertel").len(), round = ::Time.getRound()};
    }});
    yield aiBattle(t, p);
    // Whether he swings or straps the shield on first depends on the AI's scores and the map
    t.probe("shield on", seen.when);
    t.eq([seen.shield, seen.when.round <= 2], ["shield.wooden_shield", true], "shield on by his second turn");
    t.ok(chose("Bertel", "autopilot_unbag_shield"), "by the unbag shield behavior");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

local function dogBattle(_t, _mode, _seen) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.setting("dogsMode", _mode);
    ::Tales.equip(::Tales.byName("Bertel"), "scripts/items/accessory/wardog_item");
    local p = ::APT.pilot({each = function (_st) {
        // The dog's own turns go through the turn bar's UI data (KNOWN_BUGS #28)
        foreach (u in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.PlayerAnimals))
            if (u.isAlive()) _seen.dogUI <- ::Tactical.TurnSequenceBar.convertEntitySkillsToUIData(u) != null;
    }});
    _seen.p <- p;
    return aiBattle(_t, p, 4);
}

test("dogs 'at will': the wardog is unleashed", function (t) {
    local seen = {};
    yield dogBattle(t, "atwill", seen);
    ::APT.resetSettings();
    t.eq(did("Bertel", "actives.unleash_wardog"), true, "unleashed");
    t.eq(seen.p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("dogs 'never': the wardog stays", function (t) {
    local seen = {};
    yield dogBattle(t, "never", seen);
    ::APT.resetSettings();
    t.eq(did("Bertel", "actives.unleash_wardog"), false, "not unleashed");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("dogs 'defensive' (default): probe", function (t) {
    local seen = {};
    yield dogBattle(t, "defensive", seen);
    ::APT.resetSettings();
    t.probe("unleashed", did("Bertel", "actives.unleash_wardog"));
    t.eq(seen.p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// Torkel alone with javelins, rooted as Wendel above, against one thug put 2 tiles off on his first turn: in the
// javelins' range (2-4), out of reach of a melee attack, so throwing is his only attack. Once he has thrown, the
// thug is killed.
test("throwing bro: melee agent in throwing mode, throws javelins", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::Tales.byName("Bertel").setPlaceInFormation(18);
    ::Tales.byName("Wendel").setPlaceInFormation(19);
    local torkel = t.state.torkel <- ::Tales.byName("Torkel");
    rooted(torkel);
    ::Tales.equip(torkel, "scripts/items/weapons/javelin");
    ::APT.clearBag(torkel);
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({before = thugTwoOff(), each = function (_st, t) {
        if (!("mode" in t.state.seen)) t.state.seen.mode <- clone t.state.torkel.m._autopilot;
        if (!("killed" in t.state.seen) && did("Torkel", "actives.throw_javelin")) {
            t.state.seen.killed <- true;
            ::Tales.killAll();
        }
    }});
    yield aiBattle(t, p, 1);
    t.eq(seen.mode, {agent = "military_melee", ranged = true, throwing = true}, "mode");
    t.eq(did("Torkel", "actives.throw_javelin"), true, "throws");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("2-tile bro (pike) attacks", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::Tales.equip(::Tales.byName("Wendel"), "scripts/items/weapons/pike");
    local p = ::APT.pilot();
    yield aiBattle(t, p, 4);
    t.probe("Wendel's behaviors", ::Tales.uniq(::APT.autoBehaviors("Wendel").map(@(b) b.what), true));
    t.eq(did("Wendel", "actives.impale") || did("Wendel", "actives.repel"), true, "attacks with the pike");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// HEAD only (unreleased): autopilot_cleanse_ally. The ally in need is an ignored bro (Ignore
// button state), so he doesn't free himself and stays in need until someone helps.
local function needyAlly(_e, _seen, _fn) {
    local a = null;
    foreach (x in ::std.Tile.iterAdjacentActors(_e.getTile())) if (x.isAlliedWith(_e)) { a = x; break; }
    _seen.needy <- a == null ? null : a.getName();
    if (a == null) return;
    a.m._isIgnored <- true;
    _fn(a);
}

test("cleanse ally: a netted ally is cut free by a bro on AI", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    // Hurt too: toughened bros take few hits, and the cleanse weight grows with the ally's lost HP.
    local p = ::APT.pilot({before = @(_e, t) needyAlly(_e, t.state.seen, function (a) {
        ::APT.net(a);
        a.setHitpoints(a.getHitpointsMax() * 0.5);
    })});
    yield aiBattle(t, p);
    t.probe("needy", seen.needy);
    t.eq(::Tales.uniq(::APT.autoUses().filter(@(_, u) u.what == "actives.break_ally_free").map(@(u) u.what), true),
         ["actives.break_ally_free"], "cut free by a bro on AI");
    t.eq(chose(null, "autopilot_cleanse_ally"), true, "through autopilot_cleanse_ally");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// Whether the bandage is then used depends on the weighted pick and on staying adjacent, so the
// behavior's own evaluation is checked on the medic's first AI turn, the use over the battle.
test("cleanse ally: a bleeding ally is bandaged by a bro on AI", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({
        before = function (_e, t) {
            if (_e.getName() == "Torkel") return "pass";  // a melee bro, the archer'd rather shoot
            needyAlly(_e, t.state.seen, function (a) {
                t.state.seen.ally <- a;
                a.setHitpoints(a.getHitpointsMax() * 0.3);
                for (local i = 0; i < 3; i++) a.getSkills().add(::new("scripts/skills/effects/bleeding_effect"));
            });
            t.state.seen.medic <- _e;
            ::Tales.equip(_e, "scripts/items/accessory/bandage_item");
        },
        each = function (_st, t) {
            if (!("eval" in t.state.seen)) {
                local b = t.state.seen.medic.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AP_CleanseAlly);
                local score = b.onEvaluate(t.state.seen.medic);
                t.state.seen.eval <- [score > 0, b.m.Skill == null ? null : b.m.Skill.getID(),
                              b.m.TargetTile != null && b.m.TargetTile.ID == t.state.seen.ally.getTile().ID];
            }
        }});
    yield aiBattle(t, p);
    t.probe("medic, needy", [seen.medic.getName(), seen.needy]);
    t.eq(seen.eval, [true, "actives.bandage_ally", true], "cleanse wants to bandage the needy ally");
    t.probe("bandaged by", ::Tales.uniq(::APT.autoUses().filter(@(_, u) u.what == "actives.bandage_ally").map(@(u) u.who), true));
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// The bro whose turn comes first is the prophet, the other two are tired, cultists or not.
// His own evaluation is checked on his first AI turn.
local function prophetBattle(_t, _cultists) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = _t.state.seen <- {};
    local p = ::APT.pilot({
        before = function (_e, t) {
            t.state.seen.prophet <- _e;
            _e.getSkills().add(::new("scripts/skills/actives/voice_of_davkul_skill"));
            foreach (bro in t.roster()) {
                if (bro.getID() == _e.getID()) continue;
                if (_cultists) {
                    bro.getSkills().removeByID(bro.getBackground().getID());
                    bro.getSkills().add(::new("scripts/skills/backgrounds/cultist_background"));
                }
                bro.setFatigue(40);
            }
        },
        each = function (_st, t) {
            if ("eval" in t.state.seen) return;
            local prophet = t.state.seen.prophet;
            local b = prophet.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AP_VoiceOfDavkul);
            t.state.seen.eval <- b.onEvaluate(prophet) > 0;
        }});
    return aiBattle(_t, p);
}

test("voice of davkul: the prophet speaks to tired cultists", function (t) {
    yield prophetBattle(t, true);
    local seen = t.state.seen, prophet = seen.prophet.getName();
    t.probe("prophet", prophet);
    t.eq(seen.eval, true, "voice wants to speak");
    t.eq(did(prophet, "actives.voice_of_davkul"), true, "spoke");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("voice of davkul: silent with no cultists around", function (t) {
    yield prophetBattle(t, false);
    local seen = t.state.seen, prophet = seen.prophet.getName();
    t.eq(seen.eval, false, "voice doesn't want to speak");
    t.eq(did(prophet, "actives.voice_of_davkul"), false, "silent");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// A minstrel keeps his lute for Background Bonuses' party buff, he stays back instead of charging in.
test("lute: the minstrel stays back, a club bro engages", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::Tales.equip(::Tales.byName("Bertel"), "scripts/items/weapons/lute");
    ::Tales.equip(::Tales.byName("Wendel"), "scripts/items/weapons/wooden_stick");
    local p = ::APT.pilot();
    yield aiBattle(t, p);
    t.probe("Bertel's uses", ::Tales.uniq(::APT.autoUses("Bertel").map(@(u) u.what), true));
    t.eq([chose("Bertel", "ai_engage_melee"), chose("Wendel", "ai_engage_melee")], [false, true],
         "minstrel doesn't engage, club bro does");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});
