// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hackflows_perks@dev mod_hooks mod_msu stdlib@dev

// Hackflow's Perks on vanilla (no Reforged): KNOWN_BUGS.md #1 and #3.

local function dress(_bro, _body, _head) {
    local items = _bro.getItems();
    foreach (slot in [::Const.ItemSlot.Body, ::Const.ItemSlot.Head]) {
        local it = items.getItemAtSlot(slot);
        if (it != null) items.unequip(it);
    }
    if (_body) items.equip(::new("scripts/items/armor/" + _body));
    if (_head) items.equip(::new("scripts/items/helmets/" + _head));
}

// KNOWN_BUGS #1: "Stabilized can't be picked, the perk point isn't spent". Unlocked the way the
// character screen does it (general_onUnlockPerk, then the UI data of the bro).
test("HP-KB1: Stabilized unlocks naked, in medium and in heavy armor", function (t) {
    local got = {};
    foreach (kit in [["naked", null, null], ["medium", "mail_shirt", "full_helm"], ["heavy", "coat_of_plates", "full_helm"]]) {
        local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
        bro.setStartValuesEx(["farmhand_background"]);
        dress(bro, kit[1], kit[2]);
        bro.m.PerkPoints = 1;
        local res = ::World.State.m.CharacterScreen.general_onUnlockPerk([bro.getID(), "perk.hackflows.stabilized"]);
        local perk = bro.getSkills().getSkillByID("perk.hackflows.stabilized");
        got[kit[0]] <- ["error" in res, perk != null, bro.m.PerkPoints, perk == null ? null : perk.getBonus(),
            perk == null ? null : perk.getTooltip().len() > 0];
        ::World.getPlayerRoster().remove(bro);
    }
    t.eq(got, {naked = [false, true, 0, 0.0, true], medium = [false, true, 0, 25.0, true],
               heavy = [false, true, 0, 0.0, true]}, "[UI error, has perk, perk points, bonus, tooltip]");
});

test("HP-KB1: Stabilized cuts damage in medium armor in battle", function (t) {
    local bro = t.roster()[0];
    dress(bro, "mail_shirt", "full_helm");
    bro.getBaseProperties().Hitpoints += 1000;
    bro.getSkills().update();
    bro.setHitpoints(bro.getHitpointsMax());
    bro.m.PerkPoints = 1;
    t.eq(bro.unlockPerk("perk.hackflows.stabilized"), true, "unlocked");
    local id = t.state.id <- bro.getID(), out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local b = ::Tactical.getEntityByID(t.state.id);
        local thug = ::Tales.hostiles()[0];
        local hit = b.getSkills().buildPropertiesForBeingHit(thug, ::Tales.attack(thug), clone ::Const.Tactical.HitInfo);
        local self = b.getSkills().buildPropertiesForBeingHit(b, ::Tales.attack(b), clone ::Const.Tactical.HitInfo);
        t.state.out.mults <- [self.DamageReceivedRegularMult, hit.DamageReceivedRegularMult, hit.DamageReceivedArmorMult];
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    t.eq(out.mults, [1.0, 0.75, 0.75], "[own attack, a thug's attack: regular, armor] multipliers");
});

// KNOWN_BUGS #3 (fixed in 1.6.3): under vanilla the mod crashed on Reforged's perk ids.
test("HP-KB3: every perk is registered under vanilla", function (t) {
    local ids = ["perk.hackflows.balance", "perk.hackflows.bloody_harvest", "perk.hackflows.full_force",
                 "perk.hackflows.battle_flow", "perk.hackflows.flesh_on_the_bones", "perk.hackflows.stabilized"];
    t.eq(ids.map(@(id) id in ::Const.Perks.LookupMap), ids.map(@(_) true), "in LookupMap");
    local rows = [];
    foreach (id in ids) {
        local row = null;
        foreach (i, r in ::Const.Perks.Perks) foreach (p in r) if (p.ID == id) row = i;
        rows.push(row);
    }
    t.eq(rows, [4, 4, 5, 6, 2, 5], "tree rows");
    t.eq(::Hooks.hasMod("mod_reforged"), false, "no Reforged");
});
