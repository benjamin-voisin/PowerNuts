vim.api.nvim_create_user_command('Nuts', 'lua require("powernuts").sayNuts()', {})
vim.api.nvim_create_user_command('NutsPath', 'lua require("powernuts").sayPath()', {})

vim.api.nvim_create_user_command('UnNut', 'lua require("powernuts").unNut()', {})


