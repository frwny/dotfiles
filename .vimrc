"First for some reason
set nocompatible
filetype off

lua require('plugins')
lua require('lualine-config')
lua require('leap').create_default_mappings()
lua require('treesitter-config')
lua require('telescope-config')
lua require('lsp-config')
lua require('tiny-inline-diagnostic-config')
lua require('startup-config')

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
"let g:airline_detect_paste=1
"let g:airline#extensions#whitespace#enabled = 0
""Solarized airline statusbar
"let g:airline_theme='nord'
""Powerline arrows
"let g:airline_powerline_fonts = 0
"let g:airline#extensions#branch#enabled=1
""Tabs
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#show_tabs = 1
"let g:airline#extensions#tabline#show_close_button = 0
"let g:airline#extensions#tabline#buffer_idx_mode = 1

"Nord settings
let g:nord_contrast = v:true
let g:nord_borders = v:false
let g:nord_disable_background = v:false
let g:nord_italic = v:false
let g:nord_uniform_diff_background = v:true
let g:nord_bold = v:false

"Fern settings
let g:fern#renderer = "nvim-web-devicons"
let g:glyph_palette#palette = v:lua.require'fr-web-icons'.palette()
let g:fern#default_hidden = 0



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
nnoremap <Leader>b :Telescope buffers<CR>
nnoremap <Leader>gg :Git 
nnoremap <Leader>gb :Telescope git_branches layout_config={preview_width=0.6}<CR>
nnoremap <Leader>gl :Telescope git_commits layout_config={preview_width=0.6}<CR>
nnoremap <Leader>gs :Telescope git_status<CR>
nnoremap <Leader>of :Telescope oldfiles<CR>
nnoremap <Leader>k :lua require'telescope-config'.project_files()<CR>
nnoremap <S-CR> za
nnoremap <Leader>y "+yy
vnoremap <Leader>y "+y
nnoremap <silent> <Leader>z :ZenMode<CR>

"terminal
command! Term :bot 10sp | term
autocmd TermOpen term://* startinsert
tnoremap <Esc> <C-\><C-n>
nnoremap <Leader>ft :Term<CR>

" grep/search
nnoremap <Leader>ff :Telescope git_files hidden=true no_ignore=true layout_config={preview_width=0.6}<CR>
nnoremap <Leader>lg :Telescope live_grep<CR>
nnoremap <Leader>gs :Telescope grep_string<CR>
nnoremap <Leader>fb :Telescope file_browser<CR>
nnoremap <Leader>q :Telescope quickfix layout_strategy=vertical layout_config={width=0.7}<CR>
nnoremap <silent> <C-n> :cn<CR>
nnoremap <silent> <C-p> :cp<CR>

" json formatting
command Json :%!jq .

" Use ctrl-[hjkl] to select the active split!
map <silent> <C-k> <C-W>k
map <silent> <C-j> <C-W>j
map <silent> <C-h> <C-W>h
map <silent> <C-l> <C-W>l

" Use c-s-[hjkl] to resize split
nnoremap <silent> <C-S-k> :resize +10<CR>
nnoremap <silent> <C-S-j> :resize -10<CR>
nnoremap <silent> <C-S-h> :vertical-resize -10<CR>
nnoremap <silent> <C-S-l> :vertical-resize +10<CR>

" Buffer switching
map <Tab> :bn<CR>
map <S-Tab> :bp<CR>
map gd :bd!<CR>

"Fern toggle
nnoremap <silent> <leader>p :Fern . -drawer -toggle -reveal=% -width=30<CR>

"lsp
nnoremap <Leader>l :LspRestart<CR>

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

autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
autocmd BufWritePre *.tf lua vim.lsp.buf.format()

lua << EOF
vim.lsp.set_log_level("debug")
EOF

" improved grep function
" set grepprg=grepr

" function! Grep(...)
"     return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
" endfunction
" command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
" cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
" augroup quickfix
"     autocmd!
"     autocmd QuickFixCmdPost cgetexpr :execute "Telescope quickfix layout_strategy=vertical layout_config={width=0.7}<CR>"
" augroup END


