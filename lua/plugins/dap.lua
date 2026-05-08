return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"Weissle/persistent-breakpoints.nvim",
		},
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "Debug: Start/Continue",
			},
			{
				"<F1>",
				function()
					require("dap").step_into()
				end,
				desc = "Debug: Step Into",
			},
			{
				"<F2>",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: Step Over",
			},
			{
				"<F3>",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: Step Out",
			},
			{
				"<leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: Toggle Breakpoint",
			},
			{
				"<leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Debug: Set Breakpoint",
			},
			{
				"<F7>",
				function()
					require("dapui").toggle()
				end,
				desc = "Debug: See last session result",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				automatic_installation = true,
				handlers = {},
				ensure_installed = {
					"codelldb",
				},
			})

			-- Dap UI setup
			vim.schedule(function()
				dapui.setup({
					icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
					controls = {
						icons = {
							pause = "⏸",
							play = "▶",
							step_into = "⏎",
							step_over = "⏭",
							step_out = "⏮",
							step_back = "b",
							run_last = "▶▶",
							terminate = "⏹",
							disconnect = "⏏",
						},
					},
				})
			end)

			-- Change breakpoint icons
			-- Change breakpoint icons
			vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
			vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
			local breakpoint_icons = vim.g.have_nerd_font
					and {
						Breakpoint = "",
						BreakpointCondition = "",
						BreakpointRejected = "",
						LogPoint = "",
						Stopped = "",
					}
				or {
					Breakpoint = "●",
					BreakpointCondition = "⊜",
					BreakpointRejected = "⊘",
					LogPoint = "◆",
					Stopped = "⭔",
				}
			for type, icon in pairs(breakpoint_icons) do
				local tp = "Dap" .. type
				local hl = (type == "Stopped") and "DapStop" or "DapBreak"
				vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
			end

			-- dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close

			dap.configurations.c = {
				{
					name = "CMake: Build and Debug",
					type = "codelldb",
					request = "launch",
					program = function()
						local cmake = require("cmake-tools")
						cmake.build({ sync = true })
						return cmake.get_launch_target_path()
					end,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.cpp = dap.configurations.c

			-- // OBJC // --

			local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
			local uname = (not is_windows) and vim.fn.system("uname"):gsub("\n", "") or ""
			local is_mac = uname == "Darwin"
			local is_linux = uname == "Linux"

			local gnustep_makefiles = (function()
				if is_mac then
					return nil
				end
				local candidates = {
					"/usr/share/GNUstep/Makefiles",
					"/usr/local/share/GNUstep/Makefiles",
					"/opt/GNUstep/System/Library/Makefiles",
				}
				for _, path in ipairs(candidates) do
					if vim.fn.isdirectory(path) == 1 then
						return path
					end
				end

				local cfg = vim.fn.system("gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null"):gsub("\n", "")
				return cfg ~= "" and cfg or nil
			end)()

			local function build_objc()
				if is_windows then
					vim.notifiy("GNUstep on Windows is not supported", vim.log.levels.ERROR)
					return
				elseif is_mac then
					vim.fn.system("make 2>&1")
				elseif is_linux and gnustep_makefiles then
					vim.fn.system(string.format("bash -c 'source %s/GNUstep.sh && make 2>&1'", gnustep_makefiles))
				else
					vim.notify("Could not find GNUstep makefiles", vim.log.levels.ERROR)
				end
			end

			local function find_app_binary()
				local app = vim.fn.glob(vim.fn.getcwd() .. "/*.app")
				if app == "" then
					vim.notify("No .app bundle found. Did make succeed?", vim.log.level.ERROR)
					return nil
				end
				app = app:gsub("\n", "")
				local name = vim.fn.fnamemodify(app, ":t:r")
				if is_mac then
					return app .. "/Contents/MacOS/" .. name
				else
					return app .. "/" .. name
				end
			end

			local objc_env = {}
			if is_linux and gnustep_makefiles then
				objc_env = {
					GNUSTEP_MAKEFILES = gnustep_makefiles,
				}
			end

			dap.configurations.objc = {
				{
					name = "GNUstep: Build and Debug",
					type = "codelldb",
					request = "launch",
					program = function()
						build_objc()
						return find_app_binary()
					end,
					cwd = "${workspaceFolder}",
					env = objc_env,
					stopOnEntry = false,
				},
			}
			dap.configurations.objcpp = dap.configurations.objc
		end,
	},
}
