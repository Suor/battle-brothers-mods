NewCampaignMenuModule.prototype.fixesRestoreSettings = function (_s)
{
    var radios = [
        [_s.combatDifficulty, [this.mDifficultyEasyCheckbox, this.mDifficultyNormalCheckbox, this.mDifficultyHardCheckbox]],
        [_s.economicDifficulty, [this.mEconomicDifficultyEasyCheckbox, this.mEconomicDifficultyNormalCheckbox, this.mEconomicDifficultyHardCheckbox]],
        [_s.budgetDifficulty, [this.mBudgetDifficultyEasyCheckbox, this.mBudgetDifficultyNormalCheckbox, this.mBudgetDifficultyHardCheckbox]],
        [_s.lateGameCrisis, [this.mEvilRandomCheckbox, this.mEvilWarCheckbox, this.mEvilGreenskinsCheckbox, this.mEvilUndeadCheckbox,
            this.mEvilCrusadeControl.hasClass('display-none') ? null : this.mEvilCrusadeCheckbox]]  // Holy War needs its DLC
    ];
    radios.forEach(function (r) {
        if (r[1][r[0]]) r[1][r[0]].iCheck('check');  // its ifChecked sets the module's value
    });
    if ('ironman' in _s) this.mIronmanCheckbox.iCheck(_s.ironman ? 'check' : 'uncheck');
    if ('permanentDestruction' in _s) this.mEvilPermanentDestructionCheckbox.iCheck(_s.permanentDestruction ? 'check' : 'uncheck');
    if ('explorationDifficulty' in _s) this.mExplorationCheckbox.iCheck(_s.explorationDifficulty ? 'check' : 'uncheck');
};
