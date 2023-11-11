local function configure()
    vim.cmd.packadd({ "nvim-autopairs", bang = true }) -- https://github.com/windwp/nvim-autopairs
    local autopairs = require("nvim-autopairs")
    autopairs.setup({})
end

return { configure = configure }
