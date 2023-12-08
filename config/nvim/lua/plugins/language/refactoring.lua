-- https://github.com/ThePrimeagen/refactoring.nvim

local function config()
    require("refactoring").setup()
end

return {
    "ThePrimeagen/refactoring.nvim",
    config = config,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
}
