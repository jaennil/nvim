local dap = require("dap")
local dapui = require("dapui")

require("nvim-dap-virtual-text").setup()

dapui.setup({
	controls = {
		element = "repl",
		enabled = true,
		icons = {
			disconnect = "",
			pause = "",
			play = "",
			run_last = "",
			step_back = "",
			step_into = "",
			step_out = "",
			step_over = "",
			terminate = ""
		}
	},
	element_mappings = {},
	expand_lines = true,
	floating = {
		border = "single",
		mappings = {
			close = { "q", "<Esc>" }
		}
	},
	force_buffers = true,
	icons = {
		collapsed = "",
		current_frame = "",
		expanded = ""
	},
	layouts = {
		{
			elements = {
				{
					id = "repl",
					size = 0.5
				},
				-- {
				--         id = "console",
				--         size = 0.5
				--       }
			},
			position = "bottom",
			size = 10
		},
		{
			elements = {
				{
					id = "scopes",
					size = 0.25
				},
				{
					id = "breakpoints",
					size = 0.25
				},
				{
					id = "stacks",
					size = 0.25
				},
				{
					id = "watches",
					size = 0.25
				}
			},
			position = "right",
			size = 40
		},
	},
	mappings = {
		edit = "e",
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		repl = "r",
		toggle = "t"
	},
	render = {
		indent = 1,
		max_value_lines = 100
	}
})

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

dap.adapters.coreclr = {
	type = 'executable',
	command = '/usr/local/netcoredbg',
	args = { '--interpreter=vscode' }
}

-- dap.configurations.cs = {
-- 	{
-- 		type = "coreclr",
-- 		name = "launch - netcoredbg",
-- 		request = "launch",
-- 		program = function()
-- 			return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
-- 		end,
-- 	},
-- }

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "attach - netcoredbg",
		request = "attach",
		processId = function()
			return vim.fn.input('number')
		end
	}
}

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- Change this to your path!
    command = 'codelldb',
    args = {"--port", "${port}"},
  }
}

dap.configurations.rust= {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
