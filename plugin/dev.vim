function! ReloadAlpha()
lua << EOF
    for k in pairs(package.loaded) do 
        if k:match("^hello") then
            package.loaded[k] = nil
        end
    end
EOF
endfunction

" Reload the plugin
nnoremap <Leader>era :call ReloadAlpha()<CR>

" Test the plugin
nnoremap <Leader>eta :lua require("powernuts").sayNuts()<CR>
