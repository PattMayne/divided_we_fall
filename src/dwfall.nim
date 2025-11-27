# dwfall.nim

 #[ 
 # 
 # 
 # 
 # 
 # =============================
 # =============================
 # =====                   =====
 # =====  DIVIDED WE FALL  =====
 # =====                   =====
 # =============================
 # =============================
 # 
 # 
 # A script to generate divider labels (such as the one just above)
 # 
 # 
 # 
]#

import os, strutils
const AppVersion* = "0.3.7"

 #[ 
 # ======================================
 # =======                        =======
 # =======  FORWARD DECLARATIONS  =======
 # =======                        =======
 # ======================================
]#

proc print_version()
proc print_help()
proc set_borderh(param_index: int)
proc set_borderv(param_index: int)
proc set_whitespace(param_index: int)
proc set_borderchar(param_index: int)
proc set_lang_style(param_index: int)
let params = commandLineParams()
if params.contains("--help") or params.contains("-H"):
    print_help()
    quit() # Exit after showing help
elif params.contains("--version") or params.contains("-V"):
    print_version()
    quit()


 #[ 
 # ===================================================
 # =======                                     =======
 # =======  OBJECTS, ENUMS, & SUPPORTED LANGS  =======
 # =======                                     =======
 # ===================================================
]#


# The main representative language strings
type Styles = enum
    C = "c",
    Hash = "hash",
    Lisp = "lisp",
    Lua = "lua",
    HTML = "html",
    Nim = "nim",
    Zig = "zig",
    OCaml = "ocaml"
    Haskell = "haskell"


# Which strings mark the beginning of the multi-line comment style,
# the body of the continuing multi-line comment,
# and the closing of the multi-line comment.
type StyleData = object
    first: string
    body: string
    last: string


# constructor for the StyleData object
proc new_style_data(first_s: string, body_s: string, last_s: string): StyleData = 
    result.first = first_s
    result.body = body_s
    result.last = last_s


# categories of styles for reference and reduction
let c_styles = ["rust", "c++", "css", "c#", "sql", "javascript", "java", "swift", "odin", "c"]
let lisp_styles = ["clojure", "scheme", "lisp"]
let hash_styles = ["bash", "ruby", "python", "hash"]
let html_styles = ["xml", "html"]


# Allow the user to enter a broad range of language inputs,
# but reduce them to representative lang string (from Styles enum)
proc reduce_to_category(word: string): string =
    let word = word.toLower()
    if word in c_styles:
        return "c"
    elif word in lisp_styles:
        return "lisp"
    elif word in hash_styles:
        return "hash"
    elif word in html_styles:
        return "html"
    else:
        return word


# Takes a representative language string,
# maps it only the string of the Styles enums,
# and returns a style object so we can build multi-line comments for that language.
proc get_style_from_input(input: string): StyleData =
    let reduced_input = reduce_to_category(input)
    case reduced_input
    of $C:
        result = new_style_data("/* ", " * ", "*/")
    of $Hash:
        result = new_style_data("# ", "# ", "# ")
    of $Lisp:
        result = new_style_data("; ", "; ", "; ")
    of $Lua:
        result = new_style_data("--[[", "  ", "]] ")
    of $HTML:
        result = new_style_data("<!--", "  ", "--> ")
    of $Haskell:
        result = new_style_data("{- ", " - ", " -}")
    of $Nim:
        result = new_style_data(" #[ ", " # ", "]#")
    of $Zig:
        result = new_style_data("// ", "// ", "// ")
    of $OCaml:
        result = new_style_data("(* ", " * ", " *)")
    else:
        let err_string: string = input & " is not a valid input for --style. See --help for input options chart."
        echo " "
        echo err_string
        echo " "
        quit()


 #[ 
 # ssssssssssssssssssssssssssssssss
 # sssssss                  sssssss
 # sssssss  DEFAULT STYLES  sssssss
 # sssssss                  sssssss
 # ssssssssssssssssssssssssssssssss
]#


var whitespace: int = 4
var vert_border_units: int = 2
var horz_border_units: int = 5

var style_data = get_style_from_input("c")
var border_char: char = '='



 #[ 
 # ====================================
 # =======                      =======
 # =======  PROCESS USER INPUT  =======
 # =======                      =======
 # ====================================
]#


let param_count = paramCount()
# Check if at least one argument is given
if param_count < 1:
    echo "Usage: dwfall \"label text\" [options] (see --help for more details)"
    quit(1)

