local function configure()
    vim.cmd.packadd({ "telescope.nvim", bang = true }) -- https://github.com/nvim-telescope/telescope.nvim
    vim.cmd.packadd({ "telescope-ui-select.nvim", bang = true }) -- https://github.com/nvim-telescope/telescope-ui-select.nvim

    local telescope = require("telescope")
    telescope.setup({
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_cursor(),
            },
        },
    })
    telescope.load_extension("ui-select")
end

return { configure = configure }
