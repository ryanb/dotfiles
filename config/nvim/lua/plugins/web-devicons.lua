local function configure()
    -- Used for telescope, nvim-tree, and lualine
    vim.cmd.packadd({ "nvim-web-devicons", bang = true }) -- https://github.com/nvim-tree/nvim-web-devicons
    local devicons = require("nvim-web-devicons")
    devicons.setup({ default = true })
end

return { configure = configure }
