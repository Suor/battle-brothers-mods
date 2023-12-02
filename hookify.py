#!/usr/bin/env python3
"""\
Usage:
    python hookify.py <mod-file> [<to-file>] [options]
    python hookify.py <mod-dir> [options]

Rewrites old-style "copy and edit" mod files to hooks.

Arguments:
    <mod-file>  The path to a mod file to convert
    <to-file>   File to write hooks code to, defaults to <mod-name>/path/to/class.nut,
                use - to print to stdout instead
    <mod-dir>   Process all *.nut files in a dir

Options:
    -f          Overwrite existing files
    -t          Use tabs instead of spaces
    -v          Verbose output
    -h, --help  Show this help
"""
import os
from pathlib import Path
import sys
from difflib import Differ, SequenceMatcher
from itertools import groupby
from pprint import pprint, pformat

SCRIPTS = "/home/suor/_downloads/Battle Brothers mods/bbtmp2/scripts-base/";
# SCRIPTS = "/home/suor/_downloads/Battle Brothers mods/bbtmp2/mod_legends_18.1.0/scripts/";


def main():
    if "-h" in sys.argv or "--help" in sys.argv:
        print(__doc__)
        return

    opt_to_kwarg = {"f": "force", "t": "tabs", "v": "verbose"}

    # Parse options
    if lopts := [x for x in sys.argv[1:] if x.startswith("--")]:
        exit('Unknown option "%s"' % lopts[0])
    opts = lcat(x[1:] for x in sys.argv[1:] if x.startswith("-") and x != "-")
    if unknown := set(opts) - set(opt_to_kwarg) - {"h", "i"}:
        exit('Unknown option "-%s"' % unknown.pop())
    kwargs = {full: o in opts for o, full in opt_to_kwarg.items()}

    # Parse args
    args = [x for x in sys.argv[1:] if x == "-" or not x.startswith("-")]
    if len(args) < 1:
        exit("Please specify file or dir")
    elif len(args) > 2:
        exit("Too many arguments")

    filename = args[0]
    outfile = args[1] if len(args) >= 2 else None

    ctx = {"count": 0, "includes": {"": [], "queue": []}}
    path = Path(filename)
    if path.is_dir():
        if outfile is not None:
            exit("Can't specify output file for a dir")

        for subfile in path.glob("**/*.nut"):
            if "/scripts/" in subfile.resolve().as_posix():
                hookify(subfile, ctx=ctx, **kwargs)
        verbose_hint = "" if kwargs["verbose"] else " (use -v for verbose output)"
        print(f"Processed {ctx['count']} file(s)" + verbose_hint)

    elif path.is_file():
        hookify(filename, outfile, ctx=ctx, **kwargs)
    else:
        print(red("File not found: " + filename), file=sys.stderr)
        sys.exit(1)

    if "i" in opts and ctx["includes"]:
        print_includes(ctx["includes"])

def exit(message):
    print(red(message), file=sys.stderr)
    print(__doc__, file=sys.stderr)
    sys.exit(1)

def print_includes(includes):
    if not includes[""] and not includes["queue"]:
        return

    print("\nIncludes to be added to your mod file:\n")
    # print("\n".join(ctx["includes"]))
    # pprint(ctx["includes"])

    if includes[""]:
        print("\n".join(f'::include("{file}");' for file in includes[""]))
        print("")
    if includes["queue"]:
        print("::mods_queue(..., ..., function () {")
        print("\n".join(f'    ::include("{file}");' for file in includes["queue"]))
        print("}")

    print("")



def hookify(file, outfile=None, *, ctx=None, force=False, tabs=False, verbose=False):
    info = (lambda s, **kw: None) if outfile == "-" else lambda s, **kw: print(s, **kw)

    mod_dir, scripts, cls_path = Path(file).resolve().as_posix().rpartition("scripts/")
    if not scripts:
        msg = red('No "/scripts/" within path, won\'t be able to find a corresponding vanilla nut')
        print(msg, file=sys.stderr)
        return

    vanilla_file = os.path.join(SCRIPTS, cls_path)
    if not Path(vanilla_file).exists():
        if verbose:
            info(cls_path + "... " + yellow("SKIPPED, no vanilla"))
        return

    info(cls_path + "... ", end="")

    if outfile == "-":
        print(_hookify(file, vanilla_file, cls_path, tabs=tabs)[1])
    else:
        if outfile is None:
            mod_name = Path(mod_dir).name
            diff_file = Path(mod_dir, mod_name, cls_path)  # mod_name is doubled intentionally
        else:
            diff_file = Path(outfile)

        exists = diff_file.exists()
        if exists and not force:
            info(yellow("SKIPPED, file exists"))
            return

        try:
            has_hook, diff_code = _hookify(file, vanilla_file, cls_path, tabs=tabs)
        except ParseError as e:
            info(red("Failed to parse: %s" % e))
            return

        # Write to hooks file
        diff_file.parent.mkdir(parents=True, exist_ok=True)
        diff_file.write_text(diff_code)
        info(green("UPDATED" if exists else "DONE"))

        # Prepare includes
        include_name = diff_file.relative_to(mod_dir).as_posix().removesuffix(".nut")
        ctx["includes"]["queue" if has_hook else ""].append(include_name)

    ctx["count"] += 1


