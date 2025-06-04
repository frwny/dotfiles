-- Required plugins
require('plugins')
require('lualine-config')
require('treesitter-config')
require('telescope-config')
require('startup-config')
require('auto-session-config')
require('nvim-tree-config')
require('everforest-config')
require('nvim-surround').setup()
require('nvim-autopairs').setup()

require('lsp-config')
require('tiny-inline-diagnostic-config')
vim.diagnostic.config({
  virtual_text = false
})

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Mouse
vim.o.mouse = "a"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.incsearch = true

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Tabulation
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- Misc
vim.o.termguicolors = true
vim.o.breakindent = true
vim.o.undofile = true
vim.o.scrolloff = 10
vim.o.updatetime = 50
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.fillchars = "eob: "
vim.cmd([[colorscheme everforest]])



-- Key mappings
vim.g.mapleader = " "

--Telescope bindings
vim.keymap.set("n", "<Leader>bb", "Telescope.builtin.buffers, {}")
vim.keymap.set("n", "<Leader>gb", "Telescope.builtin.git_branches, {}")
vim.keymap.set("n", "<Leader>sr", "Telescope.builtin.session-lens, {}")
vim.keymap.set("n", "<Leader>gl", "Telescope.builtin.git_commits, {}")
vim.keymap.set("n", "<Leader>gs", "Telescope.builtin.git_status, {}")
vim.keymap.set("n", "<Leader>of", "Telescope.builtin.oldfiles, {}")
vim.keymap.set("n", "<Leader>lg", "Telescope.builtin.live_grep, {}")
vim.keymap.set("n", "<Leader>gs", "Telescope.builtin.grep_string, {}")
vim.keymap.set("n", "<Leader>fb", "Telescope.builtin.file_browser, {}")
vim.keymap.set("n", "<Leader>ff", "Telescope.builtin.project_files, {}")

-- Split keybinds
vim.keymap.set("n", "<S-k>", "<C-W>k")
vim.keymap.set("n", "<S-j>", "<C-W>j")
vim.keymap.set("n", "<S-h>", "<C-W>h")
vim.keymap.set("n", "<S-l>", "<C-W>l")
vim.keymap.set("n", "<Leader>v", ":vsp %<CR>")
vim.keymap.set("n", "<Leader>x", ":sp %<CR>")
vim.keymap.set("n", "<Leader>wc", ":close<CR>")
vim.keymap.set("n", "<C-k>", ":resize +10<CR>")
vim.keymap.set("n", "<C-j>", ":resize -10<CR>")
vim.keymap.set("n", "<C-->", ":vertical resize -10<CR>")
vim.keymap.set("n", "<C-=>", ":vertical resize +10<CR>")

-- Tab keybinds
vim.keymap.set("n", "<Tab>", ":bn<CR>")
vim.keymap.set("n", "<S-Tab>", ":bp<CR>")
vim.keymap.set("n", "<Leader>bd", ":bd!<CR>")

-- Misc keybinds
vim.keymap.set("n", "<Leader>gg", "<cmd>Git ")
vim.keymap.set("n", "<Leader>ss", "<cmd>SessionSave ")
vim.keymap.set("n", "<Leader>y", "\"+yy")
vim.keymap.set("v", "<Leader>y", "\"+y")
vim.keymap.set("n", "<Leader>z", "<cmd>ZenMode<CR>")
vim.keymap.set("n", "<leader>p", ":NvimTreeToggle $PWD<CR>")
vim.keymap.set("n", "<Leader>l", ":LspRestart<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Terminal
-- command! Term :bot 10sp | term
-- autocmd TermOpen term://* startinsert
-- autocmd TermOpen * setlocal nonumber norelativenumber
-- tnoremap <Esc> <C-\><C-n>
-- nnoremap <Leader>ft :Term<CR>

-- JSON formatting
-- command JsonLint :%!jq .


-- autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
-- autocmd BufWritePre *.tf lua vim.lsp.buf.format()

-- au WinLeave * set nocursorline nocursorcolumn
-- au WinEnter * set cursorline nocursorcolumn

-- augroup cdpwd
--     autocmd!
--     autocmd VimEnter * cd $PWD
-- augroup END


-- " improved grep function
-- " set grepprg=grepr

-- " function! Grep(...)
-- "     return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
-- " endfunction
-- " command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
-- " cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
-- " augroup quickfix
-- "     autocmd!
-- "     autocmd QuickFixCmdPost cgetexpr :execute "Telescope quickfix layout_strategy=vertical layout_config={width=0.7}<CR>"
-- " augroup END


