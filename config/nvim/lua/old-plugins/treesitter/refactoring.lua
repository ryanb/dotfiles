-- Extract functions and variables
--
-- https://github.com/ThePrimeagen/refactoring.nvim

local treesitter_spec = require("plugin-specs.treesitter.treesitter-spec")

local function config()
    require("refactoring").setup()
end

return {
    "ThePrimeagen/refactoring.nvim",
    config = config,
    dependencies = {
        "nvim-lua/plenary.nvim",
        treesitter_spec,
    },
}
