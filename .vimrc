"First for some reason
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

"Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'cohlin/vim-colorschemes'
Plugin 'arcticicestudio/nord-vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
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
let g:airline_theme='term_light'
"Powerline arrows
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled=1
"Tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1

"##########################################


"Enable nerdtree
let g:nerdtree_tabs_open_on_console_startup = 1
let NERDTreeWinPos = "left"
let NERDTreeShowHidden = 1

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

set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set nohlsearch
set t_Co=256
" My settings
set completeopt=menu,menuone,noselect " better autocomplete options
set hidden " allow hidden buffers
set nobackup " don't create backup files
set nowritebackup " don't create backup files
set cmdheight=1 " only one line for commands
if (has("termguicolors"))
  set termguicolors " better colors, but makes it sery slow!
endif
set mouse=
set ignorecase " search case insensitive
set smartcase " search via smartcase
set tabstop=2
set shiftwidth=2
set expandtab
set splitbelow
set splitright
set number
set showmatch
set foldmethod=syntax
set foldlevel=99
set noautochdir
syntax enable
colorscheme nord
let g:solarized_termcolors=265

"##########################################

"Key mappings
"LEADER"
nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap <CR> za
nnoremap <Leader>t :term ++rows=15<CR>
nnoremap <c-y> "+yy
vnoremap <c-y> "+y

nnoremap <c-s> :grep -r 
nmap <silent> <C-n> :cn<CR>zv
nmap <silent> <C-p> :cp<CR>zv

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

"Nerdtags toggle
nmap <leader>f :NERDTreeToggle<CR>

"split resize
nmap <leader><Up> :res +5<CR>
nmap <leader><Down> :res -5<CR>

"########################################

"Fold formatting
function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction " }}}
set foldtext=MyFoldText()
