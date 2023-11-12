local function configure()
    vim.cmd.packadd({ "nvim-tree.lua", bang = true }) -- https://github.com/nvim-tree/nvim-tree.lua
    local nvim_tree = require("nvim-tree")
    nvim_tree.setup({
        update_focused_file = { enable = true },
        view = { width = 40 },
    })
end

return { configure = configure }
