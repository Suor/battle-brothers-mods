#!/usr/bin/env python3
from pathlib import Path
import re
import sys
from difflib import Differ, SequenceMatcher
from itertools import groupby
from pprint import pprint, pformat
from funcy import re_find, post_processing, cat, isa

SCRIPTS = "/home/suor/_downloads/Battle Brothers mods/bbtmp2/scripts-base/";

def main():
    filename = sys.argv[1]
    options = {
        "force": "-f" in sys.argv,
        "verbose": "-v" in sys.argv,
        "stdout": "-" in sys.argv,
    }

    path = Path(filename)
    if path.is_dir():
        for subfile in path.glob("**/*.nut"):
            hookify(str(subfile), **options)
    elif path.is_file():
        hookify(filename, **options)
    else:
        print("File not found: " + filename, file=sys.stderr)
        sys.exit(1)


def hookify(file, force=False, verbose=False, stdout=False):
    mod_dir, _, cls_path = file.rpartition("scripts/")
    vanilla_file = SCRIPTS + cls_path

    # TODO: handle this better
    if verbose:
        print(cls_path + "... ", end="")

    if not Path(vanilla_file).exists():
        if verbose:
            print("SKIPPED, no vanilla")
        return

    if not verbose and not stdout:
        print(cls_path + "... ", end="")

    mod_name = Path(mod_dir).name
    hooks_file = Path(mod_dir, mod_name, cls_path)
    exists = hooks_file.exists()
    if not stdout and exists and not force:
        print("SKIPPED, file exists")
        return

    defs = parse(file)
    # pprint(defs[""], depth=6);
    print("".join(unparse(cls_path, defs))); return
    vanilla_defs = parse(vanilla_file)
    # print(defs[""]["body"] == vanilla_defs[""]["body"])
    # pprint(vanilla_defs[""], depth=4);
    # return

    diff = calc_diff(vanilla_defs, defs)
    # pprint(defs[""], depth=3)
    # pprint(vanilla_defs[""], depth=3)
    # import ipdb; ipdb.set_trace()
    # pprint(diff, depth=5); return
    print("".join(unparse(cls_path, diff))); return
    # import ipdb; ipdb.set_trace()
    # return

    if stdout:
        print("".join(tabs_to_spaces(hook_lines(cls_path, diff))))
        return

    # Write to hooks file
    hooks_file.parent.mkdir(parents=True, exist_ok=True)
    hooks_file.write_text("".join(tabs_to_spaces(hook_lines(cls_path, diff))))
    print("UPDATED" if exists else "DONE")


def calc_diff(from_defs, to_defs):
    def _calc_diff(from_scope, to_scope):
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

        same, same_code, body_diff = _compare_bodies(from_scope.body, to_scope.body)
        if same:
            return None
        elif to_scope.op == "inherit":
            return to_scope.copy(op="hook", body=body_diff, same_code=same_code)
        elif to_scope.kind == "{":
            # pprint(body_diff, depth=2)
            return body_diff
        elif to_scope.kind == "func":
            op = "<-" if from_scope is None else "="
            return to_scope.copy(op=op, kind="monkey", body=body_diff, same_code=same_code)

        return to_scope.copy(body=body_diff, same_code=same_code)

    def _compare_bodies(from_body, to_body):
        same = same_code = True
        body_diff = []
        from_subs = {s.name: s for s in from_body if isinstance(s, Scope)}
        to_subs = {s.name: s for s in to_body if isinstance(s, Scope)}

        def _add(x):
            nonlocal same, same_code
            if isinstance(x, Scope):
                diff = _calc_diff(from_subs.get(x.name), x)
                if diff:
                    same = False
                    if isinstance(diff, list):
                        yield from diff
                    else:
                        yield diff
            else:
                if not is_line_junk(x):
                    same = same_code = False
                yield x

        def _delete(x):
            nonlocal same
            if isinstance(x, Scope):
                if x.name not in to_subs:
                    same = False
                    yield x.copy(op="delete")
            else:
                if not is_line_junk(x):
                    same = same_code = False
                prefix = re_find(r"^([ \t]*)", x)# or "\t\t"
                deleted = ' ' + x.removeprefix(prefix)
                yield prefix + '//' + ('\n' if deleted.isspace() else deleted)

        def _same(x):
            if not isinstance(x, Scope):
                yield x

        # def _dump(tag):
        #     pass

        # isjunk = lambda s: isinstance(s, str) and (not s or s.isspace())
        cruncher = SequenceMatcher(None, from_body, to_body, autojunk=False)
        for tag, alo, ahi, blo, bhi in cruncher.get_opcodes():
            if tag == 'replace':
                body_diff.extend(cat(_delete(x) for x in from_body[alo:ahi]))
                body_diff.extend(cat(_add(x) for x in to_body[blo:bhi]))
            elif tag == 'delete':
                body_diff.extend(cat(_delete(x) for x in from_body[alo:ahi]))
            elif tag == 'insert':
                body_diff.extend(cat(_add(x) for x in to_body[blo:bhi]))
                # for is_scope, group in groupby(to_body[blo:bhi], isa(Scope)):
                #     if is_scope:
                #         body_diff.extend(cat(_add(x) for x in group))
                #     else:
                #         body_diff.extend(_dump("+", list(group)))
            elif tag == 'equal':
                body_diff.extend(cat(_same(x) for x in to_body[blo:bhi]))
            else:
                raise ValueError('unknown tag %r' % (tag,))

        return same, same_code, body_diff

    return {"": _calc_diff(from_defs[""], to_defs[""])}


