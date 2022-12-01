#!/usr/bin/env sh

_error() {
    printf '!!! %s !!!\n' "$1"
}

_countLines() {
    if [ $# -gt 0 ]; then
        printf '%s' "$1" | _countLines
        return 0
    fi
    awk '
        BEGIN {
            c = 0;
        }

        1 == 1 {
            c += 1;
        }

        END {
            print c;
        }
    '
}

_range() (
    if [ $# -lt 1 ]; then
        _error 'missing start'
        return 1
    fi
    if [ $# -lt 2 ]; then
        _error 'missing end'
        return 1
    fi
    step=1
    if [ "$1" -gt "$2" ]; then
        step=-1
    fi
    if [ $# -ge 3 ]; then
        step=$3
    fi
    i=$1
    while [ $i -ne $2 ]; do
        printf '%d ' "$i"
        i=$(($i + ($step)))
    done
    printf '%d\n' "$i"
)

_quote() {
    if [ $# -gt 0 ]; then
        printf '%s' "$1" | _quote
        return 0
    fi
    printf '"'
    sed 's|\\|\\\\|g' |
        sed 's|"|\\"|g' |
        sed 's|$|\\n|g' |
        tr -d '\n' |
        sed 's|\\n$||g'
    printf '"'
}

_log() (
    if ! printf '%s' "$1" | grep '^[A-Z]\{3\}$' >/dev/null; then
        _error 'invalid status'
        return 1
    fi
    if [ $# -lt 2 ]; then
        _error 'missing message'
        return 1
    fi
    out="$(date '+%Y-%m-%d %H-%M-%S'): ${1}: ${2}:"
    if [ $# -gt 2 ]; then
        if [ $(($# % 2)) -eq 1 ]; then
            _error 'invalid number of arguments'
            return 1
        fi
        for i in $(_range 3 $#); do
            s=''
            eval "s=\"\$${i}\""
            if [ $(($i % 2)) -eq 1 ]; then
                out="${out} $(_quote "$s")="
            else
                out="${out}$(_quote "$s")"
            fi
        done
    fi
    printf '%s\n' "$out"
)

export TRY_FILE="$(mktemp)"
trap "rm ${TRY_FILE}" EXIT

_try() (
    "$@"
    c=$?
    if [ $c -ne 0 ]; then
        printf '%d %s\n' "$c" "$*" >> "$TRY_FILE"
    fi
    return $c
)

_catch() {
    if [ "$(cat "$TRY_FILE")" = '' ]; then
        return 1
    fi
    cat "$TRY_FILE"
    printf '' > "$TRY_FILE"
    return 0
}
