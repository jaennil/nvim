-- review the current branch against the default branch: gitsigns base
-- and changed files in quickfix
local M = {}

local state = {
  base = nil,
  branch = nil,
}

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

local function default_branch()
  local head = run({ "git", "symbolic-ref", "--quiet", "refs/remotes/origin/HEAD" }, true)
  local branch = head and head:match("[^/]+$")

  if branch then
    return branch
  end

  for _, candidate in ipairs({ "master", "main" }) do
    if run({ "git", "rev-parse", "--verify", "--quiet", "origin/" .. candidate }, true) then
      return candidate
    end
  end
end

-- merge base with the default branch, so commits landed in it after this
-- branch was cut stay out of the diff
local function resolve(refresh)
  if state.base and not refresh then
    return state.base
  end

  local branch = default_branch()
  if not branch then
    vim.notify("can't detect default branch", vim.log.levels.ERROR)
    return nil
  end

  if not run({ "git", "fetch", "origin", branch }) then
    return nil
  end

  local base = run({ "git", "merge-base", "origin/" .. branch, "HEAD" })
  if not base then
    return nil
  end

  state.base = base
  state.branch = branch

  return base
end

function M.review()
  local base = resolve(true)
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

  vim.fn.setqflist({}, " ", { title = "changes against origin/" .. state.branch, items = items })
  vim.cmd("copen")
end

function M.reset()
  state.base = nil
  state.branch = nil
  require("gitsigns").change_base(nil, true)
end

return M
