vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

vim.opt.clipboard = "unnamedplus"

vim.cmd [[autocmd FileType markdown set tw=120 wrap]]
vim.cmd [[ autocmd BufNewFile,BufRead *.bicep set filetype=bicep ]]
vim.cmd [[autocmd FileType bicep setlocal commentstring=//\ %s]]

vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	command = "setlocal shiftwidth=2 tabstop=2"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "yml",
	command = "setlocal shiftwidth=2 tabstop=2"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	command = "setlocal shiftwidth=2 tabstop=2"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "bicep",
	command = "setlocal shiftwidth=2 tabstop=2"
})
-- vim.opt.autoindent = true
-- vim.opt.smarttab = true
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true
-- vim.opt.ignorecase = true
-- vim.opt.mouse = "a"
-- vim.opt.conceallevel = 0
-- vim.opt.clipboard = "unnamedplus"
--
-- vim.g.rainbow_active = 1
-- vim.g['airline#extensions#tabline#enabled'] = 1
-- vim.g['airline#extensions#tabline#buffer_nr_show'] = 1
