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
  },
}
