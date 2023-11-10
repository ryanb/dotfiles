local packadd = require("helpers").packadd

local function configure()
    packadd("vim-rails")
end

return {configure = configure}
