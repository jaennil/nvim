-- review the current branch against the default branch: gitsigns base,
-- changed files in quickfix and a highlighted list of hunks
local M = {}

local state = {
  base = nil,
  branch = nil,
  root = nil,
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
  state.root = run({ "git", "rev-parse", "--show-toplevel" })

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

-- maps every diff line to the file and line it points at, so <CR> can jump there
local function locations(lines)
  local map = {}
  local file, lnum

  for i, line in ipairs(lines) do
    local name = line:match("^%+%+%+ b/(.*)$")
    local start = line:match("^@@ %-[%d,]+ %+(%d+)")
    local first = line:sub(1, 1)

    if name then
      file = name ~= "dev/null" and (state.root .. "/" .. name) or nil
      lnum = nil
    elseif start then
      lnum = tonumber(start)
      map[i] = file and { file = file, lnum = lnum }
    elseif lnum and first == "\\" then -- "\ No newline at end of file"
      map[i] = file and { file = file, lnum = lnum }
    elseif lnum and (first == " " or first == "+") then
      map[i] = file and { file = file, lnum = lnum }
      lnum = lnum + 1
    elseif lnum and first == "-" then
      map[i] = file and { file = file, lnum = lnum }
    else
      lnum = nil
    end
  end

  return map
end

function M.hunks()
  local base = resolve(false)
  if not base then
    return
  end

  local diff = run({ "git", "diff", "--no-color", base })
  if not diff then
    return
  end

  if diff == "" then
    vim.notify("no changes against origin/" .. state.branch)
    return
  end

  local lines = vim.split(diff, "\n", { plain = true })
  local map = locations(lines)
  local origin = vim.api.nvim_get_current_win()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_name(buf, "git-review://" .. base:sub(1, 7))
  vim.bo[buf].filetype = "diff"
  vim.bo[buf].modifiable = false

  vim.cmd("botright 20split")
  vim.api.nvim_win_set_buf(0, buf)
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.wrap = false
  vim.wo.winfixheight = true

  local function map_key(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
  end

  map_key("<CR>", function()
    local target = map[vim.fn.line(".")]
    if not target then
      return
    end

    if vim.api.nvim_win_is_valid(origin) then
      vim.api.nvim_set_current_win(origin)
    else
      vim.cmd("wincmd p")
    end

    vim.cmd("edit " .. vim.fn.fnameescape(target.file))
    local last = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { math.min(target.lnum, last), 0 })
    vim.cmd("normal! zz")
  end, "Jump to hunk location")

  map_key("]h", "/^@@<CR>", "Next hunk")
  map_key("[h", "?^@@<CR>", "Previous hunk")
  map_key("q", "<CMD>close<CR>", "Close hunk list")
end

return M
