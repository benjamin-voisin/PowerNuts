if exists('g:loaded_powernuts') | finish | endif " prevent loading file twice
let g:loaded_powernuts = 1

let g:squirrel_job = -1
let g:squirrel_channel = -1
let g:squirrel_output = []

command Nuts call powernuts#Nuts()
command UnNut call powernuts#UnNut()
command PrintSquirrelOutput call powernuts#PrintSquirrelOutput()
command! -nargs=1 SendInputToSquirrel call powernuts#SendInputToSquirrel(<f-args>)
