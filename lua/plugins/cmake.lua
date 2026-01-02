return {
	{
		"Civitasv/cmake-tools.nvim",
		keys = {
			{
				"<leader><F5>",
				function()
					local cmake = require("cmake-tools")
					cmake.build({ sync = true })
					cmake.run()
				end,
				desc = "CMake: Build and Run (no debugger)",
			},
		},
		opts = {},
	},
}
