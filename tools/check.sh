#!/bin/sh
# Syntax check (LuaJIT = Lua 5.1 grammar) and luacheck for SUI's own code.
# Usage: tools/check.sh [paths...]   (default: Core Config Media Features)
cd "$(dirname "$0")/.." || exit 1
paths=${*:-"Core Config Media Features"}
fail=0
for f in $(find $paths -name '*.lua'); do
    out=$(luajit -bl "$f" 2>&1 >/dev/null) || { echo "SYNTAX $out"; fail=1; }
done
if [ -z "$LUACHECK" ]; then
    if [ -x "$HOME/.luarocks-jit/bin/luacheck" ]; then
        LUACHECK="$HOME/.luarocks-jit/bin/luacheck"
    else
        LUACHECK=luacheck
    fi
fi
"$LUACHECK" $paths --codes --no-color -q || fail=1
# Undefined lowercase globals are almost always typos of locals (WoW's API is
# CamelCase). Known lowercase WoW/Lua globals are allowed.
KNOWN='format|strsplit|strtrim|strjoin|strsub|strfind|strmatch|strlen|strlower|strupper|strrep|gsub|tinsert|tremove|wipe|sort|hooksecurefunc|securecall|securecallfunction|canaccessvalue|issecretvalue|bit|date|time|debugprofilestop|geterrorhandler|seterrorhandler|getglobal|setglobal|floor|ceil|abs|max|min|random|sqrt|mod|string|table|math|coroutine|debug|unpack|select|tostring|tonumber|type|pairs|ipairs|next|rawget|rawset|rawequal|setmetatable|getmetatable|pcall|xpcall|error|assert|print|loadstring|collectgarbage|issecure|forceinsecure|hash_SlashCmdList|scrub|tostringall|strcmputf8i|strlenutf8|strtrim|nop|debuglocals|debugstack|gcinfo|getfenv|setfenv|newproxy|tDeleteItem|tContains|tInvert|tFilter|tIndexOf|securecallmethod|secureexecuterange|issecrettable|canaccesstable|canaccessallvalues|hasanysecretvalues|secretwrap|mapvalues|dropsecretvalues|scrubsecretvalues'
"$LUACHECK" $paths --only 113 --no-config --std lua51 --formatter plain -q 2>/dev/null \
  | grep -E "accessing undefined variable '[a-z]" \
  | grep -vE "variable '($KNOWN)'" && { echo "^ undefined lowercase globals (likely typos)"; fail=1; }
exit $fail
