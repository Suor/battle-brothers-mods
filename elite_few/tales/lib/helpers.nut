// Shared helpers for the Elite Few scenarios, loaded by `// include: lib/helpers.nut`.
::EFT <- {};

::EFT.setting <- @(_name) ::EliteFew.Mod.ModSettings.getSetting(_name);

// Runs _fn with the given settings, then restores them.
::EFT.with <- @(_values, _fn) ::Tales.with(::EFT.setting, _values, _fn);

::EFT.isMaster <- @(_bro) _bro.getSkills().hasSkill("trait.master");

// A contract with one screen whose only option leads back to it, as a negotiation round does.
::EFT.loopContract <- function () {
    local c = ::new("scripts/contracts/contracts/drive_away_bandits_contract");
    local town = null;
    foreach (s in ::World.EntityManager.getSettlements())
        if (::World.FactionManager.getFaction(s.getFaction()) != null) { town = s; break; }
    c.setHome(town);
    c.setFaction(town.getFaction());
    c.setEmployerID(0);
    c.setOrigin(town);
    c.m.EFT_Starts <- 0;
    c.m.Screens.push({
        ID = "EFT_Loop", Title = "", Text = "", Image = "", List = [],
        Options = [{Text = "Again", function getResult() { return "EFT_Loop"; }}],
        function start() { this.Contract.m.EFT_Starts++; }
    });
    return c;
}
