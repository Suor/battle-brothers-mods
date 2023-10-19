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


def main():
    if "-h" in sys.argv or "--help" in sys.argv:
        print(__doc__)
        return

    opt_to_kwarg = {"f": "force", "t": "tabs", "v": "verbose"}

    # Parse options
    if lopts := [x for x in sys.argv[1:] if x.startswith("--")]:
        exit('Unknown option "%s"' % lopts[0])
    opts = lcat(x[1:] for x in sys.argv[1:] if x.startswith("-") and x != "-")
    if unknown := set(opts) - set(opt_to_kwarg) - {"h"}:
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

    path = Path(filename)
    if path.is_dir():
        if outfile is not None:
            exit("Can't specify output file for a dir")

        count = 0
        for subfile in path.glob("**/*.nut"):
            if "/scripts/" in subfile.resolve().as_posix():
                count += hookify(subfile, **kwargs)
        print(f"Processed {count} file(s) (use -v for verbose output)")

    elif path.is_file():
        hookify(filename, outfile, **kwargs)
    else:
        print(red("File not found: " + filename), file=sys.stderr)
        sys.exit(1)

def exit(message):
    print(red(message), file=sys.stderr)
    print(__doc__, file=sys.stderr)
    sys.exit(1)


def hookify(file, outfile=None, *, force=False, tabs=False, verbose=False):
    info = (lambda s, **kw: None) if outfile == "-" else lambda s, **kw: print(s, **kw)

    mod_dir, scripts, cls_path = Path(file).resolve().as_posix().rpartition("/scripts/")
    if not scripts:
        info(red('No "/scripts/" within path, won\'t be able to find a corresponding vanilla nut'))
        return 0

    vanilla_file = os.path.join(SCRIPTS, cls_path)
    if not Path(vanilla_file).exists():
        if verbose:
            info(cls_path + "... " + yellow("SKIPPED, no vanilla"))
        return 0

    info(cls_path + "... ", end="")

    if outfile == "-":
        print(_hookify(file, vanilla_file, cls_path, tabs=tabs))
    else:
        if outfile is None:
            mod_name = Path(mod_dir).name
            hooks_file = Path(mod_dir, mod_name, cls_path)  # mod_name is doubled intentionally
        else:
            hooks_file = Path(outfile)

        exists = hooks_file.exists()
        if exists and not force:
            info(yellow("SKIPPED, file exists"))
            return 0

        hook_code = _hookify(file, vanilla_file, cls_path, tabs=tabs)

        # Write to hooks file
        hooks_file.parent.mkdir(parents=True, exist_ok=True)
        hooks_file.write_text(hook_code)
        info(green("UPDATED" if exists else "DONE"))

    return 1


def _hookify(file, vanilla_file, cls_path, tabs=False):
    defs = parse_file(file)
    vanilla_defs = parse_file(vanilla_file)
    diff = calc_diff(vanilla_defs, defs)
    return unparse(cls_path, diff, tabs=tabs)


def calc_diff(from_defs, to_defs):
    def _subtract(from_scope, to_scope):
        if from_scope is None:
            return to_scope.copy(op="<-")

        # Should never compare scopes with different names and should only have certain ops in diff
        assert to_scope.name == from_scope.name
        assert to_scope.op not in {"hook", "monkey", "delete"}
        assert from_scope.op not in {"hook", "monkey", "delete"}

        if to_scope.kind != from_scope.kind:
            return to_scope.copy(op="=")
        elif to_scope.kind == "value":
            return to_scope.copy(op="=", old=from_scope.value)

        same, body_diff = _compare_bodies(from_scope.body, to_scope.body)
        if same:
            return None
        elif to_scope.op == "inherit":  # inherit - inherit == hook
            return to_scope.copy(op="hook", body=body_diff)
        elif to_scope.kind == "{":
            return body_diff
        elif to_scope.kind == "func":   # func - func == monkey
            op = "<-" if from_scope is None else "="
            return to_scope.copy(op=op, kind="monkey", body=body_diff)
        else:
            return to_scope.copy(body=body_diff)

    def _compare_bodies(from_body, to_body):
        same = True
        body_diff = []
        from_subs = {s.name: s for s in from_body if isinstance(s, Scope)}
        to_subs = {s.name: s for s in to_body if isinstance(s, Scope)}

        def _scope(op, xs, _=False):
            nonlocal same
            for x in xs:
                if op == "+":
                    diff = _subtract(from_subs.get(x.name), x)
                    if diff:
                        same = False
                        if isinstance(diff, list):
                            yield from diff
                        else:
                            yield diff

                elif op == "-":
                    if x.name not in to_subs:
                        same = False
                        yield x.copy(op="delete")

        def _lines(op, xs, new_code_block=False):
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

        # isjunk = lambda s: isinstance(s, str) and (not s or s.isspace())
        cruncher = SequenceMatcher(None, from_body, to_body, autojunk=False)
        for tag, alo, ahi, blo, bhi in cruncher.get_opcodes():
            if tag != 'equal':
                for is_scope, group in groupby(from_body[alo:ahi], isa(Scope)):
                    process = _scope if is_scope else _lines
                    body_diff.extend(process("-", list(group)))

            for is_scope, group in groupby(to_body[blo:bhi], isa(Scope)):
                process = _scope if is_scope else _lines
                op = " " if tag == "equal" else "+"
                new_code_block = op == "+" and not bhi - blo == ahi - alo == 1
                body_diff.extend(process(op, list(group), new_code_block))

        return same, body_diff

    return {"": _subtract(from_defs[""], to_defs[""])}


