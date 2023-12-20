-- Fix imports when we rename a file in neo-tree
--
-- https://github.com/antosha417/nvim-lsp-file-operations

return {
    "antosha417/nvim-lsp-file-operations",
    config = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neo-tree/neo-tree.nvim",
    },
}
