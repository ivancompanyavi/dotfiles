
call plug#begin()
    " File browser with git indicators
    " Sidebar
    Plug 'preservim/nerdtree'
    let NERDTreeShowHidden=1
    " Themes
    Plug 'arcticicestudio/nord-vim'
    "Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'mattn/emmet-vim'
    Plug 'yuezk/vim-js'
    Plug 'maxmellon/vim-jsx-pretty'
    "Plug 'peitalin/vim-jsx-typescript'
    "Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'jparise/vim-graphql'
    Plug 'easymotion/vim-easymotion'
    " Status bar
    Plug 'itchyny/lightline.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = ['coc-tsserver', 'coc-tailwindcss'
        \ ]
    if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
        let g:coc_global_extensions += ['coc-prettier']
    endif

    if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
        let g:coc_global_extensions += ['coc-eslint']
    endif
call plug#end()

set number
set encoding=utf-8
set fileencoding=utf-8

" sane editing
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
set viminfo='25,\"50,n~/.viminfo
set tw=79
set autoindent
set smartindent
set relativenumber
set clipboard=unnamedplus

" color scheme
syntax on
colorscheme nord
filetype on
filetype plugin indent on

let mapleader = " "

" Commands
" Prettier: applies Prettier config to file
command! -nargs=0 Prettier :CocCommand prettier.formatFile

augroup filetype_jsx
    autocmd!
    autocmd FileType javascript set filetype=javascriptreact
augroup END

" Mappings

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
"
" NERDTree
noremap <leader>b :NERDTreeToggle<CR>

" fzf
nnoremap <leader>o :GFiles<CR>
nnoremap <leader>y "+y
nnoremap <leader>p "+p

" Formatter
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Install plugins
nnoremap <silent><leader>1 :source ~/.config/nvim/init.vim \| :PlugInstall<CR>
" map <Leader>s <Plug>(easymotion-prefix)
imap ii <Esc>
