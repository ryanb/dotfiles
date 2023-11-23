-- https://github.com/nvim-telescope/telescope.nvim

local function config()
    local telescope = require("telescope")

    telescope.setup({
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
