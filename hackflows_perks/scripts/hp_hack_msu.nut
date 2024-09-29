local version = 0.5, prev = null, debug = false;
logInfo("HackMSU 0.5 (hackflows_perks)");
if ("HackMSU" in getroottable()) {
    if (::HackMSU.version >= version) return;
    prev = ::HackMSU;
}
logInfo("HackMSU 0.5 in (hackflows_perks), prev = " + prev);
::HackMSU <- {
    version = version             // HackMSU version to not overwrite newer versions of itself
    mods = prev ? prev.mods : {}  // Store our mods here
    hooks = {}                    // Store our hooks here

    function prepareHook(_obj, _method) {
        if (_obj in hooks && _method in hooks[_obj]) throw "Forgot to unhook " + _method;
        if (!(_method in _obj)) {
            // We are trying to hook a thing that is not there, MSU changed, unhook all and hide!
            unhookAll();
            return;
        }
        if (!(_obj in hooks)) hooks[_obj] <- {};
        return hooks[_obj][_method] <- _obj[_method];
    }
    function unhookAll() {
        foreach (obj, methods in hooks) {
            foreach (method, original in methods) obj[method] <- original;
        }
        hooks = {};
    }
};
if (prev && "unhookAll" in prev) prev.unhookAll();
if (debug) ::std.Debug.log("prev", prev)

local githubTagsUrl = "https://api.github.com/repos/%s/%s/git/matching-refs/tags/%s?per_page=100";
local githubRegex = regexp(@"https://github\.com/([-\w]+)/([-\w]+)/?.*");

// A quickhand setup helper
::HackMSU.setup <- function (_mod, _opts) {
    mods[_mod.ID] <- {
        name = _mod.Name
        version = _mod.Version
        opts = _opts

        function getUpdateURL() {
            local m = githubRegex.capture(_opts.github);
            if (!m) throw "Invalid Github URL: " + _opts.github;
            local owner = ::MSU.regexMatch(m, _opts.github, 1);
            local repo = ::MSU.regexMatch(m, _opts.github, 2);
            return format(githubTagsUrl, owner, repo, _opts.tagPrefix)
        }
        function sourcesToUI() {
            if ("ModSourceGitHubTags" in ::MSU.Class) {
                return {
                    GitHubTags = {URL = _opts.github, icon = "github"}
                    NexusMods = {URL = _opts.nexus, icon = "nexusmods"}
                }
            }
            return {
                GitHub = _opts.github
                NexusMods = _opts.nexus
            }
        }
    };
}


local getModsForUpdateCheck = ::HackMSU.prepareHook(::MSU.Class.RegistrySystem, "getModsForUpdateCheck");
if (!getModsForUpdateCheck) return;
::MSU.Class.RegistrySystem.getModsForUpdateCheck <- function () {
    local res = getModsForUpdateCheck();
    // Add our stuff
    foreach (id, mod in ::HackMSU.mods) res[id] <- mod.getUpdateURL();
    if (debug) ::std.Debug.log("getModsForUpdateCheck", res);
    return res;
}

local checkIfModVersionsAreNew = ::HackMSU.prepareHook(::MSU.Class.RegistrySystem, "checkIfModVersionsAreNew");
if (!checkIfModVersionsAreNew) return;
::MSU.Class.RegistrySystem.checkIfModVersionsAreNew <- function (_modVersionData) {
    // ::std.Debug.log("IN _modVersionData", _modVersionData);
    local myData = {};
    foreach (modID, modData in _modVersionData) {
        if (!(modID in ::HackMSU.mods)) continue;

        // ::std.Debug.log("modID", modID);
        // ::std.Debug.log("modData", modData);

        // Convert whatever server said to whatever JS expects
        local mod = ::HackMSU.mods[modID];
        local refPrefix = "refs/tags/" + mod.opts.tagPrefix, maxVersion = mod.version;
        foreach (rec in modData) {
            local version = rec.ref.slice(refPrefix.len());
            if (::HackMSU.isBiggerVersion(version, maxVersion)) maxVersion = version;
        }
        if (debug) ::std.Debug.log("maxVersion", maxVersion);
        myData[modID] <- {body = ""}; // changes for old MSU
        if (mod.version.tostring() == maxVersion.tostring()) continue;
        myData[modID].UpdateInfo <- {
            name = mod.name
            availableVersion = maxVersion.tostring()
            currentVersion = mod.version.tostring()
            updateType = ::HackMSU.getUpdateType(maxVersion, mod.version)
            sources = mod.sourcesToUI()
            changes = ""
        };
    }
    if (debug) ::std.Debug.log("checkIfModVersionsAreNew", myData, 10);

    // do not send our stuff to original func, but add it on top
    foreach (modID, _ in myData) delete _modVersionData[modID];
    local res = checkIfModVersionsAreNew(_modVersionData);
    foreach (modID, modData in myData) res[modID] <- modData;

    return res;
}

local function safeToFloat(_value) {
    try {
        return _value.tofloat();
    } catch (err) {
        return null;
    }
}
// Need to handle floats separately because 1.19 < 1.2 for floats but reverse for semver
::HackMSU.isBiggerVersion <- function(_a, _b) {
    local af = safeToFloat(_a), bf = safeToFloat(_b);
    if (af != null && bf != null) return af > bf;
    // Semver is always newer
    if (af == null && bf != null) return true;
    if (af != null && bf == null) return false;
    return ::MSU.SemVer.compareVersionWithOperator(_a, ">", _b);
}
::HackMSU.getUpdateType <- function(_new, _old) {
    local newf = safeToFloat(_new), oldf = safeToFloat(_old);
    if (newf != null && oldf != null) {
        return newf.tointeger() > oldf.tointeger() ? "MAJOR" : "MINOR";
    }

    // This can compare semver to float if mod migrated
    local nparts = split(_new.tostring(), ".").map(safeToFloat),
          oparts = split(_old.tostring(), ".").map(safeToFloat);

    if (nparts[0] > oparts[0]) return "MAJOR";
    if (nparts.len() < 3 || oparts.len() < 2 || nparts[1] > oparts[1]) return "MINOR";
    return "PATCH";
}
