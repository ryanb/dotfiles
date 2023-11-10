local packadd = require("helpers").packadd

local function configure()
    packadd("lualine.nvim") -- https://github.com/nvim-lualine/lualine.nvim
    local lualine = require("lualine")
    lualine.setup({options = {theme = "auto"}})

    vim.opt.showmode = false -- Lualine shows the mode for us.
    vim.opt.laststatus = 3 -- Use a full-width status line.
end

return {configure = configure}
