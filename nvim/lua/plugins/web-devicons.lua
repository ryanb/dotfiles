local packadd = require("helpers").packadd

local function configure()
    -- Used for telescope, nvim-tree, and lualine
    packadd("nvim-web-devicons") -- https://github.com/nvim-tree/nvim-web-devicons
    local devicons = require("nvim-web-devicons")
    devicons.setup({default = true})
end

return {configure = configure}
