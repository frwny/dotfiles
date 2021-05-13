"First for some reason
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

"Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()



"Settings
filetype plugin on
filetype plugin indent on
syntax on

"##########################################

"Plugin settings
"Show powerline statusbar
set laststatus=2
"Show paste when in paste mode
let g:airline_detect_paste=1
"Solarized airline statusbar
let g:airline_theme='solarized'
"Powerline arrows
let g:airline_powerline_fonts = 1
"Tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_close_button = 1
"Tabs
let g:airline#extensions#tabline#buffer_idx_mode = 1

"##########################################


"Enable nerdtree
let g:nerdtree_tabs_open_on_console_startup = 0

"##########################################

"Easytags settings
set tags=./tags;,~/.vimtags

"Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

"##########################################

" Syntastic
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

"##########################################

" Options from github
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set t_Co=256

" My settings
set background=dark
set mouse=a
set tabstop=4
set clipboard=unnamed
set splitbelow
set splitright

"##########################################

"Key mappings
"LEADER
let mapleader="\\"

"Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>

"Nerdtags toggle
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>

"Tabs
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap t <Plug>AirlineSelectNextTab
nmap T <Plug>AirlineSelectPrevTab
nmap <leader>d :bdelete<CR>

"split resize
nmap <leader><Up> :res +5<CR>
nmap <leader><Down> :res -5<CR>
