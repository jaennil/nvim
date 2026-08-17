-- review the current branch against the default branch: added and removed
-- lines are highlighted in the file itself, the hunk list is only navigation
local M = {}

local ns = vim.api.nvim_create_namespace("jaennil_git_review")

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

  return base
end

-- repo root, so diff paths resolve no matter the window's cwd
local function root()
  state.root = state.root or run({ "git", "rev-parse", "--show-toplevel" })
  return state.root
end

-- the theme's diff colors sit a few shades above the background and barely
-- read as green or red, so the review palette is explicit: saturated green
-- for what the branch adds, saturated red for what it removes, with the word
-- diff one step brighter on top of both
local colors = {
  added = "#005f00",
  added_word = "#008700",
  added_sign = "#5fd75f",
  removed = "#5f0000",
  removed_word = "#870000",
  removed_sign = "#ff005f",
}

local function palette()
  -- a changed line is the added half of the change: green line, with
  -- show_deleted putting the red original above it
  for _, group in ipairs({ "GitSignsAddLn", "GitSignsChangeLn" }) do
    vim.api.nvim_set_hl(0, group, { bg = colors.added })
  end

  vim.api.nvim_set_hl(0, "GitSignsDeleteVirtLn", { bg = colors.removed })

  -- signs follow the same two colors, so a blue bar never shows up for a
  -- change that is really an addition
  for _, group in ipairs({ "GitSignsAdd", "GitSignsChange", "GitSignsUntracked" }) do
    vim.api.nvim_set_hl(0, group, { fg = colors.added_sign })
  end

  for _, group in ipairs({ "GitSignsDelete", "GitSignsTopdelete", "GitSignsChangedelete" }) do
    vim.api.nvim_set_hl(0, group, { fg = colors.removed_sign })
  end

  -- word diff regions default to TermCursor (reverse video), which reads as
  -- random bright blocks; keep them in the same palette, one shade brighter
  for _, group in ipairs({ "GitSignsAddInline", "GitSignsAddLnInline", "GitSignsChangeInline", "GitSignsChangeLnInline" }) do
    vim.api.nvim_set_hl(0, group, { bg = colors.added_word })
  end

  for _, group in ipairs({ "GitSignsDeleteInline", "GitSignsDeleteLnInline" }) do
    vim.api.nvim_set_hl(0, group, { bg = colors.removed_word })
  end

  -- inside a fully deleted line the word diff covers arbitrary chunks, leading
  -- whitespace included, which only breaks the line into ragged shades; keep
  -- those lines one flat red
  vim.api.nvim_set_hl(0, "GitSignsDeleteVirtLnInLine", { bg = colors.removed })
end

-- line highlights and deleted lines live in the file buffers, driven by
-- gitsigns against the review base
local function highlight(on)
  local gitsigns = require("gitsigns")

  palette()
  gitsigns.toggle_linehl(on)
  gitsigns.toggle_deleted(on)
  gitsigns.toggle_word_diff(on)
end

-- deleted lines are the noisiest part of the review, so keep them togglable
function M.toggle_deleted()
  require("gitsigns").toggle_deleted()
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
  highlight(true)

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
  highlight(false)
end


-- files with their hunks, each hunk pointing at its first changed line
local function parse(diff)
  local files, file, hunk, lnum = {}, nil, nil, nil

  for _, line in ipairs(vim.split(diff, "\n", { plain = true })) do
    local old = line:match("^%-%-%- a/(.*)$")
    local new = line:match("^%+%+%+ b/(.*)$")
    local start = line:match("^@@ %-[%d,]+ %+(%d+)")
    local kind = line:sub(1, 1)

    if line:match("^diff %-%-git ") then
      file, hunk = nil, nil
    elseif old then
      file = { path = old, added = 0, removed = 0, hunks = {} }
    elseif new or line == "+++ /dev/null" then
      file = file or { added = 0, removed = 0, hunks = {} }
      file.path = new or file.path -- a deleted file keeps its old path
      table.insert(files, file)
    elseif start and file then
      lnum = tonumber(start)
      hunk = { lnum = lnum, added = 0, removed = 0 }
      table.insert(file.hunks, hunk)
    elseif hunk and kind == "+" then
      file.added, hunk.added = file.added + 1, hunk.added + 1
      if not hunk.text then
        hunk.lnum, hunk.sign, hunk.text = lnum, "+", vim.trim(line:sub(2))
      end
      lnum = lnum + 1
    elseif hunk and kind == "-" then
      file.removed, hunk.removed = file.removed + 1, hunk.removed + 1
      if not hunk.text then
        hunk.lnum, hunk.sign, hunk.text = lnum, "-", vim.trim(line:sub(2))
      end
    elseif hunk and kind == " " then
      lnum = lnum + 1
    end
  end

  return files
