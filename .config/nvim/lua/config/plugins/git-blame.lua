return {
	"f-person/git-blame.nvim",
	-- load the plugin at startup
	event = "VeryLazy",
	-- Because of the keys part, you will be lazy loading this plugin.
	-- The plugin wil only load once one of the keys is used.
	-- If you want to load the plugin at startup, add something like event = "VeryLazy",
	-- or lazy = false. One of both options will work.
	opts = {
		-- your configuration comes here
		-- for example
		enabled = true, -- if you want to enable the plugin
		message_template = " <author>, <date>, <summary>, <<sha>>", -- template for the blame message, check the Message template section for more options
		date_format = "%r, %Y/%m/%d %H:%M:%S", -- template for the date, check Date format section for more options
	},
	config = function()
		vim.g.gitblame_set_extmark_options = {
			-- to show diagnostic messages
			priority = 100,
		}
	end,
}
