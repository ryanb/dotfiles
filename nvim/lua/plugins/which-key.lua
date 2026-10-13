return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    delay = 300,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show()
      end,
      desc = 'Show all keymaps',
    },
  },
}
