#!/usr/bin/env sh

_error() {
    printf '!!! %s !!!\n' "$1"
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
