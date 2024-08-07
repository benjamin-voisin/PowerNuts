if exists('g:loaded_powernuts') | finish | endif " prevent loading file twice
let g:loaded_powernuts = 1

let g:squirrel_job = -1
let g:squirrel_channel = -1
let g:squirrel_output = []

autocmd FileType squirrel setlocal commentstring=(*\ %s\ *)

command Nuts call powernuts#Nuts()
command UnNut call powernuts#UnNut()
command PrintSquirrelOutput call powernuts#PrintSquirrelOutput()
command! -nargs=1 SendInputToSquirrel call powernuts#SendInputToSquirrel(<f-args>)
command SquirrelNext call powernuts#NextDotWithoutComment()
nnoremap <leader>sn :SquirrelNext<CR>
command SquirrelGoTo call powernuts#GoTo()
nnoremap <leader>sg :SquirrelGoTo<CR>
command SquirrelPrevious call powernuts#Previous()
nnoremap <leader>sp :SquirrelPrevious<CR>
