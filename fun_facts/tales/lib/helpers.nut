// Shared helpers for the Fun Facts scenarios, loaded by `// include: lib/helpers.nut`.

::FFT <- {};

::FFT.ff <- @(_bro) _bro.m.FunFacts;
::FFT.stats <- @(_bro) _bro.m.FunFacts.m.Stats;

// ::FunFacts.LastFallen is a root-table cache a fresh=1 reload doesn't reset.
::FFT.reset <- function () {
    ::FunFacts.LastFallen = null;
}

// The bro never survives being struck down (or always does, with _always).
::FFT.setSurvival <- function (_bro, _always) {
    _bro.getBaseProperties().SurviveWithInjuryChanceMult = _always ? 1000.0 : 0.0;
    _bro.getSkills().update();
}

// A hit through onDamageReceived: body, ignoring armor, guaranteed to injure when it doesn't kill.
::FFT.hit <- function (_victim, _attacker, _damage, _skill = null) {
    local h = clone ::Const.Tactical.HitInfo;
    h.DamageRegular = _damage;
    h.DamageArmor = 0.0;
    h.DamageDirect = 1.0;
    h.BodyPart = ::Const.BodyPart.Body;
    h.Injuries = ::Const.Injury.BluntBody;
    h.InjuryThresholdMult = 0.01;
    return _victim.onDamageReceived(_attacker, _skill, h);
}

// Hint texts the mod added to a tooltip (entries past the vanilla ones it was given).
::FFT.hints <- function (_tooltip, _fromId) {
    local out = [];
    foreach (e in _tooltip) if (e.id > _fromId && e.type == "hint") out.push(e.text);
    return out;
}
::FFT.rosterHints <- @(_bro) ::FFT.hints(_bro.getRosterTooltip(), 6);
::FFT.fallenHints <- @(_idx) ::FFT.hints(::World.Statistics.FunFacts_getTooltipForFallen(_idx), 2);

::FFT.red <- @(_x) ::std.Text.negative(_x);
::FFT.ally <- @(_name) ::std.Text.ally(_name);

// A deep copy through the packer, so later changes to the stats don't show in it. Version is
// left out: a bro never loaded packs the default 1, a loaded one the current 3.
::FFT.snapshot <- function (_ff) {
    local stats = ::std.Packer.unpack(::std.Packer.pack(_ff.pack()));
    delete stats.Version;
    return stats;
}

// A mod's tooltip on an obituary row, as its JS asks MSU for it on hover, by the index the row's data carries.
::FFT.obituaryTooltip <- function (_fallenIdx, _modId, _idxKey) {
    local row = ::World.State.m.ObituaryScreen.convertFallenToUIData().Fallen[_fallenIdx];
    local data = {contentType = "msu-generic", modId = _modId, elementId = "Fallen"};
    data[_idxKey] <- row[_idxKey];
    return ::TooltipScreen.getTooltipEvents().onQueryMSUTooltipData(data).map(@(e) e.text);
}

::FFT.fallenByName <- function (_name) {
    foreach (i, f in ::World.Statistics.getFallen()) if (f.Name == _name) return i;
    return null;
}
