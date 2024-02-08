if vim.g.vscode then
  -- vscode extension
else
  require "user.autocommands"
  require "user.options"

  require "user.plugins"
  require "user.bufferline"
  require "user.treesitter"
  require "user.cmp"
  require "user.tree"
  require "user.telescope"
  require "user.lsp"
  require "user.keymaps"
  require "user.whichkey"
  require "user.lualine"
  require "user.comment"
  require "user.notes"
  require "user.gitsigns"
  require "user.autopairs"
  require 'user.leap'
  require 'user.theme'
end
