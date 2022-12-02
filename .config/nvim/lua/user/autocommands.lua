
vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
    autocmd vimenter * ++nested colorscheme tokyonight
    autocmd ColorScheme * hi Normal ctermbg=none guibg=none
    autocmd ColorScheme * hi NvimTreeNormal guibg=NONE ctermbg=NONE
  augroup end
]]


-- Autoformat
vim.cmd [[
augroup _lsp
  autocmd!
  autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()
augroup end
]]

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
