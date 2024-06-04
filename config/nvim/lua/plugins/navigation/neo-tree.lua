-- File, buffer, and git status explorer
--
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local opts = {
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
