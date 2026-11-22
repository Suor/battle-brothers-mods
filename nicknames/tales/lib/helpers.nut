// Shared helpers for the nicknames scenarios, loaded by `// include: helpers.nut`.

::NickT <- {};

// ::Nicknames.State is a root-table cache that a fresh=1 reload doesn't reset (KNOWN_BUGS #1),
// so tests that read or write the title state start from what the save holds.
::NickT.resetState <- function () {
    ::Nicknames.State = null;
}

::NickT.keys <- function (_table) {
    local out = [];
    foreach (k, _ in _table) out.push(k);
    out.sort();
    return out;
}

::NickT.titles <- function (_bro) {
    return ::Nicknames.buildCandidates(_bro).map(@(c) c.title);
}

::NickT.has <- function (_arr, _x) {
    return _arr.find(_x) != null;
}

// A recruit made the way a settlement makes one: setStartValuesEx() on the temporary roster.
::NickT.recruit <- function (_backgrounds) {
    local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(_backgrounds);
    return bro;
}

// Hire a recruit the way town_hire_dialog_module.onHireRosterEntry() does.
::NickT.hire <- function (_bro) {
    ::World.getPlayerRoster().add(_bro);
    ::World.getTemporaryRoster().remove(_bro);
    _bro.onHired();
}

// Titles blocked at the strictest level of fillTitle(): generated in the last 14 days, worn by
// the roster, or worn by a once-hired brother who is gone.
::NickT.blocked <- function () {
    local out = {};
    local bros = {};
    foreach (b in ::World.getPlayerRoster().getAll()) bros[b.m.Title] <- true;
    local state = ::Nicknames.loadState();
    local today = ::World.getTime().Days;
    foreach (title, rec in state.generated)
        foreach (d in rec.days) if (d > today - 14) out[title] <- true;
    foreach (k, _ in bros) out[k] <- true;
    foreach (title, _ in state.hired) out[title] <- true;
    return out;
}

// The attr.* factors buildFactorSet() derives, from the given properties.
::NickT.attrFactors <- function (_bro, _props) {
    local out = [];
    local change = _bro.getBackground().onChangeAttributes();
    local talents = _bro.m.Talents;
    foreach (attr, br in ::Nicknames.BaseAttrRanges) {
        local low = br[0] + change[attr][0], high = br[1] + change[attr][1];
        local idx = ::Const.Attributes[attr == "Stamina" ? "Fatigue" : attr];
        local stars = idx < talents.len() ? talents[idx] : 0;
        if (stars > 0 && _props[attr] >= high - stars + 1) out.push("attr." + attr + ".high");
        if (stars == 0 && _props[attr] <= low) out.push("attr." + attr + ".low");
    }
    out.sort();
    return out;
}

::NickT.factorsWithPrefix <- function (_set, _prefix) {
    local out = [];
    foreach (f, _ in _set) if (f.find(_prefix) == 0) out.push(f);
    out.sort();
    return out;
}

// Names of the brothers fillTitle() runs for while _fn() runs.
::NickT.fills <- function (_fn) {
    local names = [], fill = ::Nicknames.fillTitle;
    ::Nicknames.fillTitle = function (_bro) { names.push(_bro.getName()); fill(_bro); };
    _fn();
    ::Nicknames.fillTitle = fill;
    return names;
}

// A wait: with the real page an event screen fades, and an event can't fire until the last one's is gone
// (world_state.showEventScreen's guard), nor while another is queued: after a load the paused world runs the
// event manager once, and Legends' special events (the legendary locations check) fire then.
::NickT.eventIdle <- function (t) {
    local st = ::World.State, screen = st.getEventScreen();
    return t.until(@() !st.m.IsTriggeringContractUpdatesOnce && ::World.Events.m.ActiveEvent == null
        && !screen.isVisible() && !screen.isAnimating() && !st.getMenuStack().hasBacksteps(), 300,
        "the event queue to clear");
}

// N7: an event's recruits are titled on hire (its option 0), not while its first screen makes them.
::NickT.checkEventRecruits <- function (t, _id, _dudes) {
    ::NickT.resetState();
    ::Tales.Autoplay = false;
    local ev = ::World.Events.getEvent(_id), dudes = null;
    local shown = ::NickT.fills(function () {
        if (!::World.Events.fire(_id, false)) throw "event " + _id + " didn't fire";
        dudes = _dudes(ev);
    });
    t.eq(shown, [], _id + ": titled while shown");
    local untitled = dudes.filter(@(_, d) d.m.Title == "").map(@(d) d.getName());
    local hired = ::NickT.fills(@() ::World.Events.processInput(0));
    ::Tales.Autoplay = true;
    t.eq(hired, untitled, _id + ": titled on hire");
    t.eq(dudes.filter(@(_, d) d.m.Title == "").len(), 0, _id + ": untitled after hire");
}

// N7: a recruit made in a screen set directly, as events and their after-battle screens do.
::NickT.checkScreenRecruit <- function (t, _id) {
    ::NickT.resetState();
    local ev = ::World.Events.getEvent(_id), dude = null;
    local shown = ::NickT.fills(@() ev.setScreen({ID = "N7", Text = "", Image = "", List = [], Characters = [],
        Options = [], function start(_event) {
            dude = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
            dude.setStartValuesEx(["farmhand_background"]);
        }}));
    ev.clear();
    t.eq(shown, [], "titled while the screen shows");
    ::World.getTemporaryRoster().clear();
}