# Label text must always be the first param
let label_text: string = paramStr(1)

# Override defaults with user input (starting after label param)
if param_count > 2:
    for param_index in 2..<param_count:
        let arg = paramStr(param_index).toLowerAscii()

        if arg == "--borderh":
            set_borderh(param_index)
        elif arg == "--borderv":
            set_borderv(param_index)
        elif arg == "--borderchar":
            set_borderchar(param_index)
        elif arg == "--whitespace":
            set_whitespace(param_index)
        elif arg == "--style":
            set_lang_style(param_index)


# set horizontal border size. min 1 max 15
proc set_borderh(param_index: int) =
    if param_index + 1 <= param_count:
        let borderh_val: string = paramStr(param_index + 1)
        try:
            var num = borderh_val.parseInt()
            if num < 1:
                num =1
            elif num > 15:
                num = 15
                echo "borderh max 15"
            horz_border_units = num
        except:
            echo "cannot parse borderh to int"


# set vertical border size. min 1 max 10
proc set_borderv(param_index: int) =
    if param_index + 1 <= param_count:
        let borderv_val: string = paramStr(param_index + 1)
        try:
            var num = borderv_val.parseInt()
            if num < 1:
                num =1
            elif num > 10:
                num = 10
                echo "borderv max 10"
            vert_border_units = num
        except:
            echo "cannot parse borderv to int"



# set whitespace. min 0 max 10
proc set_whitespace(param_index: int) =
    if param_index + 1 <= param_count:
        let whitespace_str = paramStr(param_index + 1)
        try:
            var num = whitespace_str.parseInt()
            if num < 0:
                num =0
            elif num > 10:
                num = 10
                echo "whitespace max 15"
            whitespace = num
        except:
            echo "cannot parse whitespace to int"


# set vertical border size. min 1 max 10
proc set_borderchar(param_index: int) =
    if param_index + 1 <= param_count:
        let border_char_str = paramStr(param_index + 1)
        if border_char_str.len > 0:
            border_char = border_char_str[0]


# match it to one of the style enums, which match to prefab style obejcts
proc set_lang_style(param_index: int) =
    if param_index + 1 <= param_count:
        let style_input_str = reduce_to_category(paramStr(param_index + 1))
        style_data = get_style_from_input(style_input_str)


 #[ 
 # ==================================
 # =======                    =======
 # =======  BUILD THE OUTPUT  =======
 # =======                    =======
 # ==================================
]#


# create the template for the layers of border sitting above the label
let top_border_width: int = label_text.len + (horz_border_units * 2) + 4

var horz_border_str: string = ""
for i in 1..horz_border_units:
    horz_border_str.add($border_char)

var top_border_string: string = ""
top_border_string.add(style_data.body)

for i in 1..top_border_width:
    top_border_string.add($border_char) # $ converts to string in this case

# create gap string (the string between the label and the borders)
var gap_str: string = ""
gap_str.add(style_data.body)
gap_str.add(horz_border_str)

for i in 1..(label_text.len + 4):
    gap_str.add(" ")

gap_str.add(horz_border_str)

let label_string: string = style_data.body & horz_border_str & "  " & label_text & "  " & horz_border_str

# emtpy sequence of strings
var strings: seq[string] = @[]

# start the multi-line comment
strings.add(style_data.first)

# make the TOP whitespace
for i in 1..whitespace:
    strings.add(style_data.body)

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
    strings.add(style_data.body)

# end the multi-line comment
strings.add(style_data.last)


 #[ 
 # ==================================
 # =======                    =======
 # =======  PRINT THE OUTPUT  =======
 # =======                    =======
 # ==================================
]#

for i in 0..<strings.len:
    echo strings[i]


proc print_version() =
    echo "Divided We Fall version ", AppVersion


proc print_help() =
      echo """
This program prints a divider label with adjustable params.

Usage: dwfall "label to print" [options]
Options:
  -h, --help    Show this help message
  -v, --version Show version
  --borderh <integer>       border width
  --borderv <integer>       border height
  --whtiespace <integer>    blank space above/below borders
  --borderchar <char>       character used for border
  --style <language>        comment syntax. See chart below.

    STYLE OPTIONS CHART:
    
    INPUT:  : OTHER LANGS COVERED
    html    : xml
    c       : Rust, C++, CSS, C#, SQL, JavaScipt, Java, Swift, Odin
    lisp    : Clojure, Scheme
    lua
    hash    : bash, ruby, python
    haskell
    zig
    ocaml
    nim
"""


