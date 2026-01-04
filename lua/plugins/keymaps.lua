return {
	-- Additional keymaps that aren't plugin-specific
	{
		"LazyVim/LazyVim",
		keys = {
			-- Clear search highlights on <Esc>
			{ "<Esc>", "<cmd>nohlsearch<CR>", desc = "Clear search highlights" },

			-- Exit terminal mode easier
			{ "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },

			-- Navigate between windows with Ctrl+hjkl (LazyVim has these but let's ensure they're set)
			{ "<C-h>", "<C-w><C-h>", desc = "Move focus to the left window" },
			{ "<C-l>", "<C-w><C-l>", desc = "Move focus to the right window" },
			{ "<C-j>", "<C-w><C-j>", desc = "Move focus to the lower window" },
			{ "<C-k>", "<C-w><C-k>", desc = "Move focus to the upper window" },

			-- Diagnostic quickfix list
			{ "<leader>q", vim.diagnostic.setloclist, desc = "Open diagnostic [Q]uickfix list" },

			-- CMake
			{ "<leader><F5>", "<cmd>CMakeBuild<CR>", desc = "Build with CMake" },
		},
	},
}
