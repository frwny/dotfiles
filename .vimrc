"First for some reason
set nocompatible
filetype off

lua require('plugins')

" set rtp+=~/.vim/bundle/Vundle.vim

"Plugins
" call vundle#begin()
"   Plugin 'nvim-lua/plenary.nvim'
"   Plugin 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
"   Plugin 'axkirillov/easypick.nvim'
"   Plugin 'VundleVim/Vundle.vim'
"   Plugin 'preservim/nerdtree'
"   Plugin 'vim-airline/vim-airline'
"   Plugin 'vim-airline/vim-airline-themes'
"   Plugin 'cohlin/vim-colorschemes'
"   Plugin 'arcticicestudio/nord-vim'
"   Plugin 'sheerun/vim-polyglot'
"   Plugin 'tpope/vim-fugitive'
"   Plugin 'tpope/vim-surround'
"   Plugin 'airblade/vim-gitgutter'
"   Plugin 'tpope/vim-commentary'
"   Plugin 'akinsho/git-conflict.nvim'
" call vundle#end()

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
let g:airline_theme='nord'
"Powerline arrows
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled=1
"Tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1

"Fern settings
let g:fern#renderer = "nvim-web-devicons"
let g:glyph_palette#palette = v:lua.require'fr-web-icons'.palette()
let g:fern#default_hidden = 1



"##########################################

" ctrlp settings
let g:ctrlp_show_hidden=1

"##########################################

set backspace=indent,eol,start
set relativenumber
set number
set guicursor=
set ruler
set number
set showcmd
set incsearch
set hlsearch
set nohlsearch
set scrolloff=8
" My settings
set completeopt=menu,menuone,noselect " better autocomplete options
set hidden " allow hidden buffers
set nobackup " don't create backup files
set nowritebackup " don't create backup files
set cmdheight=1 " only one line for commands
set t_Co=256
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
set showmatch
set foldmethod=indent
set foldlevel=99
set noautochdir
syntax enable
colorscheme nord
set t_u7=

"##########################################

"Key mappings
"LEADER"
nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <Leader>b :lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({}))<CR>
nnoremap <Leader>gg :Git 
nnoremap <Leader>gb :Telescope git_branches<CR>
nnoremap <Leader>gl :Telescope git_commits<CR>
nnoremap <Leader>gs :Telescope git_status<CR>
nnoremap <S-CR> za
nnoremap <C-y> "+yy
vnoremap <C-y> "+y

" grep/search
nnoremap <Leader>p :Telescope git_files hidden=true no_ignore=true<CR>
nnoremap <Leader>s :Grep 
nnoremap <Leader>S :Grep <cword><CR>
nnoremap <Leader>q :lua require'telescope.builtin'.quickfix({layout_strategy='vertical',layout_config={width=0.7}})<CR>
nnoremap <silent> <C-n> :cn<CR>
nnoremap <silent> <C-p> :cp<CR>

" Use ctrl-[hjkl] to select the active split!
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

" Use c-s-[hjkl] to resize split
nnoremap <silent> <C-S-k> :resize +10<CR>
nnoremap <silent> <C-S-j> :resize -10<CR>
nnoremap <silent> <C-S-h> :vertical-resize -10<CR>
nnoremap <silent> <C-S-l> :vertical-resize +10<CR>

" Buffer switching
map gd :bd!<CR>
map <Tab> :bn<CR>
map <S-Tab> :bp<CR>

" DiffView
nnoremap <leader>dd :DiffviewOpen 
nnoremap <leader>dq :DiffviewClose<CR>

"Fern toggle
nnoremap <silent> <leader>f :Fern . -drawer -toggle -reveal=% -width=60<CR>

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



" improved grep function
set grepprg=grepr

function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr :execute "lua require'telescope.builtin'.quickfix({layout_strategy='vertical',layout_config={width=0.7}})"
augroup END
