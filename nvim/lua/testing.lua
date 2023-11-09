local packadd = require("packadd")

return {
    configure = function()
        packadd("neotest")
        packadd("neotest-rspec")

        local neotest = require("neotest")
        neotest.setup(
            {
                adapters = {
                    require("neotest-rspec")
                }
            }
        )
    end
}
