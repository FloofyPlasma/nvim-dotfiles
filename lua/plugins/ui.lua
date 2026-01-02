return {
	-- Customize lualine
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			if opts.sections and opts.sections.lualine_c and opts.sections.lualine_c[4] then
				opts.sections.lualine_c[4] = {
					LazyVim.lualine.pretty_path({
						length = 0,
						relative = "cwd",
						modified_hl = "MatchParen",
						directory_hl = "",
						filename_hl = "Bold",
						modified_sign = "",
						readonly_icon = " 󰌾 ",
					}),
				}
			end
		end,
	},

	-- Tokyo Night theme (keep as alternative)
	{
		"folke/tokyonight.nvim",
		opts = {
			styles = {
				comments = { italic = false },
			},
		},
	},
}
