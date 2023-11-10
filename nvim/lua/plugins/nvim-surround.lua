local packadd = require("helpers").packadd

local function configure()
    packadd("nvim-surround") -- https://github.com/kylechui/nvim-surround
    local surround = require("nvim-surround")
    surround.setup({})
end

return {configure = configure}
