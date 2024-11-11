local settings = {
    -- every line should be same width without escaped \
    header = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Header",
        margin = 5,
        content = require("startup.headers").gate_banner,
        highlight = "",
        default_color = "#A7C080",
        oldfiles_amount = 0,
    },
    -- name which will be displayed and command
    body = {
        type = "mapping",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Basic Commands",
        margin = 2,
        content = {
            { " Session Restore", "SessionSearch", "<leader>sr" },
            { " Find File", "Telescope find_files", "<leader>ff" },
            { "󰍉 Find Word", "Telescope live_grep", "<leader>lg" },
            { " Recent Files", "Telescope oldfiles", "<leader>of" },
            { " File Browser", "Telescope file_browser", "<leader>fb" },
            { " New File", "lua require'startup'.new_file()", "<leader>nf" },
        },
        highlight = "",
        default_color = #7FBBB3",
        oldfiles_amount = 0,
    },
    footer = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Footer",
        margin = 5,
        content = require("startup.headers").gate_footer,
        highlight = "",
        default_color = "#A7C080",
        oldfiles_amount = 0,
    },

    options = {
        mapping_keys = true,
        cursor_column = 0.5,
        empty_lines_between_mappings = false,
        disable_statuslines = true,
        paddings = { 1, 1, 1, 0 },
    },
    mappings = {
        execute_command = "<CR>",
        open_file = "o",
        open_file_split = "<c-o>",
        open_section = "<TAB>",
        open_help = "?",
    },
    colors = {
        background = "#2E3440",
        folded_section = "#56b6c2",
    },
    parts = { "header", "body", "footer" },
}
return settings
