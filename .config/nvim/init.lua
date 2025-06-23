-- Required plugins
require('plugins')
require('lualine-config')
require('treesitter-config')
require('telescope-config')
require('startup-config')
require('auto-session-config')
require('everforest-config')
require('nvim-surround').setup()
require('nvim-autopairs').setup()

require('lsp-config')
require('mason-config')
require('tiny-inline-diagnostic-config')
-- require('blink-config')



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
vim.o.updatetime = 20
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.fillchars = "eob: "
vim.cmd([[colorscheme everforest]])



-- Key mappings
vim.g.mapleader = " "
vim.g.neovide_input_macos_alt_is_meta = true

--Telescope bindings
local builtin = require("telescope.builtin")
local pickers = require("pickers")
vim.keymap.set("n", "<Leader>bb", builtin.buffers, {})
vim.keymap.set("n", "<Leader>gb", builtin.git_branches, {})
vim.keymap.set("n", "<Leader>gl", builtin.git_commits, {})
vim.keymap.set("n", "<Leader>gs", builtin.git_status, {})
vim.keymap.set("n", "<Leader>of", builtin.oldfiles, {})
vim.keymap.set("n", "<Leader>lg", builtin.live_grep, {})
vim.keymap.set("n", "<Leader>gs", builtin.grep_string, {})
vim.keymap.set("n", "<Leader>ff", pickers.project_files, {})
vim.keymap.set("n", "<Leader>fb", "<cmd>Telescope file_browser<CR>")
vim.keymap.set("n", "<Leader>sr", "<cmd>SessionSearch<CR>")

-- Split keybinds
vim.keymap.set("n", "<S-k>", "<C-W>k")
vim.keymap.set("n", "<S-j>", "<C-W>j")
vim.keymap.set("n", "<S-h>", "<C-W>h")
vim.keymap.set("n", "<S-l>", "<C-W>l")
vim.keymap.set("n", "<Leader>v", ":vsp %<CR>")
vim.keymap.set("n", "<Leader>x", ":sp %<CR>")
vim.keymap.set("n", "<Leader>wc", ":close<CR>")
vim.keymap.set("n", "<C-k>", ":resize +5<CR>")
vim.keymap.set("n", "<C-j>", ":resize -5<CR>")
vim.keymap.set("n", "<C-->", ":vertical resize -5<CR>")
vim.keymap.set("n", "<C-=>", ":vertical resize +5<CR>")

-- Tab keybinds
vim.keymap.set("n", "<Tab>", ":bn<CR>")
vim.keymap.set("n", "<S-Tab>", ":bp<CR>")
vim.keymap.set("n", "<Leader>bd", ":bd!<CR>")

-- Misc keybinds
local quickfix = require("quickfix")
vim.keymap.set("n", "<Leader>gg", ":Git ")
vim.keymap.set("n", "<Leader>ss", ":SessionSave ")
vim.keymap.set("n", "<Leader>y", "\"+yy")
vim.keymap.set("v", "<Leader>y", "\"+y")
vim.keymap.set("v", "<Leader>p", "\"_dP")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<Leader>z", "<cmd>ZenMode<CR>")
vim.keymap.set("n", "<Leader>l", "<cmd>LspRestart<CR>")
vim.keymap.set("n", "<Leader>qf", quickfix.toggle, {})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.tf, *.tfvars" },
    callback = function()
      vim.lsp.buf.format()
    end,
})

-- Terminal
-- command! Term :bot 10sp | term
-- autocmd TermOpen term://* startinsert
-- autocmd TermOpen * setlocal nonumber norelativenumber
-- tnoremap <Esc> <C-\><C-n>
-- nnoremap <Leader>ft :Term<CR>

-- JSON formatting
-- command JsonLint :%!jq .



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