def _hookify(file, vanilla_file, cls_path, *, tabs=False):
    defs = parse_file(file)
    vanilla_defs = parse_file(vanilla_file)
    diff = calc_diff(vanilla_defs, defs)
    has_hook = any(s.op == "hook" for s in diff[""].body if isinstance(s, Scope))
    return has_hook, unparse(cls_path, diff, tabs=tabs)


def calc_diff(from_defs, to_defs):
    def _diff_scopes(from_scope, to_scope):
        # We have on input:
        #     ops:  root inherit = <- elem key
        #     kind: value { [ func code
        # Op math:
        #     <- - <- = =
        #     inherit - inherit = hook
        #     (stays the same otherwise)
        # Kind math:
        #     value - value = value
        #     { - { = edit ops?
        #     [ - [ = [            (with annotated changes and refs to exact same elements)
        #     func - func = monkey (with annotated code)
        #     code - code = code   (annotated with // and START/END NEW CODE)
        if from_scope is None:
            return to_scope.copy(op="<-")

        # Should never compare scopes with different names and should only have certain ops in diff
        assert from_scope.name == to_scope.name
        assert from_scope.op == to_scope.op
        assert from_scope.op in {"root", "inherit", "=", "<-", "elem", "key"}
        assert to_scope.op in {"root", "inherit", "=", "<-", "elem", "key"}

        if to_scope.kind != from_scope.kind:
            return to_scope.copy(op="=")# if to_scope.op == "<-" else to_scope
        elif to_scope.kind == "value":
            # op = "=" if to_scope.op == "<-" else to_scope.op
            return to_scope.copy(op="=", old=from_scope.value)

        same, body_diff = _compare_bodies(from_scope.body, to_scope.body)
        if same and to_scope.op != "elem":
            return None
        elif to_scope.op == "inherit":  # inherit - inherit == hook
            return to_scope.copy(op="hook", body=body_diff)
        elif to_scope.kind == "{":
            return Scope(op="changes", kind=to_scope.kind, body=body_diff)
        elif to_scope.kind == "func":   # func - func == monkey
            return to_scope.copy(op="=", kind="monkey", body=body_diff)
        else:
            # TODO: recode how we subtract tables
            op = "=" if to_scope.kind in {"{", "["} and to_scope.op in {"key", "<-"} \
                else to_scope.op
            return to_scope.copy(op=op, body=body_diff)

    def _compare_bodies(from_body, to_body):
        same = True
        body_diff = []
        from_subs = {s.name: s for s in from_body if isinstance(s, Scope)}
        to_subs = {s.name: s for s in to_body if isinstance(s, Scope)}
        from_elems = {e: e for e in from_body if isinstance(e, Scope) and e.op == "elem"}
        to_elems = {e for e in to_body if isinstance(e, Scope) and e.op == "elem"}

        def _find_similar(x, old_elems):
            assert x.op == "elem"

            # NOTE: may also consider functions and tables
            if x.kind not in "[":
                return

            for old in old_elems:
                if isinstance(old, Scope) and old.kind == x.kind:
                    xset = {hash(e) for e in x.body}
                    oset = {hash(e) for e in old.body}
                    if len(xset ^ oset) * 2 < len(xset) + len(oset):
                        return old

        def _scope(op, xs, tag, _=False):
            nonlocal same
            for x in xs:
                if x.op == "elem":
                    yield from _elem(op, x, tag)
                elif op == "+":
                    assert x.op in {"key", "=", "<-", "inherit"}, pformat(x)
                    diff = _diff_scopes(from_subs.get(x.name), x)
                    if diff:
                        same = False
                        yield diff
                elif op == "-":
                    if x.name not in to_subs:
                        same = False
                        yield x.copy(op="delete")

        def _elem(op, x, tag):
            nonlocal same
            if op == "+":
                same = False
                if old := from_elems.get(x):
                    yield old.copy(kind="ref")
                elif similar := _find_similar(x, from_body):
                    yield _diff_scopes(similar, x)
                else:
                    yield x  # A completely new element
            elif op == "-":
                same = False
                if tag != "replace":
                    if x not in to_elems:
                        yield f"// USED TO BE element {x.idx}\n"
            elif op == " ":
                yield x.copy(kind="ref")

        def _lines(op, xs, tag, new_code_block=False):
            nonlocal same
            if op in {"+", "-"} and not all(is_line_junk(line) for line in xs):
                same = False

            prefixes = (re_find(r"^([ \t]*)", line) for line in xs if line != "\n")
            prefix = min(prefixes, default="", key=len)
            if new_code_block:
                yield prefix + "// START NEW CODE\n"

            for line in xs:
                if op in {" ", "+"}:
                    yield line
                elif op == "-":
                    deleted = ' ' + line.removeprefix(prefix)
                    yield prefix + '//' + ('\n' if deleted.isspace() else deleted)

            if new_code_block:
                yield prefix + "// END NEW CODE\n"

        def _process_op(tag, a, alo, ahi, b, blo, bhi):
            # if a[alo].op == "elem":
                # import ipdb; ipdb.set_trace()
            # if tag != 'equal':
            for is_scope, group in groupby(a[alo:ahi], isa(Scope)):
                process = _scope if is_scope else _lines
                op = " " if tag == "equal" else "-"
                body_diff.extend(process(op, list(group), tag))

            if tag != 'equal':
                for is_scope, group in groupby(b[blo:bhi], isa(Scope)):
                    process = _scope if is_scope else _lines
                    op = " " if tag == "equal" else "+"
                    new_code_block = op == "+" and not bhi - blo == ahi - alo == 1
                    body_diff.extend(process(op, list(group), tag, new_code_block))

        isjunk = lambda s: isinstance(s, str) and (not s or s.isspace())
        cruncher = SequenceMatcher(isjunk, from_body, to_body, autojunk=False)
        for tag, alo, ahi, blo, bhi in cruncher.get_opcodes():
            if tag == 'replace':
                # Using junk arg above allows to find replacement better but then it might contain
                # same junk lines as part of replace, i.e. replace empty line with another one.
                a = from_body[alo:ahi]
                b = to_body[blo:bhi]
                subcruncher = SequenceMatcher(None, a, b, autojunk=False)
                for tag, alo, ahi, blo, bhi in subcruncher.get_opcodes():
                    _process_op(tag, a, alo, ahi, b, blo, bhi)
            else:
                _process_op(tag, from_body, alo, ahi, to_body, blo, bhi)

        return same, body_diff

    return {"": _diff_scopes(from_defs[""], to_defs[""])}


