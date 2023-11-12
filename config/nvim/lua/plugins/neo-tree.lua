local function configure()
    vim.cmd.packadd({ "nui.nvim", bang = true }) -- https://github.com/MunifTanjim/nui.nvim
    vim.cmd.packadd({ "neo-tree.nvim", bang = true }) -- https://github.com/nvim-neo-tree/neo-tree.nvim
    local neotree = require("neo-tree")
    neotree.setup({
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "document_symbols",
        },
        bind_to_cwd = false,
        use_popups_for_input = false,
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
    })
end

return { configure = configure }
