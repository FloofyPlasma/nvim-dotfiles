return {
	-- Disable snacks explorer (if you prefer neo-tree)
	{
		"folke/snacks.nvim",
		opts = {
			explorer = {
				enabled = false,
			},
		},
	},

	-- Guess indent automatically
	{
		"NMAC427/guess-indent.nvim",
		event = "BufReadPre",
		config = true,
	},

	-- Customize notify timeout
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
		},
	},

	-- Customize telescope
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			-- Add your custom telescope keymaps here if needed
			{
				"<leader>sn",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Search Neovim files",
			},
		},
	},

	-- Customize which-key
	{
		"folke/which-key.nvim",
		opts = {
			delay = 0,
		},
	},

	-- Customize treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"css",
				"diff",
				"html",
				"lua",
				"luadoc",
				"latex",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
}
