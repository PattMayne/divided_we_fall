# dwfall.nim

import os, strutils

# Defaults
var whitespace: int = 4
var vert_border_units: int = 2
var horz_border_units: int = 5

var border_char: char = '='
var comment_body_str: string = " * "
var comment_start_str: string = "/* "
var comment_end_str: string = " */"


# Check if at least one argument is given
if paramCount() < 1:
    echo "Usage: dwfall \"label text\""
    quit(1)

let label_text: string = paramStr(1)

# create the template for the layers of border sitting above the label
let top_border_width: int = label_text.len + (horz_border_units * 2) + 4

var horz_border_str: string = ""
for i in 1..horz_border_units:
    horz_border_str.add($border_char)

var top_border_string: string = ""
top_border_string.add(comment_body_str)

for i in 1..top_border_width:
    top_border_string.add($border_char) # $ converts to string in this case

# create gap string (the string between the label and the borders)
var gap_str: string = ""
gap_str.add(comment_body_str)

gap_str.add(horz_border_str)

for i in 1..(label_text.len + 4):
    gap_str.add(" ")

gap_str.add(horz_border_str)

let label_string: string = comment_body_str & horz_border_str & "  " & label_text & "  " & horz_border_str

# TO DO: get args adjusting whitespace and vert_border_units, to change the number of strings to print.
# TO DO: adjust the style (c-style is default. Allow for python, lua, whatever)

# emtpy sequence of strings
var strings: seq[string] = @[]

# start the multi-line comment
strings.add(comment_start_str)

# make the TOP whitespace
for i in 1..whitespace:
    strings.add(comment_body_str)

# make the TOP border
for i in 1..vert_border_units:
    strings.add(top_border_string)

# the actual label, surrounded by gap strings
strings.add(gap_str)
strings.add(label_string)
strings.add(gap_str)

# NOW WE BASICALLY REVERSE IT

# make the BOTTOM border
for i in 1..vert_border_units:
    strings.add(top_border_string)

# make the BOTTOM whitespace
for i in 1..whitespace:
    strings.add(comment_body_str)

# end the multi-line comment
strings.add(comment_end_str)

# now print it all out

for i in 0..<strings.len:
    echo strings[i]

# TO DO: make a help output for the --help flag
# TO DO: versions and a --version output