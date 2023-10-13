var BroStudio = {};
BroStudio.CharacterScreen_show = CharacterScreen.prototype.show;
CharacterScreen.prototype.show = function (_data) {
    Constants.Game['MAX_STATS_INCREASE_COUNT'] = MSU.getSettingValue("mod_bro_studio", "attrsUps");
    BroStudio.CharacterScreen_show.call(this, _data);
}
