-- Gives us nicer UI for vim.ui.input and vim.ui.select
--
-- https://github.com/stevearc/dressing.nvim

local opts = {
    input = {
        min_width = 60,
    },
}

return { "stevearc/dressing.nvim", opts = opts }
