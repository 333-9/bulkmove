#!/bin/sh
# date: 17.05 2020
# vim: expandtab
editor="${EDITOR:-'ed'}"
cmd='move'
escape='s/"/\"/g; s/^.*$/"&"/'
movecmd=\
'[ $0 = dry ] && alias mv="echo mv" rm="echo rm"
if   [ "$2" = //  ];   then  rm "$1"
elif [ "$1" != "$2" ]; then  mv "$1" "$2"; fi'

err() { echo $1 >&2 ; exit 1; }

while [ "$1" ]; do
    case "$1" in
        (-d) cmd='dry';;
        (-e) shift; editor="$1";;
        (-h) echo "usage: bulkmove [-d] [-e editor]" >&2; exit;;
    esac; shift
done

old=`mktemp` && new=`mktemp` ||
    err 'temp file cannot be created'

ls | tee $new | sed "$escape" > $old

$editor $new

[ `cat $old | wc -l` != `cat $new | wc -l` ] &&
    err 'added or deleted lines'

cat $new | sed "$escape" | paste $old - |
    xargs -n 2 sh -c "$movecmd" "$cmd"

rm $old $new