def unparse(cls_path, defs, *, tabs=False):
    def _block(scope, tail=()):
        if scope is None:
            return
        # yield pformat(scope, depth=2) + "\n"

        if scope.op == "root":
            yield from _body(scope)
        elif scope.op == "inherit":
            yield scope.start
            yield from _close(scope)
        elif scope.op == "hook":
            yield '::mods_hookExactClass("%s", function(cls) {\n' % cls_path.removesuffix(".nut")
            yield from _close(scope)

        elif scope.op == "changes":
            yield from _body(scope)

        elif scope.op in {"=", "<-"}:
            if scope.kind == "value":
                old = f" // {scope.old}" if scope.get("old") is not None else ""
                yield f"{scope.name} {scope.op} {scope.value};{old}\n"
            elif scope.kind == "func":
                yield "\n"
                yield f"{scope.name} {scope.op} function ({scope.params}) {{\n";
                yield from _body(scope)
                yield f"{scope.close}\n"
            elif scope.kind == "monkey":
                key = scope.name.split(".")[-1]
                yield "\n"
                if scope.op == "=":
                    yield f"local {key} = {scope.name};\n"
                yield f"{scope.name} {scope.op} function ({scope.params.strip()}) {{\n";
                yield from _body(scope)
                yield f"{scope.close}\n"
            else:
                yield f"{scope.name} {scope.op} {scope.kind}\n"
                yield from _close(scope)

        elif scope.op == "delete":
            yield f"delete {scope.name};\n"

        elif scope.op == "elem":
            scope_next = first(s for s in tail if not isinstance(s, str) or not is_line_junk(s))
            opt_comma = (scope_next is None
                or (isinstance(scope_next, str) and re.search(r"^\s*[\w{\"'@/]", scope_next))
                or (isinstance(scope_next, Scope) and scope_next.kind in {"{", "ref"})
            )
            comma = "" if opt_comma else ","
            if scope.kind == "value":
                # Q: do we ever have this old?
                old = f" // {scope.old}" if scope.get("old") is not None else ""
                yield f"{scope.value}{comma}{old}\n"
            elif scope.kind == "ref":
                parent = scope.name.rstrip("[]")  #rsplit(".", 1)[0]
                ref = f"{parent}[{scope.idx}]"
                yield f"{ref}{comma}\n"
            else:
                yield f"{scope.kind}\n"
                yield from ("\t" + line if line != "\n" else line for line in _body(scope))
                yield f"{scope.close}{comma}\n"

        elif scope.op == "key":
            key = scope.name.split(".")[-1]
            if scope.kind == "value":
                yield f"{key} = {scope.value}\n"
            elif scope.kind == "func":
                yield f"function {key}({scope.params}) {{\n";
                yield from _body(scope)
                yield f"{scope.close}\n"
            else:
                yield f"{key} = {scope.kind}\n"
                yield from _close(scope)

        else:
            raise ValueError("Don't know how to unparse %s" % pformat(scope, depth=1))

    def _close(scope):
        yield from ("\t" + line if line != "\n" else line for line in _body(scope))
        yield f"{scope.close}\n"

    def _body(scope):
        for i, sub in enumerate(scope.body):
            if isinstance(sub, str):
                yield sub
            else:
                yield from _block(sub, scope.body[i+1:])  # TODO: make it more efficient

    code = _block(defs[""])
    return "".join(code if tabs else tabs_to_spaces(code))


