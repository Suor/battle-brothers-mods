// Shared by tale_legends_bugs_challenges.nut and tale_legends_control_challenges.nut (loaded by `// include:`).
::CHL_levelUpData <- function () {
    local bro = ::World.getPlayerRoster().getAll()[0];
    bro.addXP(3000, false);
    bro.updateLevel();
    local d = ::UIDataHelper.convertEntityToUIData(bro, null);
    local c = d.character;
    return {levelUps = bro.getLevelUps(), perkPoints = c.perkPoints, hasLevelUpValues = c.levelUp != null};
}
