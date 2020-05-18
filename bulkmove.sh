#!/bin/sh
# date: 17.05 2020
# vim: expandtab

logfile='./.move'
quiet='false'
editor="${EDITOR:-'ed'}"

movecmd='
  if [ -e "$1" ] && [ "$2" ]; then
    [ "$1" = "$2" ] || mv "$1" "$2"
  elif [ ! "$2" ]; then
    rm "$1"
  else
    rm "$2"
  fi '

movedry='
  if [ -e "$1" ] && [ "$2" ]; then
    [ "$1" = "$2" ] || echo mv "$1" "$2" >&2
  elif [ ! "$2" ]; then
    echo rm "$1" >&2
  else
    echo rm "$2" >&2
  fi '


### options:

while [ "$1" ]; do
    case "$1" in
        (-d) movecmd="$movedry" ;;
        (-l) logmove='true' ;;
        (-p) movecmd="$movedry;$movecmd" ;;
        (-q) quiet='true' ;;
        (-e)
            shift
            editor="$1"
            ;;
        (-f)
            shift
            if [ ! "$1" ] && [ ! -e "$1" ]; then
                $quiet || echo log file not found >&2
                exit 1
            fi
            cat "$1" | xargs -n 2 sh -c "$movecmd" move
            exit 0;
            ;;
        (-h)
            echo "usage: $0 [-d|-p] [-ql] [-e editor] [file ...]" >&2
            echo "       $0 [-d|-p] [-q] [-f log_file]" >&2
            exit 0
            ;;
        (*)
            alias ls='while [ "$1" ]; do echo "$1"; shift; done'
            break
            ;;
    esac
    shift
done


### main:

old=`mktemp`
new=`mktemp`

trap "rm '$old' '$new'; exit 1" HUP INT QUIT TERM

if [ ! -e $old ] || [ ! -e $new ]; then
    $quiet || echo temp file cannot be obtained >&2
    exit 1
fi


ls | sed 's/"/"\\""/g; s/^/&"/; s/$/"/' | nl > $old
cp $old $new

$editor $new

join -a 1 -t "\t" -o "1.2 2.2" $old $new | \
    xargs -n 2 sh -c "$movecmd" move


if [ $logmove ]; then
    join -a 1 -t "\t" -o "1.2 2.2" $old $new >| $logfile
    $quiet || {
        echo -n 'log file created  ' >&2
        echo $logfile
    }
fi


rm "$old" "$new"