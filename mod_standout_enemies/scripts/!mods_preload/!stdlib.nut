// Alias things to make it easier for us inside. These are still global and accessible from outside
::std <- {version = 1.1};
local Str = ::std.Str <- {},
      Util = ::std.Util <- {},
      Rand = ::std.Rand <- {},
      Debug = ::std.Debug <- {},
      Hook = ::std.Hook <- {};

// Since we use forward declarations we can't override, we should extend tables.
local function extend(dst, src) {
    foreach (key, value in src) {
        dst[key] <- value
    }
    return dst;
}

extend(Str, {
    function startswith(s, sub) {
        if (s.len() < sub.len()) return false;
        return s.slice(0, sub.len()) == sub;
    }
    function endswith(s, sub) {
        if (s.len() < sub.len()) return false;
        return s.slice(-sub.len()) == sub;
    }
    function join(sep, lines) {
        local s = "";
        foreach (i, line in lines) {
            if (i > 0) s += sep;
            s += line;
        }
        return s;
    }
    function indent(level, s) {
        return format("%"+ (level * 4) + "s", "") + s;
    }
})

extend(Util, {
    function concat(...){
        local res = [];
        foreach (arr in vargv) res.extend(arr);
        return res
    }

    function keys(data) {
        local res = [];
        foreach (key, _ in data) res.push(key);
        return res;
    }

    function merge(t1, t2) {
        if (t1 == null) return t2;
        if (t2 == null) return t1;
        return extend(clone t1, t2);
    }
    extend = extend

    function sum(arr) {
        return arr.reduce(@(a, b) a + b);
    }

    function all(arr, func) {
        foreach (item in arr) {
            if (!func(item)) return false;
        }
        return true;
    }
    function any(arr, func) {
        foreach (item in arr) {
            if (func(item)) return true;
        }
        return false;
    }
})


// Higher level random helpers

extend(Rand, {
    function chance(prob) {
        if (prob <= 0) return false;
        return this.Math.rand(1, 1000) <= prob * 1000;
    }

    function choice(arr) {
        return arr[this.Math.rand(0, arr.len() - 1)];
    }
    function choices(num, arr) {
        local res = [];
        for (local i = 0; i < num; i++) res.push(Rand.choice(arr));
        return res;
    }
    function weighted(weights, choices) {
        local total = Util.sum(weights);
        local roll = this.Math.rand(1, 1000) * total / 1000.0;

        local sofar = 0;
        for (local i = 0; i < weights.len(); i++) {
            sofar += weights[i];
            if (roll <= sofar) return choices[i]
        }
        return choices[choices.len() - 1];  // To be safe
    }
    function insert(arr, item, num = 1) {
        for (local i = 0; i < num; i++) {
            local index = Math.rand(0, arr.len());
            arr.insert(index, item);
        }
    }

    function poly(tries, prob) {
        if (prob <= 0 || tries < 1) return 0;

        local num = 0;
        for (local i = 0; i < tries; i++)
            if (Rand.chance(prob)) num++;
        return num;
    }
    function range(from, to) {
        return this.Math.rand(from * 1000, to * 1000) / 1000.0;
    }
})


// Debug things

local function joinLength(items, sepLen) {
    if (items.len() == 0) return 0;
    return Util.sum(items.map(@(s) s.len())) + (items.len() - 1) * sepLen;
}

extend(Debug, {
    DEFAULTS = {prefix = "", width = 80, depth = 3, funcs = "count"}

    // Pretty print a data structure. Options:
    //     width   max line width in chars
    //     depth   max depth to show
    //     funcs   how functions should be shown ("count" | "full" | false)
    // See option defaults above.
    function pp(data, options = {}, level = 0) {
        local function ppCont(items, level, start, end) {
            if (joinLength(items, 2) <= options.width - level * 4 - 2) {
                return start + Str.join(", ", items) + end;
            } else {
                local lines = [start];
                lines.extend(items.map(@(item) Str.indent(level + 1, item)));
                lines.push(Str.indent(level, end));
                return Str.join("\n", lines);
            }
        }

        if (level == 0) options = Util.merge(Debug.DEFAULTS, options);
        if (level >= options.depth) return "" + data;  // More robust than .tostring()

        local endln = (level == 0 ? "\n" : "");

        if (typeof data == "table") {
            if ("pp" in data) return data.pp;

            local items = [], funcs = 0;
            foreach (k, v in data) {
                if (typeof v == "function") {
                    funcs += 1;
                    if (options.funcs != "full") continue;
                }
                items.push(k + " = " + Debug.pp(v, options, level + 1))
            }
            if (options.funcs == "count" && funcs) items.push("(" + funcs + " functions)");
            return ppCont(items, level, "{", "}") + endln;
        } else if (typeof data == "array") {
            local items = data.map(@(item) Debug.pp(item, options, level + 1));
            return ppCont(items, level, "[", "]") + endln;
        } else if (data == null) {
            return "null" + endln;
        } else {
            return "" + data + endln;
        }
    }

    function log(name, data, options = {}) {
        this.logInfo("<pre>" + this.DEFAULTS.prefix + name + " = " + Debug.pp(data, options) + "</pre>");
    }

    // Create a new Debug with changed default options:
    //     local Debug = ::std.Debug.with({prefix: "my-module: ", width: 120});
    //     Debug.log("enemy", enemy);
    function with(options) {
        return Util.merge(this, {DEFAULTS = Util.merge(this.DEFAULTS, options)})
    }
})


extend(Hook, {
    function method(cls, methodName, func) {
        while (!(methodName in cls)) cls = cls[cls.SuperName];

        local super = cls[methodName];
        cls[methodName] = function (...) {
            return func.acall(Util.concat([this, super], vargv));
        };
    }
    function after(cls, methodName, func) {
        while (!(methodName in cls)) cls = cls[cls.SuperName];

        local super = cls[methodName];
        cls[methodName] = function (...) {
            local args = Util.concat([this], vargv);
            super.acall(args);
            func.acall(args);
        };
    }

    function _find(cls, methodName) {
        while (!(methodName in cls)) cls = cls[cls.SuperName];

        local super = cls[methodName];
        local function override(className, func) {
            cls[methodName] = function (...) {
                local args = Util.concat([this], vargv);
                return (::mods_isClass(this, className) ? func : super).acall(args);
            }
        }
        return {super = super, override = override}
    }
})
