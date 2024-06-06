-- Tool for installing language servers, linters, etc.
--
-- https://github.com/williamboman/mason.nvim

local opts = {
    PATH = "append",
}

return {
    "williamboman/mason.nvim",
    dependencies = { "rcarriga/nvim-notify" },
    opts = opts,
}
