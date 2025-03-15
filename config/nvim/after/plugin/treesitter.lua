require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"javascript",
		"typescript",
		"rust",
		"lua",
		"vim",
		"vimdoc",
		"svelte",
		"html",
		"css",
    "markdown",
    "markdown_inline",
	},

	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
	},
})
