" Make Vim more useful
set nocompatible

"let mapleader="`"
"let maplocalleader="\\"

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Enhance command-line completion
set wildmenu

" Allow cursor keys in insert mode
set esckeys

" Allow backspace in insert mode
set backspace=indent,eol,start

" Optimize for fast terminal connections
set ttyfast

" Add the g flag to search/replace by default
set gdefault

" Use UTF-8 without BOM
set encoding=utf-8 nobomb
scriptencoding utf-8

" Don’t add empty newlines at the end of files
set binary
set noeol

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undofile
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Store more history entries
set history=10000

" Respect modeline in files
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Make tabs as wide as four spaces
set tabstop=4

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,nbsp:_
set list

" Highlight searches
set hlsearch

" Ignore case of searches unless searching with upper case letters
set ignorecase
set smartcase

" Highlight dynamically as pattern is typed
set incsearch

" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse=a

" Disable error bells
set noerrorbells

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Don’t show the intro message when starting Vim
set shortmess=atI

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title
set titlestring=%F

" Tab Settings
set smarttab

" Turn indentation on
set autoindent
filetype plugin indent on

" Show the (partial) command as it’s being typed
set showcmd

" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
" Show the current line number, instead of 0 (hybrid mode)
	set number
	au BufReadPost * set relativenumber
endif

" Start scrolling three lines before the horizontal window border
set scrolloff=3

set spelllang=en
set spellfile=$CONFIGDIR/en.utf-8.add

" Commands
" --------

" sudo write this
" cmap is a (c)ommand (map)ing
cmap W! w !sudo tee % >/dev/null


" Language / syntax specific settings
" -----------------------------------

" Add spell-checking and text-wrapping to commit messages
autocmd Filetype gitcommit setlocal textwidth=72 spell

" javascript support
autocmd Filetype javascript setlocal expandtab shiftwidth=2 tabstop=4 softtabstop=2

" bash support
autocmd Filetype sh setlocal expandtab shiftwidth=2 tabstop=4 softtabstop=2

" python support
" --------------
"  don't highlight exceptions and builtins.
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
\ formatoptions=croq softtabstop=4 textwidth=74 foldmethod=indent comments=:#\:,:#
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0
let python_slow_sync=1

