// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_camps_and_artifacts@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md #4, #7, #16, #17 on the real Legends 19.4.23 (Legends brings
// its own mod_hooks, so no hackflow shim).

test("Legends and C&A are loaded", function (t) {
    t.ok(::mods_getRegisteredMod("mod_legends") != null, "mod_legends");
    t.ok(::mods_getRegisteredMod("mod_camps_and_artifacts") != null, "mod_camps_and_artifacts");
    local body = t.roster()[0].getItems().getItemAtSlot(::Const.ItemSlot.Body);
    t.probe("a starting bro's body armor", body == null ? null : body.ClassName);
});

// #7: a plain Handgonne showed as "Famed" with C&A (Legends + SSU).
test("CA-KB7 legends: a plain Handgonne isn't Famed", function (t) {
    local g = ::new("scripts/items/weapons/oriental/handgonne");
    t.eq(g.isItemType(::Const.Items.ItemType.Named), false, "Named flag");
    t.eq(g.isItemType(::Const.Items.ItemType.Artifact), false, "Artifact flag");
    local text = "";
    foreach (row in g.getTooltip()) if ("text" in row && row.text != null) text += row.text + "\n";
    t.probe("name", g.getName());
    t.eq(text.find("Famed"), null, "CA-KB7: tooltip has no 'Famed'");
});

// #16: artifact armor isn't Legends' layered armor; vanilla attachments from camp loot don't fit layered armor.
test("CA-KB16 legends: artifact body armors are Legends layered armor", function (t) {
    local notLayered = [];
    foreach (s in ::CAT.artifactScripts("armor/")) {
        local a = ::new(s);
        if (!::isKindOf(a, "legend_armor")) notLayered.push(a.ClassName);
    }
    t.probe("artifact armors", ::CAT.artifactScripts("armor/").len());
    t.eq(notLayered, [], "CA-KB16: artifact armors without Legends layers");
});

test("CA-KB16 legends: armor attachments C&A camps drop fit a bro's layered armor", function (t) {
    local drops = ["metal_plating_upgrade", "metal_pauldrons_upgrade", "mail_patch_upgrade", "leather_shoulderguards_upgrade",
                   "leather_neckguard_upgrade", "joint_cover_upgrade", "heraldic_plates_upgrade", "double_mail_upgrade"];
    local bro = t.roster()[0];
    local body = bro.getItems().getItemAtSlot(::Const.ItemSlot.Body);
    t.ok(body != null && ::isKindOf(body, "legend_armor"), "the bro wears layered armor");
    local rejected = [];
    foreach (d in drops) {
        local u = ::new("scripts/items/armor_upgrades/" + d);
        local ok = false;
        try { ok = u.onUse(bro) == true; } catch (e) { ok = false; t.log(d + ": " + e); }
        if (!ok) rejected.push(d);
    }
    t.eq(rejected, [], "CA-KB16: attachments a layered armor doesn't take");
});

// #17 (the Legends part, SSU doesn't boot on Legends 19.4): every faction's C&A camp action updates.
test("CA-KB17 legends: every faction updates without errors, also after a load", function (t) {
    local errs = t.state.errs <- [];
    local run = function (t) {
        foreach (f in ::World.FactionManager.getFactions()) {
            if (f == null) continue;
            foreach (a in f.m.Deck) {
                if (a.getID().find("camp_action") == null) continue;
                try { a.update(false); } catch (e) { t.state.errs.push([f.ClassName, a.getID(), e]); }
            }
        }
    };
    run(t);
    t.save("ca_kb17_lg");
    yield t.load("ca_kb17_lg");
    run(t);
    t.eq(errs, [], "CA-KB17: camp action errors");
    yield t.days(3, {quiet = true});
});

// #4: a barbarian using Barbarian Fury crashed the game (Legends + C&A). AI plays both sides against barbarians.
test("CA-KB4 legends: battles against barbarians with Barbarian Fury end without errors", function (t) {
    foreach (i in [0, 1, 2]) {
        ::Tales.toughen();
        yield t.battle({spawn = "Barbarians", faction = "Barbarians", resources = 200, terrain = "tactical.snow"});
        t.probe("battle " + i, t.result);
    }
    t.ok(true, "no errors");
});