end

local LIST_NAME = "git-review://"

-- buffers and window left over from a previous list; the buffer survives
-- closing the window, and its name would collide with the new one
local function previous_lists()
  local bufs = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf):find(LIST_NAME, 1, true) then
      table.insert(bufs, buf)
    end
  end

  local win
  for _, candidate in ipairs(vim.api.nvim_list_wins()) do
    if vim.tbl_contains(bufs, vim.api.nvim_win_get_buf(candidate)) then
      win = candidate
    end
  end

  return { bufs = bufs, win = win }
end

-- one line per file, one per hunk; targets[line] is where <CR> jumps
local function render(files)
  local lines, marks, targets = {}, {}, {}

  for _, file in ipairs(files) do
    local path = root() .. "/" .. file.path
    local added = ("+%d"):format(file.added)
    local removed = ("-%d"):format(file.removed)

    table.insert(lines, ("%s  %s %s"):format(file.path, added, removed))
    targets[#lines] = {
      file = path,
      lnum = file.hunks[1] and file.hunks[1].lnum or 1,
      header = true,
    }

    local col = #file.path + 2
    table.insert(marks, { #lines, 0, #file.path, "Directory" })
    table.insert(marks, { #lines, col, col + #added, "Added" })
    table.insert(marks, { #lines, col + #added + 1, col + #added + 1 + #removed, "Removed" })

    for _, hunk in ipairs(file.hunks) do
      local number = ("%6d"):format(hunk.lnum)
      local sign = hunk.sign or " "
      table.insert(lines, ("%s  %s %s"):format(number, sign, hunk.text or ""))
      targets[#lines] = { file = path, lnum = hunk.lnum }
      table.insert(marks, { #lines, 0, #number, "LineNr" })
      table.insert(marks, { #lines, #number + 2, #number + 3, sign == "-" and "Removed" or "Added" })
    end
  end

  return lines, marks, targets
end

-- the panel itself: a scratch buffer in a bottom split, reusing the window of
-- a list opened earlier
local function open_panel(name, lines, marks)
  local stale = previous_lists()
  local origin = vim.api.nvim_get_current_win()
  if stale.win and origin == stale.win then
    origin = vim.fn.win_getid(vim.fn.winnr("#"))
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "git-review"
  vim.bo[buf].bufhidden = "wipe"

  for _, mark in ipairs(marks) do
    local line, from, to, group = unpack(mark)
    vim.api.nvim_buf_set_extmark(buf, ns, line - 1, from, { end_col = to, hl_group = group })
  end

  vim.bo[buf].modifiable = false

  if vim.api.nvim_win_is_valid(stale.win or -1) then
    vim.api.nvim_win_set_buf(stale.win, buf)
    vim.api.nvim_set_current_win(stale.win)
  else
    vim.cmd("botright 15split")
    vim.api.nvim_win_set_buf(0, buf)
  end

  for _, old_buf in ipairs(stale.bufs) do
    if vim.api.nvim_buf_is_valid(old_buf) then
      vim.api.nvim_buf_delete(old_buf, { force = true })
    end
  end

  vim.api.nvim_buf_set_name(buf, LIST_NAME .. name)
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  vim.wo.wrap = false
  vim.wo.cursorline = true
  vim.wo.winfixheight = true

  return buf, vim.api.nvim_get_current_win(), origin
end

local function map_key(buf, lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
end

-- shared by every hunk list: jumping into the file, walking files, closing
local function hunk_panel(name, lines, marks, targets, back)
  local buf, list, origin = open_panel(name, lines, marks)

  local function open(focus)
    local target = targets[vim.fn.line(".")]
    if not target then
      return
    end

    if not vim.uv.fs_stat(target.file) then
      vim.notify(target.file .. " is gone in the working tree", vim.log.levels.WARN)
      return
    end

    if vim.api.nvim_win_is_valid(origin) then
      vim.api.nvim_set_current_win(origin)
    else
      vim.cmd("wincmd p")
    end

    vim.cmd("edit " .. vim.fn.fnameescape(target.file))
    local last = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { math.min(math.max(target.lnum, 1), last), 0 })
    vim.cmd("normal! zz")

    if not focus and vim.api.nvim_win_is_valid(list) then
      vim.api.nvim_set_current_win(list)
    end
  end

  -- next/previous file header, so ]f skips over the hunks in between
  local function to_file(step)
    local line = vim.fn.line(".")
    for i = line + step, step > 0 and #lines or 1, step do
      if targets[i] and targets[i].header then
        vim.api.nvim_win_set_cursor(list, { i, 0 })
        return
      end
    end
  end

  map_key(buf, "<CR>", function()
    open(true)
  end, "Open hunk")
  map_key(buf, "o", function()
    open(false)
  end, "Preview hunk, keep focus on the list")
  map_key(buf, "]f", function()
    to_file(1)
  end, "Next file")
  map_key(buf, "[f", function()
    to_file(-1)
  end, "Previous file")
  map_key(buf, "q", "<CMD>close<CR>", "Close hunk list")

  if back then
    map_key(buf, "<BS>", back, "Back to the commit list")
  end
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

  require("gitsigns").change_base(base, true)
  highlight(true)

  local lines, marks, targets = render(parse(diff))
  hunk_panel(base:sub(1, 7), lines, marks, targets)
end

-- the empty tree, so the first commit in a repo diffs against something
local EMPTY_TREE = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"

-- one commit's own changes: diffed against its parent, with gitsigns showing
-- the same range in the files
function M.commit(rev, back)
  local parent = run({ "git", "rev-parse", "--verify", "--quiet", rev .. "^" }, true) or EMPTY_TREE
  local diff = run({ "git", "diff", "--no-color", parent, rev })

  if not diff or diff == "" then
    vim.notify("no changes in " .. rev)
    return
  end

  require("gitsigns").change_base(parent, true)
  highlight(true)

  local lines, marks, targets = render(parse(diff))
  hunk_panel(rev, lines, marks, targets, back)
end

local function commit_entries(limit)
  local log = run({ "git", "log", "--no-color", "-n", tostring(limit), "--pretty=format:%h\30%ar\30%an\30%s" })
  if not log then
    return nil
  end

  local entries = {}
  for line in vim.gsplit(log, "\n", { plain = true, trimempty = true }) do
    local parts = vim.split(line, "\30", { plain = true })
    table.insert(entries, { rev = parts[1], age = parts[2], author = parts[3], subject = parts[4] })
  end

  return entries
end

local function render_commits(entries)
  local lines, marks, targets = {}, {}, {}
  local width = 0

  for _, entry in ipairs(entries) do
    width = math.max(width, #entry.age)
  end

  for _, entry in ipairs(entries) do
    local age = ("%-" .. width .. "s"):format(entry.age)
    table.insert(lines, ("%s  %s  %s"):format(entry.rev, age, entry.subject))
    targets[#lines] = entry

    local age_at = #entry.rev + 2
    table.insert(marks, { #lines, 0, #entry.rev, "Added" })
    table.insert(marks, { #lines, age_at, age_at + #age, "Comment" })
  end

  return lines, marks, targets
end

-- pick a commit, then walk its diff; <CR> drills in, <BS> comes back here
function M.commits(limit)
  local entries = commit_entries(limit or 100)
  if not entries or #entries == 0 then
    vim.notify("no commits", vim.log.levels.WARN)
    return
  end

  local lines, marks, targets = render_commits(entries)
  local buf = open_panel("commits", lines, marks)

  map_key(buf, "<CR>", function()
    local entry = targets[vim.fn.line(".")]
    if entry then
      M.commit(entry.rev, function()
        M.commits(limit)
      end)
    end
  end, "Show this commit's diff")
  map_key(buf, "q", "<CMD>close<CR>", "Close commit list")
end

return M
