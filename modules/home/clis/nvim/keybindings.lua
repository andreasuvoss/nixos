-- Wrapper for mapping keybindings
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--

-- Set leader key to ,
map("", ",", "<Nop>")
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Move highlighted lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste but keep in clipboard
map("x", "<leader>p", "\"_dP")

-- Delete to void register
map("n", "<leader>d", "\"_d")
map("v", "<leader>d", "\"_d")

-- Magic
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>x", "<cmd>!chmod +x %<CR>")

-- Custom keybinds
--map("n", "<C-t>", ":NeoTreeFocusToggle<CR>")
map("n", "<leader>e", ":Neotree<CR>")
map("n", "<C-z>", ":Neotree toggle<CR>")
map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>lg", ":Telescope live_grep<CR>")
map("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>")

-- Move better between splits
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Tabbing
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "<S-Tab>", "<gv")
map("v", "<Tab>", ">gv")

map("n", "<S-Tab>", "<<_")
map("n", "<Tab>", ">>_")
