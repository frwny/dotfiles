local M = {}

local buf = nil
local win = nil
local job_id = nil
local prompt_ns = vim.api.nvim_create_namespace("cursor_prompt")
local writing = false

local BUF_NAME = "cursor://chat"
local PROMPT_PREFIX = "> "

local function buf_set_lines(...)
  writing = true
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, ...)
  vim.bo[buf].modifiable = false
  writing = false
end

local function ensure_buf()
  if buf and vim.api.nvim_buf_is_valid(buf) then
    return
  end
  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, BUF_NAME)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
end

local function prompt_line_nr()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return nil end
  local last = vim.api.nvim_buf_line_count(buf)
  local line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""
  if line:sub(1, #PROMPT_PREFIX) == PROMPT_PREFIX then return last end
  return nil
end

local function snap_to_prompt()
  local pline = prompt_line_nr()
  if not pline then return end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  if row ~= pline then
    local col = #(vim.api.nvim_buf_get_lines(buf, pline - 1, pline, false)[1] or "")
    vim.api.nvim_win_set_cursor(0, { pline, math.max(col, #PROMPT_PREFIX) })
  end
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col < #PROMPT_PREFIX then
    vim.api.nvim_win_set_cursor(0, { pline, #PROMPT_PREFIX })
  end
end

local split_mode = "vertical"

local function open_win()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    return
  end
  if split_mode == "vertical" then
    local width = math.floor(vim.o.columns * 0.3)
    vim.cmd("botright " .. width .. "vsplit")
  else
    local height = math.floor(vim.o.lines * 0.3)
    vim.cmd("botright " .. height .. "split")
  end
  win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true
end

local function scroll_to_bottom()
  if win and vim.api.nvim_win_is_valid(win) then
    local last = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_win_set_cursor(win, { last, 0 })
  end
end

local function add_prompt()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

  local last = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""

  if last_line:sub(1, #PROMPT_PREFIX) == PROMPT_PREFIX then return end

  local lines = {}
  if last_line ~= "" then table.insert(lines, "") end
  table.insert(lines, PROMPT_PREFIX)
  buf_set_lines(last, last, false, lines)

  last = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_buf_clear_namespace(buf, prompt_ns, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, prompt_ns, "Question", last - 1, 0, #PROMPT_PREFIX)

  scroll_to_bottom()

  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_cursor(win, { last, #PROMPT_PREFIX })
    if vim.api.nvim_get_current_win() == win then
      vim.cmd("startinsert!")
    end
  end
end

local function remove_prompt_line()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
  local last = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""
  if last_line:sub(1, #PROMPT_PREFIX) == PROMPT_PREFIX then
    buf_set_lines(last - 1, last, false, {})
  end
end

local function append_lines(data)
  vim.schedule(function()
    if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

    remove_prompt_line()

    local last = vim.api.nvim_buf_line_count(buf)
    local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""

    writing = true
    vim.bo[buf].modifiable = true
    for i, chunk in ipairs(data) do
      if i == 1 then
        vim.api.nvim_buf_set_lines(buf, last - 1, last, false, { last_line .. chunk })
      else
        last = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_buf_set_lines(buf, last, last, false, { chunk })
      end
    end
    vim.bo[buf].modifiable = false
    writing = false

    scroll_to_bottom()
  end)
end

local function separator(prompt)
  local ts = os.date("%H:%M:%S")
  return { "", string.rep("─", 60), "**[" .. ts .. "]** " .. prompt, "" }
end

local function enter_insert(insert_cmd)
  local pline = prompt_line_nr()
  if not pline then return end
  snap_to_prompt()
  vim.bo[buf].modifiable = true
  vim.cmd(insert_cmd or "startinsert!")
end

local function set_buf_keymaps()
  vim.keymap.set("i", "<CR>", function()
    local pline = prompt_line_nr()
    if not pline then return end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    if row ~= pline then return end

    local line = vim.api.nvim_buf_get_lines(buf, pline - 1, pline, false)[1] or ""
    local prompt = vim.trim(line:sub(#PROMPT_PREFIX + 1))
    if prompt == "" then return end

    vim.cmd("stopinsert")
    M.send(prompt)
  end, { buffer = buf, desc = "Send Cursor prompt" })

  for _, key in ipairs({ "i", "a", "A", "I" }) do
    vim.keymap.set("n", key, function() enter_insert("startinsert!") end, { buffer = buf })
  end

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = buf,
    callback = function()
      if writing then return end
      if prompt_line_nr() then snap_to_prompt() end
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    buffer = buf,
    callback = function()
      if writing then return end
      vim.bo[buf].modifiable = false
    end,
  })
end

function M.send(prompt)
  if not prompt or prompt == "" then
    vim.notify("Usage: :Cursor <prompt>", vim.log.levels.WARN)
    return
  end

  ensure_buf()
  open_win()

  remove_prompt_line()

  local sep = separator(prompt)
  local last = vim.api.nvim_buf_line_count(buf)
  local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
  if first_line == "" and last == 1 then
    buf_set_lines(0, -1, false, sep)
  else
    buf_set_lines(last, last, false, sep)
  end

  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
  end

  job_id = vim.fn.jobstart({
    "cursor-agent", "--print", prompt,
  }, {
    stdout_buffered = false,
    on_stdout = function(_, data, _)
      if data then append_lines(data) end
    end,
    on_stderr = function(_, data, _)
      if data then append_lines(data) end
    end,
    on_exit = function(_, code, _)
      vim.schedule(function()
        job_id = nil
        if code ~= 0 then
          vim.notify("cursor-agent exited with code " .. code, vim.log.levels.ERROR)
        end
        add_prompt()
      end)
    end,
  })
end

function M.stop()
  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
    vim.notify("Cursor stopped", vim.log.levels.INFO)
    add_prompt()
  end
end

function M.toggle()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
  else
    ensure_buf()
    open_win()
    add_prompt()
  end
end

function M.open_vertical()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
  end
  split_mode = "vertical"
  ensure_buf()
  open_win()
  add_prompt()
end

function M.open_horizontal()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
  end
  split_mode = "horizontal"
  ensure_buf()
  open_win()
  add_prompt()
end

function M.clear()
  if buf and vim.api.nvim_buf_is_valid(buf) then
    buf_set_lines(0, -1, false, { "" })
    add_prompt()
  end
end

function M.setup()
  vim.api.nvim_create_user_command("Cursor", function(opts)
    M.send(opts.args)
  end, { nargs = "+", desc = "Send prompt to Cursor agent" })

  vim.api.nvim_create_user_command("CursorStop", function()
    M.stop()
  end, { desc = "Stop running Cursor agent job" })

  vim.api.nvim_create_user_command("CursorToggle", function()
    M.toggle()
  end, { desc = "Toggle Cursor chat window" })

  vim.api.nvim_create_user_command("CursorClear", function()
    M.clear()
  end, { desc = "Clear Cursor chat buffer" })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(ev)
      if ev.buf == buf then set_buf_keymaps() end
    end,
  })
end

return M
