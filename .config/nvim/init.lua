-- Required plugins
require('lazy_config')


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
vim.g.indent_blankline_filetype_exclude = {'NvimTree'}

-- Enable autoread and set up checking triggers
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = "*",
})

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
local builtin = require('telescope.builtin')
local pickers = require('configs.pickers')
vim.keymap.set("n", "<Leader>bb", builtin.buffers, {})
vim.keymap.set("n", "<Leader>gb", builtin.git_branches, {})
vim.keymap.set("n", "<Leader>gl", builtin.git_commits, {})
vim.keymap.set("n", "<Leader>of", builtin.oldfiles, {})
vim.keymap.set("n", "<Leader>gs", builtin.grep_string, {})
vim.keymap.set("n", "<Leader>lg", builtin.live_grep, {})
vim.keymap.set("n", "<Leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<Leader>pf", pickers.project_files, {})
vim.keymap.set("n", "<Leader>fid", ":Telescope find_files cwd=")
vim.keymap.set("n", "<Leader>fb", "<cmd>Telescope file_browser<CR>")
vim.keymap.set("n", "<Leader>sr", "<cmd>AutoSession search<CR>")

-- Split keybinds
vim.keymap.set("n", "<Leader>v", ":vsp %<CR>")
vim.keymap.set("n", "<Leader>h", ":sp %<CR>")
vim.keymap.set("n", "<Leader>wc", ":close<CR>")

-- Tmux keybinds
vim.keymap.set("n", "<C-h>", "<cmd>lua require('tmux').move_left()<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>lua require('tmux').move_bottom()<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>lua require('tmux').move_top()<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>lua require('tmux').move_right()<cr>")

vim.keymap.set("n", "<C-M-h>", "<cmd>lua require('tmux').resize_left()<cr>")
vim.keymap.set("n", "<C-M-j>", "<cmd>lua require('tmux').resize_bottom()<cr>")
vim.keymap.set("n", "<C-M-k>", "<cmd>lua require('tmux').resize_top()<cr>")
vim.keymap.set("n", "<C-M-l>", "<cmd>lua require('tmux').resize_right()<cr>")


-- Tab keybinds
vim.keymap.set("n", "<Tab>", ":bn<CR>")
vim.keymap.set("n", "<S-Tab>", ":bp<CR>")
vim.keymap.set("n", "<Leader>bd", ":bd!<CR>")

-- Misc keybinds
local quickfix = require('configs.quickfix')
vim.keymap.set("n", "<Leader>gg", ":Git ")
vim.keymap.set("n", "<Leader>ss", ":AutoSession save ")
vim.keymap.set("n", "<Leader>ft", ":set ft=")
vim.keymap.set("n", "<Leader>/", "*")
vim.keymap.set("n", "<Leader>?", "#")
vim.keymap.set("n", "<Leader>y", "\"+yy")
vim.keymap.set("v", "<Leader>y", "\"+y")
vim.keymap.set("v", "<Leader>p", "\"_dP")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<Leader>z", "<cmd>ZenMode<CR>")
vim.keymap.set("n", "<Leader>l", "<cmd>LspRestart<CR>")
vim.keymap.set("n", "<Leader>fb", "<cmd>NvimTreeFindFileToggle<CR>")
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


