// mode: menu
// mods: mod_fixes@dev mod_hooks mod_msu stdlib@dev

local pd = @() ::HackFixes.msu.PersistentData;
local module = @() ::RootState.get("MainMenuState").m.MainMenuScreen.getNewCampaignMenuModule();
local shown = "(function () { var m = Screens.MainMenuScreen.mNewCampaignModule; return [m.mDifficulty, "
    + "m.mEconomicDifficulty, m.mBudgetDifficulty, m.mDifficultyHardCheckbox.is(':checked'), "
    + "m.mIronmanCheckbox.is(':checked'), m.mExplorationCheckbox.is(':checked'), m.mEvil, "
    + "m.mEvilUndeadCheckbox.is(':checked'), m.mEvilPermanentDestructionCheckbox.is(':checked')]; })()";

test("the New Campaign screen comes up as the last campaign started", function (t) {
    // as a previous run left it
    pd().createFile("new_campaign", {combatDifficulty = 2, economicDifficulty = 1, budgetDifficulty = 2,
        ironman = true, explorationDifficulty = false, lateGameCrisis = 3, permanentDestruction = true});
    ::RootState.get("MainMenuState").m.MainMenuScreen.getMainMenuModule().onNewCampaignButtonPressed();
    yield t.until(@() module().isVisible(), 600, "the New Campaign screen");
    t.eq(t.js(shown), [2, 1, 2, true, true, false, 3, true, true]);
}, {needs = ["ui"]});

test("starting a campaign keeps its settings", function (t) {
    local m = module(), listener = m.m.OnStartButtonPressedListener;
    m.m.OnStartButtonPressedListener = null;  // no campaign: only what the screen hands over
    m.onStartButtonPressed({companyName = "X", banner = "banner_04", combatDifficulty = 1, economicDifficulty = 2,
        budgetDifficulty = 0, ironman = false, explorationDifficulty = true, lateGameCrisis = 0,
        permanentDestruction = false, seed = "ABC", origin = "scenario.early_access"});
    m.m.OnStartButtonPressedListener = listener;
    t.eq(pd().readFile("new_campaign"), {combatDifficulty = 1, economicDifficulty = 2, budgetDifficulty = 0,
        ironman = false, explorationDifficulty = true, lateGameCrisis = 0, permanentDestruction = false});
});
