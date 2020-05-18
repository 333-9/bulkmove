<!-- 18.05 2020 -->

# bulkmove.sh
shell script for renaming and changing files

Running bulkmove will open the current directory
and let you edit the files in your editor.

## Options
  - `-h`  show short help and exit
  - `-d`  dry run - show the commands, but don't execute them
  - `-p`  print commands as they are executed
  - `-q`  don't print debug messages
  - `-l`  write changes to a logfile
  - `-f file`    don't open an editor, but read from a generated logfile
  - `-e editor`  use editor instead of `$EDITOR`

## Usage
bulkmove should open your editor with a file that looks like this:
```
     1	"foo"
     2	"bar"
	...
```
the line numbers are important and removing them will likely result in errors.
To remove files you should remove the name, not the whole line:
```
     1	""
     2	"foo"
```
note that quotes are not part of the name.
You can also move files to different directories:
```
     1	"baz/"
     2	"baz/"
```

## Installation
Run `install.sh`.
You can edit `dir` and `name` variables for your system.
The default install is to `/usr/bin/bulkmove`.

## Example
``` sh
bulkmove -d -l -e vim *.h
# edit all .h files and save the changes into a logfile without executing them.

bulkmove -f .move
# execute changes.
```

## Note
Special characters, such as newlines, quotes and tabs might
break the script or behave unexpectedly.
As of now the script does not stop at the first error,
but continues until end of file.
