-- NvChad-aligned TextMate-style runner: nvim/.config/nvim/lua/utils/textmate_run.lua:1
-- <leader>r: visual -> selection, normal def-at-bol -> exec buffer + call func(), else -> current line
-- <leader>R: whole file
-- Output: floating overlay (chadrc.lua:80 style), close with <Esc>/q, no split
local M = {}

local function get_python_cmd()
  -- prefer `uv run python` for project-aware venv (falls back to python3)
  -- override with :let g:textmate_python_cmd = "python3" or "uv run --with pandas python"
  if vim.g.textmate_python_cmd then
    return vim.g.textmate_python_cmd
  end
  if vim.fn.executable "uv" == 1 then
    return "uv run python"
  end
  return "python3"
end

local function get_func_name(line)
  return line:match "^%s*async%s+def%s+([%w_]+)%s*%(" or line:match "^%s*def%s+([%w_]+)%s*%("
end

local function is_on_def_line()
  local line = vim.api.nvim_get_current_line()
  local func = get_func_name(line)
  if not func then
    return nil
  end
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local indent = line:match("^%s*"):len()
  if col <= indent + 3 then
    return func
  end
  return func
end

-- NvChad chadrc float style: 0.7 x 0.6 centered, single border (chadrc.lua:80)
local function show_float(lines, title, is_error)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "text"
  vim.bo[buf].modifiable = false

  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
    title = title or "TextMate",
    title_pos = "center",
  })
  vim.wo[win].wrap = true
  vim.wo[win].cursorline = false
  -- allow Esc/q to close, like NvChad term float (chadrc.lua:80)
  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true, desc = "Close overlay" })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, nowait = true, desc = "Close overlay" })
  vim.keymap.set("n", "<C-c>", close, { buffer = buf, nowait = true, desc = "Close overlay" })
  -- also set hl to match NvChad term float
  vim.api.nvim_set_option_value("winhl", "Normal:Normal,FloatBorder:FloatBorder", { win = win })
  if is_error then
    vim.notify(title or "Error", vim.log.levels.ERROR)
  end
  return buf, win
end

local function run_code(code, title)
  local tmp = vim.fn.tempname() .. ".py"
  vim.fn.writefile(vim.split(code, "\n"), tmp)
  local cmd = string.format("%s %s 2>&1", get_python_cmd(), vim.fn.shellescape(tmp))
  local out = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error
  vim.fn.delete(tmp)

  local lines = vim.split(out, "\n")
  -- keep trailing empty line handling
  if lines[#lines] == "" then
    table.remove(lines)
  end
  if #lines == 0 then
    lines = { exit_code == 0 and "[no output — exit 0]" or "[no output]" }
  end
  -- prepend context
  table.insert(lines, 1, string.format("── %s ── exit:%d ──", title or "output", exit_code))
  table.insert(lines, 1, "")
  local is_error = exit_code ~= 0 or out:match "Traceback" or out:match "Error"
  show_float(lines, title or "Python", is_error)
  return exit_code
end

local function build_code_for_function_call(func_name)
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local buf_code = table.concat(buf_lines, "\n")
  local code = buf_code .. "\n\n# --- TextMate: auto-call " .. func_name .. "() ---\n"
  code = code .. "try:\n"
  code = code .. string.format("  %s()\n", func_name)
  code = code .. "except TypeError as _e:\n"
  code = code .. "  import inspect\n"
  code = code .. string.format('  print(f"[TextMate] %s requires args: {inspect.signature(%s)}")\n', func_name, func_name)
  code = code .. "  raise\n"
  return code
end

function M.run()
  if vim.bo.filetype ~= "python" then
    vim.notify("TextMate: only python (current: " .. vim.bo.filetype .. ")", vim.log.levels.WARN)
    return
  end
  local func = is_on_def_line()
  if func then
    local code = build_code_for_function_call(func)
    run_code(code, "TextMate: " .. func .. "()")
    return
  end
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  if line:match "^%s*$" then
    vim.notify("[TextMate] empty line", vim.log.levels.WARN)
    return
  end
  -- Fix: screenshot shows NameError on `pprint(data)` at line 20 — isolated line lacks
  -- `from pprint import pprint` and `data = {...}` context. Now run with context:
  -- execute buffer up to cursor (imports + definitions + target line), matching
  -- TextMate's "run with file context" expectation. Use `vim.g.textmate_line_isolated = true`
  -- to restore pure isolated `line` behavior.
  local code
  if vim.g.textmate_line_isolated then
    code = line
  else
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, lnum, false)
    code = table.concat(buf_lines, "\n")
  end
  run_code(code, "TextMate: line " .. lnum)
end

function M.run_visual()
  if vim.bo.filetype ~= "python" then
    vim.notify("TextMate: only python", vim.log.levels.WARN)
    return
  end
  local s = vim.fn.getpos "'<"
  local e = vim.fn.getpos "'>"
  local sl, el = s[2], e[2]
  if sl == 0 or el == 0 then
    vim.notify("[TextMate] no selection", vim.log.levels.WARN)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
  local sc, ec = s[3], e[3]
  if #lines == 1 then
    lines[1] = string.sub(lines[1], sc, ec)
  end
  local code = table.concat(lines, "\n")
  if code:match "^%s*$" then
    vim.notify("[TextMate] empty selection", vim.log.levels.WARN)
    return
  end
  -- Visual also needs context (same NameError as screenshot). If `vim.g.textmate_visual_with_context`
  -- (default true), prepend file imports so `pprint` etc. are defined.
  if vim.g.textmate_visual_with_context ~= false then
    local all = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local imports = {}
    for _, l in ipairs(all) do
      if l:match "^%s*from%s+%S+%s+import%s+" or l:match "^%s*import%s+" then
        table.insert(imports, l)
      end
    end
    if #imports > 0 and not code:match "^%s*import%s+" and not code:match "^%s*from%s+" then
      local has_pprint = false
      for _, imp in ipairs(imports) do
        if imp:match "pprint" and code:match "pprint" then
          has_pprint = true
          break
        end
      end
      if has_pprint or #imports <= 3 then
        code = table.concat(imports, "\n") .. "\n" .. code
      end
    end
  end
  run_code(code, "TextMate: selection")
end

function M.run_file()
  if vim.bo.filetype ~= "python" then
    vim.notify("TextMate: only python", vim.log.levels.WARN)
    return
  end
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local code = table.concat(buf_lines, "\n")
  if code:match "^%s*$" then
    vim.notify("[TextMate] empty file", vim.log.levels.WARN)
    return
  end
  local fname = vim.fn.expand "%:t"
  if fname == "" then
    fname = "unsaved"
  end
  run_code(code, "TextMate: " .. fname)
end

return M
