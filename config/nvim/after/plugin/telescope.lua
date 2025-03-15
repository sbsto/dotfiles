local builtin = require("telescope.builtin")

local find_files_config = function()
	builtin.find_files({
		hidden = true,
		no_ignore = false,
		file_ignore_patterns = { ".git/" },
	})
end

local live_grep_config = function()
	builtin.live_grep({
		additional_args = function(_)
			return { "--hidden", "--glob", "!.git/*" }
		end,
	})
end

local buffers_config = function()
	builtin.buffers({
		additional_args = function(_)
			return { "--hidden", "--glob", "!.git/*" }
		end,
	})
end

-- Set keybindings
vim.keymap.set("n", "<leader>ff", find_files_config, {})
vim.keymap.set("n", "<leader>fr", ":Telescope frecency<CR>", {})
vim.keymap.set("n", "<leader>fw", live_grep_config, {})
vim.keymap.set("n", "<leader>fb", buffers_config, {})
