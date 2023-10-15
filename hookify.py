#!/usr/bin/env python3
from pathlib import Path
import re
import sys
from difflib import Differ, SequenceMatcher
from pprint import pprint
from funcy import re_find, post_processing

SCRIPTS = "/home/suor/_downloads/Battle Brothers mods/bbtmp2/scripts-base/";

def main():
    filename = sys.argv[1]
    force = "-f" in sys.argv

    path = Path(filename)
    if path.is_dir():
        for subfile in path.glob("**/*.nut"):
            hookify(str(subfile), force=force)
    elif path.is_file():
        hookify(filename, force=force)
    else:
        print("File not found: " + filename, file=sys.stderr)
        sys.exit(1)


def hookify(file, force=False):
    # TODO: skip config
    mod_dir, _, cls_path = file.rpartition("scripts/")
    vanilla_file = SCRIPTS + cls_path

    if cls_path.startswith("config/"):
        # print("SKIPPED, hooking configs not implemented")
        return

    if not Path(vanilla_file).exists():
        # print("SKIPPED, no vanilla")
        return

    print(cls_path + "... ", end="")

    defs = bb_defs(file)
    vanilla_defs = bb_defs(vanilla_file)

    # Calc diff
    diff = {}
    for name, block in defs.items():
        vblock = vanilla_defs.get(name)
        if vblock is None:
            diff[name] = block | {"new" : True}
        else:
            if block == vblock:
                continue
            isjunk = lambda s: not s or s.isspace()
            same, body_diff = CommentedChanges(isjunk).diff(vblock["body"], block["body"])
            if same:
                continue
            diff[name] = block | {"body": body_diff, "new": False}

    for name, block in vanilla_defs.items():
        if name not in defs:
            diff[name] = {"delete": True}

    # Create a hooks file
    mod_name = Path(mod_dir).name
    # hooks_path = Path(mod_name, cls_path)
    hooks_file = Path(mod_dir, mod_name, cls_path)

    exists = hooks_file.exists()
    if exists and not force:
        print("SKIPPED, file exists")
        return
    hooks_file.parent.mkdir(parents=True, exist_ok=True)
    hooks_file.write_text("".join(tabs_to_spaces(hook_lines(cls_path, diff))))
    print("UPDATED" if exists else "DONE")


def tabs_to_spaces(lines, num=4):
    for line in lines:
        yield line.replace("\t", " " * num)


def print_defs(defs):
    lines = []
    for name, block in defs.items():
        if name == "m":
            lines.append(f"{block['prefix']}m = {{\n")
        elif name.startswith("m."):
            _open = {"}": "{", "]": "["}[block["close"]]
            lines.append(f"{block['prefix']}{name} = {_open}\n")
        else:
            lines.append(f"{block['prefix']}function {name}({block['params']}) {{\n")
        for line in block["body"]:
            lines.append(line)
        lines.append(block["prefix"] + (block.get("close", "}")) + "\n")
    print("".join(lines))


def hook_lines(cls_path, defs):
    # indent = "\t"
    # yield from (line.replace("\t", indent) for line in block["body"])
    # TODO: tabs to spaces
    yield '::mods_hookExactClass("%s", function(cls) {\n' % cls_path.removesuffix(".nut")
    for name, block in defs.items():
        unindent = False
        if block.get("delete"):
            yield f"\tdelete cls.{name};\n"
            continue
        elif name == "m":
            yield f"\tcls.m = {{\n"
        elif name.startswith("m.") and "value" in block:
            yield f"\tcls.{name} {'<-' if block['new'] else '='} {block['value']};\n"
            continue
        elif name.startswith("m."):
            _open = {"}": "{", "]": "["}[block["close"]]
            yield f"\tcls.{name} {'<-' if block['new'] else '='} {_open}\n"
            unindent = True
        elif block["new"]:
            yield f"\tcls.{name} <- function ({block['params']}) {{\n"
        else:
            yield f"\tlocal {name} = cls.{name};\n"
            yield f"\tcls.{name} = function ({block['params']}) {{\n"
        # body and close
        if unindent:
            yield from (line[1:] for line in block["body"])
        else:
            yield from block["body"]
        yield f"\t{block.get('close', '}')}\n\n"
    yield '}\n';


def bb_defs(filename):
    lines = open(filename).readlines()
    blocks = {}
    scopes = []
    current = None

    def push_scope(name, desc):
        nonlocal current
        blocks[name] = desc
        scopes.append(blocks[name])
        current = desc

    def pop_scope():
        nonlocal current
        scopes.pop()
        current = scopes[-1] if scopes else None

    for line in lines:
        if current is None:
            if m := re_find(r"^(\s+)function (\w+)\(([^)]*)\)", line):
                prefix, name, params = m
                push_scope(name, {"params": params, "prefix": prefix, "body": []})
            elif prefix := re_find(r"^(\s+)m = {", line):
                push_scope("m", {"prefix": prefix, "body": []})
        elif current is blocks.get("m") and (m := re_find(r"^(\s+)(\w+) = ([{[])\n$", line)):
            prefix, name, bracket = m
            close = {"{": "}", "[": "]"}[bracket]
            push_scope("m." + name, {"prefix": prefix, "close": close, "body": []})
        elif current is blocks.get("m") and (m := re_find(r"^(\s+)(\w+) = ([^{[]+?),?\n$", line)):
            prefix, name, value = m
            blocks["m." + name] = {"prefix": prefix, "value": value}
        else:
            if line.startswith(current["prefix"] + current.get("close", "}")):
                pop_scope()
            elif line.startswith(current["prefix"] + "{"): # do not put this to body
                continue
            else:
                current["body"].append(line)
    return blocks


def is_line_junk(line, pat=re.compile(r"^\s*(?:$|//)")):
    return pat.search(line) is not None


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
        non_empty = next((line for line in x[lo:hi] if line != "\n"), "")
        prefix = re_find(r"^([ \t]*)", non_empty)# or "\t\t"
        if tag == "+" and (not in_replace or hi - lo > 1):
            yield prefix + "// START NEW CODE\n"
        # elif tag == "-":
        #     yield prefix + "// DELETED %s\n" % ("BLOCK" if hi - lo > 1 else "LINE")
        for i in range(lo, hi):
            if tag == " ":
                yield x[i]
            if tag == "+":
                if not is_line_junk(x[i]):
                    self._same = False
                yield x[i]
            elif tag == "-":
                if not is_line_junk(x[i]):
                    self._same = False
                yield prefix + '// ' + x[i].removeprefix(prefix)
        if tag == "+" and (not in_replace or hi - lo > 1):
            yield prefix + "// END NEW CODE\n"


if __name__ == "__main__":
    main()