def parse_file(filename):
    with open(filename) as fd:
        return parse(fd.read())

def parse(code):
    def _close():
        if "close" in stack.top and re.search(fr"^\s*{re.escape(stack.top.close)}[,;]?\s*$", line):
            stack.pop()
            return True

    def _collect(prefix=None):
        if prefix is None:
            prefix = stack.top.prefix
        stack.top.body.append(line.removeprefix(prefix))

    def _unexpected():
        # NOTE: we loose comments by simply skipping "junk"
        if not is_line_junk(line):
            raise ParseError(
                f"Unexpected '{line.rstrip()}' in scope {pformat(stack.top, depth=1)} at line {i}")

    lines = code.splitlines(keepends=True)
    stack = ScopeStack()
    stack.push("root", "code", "")
    for i, line in enumerate(lines, start=1):
        if stack.top.kind == "code":
            if m := re_find(r"^this.\w+ <- this\.inherit\(", line):
                stack.push("inherit", "{", "cls", start=line, close="})")
            elif m := re_find(r"^(gt\.[\w\.]+) (=|<-) ([{[])\s*$", line):
                name, op, kind = m
                stack.push(op, kind, name, len=0)
            else:
                _collect("")
        elif stack.top.kind == "{":
            if m := re_find(r"^(\s+)(\w+) ?= ?(\{\}?|\[\]?),?\n$", line):
                prefix, key, kind = m
                name = stack.top["name"] + "." + key
                stack.push("key", kind[0], name, prefix=prefix, len=0)
                if len(kind) > 1:
                    stack.pop()  # empty table or array
            elif m := re_find(r"^(\s+)(\w+) ?= ?([^{[]+?),?\n$", line):
                prefix, key, value = m
                name = stack.top.name + "." + key
                stack.push("key", "value", name, prefix=prefix, value=value)
                stack.pop()
            elif m := re_find(r"^(\s+)function (\w+)\s*\(([^)]*)\)\s*(\{?)\s*$", line):
                prefix, key, params, curly = m
                name = stack.top.name + "." + key
                stack.push("key", "func", name, params=params, level=int(bool(curly)), prefix=prefix)

            else:
                _close() or _unexpected()
        elif stack.top.kind == "[":
            if m := re_find(r"^(\s+)(\{|\[)\n", line):
                prefix, kind = m
                idx = stack.top.len
                stack.top.len = idx + 1
                name = stack.top["name"] + "[]" #+ "." + str(idx)
                stack.push("elem", kind, name, prefix=prefix, idx=idx, len=0)
            elif _close():
                pass
            else:
                if not is_line_junk(line):
                    stack.top.len += 1  # This is fragile, need proper parser!
                # TODO: make it better
                indent = '\t' if line.startswith('\t') else '    '
                _collect(stack.top.prefix + indent)
        elif stack.top.kind == "func":
            if stack.top.level == 0:
                if is_line_junk(line):
                    continue  # loosing junk in between ) and { in func decl
                elif re_find(r"^\s*\{\s*$", line):
                    stack.top.level = 1
                else:
                    raise ParseError(f"Expected '{{' at line {i}, got {line} instead")
            elif stack.top.level == 1 and _close():
                pass
            else:
                parts = re.findall(r"[{}]", line)
                for c in parts:
                    stack.top.level += 1 if c == "{" else -1
                if stack.top.level < 0:
                    raise ParseError(f"Unexpected '}}' at line {i}")
                elif stack.top.level == 0:
                    stack.pop()
                else:
                    _collect()
        else:
            _close() or _collect()
    if stack.top.op != "root":
        raise ParseError(f"never closed {stack.top.name}")
    return stack.blocks

