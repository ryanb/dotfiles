local function configure()
    vim.g.mapleader = ","

    -- Shortcuts for navigation between windows
    vim.keymap.set("n", "<c-h>", "<c-w>h")
    vim.keymap.set("n", "<c-j>", "<c-w>j")
    vim.keymap.set("n", "<c-k>", "<c-w>k")
    vim.keymap.set("n", "<c-l>", "<c-w>l")

    -- Reselect the visual area when changing indenting in visual mode.
    vim.keymap.set("v", "<", "<gv")
    vim.keymap.set("v", ">", ">gv")

    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "show diagnostic" })
end

return { configure = configure }
