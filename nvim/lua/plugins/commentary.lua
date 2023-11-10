local packadd = require("helpers").packadd

local function configure()
    packadd("vim-commentary")
end

return {configure = configure}
