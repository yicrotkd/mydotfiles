return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
		config = function()
			require("oil").setup({
				keymaps = {
					["g?"] = { "actions.show_help", mode = "n" },
					["<CR>"] = "actions.select",
					["<C-s>"] = { "actions.select", opts = { vertical = true } },
					["<C-h>"] = { "actions.select", opts = { horizontal = true } },
					["<C-t>"] = { "actions.select", opts = { tab = true } },
					-- ["<C-p>"] = { "actions.preview", opts = { split = "botright" } },
					["<C-c>"] = { "actions.close", mode = "n" },
					["<C-l>"] = "actions.refresh",
					["h"] = { "actions.parent", mode = "n" },
					["l"] = { "actions.select", mode = "n" },
					["_"] = { "actions.open_cwd", mode = "n" },
					["cd"] = { "actions.cd", mode = "n" },
					["gs"] = { "actions.change_sort", mode = "n" },
					["gx"] = "actions.open_external",
					["."] = { "actions.toggle_hidden", mode = "n" },
					["g\\"] = { "actions.toggle_trash", mode = "n" },
				},
				use_default_keymaps = false,
				win_options = {
					signcolumn = "yes:2",
				},
				view_options = {
					natural_order = "fast",
				},
				-- Configuration for the floating window in oil.open_float
				float = {
					-- Padding around the floating window
					padding = 2,
					-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					max_width = 0.8,
					max_height = 0.8,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
					-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
					get_win_title = nil,
					-- preview_split: Split direction: "auto", "left", "right", "above", "below".
					preview_split = "auto",
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					override = function(conf)
						return conf
					end,
				},
			})

			vim.keymap.set("n", "<Space>f", function()
				require("oil").open()
			end, { desc = "Oil current buffer's directory" })
			vim.keymap.set("n", "<Space>of", function()
				require("oil").open_float()
			end, { desc = "Oil floating window current buffer's directory" })
			vim.keymap.set("n", "<Space>F", function()
				require("oil").open(".")
			end, { desc = "Oil ." })
			vim.keymap.set("n", "<Space>oF", function()
				require("oil").open(".")
			end, { desc = "Oil floating window ." })
		end,
	},
	{
		"refractalize/oil-git-status.nvim",

		dependencies = {
			"stevearc/oil.nvim",
		},

		config = true,
	},
}
