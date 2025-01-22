# Migrates Adam's hooks to Modern ones
# Shitty script made by ChatGPT, somewhat fixed and complemented by me
# Usage:
#
#   python migrate_hooks.py path/to/file
#   python migrate_hooks.py path/to/file -i  # do it inplace
#
# Requires Python 3.12, no other deps

import ast
import os
import re
import sys


def update_code(file_path, inplace=False, mhvar="mod"):
    # Detect newline style, then read converting to \n for easier handling
    with open(file_path, 'rb') as file:
        line = file.readline()
        newline = detect_newline_style(line)
    with open(file_path, 'r') as file:
        content = file.read()

    m = re.search(rf'local {mhvar}\s*=\s*(?:::|{{)(\w+)', content)
    have_mhvar = m and m[1] != "Hooks"
    have_def = bool(re.search(r'local def\s*=\s*(::|{)', content))
    if have_mhvar and not have_def:
        content = replace_word_in_code(content, mhvar, "def")
        have_def = True

    # Step 1: Rewrite some calls
    content = re.sub(r'::mods_registerMod\((.*?)\)',
                    rf'local {mhvar} = {"def.mh <- " if have_def else ""}::Hooks.register(\1)', content)
    content = re.sub(r'::mods_register(JS|CSS)\((.*?)\)',
        lambda m: rf'::Hooks.register{m[1]}("{"ui/mods/" + ast.literal_eval(m[2])}")', content)

    content = re.sub(r'(if\s*\([^)]*?)::mods_getRegisteredMod\((.*?)\)', r'\1::Hooks.hasMod(\2)', content)
    content = re.sub(r'::mods_getRegisteredMod\((.*?)\)', r'::Hooks.getMod(\1)', content)

    content = update_queue_calls(content)

    # Step 2: Replace hook parameter (e.g., cls, obj) with `q` in the function definition and body scope
    def replace_hook(match):
        hook = match[1] or ""
        path = match[2]
        func_ws = match[3]
        param = match[4]
        body = match[5]
        # print(match)
        # import ipdb; ipdb.set_trace()

        # Replace instances of the parameter name only in the function body
        body = replace_word_in_code(body, param, 'q')

        # "key" in q tests do not work, should use q.contains("key")
        body = re.sub(r'(\(\s*)?("\w+")\s*in\s*q\b(?(1)\s*\)|)', r'q.contains(\2)', body)

        typ = ""
        if hook in {"Class", "BaseClass"}:
            old_body = body
            body = re.sub(rf'^\s*\bq\s*=\s*q(\[q\.SuperName\]|\.\w+);?\s*$',
                 '', body, flags=re.MULTILINE)
            if body == old_body:
                typ = "Tree"
        elif hook == "Descendants":
            typ = "Tree"

        return f"{mhvar}.hook{typ}(\"scripts/{path}\",{func_ws}function (q) {body}"

    content = replace_body(
        r'::mods_hook(ExactClass|NewObject(?:Once)?|Class|BaseClass|Descendants)'
        r'\("([^"]+)",(\s*)function\s*\(\s*(\w+)\s*\)\s*{',
        replace_hook, content, flags=re.DOTALL)

    # Step 3: Remove `local funcName = q.funcName;` lines
    content = re.sub(r'local\s+\w+\s*=\s*q\.\w+;\s*', '', content)

    # Step 4: Add @(__original) for all function assignments within the hook, capturing any arguments
    def replace_function(match):
        function_name = match[1]
        args = match[2]
        body = match[3]

        # Replace the old function name with __original in the body
        updated_body = re.sub(rf'(?<!\.)\b{re.escape(function_name)}\b', '__original', body)

        return f'q.{function_name} = @(__original) function ({args}) {updated_body}'

    # Apply the replacement on each matched function assignment, expanding to capture full body with nested braces
    content = replace_body(
        r'q\.(\w+)\s*=\s*function\s*\((.*?)\)\s*{', replace_function, content, flags=re.DOTALL)

    # Save the updated content back to the file
    if inplace:
        new_path = file_path
    else:
        name, ext = os.path.splitext(file_path)
        new_path = f"{name}_new{ext}"

    with open(new_path, 'w', newline=newline) as file:
        file.write(content)


def update_queue_calls(content):
    # Pattern to match the ::mods_queue calls
    pattern = re.compile(r'::mods_queue\(([^,]+),\s*("[^"]+"|null),\s*function\s*\(\)\s*{')

    def replacement(match):
        mod_id = match.group(1)
        requirements = match.group(2)

        # def translate_req(item):

        # Split the requirements into individual items
        items = [] if requirements == "null" else requirements.strip('"').split(",")
        require, conflict, queue = [], [], []

        for item in items:
            item = item.strip()
            m = re.search(r"^([!><])?\s*([^ ()]+)(?:\(([><!]=?)\s*([^ )]+)\))?", item)

            if not m:
                if item: require.append(item)  # This is weird but save it to not loose it
                continue

            queue_op, mod, op, version = m.groups()
            if mod == "mod_hooks":
                continue

            expr = f"{mod} {op} {version}" if op else mod
            queue_expr = f"{queue_op or '>'}{mod}"

            if queue_op is None:
                require.append(expr)
                queue.append(queue_expr)
            elif queue_op == "!":
                conflict.append(expr)
            elif queue_op in "><":
                queue.append(queue_expr)

        def make_args(items):
            return ", ".join(f'"{item}"' for item in items)

        # Build the replacement strings
        require_str = f'{mhvar}.require({make_args(require)});\n' if require else ''
        conflict_str = f'{mhvar}.conflictWith({make_args(conflict)});\n' if conflict else ''
        queue_str = f'{mhvar}.queue({make_args(queue) + ", " if queue else ""}function () {{'

        # Combine require and queue with the function body
        return f"{require_str}{conflict_str}{queue_str}"

    # Replace all matches in the content
    content = pattern.sub(replacement, content)
    return content


def replace_word_in_code(content, old_word, new_word):
    def repl(match):
        code = match[1] # Code before the comment
        comment = match[2] # Comment part starting with //
        # print(code, comment)

        # Replace the word in the code part only
        updated_code_part = re.sub(rf'\b{re.escape(old_word)}\b', new_word, code)

        # Return combined code and comment parts
        return f"{updated_code_part}{comment or ''}"

    # Perform the replacement line by line
    return re.sub(r'^(.*?)(//.*)?$', repl, content, flags=re.MULTILINE)


def replace_body(pat, repl, content, flags=None):
    pos, res = 0, ""
    for match in re.finditer(pat, content, flags=flags):
        res += content[pos:match.start()]

        assert content[match.end() - 1] == "{"
        pos = find_matching_brace(content, match.end())
        res += repl([None] + list(match.groups()) + [content[match.end()-1:pos]])

    res += content[pos:]
    return res


def find_matching_brace(content, start_index):
    """Find the position of the matching closing brace for the opening brace at start_index."""
    stack = 1
    for i in range(start_index + 1, len(content)):
        if content[i] == '{':
            stack += 1
        elif content[i] == '}':
            stack -= 1
        if stack == 0:
            return i
    return -1


def detect_newline_style(content):
    if b'\r\n' in content:
        return '\r\n'  # CRLF (Windows)
    elif b'\r' in content:
        return '\r'    # CR (Old Mac)
    else:
        return '\n'    # LF (Unix)


mhvar = next((a[2:] for a in sys.argv if a.startswith("-m")), "mod")
update_code(sys.argv[1], inplace="-i" in sys.argv, mhvar=mhvar)
