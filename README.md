# DIVIDED WE FALL

This is a command line tool to generate divider-style comments to paste labels in your code.
It won't make ASCII art. Just a simple label surrounded by a border of characters.
Takes arguments to change border thickness, amount of whitespace, border character, and comments style (based on language)


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