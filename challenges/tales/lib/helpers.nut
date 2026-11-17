// Shared helpers for the Challenges scenarios, loaded by `// include: lib/helpers.nut`.
::CHT <- {};

::CHT.setting <- @(_name) ::Challenges.Mod.ModSettings.getSetting(_name);

// Sets the given settings (slider values set directly); returns a function restoring them.
::CHT.set <- @(_values) ::Tales.set(::CHT.setting, _values, true);
::CHT.with <- @(_values, _fn) ::Tales.with(::CHT.setting, _values, _fn, true);

// The `player` of a t.battle(): on the first player turn the active bro kills every enemy
// (a real victory, EnemyDestroyed, so loot is gathered as after a won fight), then ends turns.
// The loot found is summarized into ::CHT.Loot every frame once the battle is over (the runner
// stops calling the player function then, so a real-time ticker does it).
::CHT.Loot <- null;
::CHT.killAllPlayer <- function () {
    local st = {done = false, wrapped = false};
    ::CHT.Loot = null;
    return function () {
        if (!::Tales.inBattle()) return;
        local ts = ::Tactical.State;
        if (!st.wrapped) {
            local tick;
            tick = function (_tag) {
                if (!::Tales.inBattle()) return;
                if (::Tactical.State.isBattleEnded()) ::CHT.Loot = ::CHT.lootSummary();
                ::Time.scheduleEvent(::TimeUnit.Real, 10, tick, null);
            };
            ::Time.scheduleEvent(::TimeUnit.Real, 10, tick, null);
            st.wrapped = true;
        }
        if (ts.isBattleEnded() || ::LoadingScreen.isVisible()) return;
        local bar = ::Tactical.TurnSequenceBar;
        local e = bar.getActiveEntity();
        if (e == null || !e.isPlayerControlled() || !e.isTurnStarted()) return;
        if (!st.done) {
            ::Tales.killAll(e);
            st.done = true;
            return;
        }
        if (ts.isInputLocked() || ::Time.hasEventScheduled(::TimeUnit.Virtual) || bar.m.IsLocked) return;
        bar.onNextTurnButtonPressed();
    };
}

::CHT.isEquipment <- function (_item) {
    foreach (k in ["weapon", "shield", "armor", "helmet"]) if (::std.Util.isKindOf(_item, k)) return true;
    return false;
}

::CHT.lootSummary <- function () {
    local equipment = [], named = [], money = 0;
    foreach (item in ::Tactical.CombatResultLoot.getItems()) {
        if (item == null) continue;
        if (item.getID() == "supplies.money") money += item.getAmount();
        else if (::CHT.isEquipment(item) && !item.isItemType(::Const.Items.ItemType.Tool)) {
            if (item.isItemType(::Const.Items.ItemType.Named) || item.isItemType(::Const.Items.ItemType.Legendary)) named.push(item.getID());
            else equipment.push(item.getID());
        }
    }
    return {equipment = equipment, named = named, money = money};
}
