local function configure()
    vim.cmd.packadd({ "lualine.nvim", bang = true }) -- https://github.com/nvim-lualine/lualine.nvim
    local lualine = require("lualine")
    lualine.setup({ options = { theme = "auto" } })

    vim.o.showmode = false -- Lualine shows the mode for us.
    vim.o.laststatus = 3 -- Use a full-width status line.
end

return { configure = configure }
