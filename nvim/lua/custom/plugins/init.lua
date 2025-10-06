-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- convert tabs to spaces
--
require('lazy').setup {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {}
    end,
  },
}
-- See the kickstart.nvim README for more information
return {}
