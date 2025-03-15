vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Global key mappings

-- Move lines up or down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy and paste
vim.keymap.set({ "n", "v" }, "y", '"+y') -- Copy in normal and visual mode
vim.keymap.set("n", "Y", '"+Y') -- Copy to the end of the line in normal mode

vim.keymap.set("n", "x", '"+x') -- Cut in normal mode
vim.keymap.set("v", "x", '"+x') -- Cut in visual mode

vim.keymap.set("n", "p", '"+p') -- Paste in normal mode
vim.keymap.set("v", "p", '"+p') -- Paste in visual mode

-- Copy whole file
vim.keymap.set("n", "<C-c>", ":%y+<CR>")

-- Select whole file
vim.keymap.set("n", "<leader>V", "ggVG")

-- Global key mappings for window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Floating diagnostics
vim.keymap.set("n", "L", function()
	vim.diagnostic.open_float(nil, { scope = "line" })
end, { noremap = true, silent = true })

-- Previous buffer
vim.keymap.set("n", "<leader>p", ":bp<CR>", { noremap = true, silent = true })

-- open file explorer
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { noremap = true, silent = true })

-- copy commit URL
vim.keymap.set("n", "<leader>cb", ":GitBlameOpenFileURL<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>cb", ":GitBlameOpenFileURL<CR>", { noremap = true, silent = true })

-- open commit in browser
vim.keymap.set("n", "<leader>cc", ":GitBlameCopyFileURL<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>cc", ":GitBlameCopyFileURL<CR>", { noremap = true, silent = true })