class ParseError(Exception):
    pass


class ScopeStack:
    def __init__(self):
        self.blocks = {}
        self.stack = []
        self.top = None

    def push(self, op, kind, name, **kwargs):
        scope = self.blocks[name] = Scope(op=op, kind=kind, name=name, **kwargs)
        self.stack.append(scope)
        if self.top is not None:
            self.top.body.append(scope)
        self.top = scope

    def pop(self):
        self.stack.pop()
        self.top = self.stack[-1] if self.stack else None


class Scope(dict):
    CLOSES = {"{": "}", "[": "]", "func": "}", "inherit": "})"}

    def __init__(self, *args, **kwargs):
        self.update(prefix="", body=[])
        dict.__init__(self, *args, **kwargs)

        if "close" not in self and self.kind in self.CLOSES:
            self["close"] = self.CLOSES[self.kind]

    def copy(self, **kwargs):
        return Scope(self, **kwargs)

    def __getattr__(self, name):
        if name not in self:
            raise AttributeError(f"No '{name}' in scope {pformat(self, depth=1)}")
        return self[name]

    def __hash__(self):
        return hash((self.kind, self.get("value")) + tuple(self.body))

    def __eq__(self, other):
        if not isinstance(other, Scope):
            return False
        elif self.op == other.op == "elem":
            return self.kind == other.kind and self.body == other.body
        else:
            return dict.__eq__(self, other)

# Helpers

from itertools import chain
from operator import methodcaller
import re


def is_line_junk(line, pat=re.compile(r"^\s*(?:$|//)")):
    return pat.search(line) is not None

def tabs_to_spaces(lines, num=4):
    for line in lines:
        yield line.replace("\t", " " * num)

def isa(typ):
    return lambda x: isinstance(x, typ)

def lcat(seqs):
    return list(chain.from_iterable(seqs))

def first(seq):
    """Returns the first item in the sequence.
       Returns None if the sequence is empty."""
    return next(iter(seq), None)

def re_find(regex, s, flags=0):
    """Matches regex against the given string,
       returns the match in the simplest possible form."""
    regex, _getter = _inspect_regex(regex, flags)
    getter = lambda m: _getter(m) if m else None
    return getter(regex.search(s))

def _inspect_regex(regex, flags):
    if not isinstance(regex, re.Pattern):
        regex = re.compile(regex, flags)
    return regex, _make_getter(regex)

def _make_getter(regex):
    if regex.groups == 0:
        return methodcaller('group')
    elif regex.groups == 1 and regex.groupindex == {}:
        return methodcaller('group', 1)
    elif regex.groupindex == {}:
        return methodcaller('groups')
    elif regex.groups == len(regex.groupindex):
        return methodcaller('groupdict')
    else:
        return lambda m: m

# Coloring works on all systems but Windows
if os.name == 'nt':
    red = green = yellow = lambda text: text
else:
    red = lambda text: "\033[31m" + text + "\033[0m"
    green = lambda text: "\033[32m" + text + "\033[0m"
    yellow = lambda text: "\033[33m" + text + "\033[0m"


if __name__ == "__main__":
    main()
