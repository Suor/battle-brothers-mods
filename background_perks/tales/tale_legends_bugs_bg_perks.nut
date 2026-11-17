// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_background_perks@dev stdlib@dev
// allow-errors: Mod mod_background_perks .* is wrapping function setStartValuesEx in bb class scripts/entity/tactical/player with fewer total parameters

// Starting Perks by Background on real Legends 19.4.23 (Legends is unsupported by the mod).
// The boot logs Modern Hooks' "wrapping function setStartValuesEx ... with fewer total parameters
// (used to be 4, wrapper returned function with 2)" error: the root of BP-KB4. A control without the
// mod is tale_legends_control_bg_perks.nut.

local function equipped(_bro) {
    local n = 0;
    foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand, ::Const.ItemSlot.Body, ::Const.ItemSlot.Head])
        if (_bro.getItems().getItemAtSlot(slot) != null) n++;
    return n;
}

// KNOWN_BUGS background_perks #4: Legends' supposed_witch_event calls
// setStartValuesEx(::Const.SupposedWitchBackgrounds, true, 1): the 2-param wrapper drops the gender.
test("BP-KB4: setStartValuesEx keeps Legends' gender and addEquipment args", function (t) {
    t.probe("GenderEquality", ::Legends.Mod.ModSettings.getSetting("GenderEquality").getValue());
    local got = [];
    for (local i = 0; i < 6; i++) {
        // The original raises for a roster id it doesn't have; the engine returns null.
        local roster = null;
        try { roster = ::World.getRoster(9997); } catch (e) {}
        if (roster == null) roster = ::World.createRoster(9997);
        local bro = roster.create("scripts/entity/tactical/player");
        bro.setStartValuesEx(["monk_background"], true, 1, false);
        got.push([bro.getGender(), equipped(bro)]);
    }
    t.eq(got, array(6, [1, 0]), "[gender, equipped items] of 6 bros made with gender 1, no equipment");
});

// The event itself: its bro made for the "Good" screen.
test("BP-KB4: the supposed witch event's bro is female", function (t) {
    local genders = [];
    for (local i = 0; i < 6; i++) {
        local roster = ::World.getTemporaryRoster();
        local bro = roster.create("scripts/entity/tactical/player");
        bro.setStartValuesEx(::Const.SupposedWitchBackgrounds, true, 1);
        genders.push(bro.getGender());
        roster.clear();
    }
    t.eq(genders, array(6, 1), "genders of 6 event bros");
});

// New (BP-L1): Legends' getPerk (via unlockPerk) throws `the index 'Const' does not exist` for a perk id Legends
// doesn't define, where vanilla's unlockPerk returns false; without Dynamic Perks the mod's canAddPerk only checks
// hasPerk. The perks of other mods (Hackflow's Perks, Proper Necro) aren't there unless those are installed, and
// `ALL` rolls hackflows.flesh_on_the_bones for every recruit (1%), so ~1 in 30 recruits throws mid-setStartValuesEx.
test("BP-L1: every perk the mod can roll exists under Legends", function (t) {
    local missing = [];
    local keys = {};
    foreach (bg, chances in ::BgPerks.chances) foreach (perk, _ in chances) keys[perk] <- true;
    foreach (perk, _ in keys) {
        local def = ::Const.Perks.findById("perk." + perk);
        if (def == null || !("Const" in def)) missing.push(perk);
    }
    missing.sort();
    t.probe("perks rolled", keys.len());
    t.eq(missing, [], "perks the mod rolls that Legends' getPerk can't resolve");
});

test("BP-L1: recruits of every background get perks without a script error", function (t) {
    local failed = [], perked = 0, n = 0;
    foreach (bg in ::Const.CharacterBackgrounds) {
        for (local j = 0; j < 2; j++) {
            n++;
            try {
                local bro = ::Tales.recruit(bg);
                if (bro.getSkills().query(::Const.SkillType.Perk).len() > 0) perked++;
            } catch (e) {
                failed.push([bg, e]);
            }
        }
    }
    t.probe("recruits with perks", perked + " of " + n);
    t.eq(failed, [], "[background, error] of recruits that threw");
});
