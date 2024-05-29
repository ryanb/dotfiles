-- Nightfox colour scheme
--
-- https://github.com/EdenEast/nightfox.nvim

local opts = {
    groups = {
        all = {
            -- Work around this issue:
            -- https://github.com/EdenEast/nightfox.nvim/issues/440
            NeoTreeTitleBar = { fg = "#131a24", bg = "#71839b" },
        },
    },
    options = {
        transparent = true,
    },
}

return {
    "EdenEast/nightfox.nvim",
    opts = opts,
    lazy = false,
    priority = 1000,
}
