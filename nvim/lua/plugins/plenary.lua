local packadd = require("helpers").packadd

local function configure()
    packadd("plenary.nvim")
end

return {configure = configure}
