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
        buffers = { show_unloaded = true },
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
        window = { position = "right", width = 49 },
    },
}

-- nvim-lsp-file-operations automatically fixes imports whenever we rename a
-- file in neo-tree.
--
-- Neo-tree must load before this, so this depends on the Neo-tree spec.
local neo_tree_file_operations_spec = {
    -- https://github.com/antosha417/nvim-lsp-file-operations
    "antosha417/nvim-lsp-file-operations",
    config = true,
    dependencies = { "nvim-lua/plenary.nvim", neo_tree_spec },
}

return { neo_tree_file_operations_spec }
