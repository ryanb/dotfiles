-- neo-tree gives us a sidebar in which we can explore the file system, open
-- buffers, or files changed by git.
local neo_tree_spec = {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker",
    },
    opts = {
        bind_to_cwd = false,
        default_component_configs = {
            diagnostics = {
                -- The neo-tree docs say these should be read from the signs we
                -- define in signs.lua, but it doesn't seem to work so we need to
                -- set them here.
                symbols = { error = "󰅚 ", hint = "󰌶", info = "󰋽 ", warn = "󰀪 " },
            },
            indent = { with_markers = false },
        },
        filesystem = {
            follow_current_file = {
                enabled = false,
                leave_dirs_open = false,
            },
            use_libuv_file_watcher = true,
            window = {
                mappings = {
                    ["<space>"] = "none", -- Let our leader key work in the explorer.
                },
            },
        },
        sources = { "filesystem", "buffers", "git_status" },
        use_popups_for_input = true,
        window = { width = 50 },
    },
}

local neo_tree_file_operations_spec = {
    "antosha417/nvim-lsp-file-operations",
    config = true,
    dependencies = { "nvim-lua/plenary.nvim" },
}

local telescope_spec = {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = { layout_strategy = "vertical" },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        })
        require("telescope").load_extension("ui-select")
    end,
}

return {
    neo_tree_spec,
    neo_tree_file_operations_spec,
    telescope_spec,
}
