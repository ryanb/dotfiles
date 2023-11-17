local function opts()
    return {
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown(),
            },
        },
    }
end

local function init()
    require("telescope").load_extension("ui-select")
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        init = init,
        opts = opts,
    },
    "nvim-telescope/telescope.nvim",
}
