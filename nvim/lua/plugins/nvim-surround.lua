local function configure()
    vim.cmd.packadd({ "nvim-surround", bang = true }) -- https://github.com/kylechui/nvim-surround
    local surround = require("nvim-surround")
    surround.setup({})
end

return { configure = configure }
