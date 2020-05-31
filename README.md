<!-- 31.05 2020 -->

# bulkmove.sh
shell script for renaming and changing files

Running bulkmove will open the current directory
and let you edit the files in your editor.

## Options
  - `-h`  show short help and exit
  - `-d`  dry run - show the commands, but don't execute them
  - `-e editor`  use editor instead of `$EDITOR`
  - `-f file ...`  specify files to be renamed

## Installation
Run `install.sh`.
Default install is to `/usr/bin/bulkmove`.

## Note
Newlines in file names will break the script
