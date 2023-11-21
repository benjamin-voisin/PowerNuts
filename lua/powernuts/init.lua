local powernuts = {}

-- vim.cmd(":autocmd BufEnter * if tabpagenr('$') == 2 && winnr('$') == 2 && exists('b:info0') && exists('b:goal0') | quit | endif")

function powernuts.setup(table)
    powernuts.path = table["path"] or "No path to the squirrel prover specified"
end

local function get_buf(name)
    local buffers = vim.api.nvim_list_bufs()
    for i = 1, #buffers, 1 do
        if (string.sub(vim.api.nvim_buf_get_name(buffers[i]), -(#name)) == name) then
            return buffers[i]
        end
    end
end

local function get_win(name)
    local windows = vim.api.nvim_list_wins()
    for i = 1, #windows, 1 do
        if (string.sub(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(windows[i])), -(#name)) == name) then
            return windows[i]
        end
    end
end

local function get_ascii(path)
    local lines = {}
    for line in io.lines(path) do
        lines[#lines + 1] = line
    end
    return lines
end


function powernuts.sayNuts()
    require("toggleterm").setup()
    local Terminal  = require('toggleterm.terminal').Terminal
    local command =  powernuts.path..' '..vim.fn.expand('%')
    local squirrel = Terminal:new({ cmd = command, close_on_exit=false, direction="float"})
    vim.cmd(":set splitright | vnew info0 |  new goal0 | winc h")
    -- squirrel:toggle()
    -- print(vim.api.nvim_buf_get_name(vim.api.nvim_list_wins()[1]))

    -- vim.api.nvim_buf_set_text(get_buf("info0"), 0, 0, 0, 0, get_ascii("assets/squirrels.txt"))

end

function powernuts.unNut()
    vim.api.nvim_buf_delete(get_buf("goal0"), {force = true})
    vim.api.nvim_buf_delete(get_buf("info0"), {force = true})
end

function powernuts.sayPath() print(powernuts.path) end

return powernuts
