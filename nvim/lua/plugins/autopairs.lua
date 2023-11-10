local packadd = require("helpers").packadd

local function configure()
    packadd("nvim-autopairs") -- https://github.com/windwp/nvim-autopairs
    local autopairs = require("nvim-autopairs")
    autopairs.setup({})
end

return {configure = configure}
