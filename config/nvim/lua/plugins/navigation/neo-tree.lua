-- File, buffer, and git status explorer
--
-- https://github.com/nvim-neo-tree/neo-tree.nvim

-- Generate a key mapping that sets the base used to calculate git status.
local function set_git_base(git_base)
    return {
        function(_)
            local neo_tree_command = require("neo-tree.command")
            neo_tree_command.execute({
                action = "focus",
                source = "git_status",
                git_base = git_base,
            })
        end,
        desc = "show diffs from " .. git_base,
    }
end

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
    git_status = {
        window = {
            mappings = {
                ["bh"] = set_git_base("HEAD"),
                ["bl"] = set_git_base("HEAD~1"),
                ["bm"] = set_git_base("main"),
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
