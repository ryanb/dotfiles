local packadd = require("helpers").packadd

local function configure()
    packadd("gitsigns.nvim") -- https://github.com/lewis6991/gitsigns.nvim
    local gitsigns = require("gitsigns")
    gitsigns.setup()
end

return {configure = configure}
