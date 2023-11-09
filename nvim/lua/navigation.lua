local packadd = require("helpers/packadd")

local function configure_telescope()
    packadd("telescope.nvim")           -- https://github.com/nvim-telescope/telescope.nvim
    packadd("telescope-ui-select.nvim") -- https://github.com/nvim-telescope/telescope-ui-select.nvim

    local telescope = require("telescope")
    telescope.setup(
        {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor()
                }
            }
        }
    )
    telescope.load_extension("ui-select")
end

local function configure_nvim_tree()
    packadd("nvim-tree.lua") -- https://github.com/nvim-tree/nvim-tree.lua
    local nvim_tree = require("nvim-tree")
    nvim_tree.setup(
        {
            filters = { dotfiles = true },
            update_focused_file = { enable = true }
        }
    )
end

return {
    configure = function()
        configure_telescope()
        configure_nvim_tree()
        packadd("vim-rails")
    end
}
