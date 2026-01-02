return {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"cmakelang",
				"cmakelint",
				"neocmakelsp",
				"codelldb",
				"clangd",
				"clang-format",
				"cpptools",
				"markdown-toc",
				"markdownlint-cli2",
				"marksman",
			},
		},
	},

	-- Configure LSP servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Custom keymaps for all LSP servers
				["*"] = {
					keys = {
						{ "grn", vim.lsp.buf.rename, desc = "LSP: [R]e[n]ame" },
						{ "gra", vim.lsp.buf.code_action, desc = "LSP: [G]oto Code [A]ction", mode = { "n", "x" } },
						{ "grr", "<cmd>Telescope lsp_references<cr>", desc = "LSP: [G]oto [R]eferences" },
						{ "gri", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP: [G]oto [I]mplementation" },
						{ "grd", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP: [G]oto [D]efinition" },
						{ "grD", vim.lsp.buf.declaration, desc = "LSP: [G]oto [D]eclaration" },
						{ "gO", "<cmd>Telescope lsp_document_symbols<cr>", desc = "LSP: Open Document Symbols" },
						{
							"gW",
							"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
							desc = "LSP: Open Workspace Symbols",
						},
						{ "grt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP: [G]oto [T]ype Definition" },
						{
							"<leader>th",
							function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
							end,
							desc = "[T]oggle Inlay [H]ints",
						},
					},
				},
				clangd = {
					keys = {
						{ "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
					},
				},
				ts_ls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			},
			setup = {
				-- Configure SourceKit for Swift
				sourcekit = function(_, opts)
					require("lspconfig").sourcekit.setup({
						capabilities = {
							workspace = {
								didChangeWatchedFiles = {
									dynamicRegistration = true,
								},
							},
						},
					})
					return true
				end,
			},
		},
	},

	-- Customize diagnostic display
	{
		"neovim/nvim-lspconfig",
		init = function()
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						return diagnostic.message
					end,
				},
			})
		end,
	},
}
