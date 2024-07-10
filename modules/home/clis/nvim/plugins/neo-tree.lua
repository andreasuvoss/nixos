vim.cmd [[highlight NeoTreeNormal guifg=#F8F8F2 guibg=#282A36]]
vim.cmd [[highlight NeoTreeNormalNC guifg=#F8F8F2 guibg=#282A36]]
vim.cmd [[highlight NeoTreeDirectoryName guifg=#F8F8F2]]
vim.cmd [[highlight NeoTreeGitUnstaged guifg=#FF92DF]]  -- bright pink
vim.cmd [[highlight NeoTreeGitModified guifg=#FF92DF]]  -- bright pink
vim.cmd [[highlight NeoTreeGitUntracked guifg=#69FF94]] -- bright green
vim.cmd [[highlight NeoTreeDirectoryIcon guifg=#BD93F9]] -- purple
vim.cmd [[highlight NeoTreeIndentMarker guifg=#3B4048]] -- nontext
vim.cmd [[highlight NeoTreeDotfile guifg=#6272A4]]      -- comment

require("neo-tree").setup({
    close_if_last_window = true,
    window = {
        mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
            ["a"] = { "add", config = { show_path = "relative" } },
            ["A"] = { "add_directory", config = { show_path = "relative" } },
            ["c"] = { "copy", config = { show_path = "relative" } },
            ["m"] = { "move", config = { show_path = "relative" } },
        }
    },
    filesystem = {
        follow_current_file = {
            enabled = true
        },
        use_libuv_file_watcher = true,
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            never_show = {
                "node_modules",
                ".git",
            }
        }
    }
})
