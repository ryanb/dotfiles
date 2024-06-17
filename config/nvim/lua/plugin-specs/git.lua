-- Show git differences in the gutter to the left of the file being edited,
-- and perform other basic git operations.
local gitsigns_spec = {
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    opts = {},
}

-- View and manipulate a git repo with LazyGit in a window.
--
-- (LazyGit is no relation to lazy.nvim.)
local lazygit_spec = {
    -- https://github.com/kdheepak/lazygit.nvim
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.g.lazygit_floating_window_use_plenary = 1
    end,
}

return { gitsigns_spec, lazygit_spec }
