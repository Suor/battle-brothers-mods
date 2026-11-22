// mode: menu
// mods: mod_modern_hooks mod_rus_menu_fix@dev
// needs: ui
// langs: ru

// Without the fix the game's addCrossMarketing call throws in the page, which fails the launch.
test("the main menu shows under the Russian translation", function (t) {
    t.eq(t.js("$('.russian-version').text().indexOf('Русификатор')"), 0, "the translation is mounted");
    t.ok(::RootState.get("MainMenuState").m.MainMenuScreen.isVisible(), "the menu is visible");
});