def tabs_to_spaces(lines, num=4):
    for line in lines:
        yield line.replace("\t", " " * num)

def unparse(cls_path, defs):
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
                yield f"{scope.name} {scope.op} {scope.value};\n"
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
        yield from ("    " + line if line != "\n" else line for line in _body(scope["body"]))
        yield f"{scope.close}\n"

    def _body(body):
        for line in body:
            if isinstance(line, str):
                yield line
            else:
                yield from _block(line)

    yield from _block(defs[""])


def parse(filename):
    def _close_or_unexpected():
        if line.startswith(stack.top.prefix + stack.top.close):
            stack.pop()
        # NOTE: we loose comments by simply skipping "junk"
        elif not is_line_junk(line):
            raise ValueError(f"Unexpected '{line.rstrip()}' in scope {stack.top.name} at line {i}")

    lines = readlines(filesname) if isinstance(filename, str) else filename
    stack = ScopeStack()
    stack.push("root", "code", "")
    # print("-" * 80)
    for i, line in enumerate(lines, start=1):
        if stack.top.kind == "code":
            # print(line)
            if m := re_find(r"^this.\w+ <- this\.inherit\(", line):
                # TODO: merge inherit and table
                stack.push("inherit", "{", "cls", start=line, close="})")
            elif m := re_find(r"^(gt\.[\w\.]+) (=|<-) ([{[])\s*$", line):
                name, op, kind = m
                # op = "set" if _op == "=" else "new"
                # kind = "table" if bracket == "{" else "array"
                stack.push(op, kind, name)
            else:
                stack.top.body.append(line)
        # elif stack.top.op == "inherit":
        #     if m := re_find(r"^(\s+)function (\w+)\(([^)]*)\)", line):
        #         prefix, name, params = m
        #         stack.push("=", "func", name, params=params, prefix=prefix)
        #     elif prefix := re_find(r"^(\s+)m = {", line):
        #         stack.push("=", "{", "cls.m", prefix=prefix)
        #     else:
        #         _close_or_unexpected()
        elif stack.top.kind == "{":
            if m := re_find(r"^(\s+)(\w+) = ([{[])\n$", line):
                prefix, key, kind = m
                name = stack.top["name"] + "." + key
                stack.push("key", kind, name, prefix=prefix)
            elif m := re_find(r"^(\s+)(\w+) = ([^{[]+?),?\n$", line):
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


def readlines(filename):
    with open(filename) as fd:
        return fd.readlines()


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


# Diff stuff

def is_line_junk(line, pat=re.compile(r"^\s*(?:$|//)")):
    return isinstance(line, str) and pat.search(line) is not None


# TODO: don't use Differ
class CommentedChanges(Differ):
    def diff(self, a, b):
        self._same = True
        changes = list(self.compare(a, b))
        return self._same, changes

    def compare(self, a, b):
        # Overwrite this to pass autojunk=False
        cruncher = SequenceMatcher(self.linejunk, a, b, autojunk=False)
        for tag, alo, ahi, blo, bhi in cruncher.get_opcodes():
            # print(tag, alo, ahi, blo, bhi)
            # import ipdb; ipdb.set_trace()
            if tag == 'replace':
                yield from self._dump('-', a, alo, ahi, True)
                yield from self._dump('+', b, blo, bhi, True)
            elif tag == 'delete':
                yield from self._dump('-', a, alo, ahi)
            elif tag == 'insert':
                yield from self._dump('+', b, blo, bhi)
            elif tag == 'equal':
                yield from self._dump(' ', a, alo, ahi)
            else:
                raise ValueError('unknown tag %r' % (tag,))

    def _dump(self, tag, x, lo, hi, in_replace=False):
        non_empty = next((line for line in x[lo:hi] if isinstance(line, str) and line != "\n"), "")
        prefix = re_find(r"^([ \t]*)", non_empty)# or "\t\t"
        if tag == "+" and (not in_replace or hi - lo > 1):
            yield prefix + "// START NEW CODE\n"
        # elif tag == "-":
        #     yield prefix + "// DELETED %s\n" % ("BLOCK" if hi - lo > 1 else "LINE")
        for i in range(lo, hi):
            if tag == " ":
                yield x[i]
            elif tag == "+":
                if not is_line_junk(x[i]):
                    self._same = False
                yield x[i]
            elif tag == "-":
                if not is_line_junk(x[i]):
                    self._same = False
                if not isinstance(x[i], Scope):
                    yield prefix + '// ' + x[i].removeprefix(prefix)
        if tag == "+" and (not in_replace or hi - lo > 1):
            yield prefix + "// END NEW CODE\n"


if __name__ == "__main__":
    main()
