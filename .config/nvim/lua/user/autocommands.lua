local theme = require('user.theme')

local general_settings = vim.api.nvim_create_augroup('_general_settings', { clear = true })
local lsp_settings = vim.api.nvim_create_augroup('_lsp_settings', { clear = true })

print(vim.inspect(theme.theme))

vim.api.nvim_create_autocmd("vimenter", {
  group = general_settings,
  pattern = "*",
  nested = true,
  command = "colorscheme " .. theme.colorscheme
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = lsp_settings,
  pattern = "*",
  callback = function()
    vim.lsp.buf.format()
  end
})

vim.cmd [[
  augroup _random
     autocmd!
     autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
     autocmd BufWinEnter * :set formatoptions-=cro
     autocmd FileType qf set nobuflisted
     autocmd ColorScheme * hi Normal ctermbg=none guibg=none
     autocmd ColorScheme * hi NvimTreeNormal guibg=NONE ctermbg=NONE
   augroup end
]]


-- vim.cmd [[
--   augroup _general_settings
--     autocmd!
--     autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
--     autocmd BufWinEnter * :set formatoptions-=cro
--     autocmd FileType qf set nobuflisted
--     autocmd vimenter * ++nested colorscheme gruvbox
--     autocmd ColorScheme * hi Normal ctermbg=none guibg=none
--     autocmd ColorScheme * hi NvimTreeNormal guibg=NONE ctermbg=NONE
--   augroup end
-- ]]


-- Autoformat
-- vim.cmd [[
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.format()
-- augroup end
-- ]]

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
