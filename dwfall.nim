# dwfall.nim

import os, strutils, parseopt

# Defaults
var whitespace: int = 4
var vert_border_units: int = 2
var horz_border_units: int = 5

var border_char: char = '='
var comment_body_str: string = " * "
var comment_start_str: string = "/* "
var comment_end_str: string = " */"

let param_count = paramCount()
# Check if at least one argument is given
if param_count < 1:
    echo "Usage: dwfall \"label text\""
    quit(1)

let label_text: string = paramStr(1)


# Override defaults with user input
if param_count > 2:
    echo "checking params"
    echo "param count: " & $param_count
    for param_index in 2..<param_count:
        let arg = paramStr(param_index)

        if arg == "--borderh":
            # set horizontal border size. min 1 max 10

            if param_index + 1 <= param_count:
                let borderh_val: string = paramStr(param_index + 1)
                try:
                    var num = borderh_val.parseInt()
                    if num < 1:
                        num =1
                    elif num > 10:
                        num = 10
                        echo "borderh max 10"
                    horz_border_units = num
                except:
                    echo "cannot parse borderh to int"
        elif arg == "--borderv":
            # set vertical border size. min 1 max 5
            if param_index + 1 <= param_count:
                let borderv_val: string = paramStr(param_index + 1)
                try:
                    var num = borderv_val.parseInt()
                    if num < 1:
                        num =1
                    elif num > 5:
                        num = 5
                        echo "borderv max 5"
                    vert_border_units = num
                except:
                    echo "cannot parse borderv to int"
        elif arg == "--borderchar":
            # set vertical border size. min 1 max 10
            if param_index + 1 <= param_count:
                let border_char_str = paramStr(param_index + 1)
                if border_char_str.len > 0:
                    border_char = border_char_str[0]
        elif arg == "--whitespace":
            # set whitespace. min 0 max 10
            if param_index + 1 <= param_count:
                let whitespace_str = paramStr(param_index + 1)
                try:
                    var num = whitespace_str.parseInt()
                    if num < 0:
                        num =0
                    elif num > 10:
                        num = 10
                        echo "whitespace max 10"
                    whitespace = num
                except:
                    echo "cannot parse whitespace to int"


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
