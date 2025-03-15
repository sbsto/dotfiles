local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

lsp.on_attach(function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	lsp.default_keymaps({ buffer = bufnr })

	vim.api.nvim_set_keymap("n", "<leader>fm", ":Format<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>ra", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "<leader>gi", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "<leader>gr", function()
		vim.lsp.buf.references()
	end, opts)
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = false,
})

require("lspconfig").ts_ls.setup({})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "svelte",
    "ts_ls",
    "tailwindcss",
    "eslint",
    "biome",
    "bashls",
  },
  handlers = {
    lsp.default_setup,
  },
})
require("mason-tool-installer").setup({
  ensure_installed = {
    "biome",
    "eslint",
    "prettierd",
    "stylua",
    "shfmt",
  }
})
