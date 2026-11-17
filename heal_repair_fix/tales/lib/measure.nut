// Healing and repair rates per hourly tick of the asset manager.

::HRF <- {};

// A wounded bro and a worn armor before the world runs; ::HRF.rates() after ::HRF.hours() gives
// {hp, armor} gained per hour. _follower: "follower.cook", "follower.blacksmith" or null.
::HRF.start <- function (t, _camp, _follower) {
    if (_follower != null) ::World.Retinue.setFollower(0, ::World.Retinue.getFollower(_follower));
    ::World.Assets.setCamping(_camp);
    ::World.Assets.m.ArmorParts = 500;
    local bro = t.roster()[0];
    bro.getBaseProperties().Hitpoints += 300;
    bro.getSkills().update();
    bro.setHitpoints(5);
    local armor = bro.getItems().getItemAtSlot(::Const.ItemSlot.Body);
    armor.m.ConditionMax = 1000.0;
    armor.setCondition(10.0);
    return {bro = bro, armor = armor, hp0 = bro.getHitpoints(), c0 = armor.m.Condition};
};

// Runs the world until exactly _n hourly ticks (asset_manager.update's LastHourUpdated changes) have
// healed and repaired, then pauses it: the clock may cross an hour a frame before its tick runs.
::HRF.hours <- function (t, _n, _speed = 4.0) {
    if (t.env == "code") t.skip("world hours: no world simulation");
    t.state.ticks <- 0;
    t.state.last <- ::World.Assets.m.LastHourUpdated;
    t.state.wasAttackable <- ::World.State.getPlayer().isAttackable();
    ::World.State.getPlayer().setAttackable(false);
    return t.until(function (t) {
        local ws = ::World.State;
        if (::World.Assets.m.LastHourUpdated != t.state.last) {
            t.state.last = ::World.Assets.m.LastHourUpdated;
            t.state.ticks++;
        }
        if (t.state.ticks >= _n) {
            ws.setPause(true);
            ws.getPlayer().setAttackable(t.state.wasAttackable);
            return true;
        }
        if (ws.isPaused() && !ws.getEventScreen().isVisible() && !::Tales.inBattle()) {
            ws.setAutoPause(false);
            ws.setPause(false);
        }
        if (!ws.isPaused()) {
            ws.m.LastWorldSpeedMult = _speed;
            ::World.setSpeedMult(_speed);
        }
        return false;
    }, (_n * ::World.getTime().SecondsPerHour * 120 / _speed).tointeger() + 600, _n + " hour ticks");
};

::HRF.rates <- function (t, s) {
    ::World.Assets.setCamping(false);
    local n = t.state.ticks;
    return {hp = (s.bro.getHitpoints() - s.hp0) * 1.0 / n, armor = (s.armor.m.Condition - s.c0) / n};
};
