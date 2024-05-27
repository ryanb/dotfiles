-- Nightfox colour scheme
--
-- https://github.com/EdenEast/nightfox.nvim

local opts = {
    options = {
        module_default = false,
        modules = {
            diagnostic = { enabled = true, background = true },
            gitsigns = true,
            lazy = true,
            lsp_semantic_tokens = true,
            native_lsp = { enabled = true, background = true },
            neotree = true,
            notify = true,
            telescope = true,
            treesitter = true,
            whichkey = true,
        },
        transparent = true,
    },
}

return {
    "EdenEast/nightfox.nvim",
    opts = opts,
    lazy = false,
    priority = 1000,
}
