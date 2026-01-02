return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Add more formatters as needed
				-- python = { "isort", "black" },
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			format_on_save = function(bufnr)
				-- Disable for specific filetypes if needed
				local disable_filetypes = {}
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				end
				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,
		},
	},
}