def unparse(cls_path, defs, tabs=False):
    def _block(scope):
        if scope is None:
            return
        # yield pformat(scope, depth=2) + "\n"

        if scope.op == "root":
            yield from _body(scope.body)
        elif scope.op == "inherit":
            yield scope.start
            yield from _close(scope)
        elif scope.op == "hook":
            yield '::mods_hookExactClass("%s", function(cls) {\n' % cls_path.removesuffix(".nut")
            yield from _close(scope)

        elif scope.op in {"=", "<-"}:
            if scope.kind == "value":
                old = f" // {scope.old}" if scope.get("old") is not None else ""
                yield f"{scope.name} {scope.op} {scope.value};{old}\n"
            elif scope.kind == "func":
                yield "\n"
                yield f"{scope.name} {scope.op} function ({scope.params}) {{\n";
                yield from _body(scope["body"])
                yield f"{scope.close}\n"
            elif scope.kind == "monkey":
                key = scope.name.split(".")[-1]
                yield "\n"
                if scope.op == "=":
                    yield f"local {key} = {scope.name};\n"
                yield f"{scope.name} {scope.op} function ({scope.params}) {{\n";
                yield from _body(scope["body"])
                yield f"{scope.close}\n"
            else:
                yield f"{scope.name} {scope.op} {scope.kind}\n"
                yield from _close(scope)

        elif scope.op == "delete":
            yield f"delete {scope.name};\n"

        elif scope.op == "key":
            key = scope.name.split(".")[-1]
            if scope.kind == "value":
                yield f"{key} = {scope.value}\n"
            elif scope.kind == "func":
                yield f"function {key}({scope.params}) {{\n";
                yield from _body(scope["body"])
                yield f"{scope.close}\n"
            else:
                yield f"{key} = {scope.kind}\n"
                yield from _close(scope)
        else:
            raise ValueError("Don't know how to unparse %s" % pformat(scope, depth=1))

    def _close(scope):
        yield from (indent + line if line != "\n" else line for line in _body(scope["body"]))
        yield f"{scope.close}\n"

    def _body(body):
        for line in body:
            if isinstance(line, str):
                yield line
            else:
                yield from _block(line)

    indent = "\t" if tabs else "    "
    code = _block(defs[""])
    return "".join(code if tabs else tabs_to_spaces(code))


def parse_file(filename):
    with open(filename) as fd:
        return parse(fd.read())

def parse(code):
    def _close_or_unexpected():
        if line.startswith(stack.top.prefix + stack.top.close):
            stack.pop()
        # NOTE: we loose comments by simply skipping "junk"
        elif not is_line_junk(line):
            raise ValueError(
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
                stack.push(op, kind, name)
            else:
                stack.top.body.append(line)
        elif stack.top.kind == "{":
            if m := re_find(r"^(\s+)(\w+) = (\{\}?|\[),?\n$", line):
                prefix, key, kind = m
                name = stack.top["name"] + "." + key
                stack.push("key", kind[0], name, prefix=prefix)
                if len(kind) > 1:
                    stack.pop()  # empty table
            elif m := re_find(r"^(\s+)(\w+) = ([^{[]+?|\[\]),?\n$", line):
                prefix, key, value = m
                name = stack.top.name + "." + key
                stack.push("key", "value", name, prefix=prefix, value=value)
                stack.pop()
            elif m := re_find(r"^(\s+)function (\w+)\s*\(([^)]*)\)", line):
                prefix, key, params = m
                name = stack.top.name + "." + key
                stack.push("key", "func", name, params=params, prefix=prefix)
            else:
                _close_or_unexpected()
        elif stack.top.kind == "[":
            # TODO: handle array in table better
            # if m := re_find(r"^(\s+)([{[])\n$", line):
            #     prefix, bracket = m
            #     op = "table" if bracket == "{" else "array"
            #     idx = stack.top.len
            #     stack.top.len = idx + 1
            #     name = stack.top["name"] + "." + str(idx)
            #     stack.push(op, name, prefix=prefix, idx=idx)
            # el
            if line.startswith(stack.top.prefix + stack.top.close):
                stack.pop()
            else:
                stack.top.body.append(line.removeprefix(stack.top.prefix))
            # else:
            #     _close() or _collect()
        else:
            if stack.top.kind == "func" and line.startswith(stack.top.prefix + "{"):
                continue  # do not put this to function body
            elif "close" in stack.top and line.startswith(stack.top.prefix + stack.top.close):
                stack.pop()
            else:
                stack.top.body.append(line.removeprefix(stack.top.prefix))
    return stack.blocks


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
        return hash(self.name)


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
