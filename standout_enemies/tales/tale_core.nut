// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_standout_enemies@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// Quirks on a real bandit party's troops, and the Cursed effect on a brother.

local Sprites = ["head", "face", "body", "hair", "beard", "beard_top"];

test("bandits of a party get quirks once the days scale allows", function (t) {
    ::Tales.toughen();
    local cfg = ::StandoutEnemies.Config, days = cfg.ScaleDays;
    cfg.ScaleDays = 1;  // scale = Days / ScaleDays: past every strategy's MinScale
    local p = ::SET.partyEntities(200);
    local names = t.state.names <- [];
    yield t.battle({entities = p.entities, player = ::Tales.scripted([function (t) {
        foreach (e in ::Tales.hostiles()) t.state.names.push(e.getName());
        ::Tales.killAll();
    }])});
    cfg.ScaleDays = days;
    if (p.party.isAlive()) p.party.die();
    local quirked = names.filter(@(_, n) ["Agile ", "Huge "].filter(@(_, q) n.find(q) == 0).len() > 0);
    t.probe("names", names);
    t.eq(quirked.len() > 0, true, "some bandit is Agile or Huge");
    t.eq(t.result.survivors.enemies, 0, "won");
});

test("Cursed: stacks, debuffs and wears off after its turns", function (t) {
    ::Tales.toughen();
    local bro = t.state.bro <- t.roster()[0], seen = t.state.seen <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 30, player = ::Tales.scripted([
        function (t) {
            local bro = t.state.bro;
            local seen = t.state.seen;
            seen.skill <- [bro.getCurrentProperties().MeleeSkillMult];
            bro.getSkills().add(::new("scripts/skills/cursed_effect"));
            bro.getSkills().add(::new("scripts/skills/cursed_effect"));
        },
        function (t) {
            local bro = t.state.bro;
            local seen = t.state.seen;
            bro.getSkills().update();
            local fx = bro.getSkills().getSkillByID("standout_enemies.effects.cursed");
            seen.count <- fx.m.Count;
            seen.bonus <- fx.getBonus();
            seen.skill.push(bro.getCurrentProperties().MeleeSkillMult);
        },
        function () { ::Tales.killAll(); }
    ])});
    t.eq(seen.count, 2, "two curses stack");
    t.eq(seen.bonus, 19, "-19% at two stacks");
    t.near(seen.skill[1] / seen.skill[0], 0.81, 0.001, "melee skill mult x0.81");
    t.eq(bro.getSkills().getSkillByID("standout_enemies.effects.cursed"), null, "removed after the battle");
});

// KNOWN_BUGS #1: setBrightness scales the sprite's current color (the native keeps nothing
// else), so 0.1 then 1.0 leaves hair and beard at a tenth; head and body are reset to plain
// white, dropping the tint the background rolled for them.
test("SE-KB1: a brother's look comes back after the curse", function (t) {
    if (t.env == "code") t.skip("sprite colors and setBrightness aren't modelled");
    ::Tales.toughen();
    local bro = t.state.bro <- t.roster().filter(@(_, b) b.getSprite("hair").HasBrush)[0];
    local before = ::SET.look(bro, Sprites), seen = t.state.seen <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 30, player = ::Tales.scripted([
        function (t) {
            local bro = t.state.bro;
            bro.getSkills().add(::new("scripts/skills/cursed_effect"));
            t.state.seen.during <- ::SET.look(bro, Sprites);
        },
        function () { ::Tales.killAll(); }
    ])});
    t.eq(seen.during.hair, before.hair.map(@(c) c > 1 ? (c * 0.1).tointeger() : c), "hair darkened while cursed");
    t.eq(bro.getSkills().getSkillByID("standout_enemies.effects.cursed"), null, "curse gone");
    t.eq(::SET.look(bro, Sprites), before, "sprites as before the curse");
});

// KNOWN_BUGS #2: checkResist() refers to an undeclared `actor`, so a resisted curse throws.
test("SE-KB2: a status-resistant target resists the curse without an error", function (t) {
    ::Tales.toughen();
    local bro = t.state.bro <- t.roster()[0], errors = t.state.errors <- [];
    yield t.battle({spawn = "BanditRaiders", resources = 30, player = ::Tales.scripted([
        function (t) {
            local bro = t.state.bro;
            bro.getBaseProperties().IsResistantToAnyStatuses = true;
            bro.getSkills().update();
            for (local i = 0; i < 20; i++) {
                try { bro.getSkills().add(::new("scripts/skills/cursed_effect")); }
                catch (e) { t.state.errors.push(e); }
            }
            bro.getBaseProperties().IsResistantToAnyStatuses = false;
            bro.getSkills().update();
        },
        function () { ::Tales.killAll(); }
    ])});
    t.eq(errors, [], "no errors applying the curse 20 times");
});
