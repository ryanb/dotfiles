-- Quickly open and search files in a project
--
-- https://github.com/nvim-telescope/telescope.nvim

local function config()
    local telescope = require("telescope")

    telescope.setup({
        defaults = {
            layout_strategy = "vertical",
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown(),
            },
        },
    })

    require("telescope").load_extension("ui-select")
end

return {
    "nvim-telescope/telescope.nvim",
    config = config,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-ui-select.nvim",
    },
}
