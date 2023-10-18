from pprint import pprint
from textwrap import dedent
from hookify import parse, unparse, calc_diff


def test_parse_table():
    code = dedent("""\
        gt.Props = {
            Count = 0,
            SpawnList = null
            Flag = true
            function test(_param)
            {
                return _param > 100;
            }
        }
    """)
    assert roundtrip(code) == code.replace(",", "").replace(")\n    {", ") {")

def test_parse_inherit():
    code = """\
        this.location <- this.inherit("scripts/entity/world/world_entity", {
            m = {
                Name = "",
                Type = 0,
                Loot = null
            },
            function create()
            {
                this.world_entity.create();
                this.m.IsAttackable = true;
            }
        })
    """
    assert roundtrip(code) == dedent(code).replace(",\n", "\n").replace(")\n    {", ") {")


def test_diff_inherit():
    base_code = """\
        this.location <- this.inherit("scripts/entity/world/world_entity", {
            m = {
                Name = "",
                Type = 0,
                Banner = "banner_beasts_01",
                Loot = null
            },

            function create()
            {
                this.world_entity.create();
                this.m.IsAttackable = true;
                this.m.Loot = this.new("scripts/items/stash_container");
                this.m.Loot.setResizable(true);
            }
            function getTypeID()
            {
                return this.m.TypeID;
            }

            function isLocation()
            {
                return true;
            }
        })
    """
    code = """\
        this.location <- this.inherit("scripts/entity/world/world_entity", {
            m = {
                Name = ""
                Type = 2,
                Description = "<not-set>",
                // Troops = [] // comment is lost
                Loot = null
            },
            function create()
            {
                this.world_entity.create();
                this.m.IsAttackable = false;
                this.m.Loot = this.new("scripts/items/stash_container");
                this.m.Loot.setResizable(true);
            }
            function newFunc ( _a, _b )
            {
                return _a + _b;
            }
            function getTypeID()
            {
                return this.m.TypeID;
            }
        })
    """
    assert diff(code, code) == ""
    assert diff(base_code, code) == dedent("""\
        ::mods_hookExactClass("path/to/location", function(cls) {
            delete cls.m.Banner;
            cls.m.Type = 2;
            cls.m.Description <- "<not-set>";

            local create = cls.create;
            cls.create = function () {
                this.world_entity.create();
                // this.m.IsAttackable = true;
                this.m.IsAttackable = false;
                this.m.Loot = this.new("scripts/items/stash_container");
                this.m.Loot.setResizable(true);
            }

            cls.newFunc <- function ( _a, _b ) {
                return _a + _b;
            }
            delete cls.isLocation;
        })
    """)


def test_diff_table():
    base_code = """\
        gt.Props = {
            Name = "",
            Count = 0
            Flag = false
        }
    """
    code = """\
        gt.Props = {
            Count = 0,
            SpawnList = null,
            Flag = true
        }
    """
    assert diff(base_code, code) == dedent("""\
        delete gt.Props.Name;
        gt.Props.SpawnList <- null;
        gt.Props.Flag = true;
    """)

def test_nested_table():
    base_code = """\
        gt.Const = {
            Props = {
                Num = 12
            }
        }
    """
    code = """\
        gt.Const = {
            Props = {
                Num = 25
            }
        }
    """
    assert diff(base_code, code) == "gt.Const.Props.Num = 25;\n"

def test_new_table():
    base_code = ""
    code = """\
        gt.Const <- {
            Num = 25
        }
    """
    assert diff(base_code, code) == dedent(code)


def test_diff_code():
    base_code = """\
        local gt = getroottable();
        if (!("Const" in gt)) gt.Const <- {};

        a = 1;
        b = 2;
        c = 3;
        d = 4;

        if (a > b) {
            if (...) {
                d = c + 1;
            }

            print(a - b);
        }
    """
    code = """\
        a = 1;
        b = 2;
        c = 3;
        c1 = 3.2;
        c2 = 3.7;
        d = 4;

        if (a > b) {
            print("EXPLAIN");
            print(a - b);
        }
    """
    assert diff(code, code) == ""
    assert diff(base_code, code) == dedent("""\
        // local gt = getroottable();
        // if (!("Const" in gt)) gt.Const <- {};
        //
        a = 1;
        b = 2;
        c = 3;
        c1 = 3.2;
        c2 = 3.7;
        d = 4;

        if (a > b) {
            // if (...) {
                // d = c + 1;
            // }
        //
            print("EXPLAIN");
            print(a - b);
        }
    """)


# Helpers

def roundtrip(code):
    defs = parse(_code_to_lines(code))
    # pprint(defs[""])
    return "".join(unparse("path/to/location.nut", defs))

def diff(base_code, code):
    return _hookify("path/to/location.nut", _code_to_lines(base_code), _code_to_lines(code))

def _code_to_lines(code):
    return dedent(code).splitlines(keepends=True)

def _hookify(filename, base_lines, lines):
    defs = parse(lines)
    # pprint(defs[""]); return
    base_defs = parse(base_lines)
    # pprint(base_defs[""]); return
    diff = calc_diff(base_defs, defs)
    pprint(diff[""])
    return "".join(unparse(filename, diff));
