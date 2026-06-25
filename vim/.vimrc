" Vim configuration
set nocompatible
set encoding=utf-8
set fileencoding=utf-8

" Line numbers
set number
set relativenumber
set cursorline

" Search
set hlsearch
set ignorecase
set smartcase
set incsearch

" UI
set wrap
set scrolloff=8
set sidescrolloff=8
set showcmd
set showmode
set cmdheight=1
set shortmess+=c
set splitright
set splitbelow
set termguicolors

" Clipboard
if has('clipboard')
    set clipboard=unnamedplus
endif

" Behavior
set mouse=a
set hidden
set noswapfile
set nobackup
set nowritebackup
set autoread
set autowrite
set hidden

" Indentation
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Completion
set completeopt=menu,menuone,noselect
set pumheight=10

" Performance
set lazyredraw
set ttyfast

" Leader
let mapleader = " "

" Better escape
inoremap jk <Esc>
inoremap kj <Esc>

" Quick save
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Center search results
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" Clear highlights
nnoremap <leader>/ :nohlsearch<CR>

" Better indenting
vnoremap > >gv
vnoremap < <gv

" Terminal
tnoremap <Esc> <C-\><C-n>
