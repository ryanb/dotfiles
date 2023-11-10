local packadd = require("helpers").packadd

local function configure()
    packadd("nvim-tree.lua") -- https://github.com/nvim-tree/nvim-tree.lua
    local nvim_tree = require("nvim-tree")
    nvim_tree.setup(
        {
            update_focused_file = {enable = true},
            view = {width = 40}
        }
    )

    local nvim_tree_api = require("nvim-tree.api")

    vim.keymap.set("n", "<leader>fe", nvim_tree_api.tree.toggle, {desc = "file explorer"})
end

return {configure = configure}
