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
        local function run(args, silent)
          local result = vim.system(args, { text = true }):wait()

          if result.code ~= 0 then
            if not silent then
              vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
            end
            return nil
          end

          return vim.trim(result.stdout)
        end

        local head = run({ "git", "symbolic-ref", "--quiet", "refs/remotes/origin/HEAD" }, true)
        local target = head and head:match("[^/]+$")

        if not target then
          for _, candidate in ipairs({ "master", "main" }) do
            if run({ "git", "rev-parse", "--verify", "--quiet", "origin/" .. candidate }, true) then
              target = candidate
              break
            end
          end
        end

        if not target then
          vim.notify("can't detect default branch", vim.log.levels.ERROR)
          return
        end

        if not run({ "git", "fetch", "origin", target }) then
          return
        end

        local base = run({ "git", "merge-base", "origin/" .. target, "HEAD" })
        if not base then
          return
        end

        local files = run({ "git", "diff", "--name-only", base })
        if not files then
          return
        end

        require("gitsigns").change_base(base, true)

        local items = {}
        for file in vim.gsplit(files, "\n", { plain = true, trimempty = true }) do
          table.insert(items, { filename = file, lnum = 1, col = 1, text = file })
        end

        vim.fn.setqflist({}, " ", { title = "changes against origin/" .. target, items = items })
        vim.cmd("copen")
      end,
      desc = "Review branch diff against default branch",
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
