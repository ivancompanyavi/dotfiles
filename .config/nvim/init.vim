
call plug#begin()
    " File browser with git indicators
    " Sidebar
    Plug 'preservim/nerdtree'
    " Themes
    Plug 'arcticicestudio/nord-vim'
    Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'jparise/vim-graphql'
    Plug 'easymotion/vim-easymotion'
    " Status bar
    Plug 'itchyny/lightline.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = [
        \ 'coc-tsserver'
        \ ]
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

" color scheme
syntax on
colorscheme nord
filetype on
filetype plugin indent on

let mapleader = " "

noremap <leader>b :NERDTreeFocus<CR>
" map <Leader>s <Plug>(easymotion-prefix)
