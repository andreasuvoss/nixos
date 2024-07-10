require("nvim-treesitter.configs").setup({
    -- ensure_installed = "all", -- one of "all" or a list of languages
    -- ensure_installed = { }, --"all", -- one of "all" or a list of languages
    -- ignore_install = { "phpdoc", "d", "wing" }, -- List of parsers to ignore installing
    -- ignore_install = {}, -- List of parsers to ignore installing
    auto_install = false,
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
        disable = { "" }, -- list of language that will be disabled
    },
    indent = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
    }
})
