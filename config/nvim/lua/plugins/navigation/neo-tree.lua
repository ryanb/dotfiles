-- File, buffer, and git status explorer
--
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local opts = {
    sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
    },
    bind_to_cwd = false,
    use_popups_for_input = true,
    default_component_configs = {
        indent = {
            with_markers = false,
        },
    },
    filesystem = {
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
        window = {
            mappings = {
                ["<space>"] = "none", -- Let our leader key work in the explorer.
            },
        },
    },
}

return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker",
    },
    opts = opts,
}
