local packadd = require("packadd")

local function configure_autoclosing()
    packadd("nvim-autopairs") -- https://github.com/windwp/nvim-autopairs
    local autopairs = require("nvim-autopairs")
    autopairs.setup({})

    packadd("nvim-ts-autotag") -- https://github.com/windwp/nvim-ts-autotag
    local autotag = require("nvim-ts-autotag")
    autotag.setup()
end

local function configure_autoformatting()
    packadd("neoformat") -- https://github.com/sbdchd/neoformat
    vim.g.neoformat_try_node_exe = true
end

local function configure_git_signs()
    packadd("gitsigns.nvim") -- https://github.com/lewis6991/gitsigns.nvim
    local gitsigns = require("gitsigns")
    gitsigns.setup()
end

local function configure_telescope()
    packadd("telescope.nvim") -- https://github.com/nvim-telescope/telescope.nvim
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
            filters = {dotfiles = true},
            update_focused_file = {enable = true}
        }
    )
end

return {
    configure = function()
        configure_autoclosing()
        configure_autoformatting()
        configure_git_signs()
        packadd("vim-commentary")
        packadd("vim-rails")
        configure_telescope()
        configure_nvim_tree()
    end
}
