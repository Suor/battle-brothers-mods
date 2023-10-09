::mods_registerMod(::VAP.ID, ::VAP.Version, ::VAP.Name);
::mods_queue(::VAP.ID, "mod_hooks(>=17), mod_msu(>=1.2.6)", function() {
    ::VAP.Mod <- ::MSU.Class.Mod(::VAP.ID, ::VAP.Version, ::VAP.Name);

    // pages
    local page = ::VAP.Mod.ModSettings.addPage("General");

    // helpers
    local function add(elem) {
        page.addElement(elem);
        elem.Data.NewCampaign <- true;
        return elem;
    }
    local function safeToInteger(n) {
        try {
            return n.tointeger();
        } catch (err) {
            this.logWarning("vap: ERROR failed to convert to number: " + n);
            return 0;
        }
    }

    local talentDiv = add(::MSU.Class.RangeSetting("TalentDiv", 3, 2, 5, 1, "Talent Divisor"));
    talentDiv.setDescription("Non-veterans get 0.5 per level per star on average. "
                           + "Veterans will get this times less.");
    ::VAP.getTalentValue <- function () {
        return 0.5 / talentDiv.getValue();
    }

    add(::MSU.Class.SettingsDivider("Div1"));

    // perks
    local perksMode = add(::MSU.Class.EnumSetting(
        "PerksMode", "preset", ["none" "preset" "every nth"], "Perks Mode"));
    add(::MSU.Class.SettingsSpacer("PerksSpacer", "35rem", "8rem"));
    local perksPreset = add(::MSU.Class.StringSetting("PerksPreset", "13, 16, 20, 25, 31",
        "Give a perk on these levels", "Level numbers separated by space or comma"));
    local perksNth = add(::MSU.Class.RangeSetting("PerksNth", 2, 1, 10, 1, "Every Nth Level",
        "Starting from but not including 11"));

    if (::mods_getRegisteredMod("mod_ultrabros")) {
        foreach(setting in [perksMode, perksPreset, perksNth])
            setting.lock("This is overtaken by Ultra Bros");
    }

    ::VAP.getGivePerk <- function () {
        local mode = perksMode.getValue();
        if (mode == "none") {
            this.logInfo("vap: perks " + mode);
            return @(l) false;
        }
        if (mode == "preset") {
            local preset = perksPreset.getValue();
            this.logInfo("vap: perks " + mode + " " + preset);
            local levels_ = split(preset, ", ");
            local levels = levels_.map(safeToInteger);
            return @(l) levels.find(l) != null;
        }
        if (mode == "every nth") {
            local n = safeToInteger(perksNth.getValue());
            this.logInfo("vap: perks " + mode + " " + n);
            local afterLevel = 11;
            return @(l) l > afterLevel && (l - afterLevel) % n == 0;
        }
        this.logWarning("vap: ERROR unknown perk mode: " + mode);
        return @(l) false;
    }
