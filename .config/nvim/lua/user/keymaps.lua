local opts = { noremap = true, silent = true }
-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- themes
function _G.dark_theme()
  vim.cmd("!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to true'")
  vim.cmd("!sed -i.bak 's/\\(colors:\\ \\*\\).*$/\\1frappe/' ~/projects/dotfiles/.config/alacritty/alacritty.yml")
  vim.o.background = 'dark'
end

function _G.light_theme()
  vim.cmd("!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to false'")
  vim.cmd("!sed -i.bak 's/\\(colors:\\ \\*\\).*$/\\1latte/' ~/projects/dotfiles/.config/alacritty/alacritty.yml")
  vim.o.background = 'light'
end

function _G.ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match('^user') and not name:match('nvim-tree') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

keymap("n", "<leader>c", "<cmd>source $MYVIMRC<cr>", opts)

keymap("n", "<leader>w", "<cmd>w<CR>", opts)
keymap("n", "<leader>W", "<cmd>wa<CR>", opts)
keymap("i", "jk", "<ESC>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>c", ":bd<cr>", opts)
keymap("n", "<leader>C", ":%bd|e#|bd#<cr>", opts)
keymap("n", "<leader>o", ":only<cr>", opts)

-- Navigate windows
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)

-- Move lines up/down
keymap("n", "∆", ":m +1<cr>", opts) -- Alt-j in Mac OS
keymap("n", "˚", ":m -2<cr>", opts) -- Alt-k in Mac OS

-- Nvim Tree
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

-- Telescope
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>ft", "<cmd>lua require'telescope.builtin'.live_grep()<cr>", opts)
-- Reload config
keymap("n", "<leader><leader>", "<cmd>lua ReloadConfig()<CR>", { noremap = true, silent = false })

-- LSP
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
-- keymap("n", "K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
-- keymap("n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
keymap(
  "n",
  "gl",
  '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
  opts
)
keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Terminal
keymap("n", "<leader>tt", '<cmd>ToggleTerm size=10 direction=horizontal<cr>', opts)
