local powernuts = {}

function powernuts.sayNuts()
    require("toggleterm").setup()
    local Terminal  = require('toggleterm.terminal').Terminal
    local command =  powernuts.path..' '..vim.fn.expand('%')
    local squirrel = Terminal:new({ cmd = command, close_on_exit=false, direction="float"})
    squirrel:toggle()

end

function powernuts.sayPath() print(powernuts.path or 'No Path to the squirrel prover specified') end

return powernuts
