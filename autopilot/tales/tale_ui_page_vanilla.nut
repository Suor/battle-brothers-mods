// mode: campaign seed=bbtest-battle fresh=1 launch=uiv
// mods: mod_ap_probe mod_msu stdlib@dev
// needs: ui
// include: lib/helpers.nut lib/ui_page_body.nut

// KNOWN_BUGS #4 without Autopilot, to tell its share from vanilla's (the test is in lib/ui_page_body.nut).

test("KB4: after a tile hover the status bar shows the active bro's own effects", ::UIPage.kb4);
