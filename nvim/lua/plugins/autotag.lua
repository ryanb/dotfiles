local packadd = require("helpers").packadd

local function configure()
    packadd("nvim-ts-autotag") -- https://github.com/windwp/nvim-ts-autotag
    local autotag = require("nvim-ts-autotag")
    autotag.setup()
end

return {configure = configure}
