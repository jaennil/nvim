return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "dlyongemallo/diffview-plus.nvim",
  },
  build = function()
    require("gitlab.server").build(true)
  end,
  config = function()
    require("gitlab").setup({
      auth_provider = function()
        local result = vim.system({ "glab", "config", "get", "token", "--host", "git.amocrm.ru" }, { text = true }):wait()

        if result.code ~= 0 then
          return nil, nil, result.stderr
        end

        return vim.trim(result.stdout), "https://git.amocrm.ru", nil
      end,
    })
  end,
  keys = {
    {
      "<leader>mr",
      function()
        require("gitlab").choose_merge_request()
      end,
      desc = "Choose GitLab merge request",
    },
    {
      "<leader>mR",
      function()
        require("gitlab").review()
      end,
      desc = "Review current GitLab merge request",
    },
    {
      "<leader>mw",
      function()
        local function run(args)
          local result = vim.system(args, { text = true }):wait()

          if result.code ~= 0 then
            vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
            return nil
          end

          return vim.trim(result.stdout)
        end

        local target = run({ "glab", "mr", "view", "--output", "json", "--jq", ".target_branch" })
        if not target or target == "" then
          return
        end

        if not run({ "git", "fetch", "origin", target }) then
          return
        end

        local base = "origin/" .. target
        local files = run({ "git", "diff", "--name-only", base .. "...HEAD" })
        if not files then
          return
        end

        require("gitsigns").change_base(base, true)

        local items = {}
        for file in vim.gsplit(files, "\n", { plain = true, trimempty = true }) do
          table.insert(items, { filename = file, lnum = 1, col = 1, text = file })
        end

        vim.fn.setqflist({}, " ", { title = "MR changes against " .. base, items = items })
        vim.cmd("copen")
      end,
      desc = "Review MR in worktree",
    },
    {
      "<leader>mB",
      function()
        require("gitsigns").change_base(nil, true)
      end,
      desc = "Reset Git diff base",
    },
  },
}
