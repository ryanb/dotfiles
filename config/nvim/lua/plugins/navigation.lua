-- neo-tree gives us a sidebar in which we can explore the file system, open
-- buffers, and files changed by git.
local neo_tree_spec = {
    -- https://github.com/nvim-neo-tree/neo-tree.nvim
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
                -- Set the diagnostic signs to match lualine's.
                symbols = { error = "󰅚 ", hint = "󰌶", info = "󰋽 ", warn = "󰀪 " },
            },
            indent = { with_markers = false },
        },
        filesystem = {
            follow_current_file = { enabled = false, leave_dirs_open = false },
            use_libuv_file_watcher = true,
        },
        hide_root_node = true,
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
            content_layout = "center",
            sources = {
                { source = "filesystem" },
                { source = "git_status" },
                { source = "buffers" },
            },
            statusline = true,
        },
        window = { width = 49 },
    },
}

-- nvim-lsp-file-operations automatically fixes imports whenever we rename a
-- file in neo-tree.
local neo_tree_file_operations_spec = {
    -- https://github.com/antosha417/nvim-lsp-file-operations
    "antosha417/nvim-lsp-file-operations",
    config = true,
    dependencies = { "nvim-lua/plenary.nvim" },
}

-- telescope does fuzzy finding over all sorts of things.
local telescope_spec = {
    -- https://github.com/nvim-telescope/telescope.nvim
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
