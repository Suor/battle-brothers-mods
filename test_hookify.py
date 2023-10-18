from pprint import pprint
from textwrap import dedent
from hookify import parse, unparse, calc_diff


def test_table():
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
        gt.Const = {
            Num = 25
        }
    """
    assert diff(base_code, code) == dedent(code)


def diff(base_code, code):
    return _hookify("code.nut", _code_to_lines(base_code), _code_to_lines(code))

def _code_to_lines(code):
    return dedent(code).splitlines(keepends=True)

def _hookify(filename, base_lines, lines):
    defs = parse(lines)
    base_defs = parse(base_lines)
    diff = calc_diff(base_defs, defs)
    # pprint(diff[""])
    return "".join(unparse(diff));
