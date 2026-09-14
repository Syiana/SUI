#!/bin/sh
# Downloads the libraries listed under "externals" in .pkgmeta into Libs/,
# the same way the release packager does. Needs git and svn
# (macOS: brew install subversion).
#
# Usage: tools/libs.sh           fetch missing libraries
#        tools/libs.sh --update  replace all libraries with the latest version
cd "$(dirname "$0")/.." || exit 1

update=0
[ "$1" = "--update" ] && update=1

command -v git >/dev/null || { echo "git is required"; exit 1; }

fail=0
sed -n '/^externals:/,/^[^ ]/p' .pkgmeta | grep -E '^  Libs/' | while read -r target url; do
    target=${target%:}
    if [ -d "$target" ] && [ $update -eq 0 ]; then
        echo "ok      $target"
        continue
    fi
    rm -rf "$target"
    case "$url" in
        *.git)
            echo "git     $target"
            git clone -q --depth 1 "$url" "$target" && rm -rf "$target/.git" || fail=1
            ;;
        *)
            command -v svn >/dev/null || { echo "svn is required for $target (brew install subversion)"; exit 1; }
            echo "svn     $target"
            svn export -q "$url" "$target" || fail=1
            ;;
    esac
    [ $fail -eq 0 ] || { echo "failed  $target ($url)"; exit 1; }
done
