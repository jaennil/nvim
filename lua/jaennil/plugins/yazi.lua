return {
    "mikavilpas/yazi.nvim",
    opts = {
	open_for_directories = true,

	-- enable this if you are using latest version of yazi
	-- use_ya_for_events_reading = true,
	-- use_yazi_client_id_flag = true,
    },
    keys = {
	{
	    "<leader>n",
	    function()
		require("yazi").yazi()
	    end,
	    desc = "Open the yazi file manager",
	},
    },
}
