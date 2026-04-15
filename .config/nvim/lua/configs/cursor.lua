--- Cursor Agent chat — docs: lua/configs/README-cursor.md | :help cursor-chat (helptags doc/)
local M = {}

local buf = nil
local win = nil
local job_id = nil
local chat_id = nil
local prompt_ns = vim.api.nvim_create_namespace("cursor_prompt")
local status_ns = vim.api.nvim_create_namespace("cursor_status")
local writing = false

local BUF_NAME = "cursor://chat"
local PROMPT_PREFIX = "> "
local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_timer = nil
local spinner_idx = 0
local spinner_text = ""

local modes = { "agent", "ask", "plan" }
local mode_idx = 1

local function current_mode()
  return modes[mode_idx]
end

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

local function append_text(text)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
  if not text or text == "" then return end

  remove_prompt_line()

  local lines = vim.split(text, "\n", { plain = true })

  writing = true
  vim.bo[buf].modifiable = true

  local last = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""

  vim.api.nvim_buf_set_lines(buf, last - 1, last, false, { last_line .. lines[1] })

  if #lines > 1 then
    vim.api.nvim_buf_set_lines(buf, last, last, false, vim.list_slice(lines, 2))
  end

  vim.bo[buf].modifiable = false
  writing = false

  scroll_to_bottom()
end

local function append_status_line(text, hl_group)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

  remove_prompt_line()

  local last = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""

  writing = true
  vim.bo[buf].modifiable = true

  -- collapse consecutive tool lines: if last line is blank and line above is a [status] line,
  -- replace the blank so tool results form a tight block
  if last_line == "" and last >= 2 then
    local prev = vim.api.nvim_buf_get_lines(buf, last - 2, last - 1, false)[1] or ""
    if prev:match("^%[") then
      vim.api.nvim_buf_set_lines(buf, last - 1, last, false, { text })
    else
      vim.api.nvim_buf_set_lines(buf, last, last, false, { text })
      last = last + 1
    end
  else
    vim.api.nvim_buf_set_lines(buf, last, last, false, { text })
    last = last + 1
  end

  if hl_group then
    vim.api.nvim_buf_set_extmark(buf, status_ns, last - 1, 0, {
      line_hl_group = hl_group, priority = 200,
    })
  end

  vim.bo[buf].modifiable = false
  writing = false

  scroll_to_bottom()
end

local SPINNER_PAT = "^%[[⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏]"

local function replace_last_status(text, hl_group)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

  local last = vim.api.nvim_buf_line_count(buf)
  local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""

  if not last_line:match(SPINNER_PAT) then
    writing = true
    vim.bo[buf].modifiable = true
    if last_line == "" then
      -- replace trailing blank line so spinner sits directly under content
      vim.api.nvim_buf_set_lines(buf, last - 1, last, false, { text })
    else
      vim.api.nvim_buf_set_lines(buf, last, last, false, { text })
      last = last + 1
    end
    if hl_group then
      vim.api.nvim_buf_set_extmark(buf, status_ns, last - 1, 0, {
        line_hl_group = hl_group, priority = 200,
      })
    end
    vim.bo[buf].modifiable = false
    writing = false
    scroll_to_bottom()
    return
  end

  writing = true
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, last - 1, last, false, { text })
  vim.api.nvim_buf_clear_namespace(buf, status_ns, last - 1, last)
  if hl_group then
    vim.api.nvim_buf_set_extmark(buf, status_ns, last - 1, 0, {
      line_hl_group = hl_group, priority = 200,
    })
  end
  vim.bo[buf].modifiable = false
  writing = false

  scroll_to_bottom()
end

local function stop_spinner()
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
  if buf and vim.api.nvim_buf_is_valid(buf) then
    local last = vim.api.nvim_buf_line_count(buf)
    local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""
    if last_line:match(SPINNER_PAT) then
      -- replace spinner with empty line (restore the blank it may have consumed)
      buf_set_lines(last - 1, last, false, { "" })
    end
  end
end

local spinner_generation = 0

local function start_spinner(text)
  stop_spinner()
  spinner_text = text or "thinking"
  spinner_idx = 0
  spinner_generation = spinner_generation + 1
  local gen = spinner_generation
  spinner_timer = vim.uv.new_timer()
  spinner_timer:start(0, 80, vim.schedule_wrap(function()
    if gen ~= spinner_generation then return end
    if not spinner_timer then return end
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
      stop_spinner()
      return
    end
    spinner_idx = (spinner_idx % #SPINNER) + 1
    local frame = SPINNER[spinner_idx]
    replace_last_status("[" .. frame .. " " .. spinner_text .. "]", "Comment")
  end))
end

local function separator(prompt)
  local ts = os.date("%H:%M:%S")
  return { string.rep("─", 40), "you (" .. ts .. "): " .. prompt, "", "" }
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

  for _, key in ipairs({ "i", "a", "A", "I", "o", "O" }) do
    vim.keymap.set("n", key, function() enter_insert("startinsert!") end, { buffer = buf })
  end

  vim.keymap.set("n", "dd", function()
    local pline = prompt_line_nr()
    if not pline then return end
    local line = vim.api.nvim_buf_get_lines(buf, pline - 1, pline, false)[1] or ""
    local text = line:sub(#PROMPT_PREFIX + 1)
    if text == "" then return end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, pline - 1, pline, false, { PROMPT_PREFIX })
    vim.api.nvim_win_set_cursor(0, { pline, #PROMPT_PREFIX })
  end, { buffer = buf })

  vim.keymap.set("i", "<BS>", function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local pline = prompt_line_nr()
    if pline and row == pline and col <= #PROMPT_PREFIX then
      return ""
    end
    return "<BS>"
  end, { buffer = buf, expr = true, replace_keycodes = true })

  vim.keymap.set("n", "<Esc>", function()
    local pline = prompt_line_nr()
    if pline then
      snap_to_prompt()
      vim.bo[buf].modifiable = true
    end
  end, { buffer = buf })

  vim.api.nvim_create_autocmd("CursorMovedI", {
    buffer = buf,
    callback = function()
      if writing then return end
      local pline = prompt_line_nr()
      if not pline then return end
      snap_to_prompt()
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      if writing then return end
      local m = vim.fn.mode()
      if m:match("[vVsS\22\19]") then return end
      local pline = prompt_line_nr()
      if not pline then return end
      local on_prompt = vim.api.nvim_win_get_cursor(0)[1] == pline
      vim.bo[buf].modifiable = on_prompt
    end,
  })
end

local function ensure_chat_id(callback)
  if chat_id then
    callback()
    return
  end
  vim.fn.jobstart({ "cursor-agent", "create-chat" }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local id = vim.trim(table.concat(data, ""))
        if id ~= "" then chat_id = id end
      end
    end,
    on_exit = function()
      vim.schedule(callback)
    end,
  })
end

local function rel_path(abs)
  if not abs then return nil end
  local cwd = vim.fn.getcwd() .. "/"
  if abs:sub(1, #cwd) == cwd then
    return abs:sub(#cwd + 1)
  end
  return abs
end

local function tool_type(tool_call)
  if tool_call.shellToolCall then return "shell"
  elseif tool_call.readToolCall then return "read"
  elseif tool_call.editToolCall then return "edit"
  elseif tool_call.listToolCall then return "list"
  elseif tool_call.grepToolCall then return "grep"
  end
  return "tool"
end

local function get_tool_description(tool_call)
  if not tool_call then return nil end
  local kind = tool_type(tool_call)
  if tool_call.description and tool_call.description ~= "" then
    return kind .. ": " .. tool_call.description
  end
  local tc = tool_call.shellToolCall
    or tool_call.readToolCall
    or tool_call.editToolCall
    or tool_call.listToolCall
    or tool_call.grepToolCall
  if tc and tc.description then return kind .. ": " .. tc.description end
  if tc and tc.args then
    local target = tc.args.command or tc.args.pattern or rel_path(tc.args.path)
    if target then return kind .. ": " .. target end
  end
  return kind
end

local function get_tool_result_info(tool_call)
  if not tool_call then return nil end
  local kind = tool_type(tool_call)

  local tc = tool_call.shellToolCall
  if tc then
    local r = tc.result and tc.result.success
    if r then
      local code = r.exitCode or 0
      local cmd = r.command or ""
      if code ~= 0 then
        return "[" .. kind .. "] exit " .. code .. ": " .. cmd, "DiagnosticError"
      end
      return "[" .. kind .. "] " .. cmd, "Comment"
    end
  end

  tc = tool_call.editToolCall
  if tc then
    local path = rel_path(tc.args and tc.args.path) or ""
    local r = tc.result and tc.result.success
    if r then
      local added = r.linesAdded or 0
      local removed = r.linesRemoved or 0
      return "[" .. kind .. "] " .. path .. " (+" .. added .. " -" .. removed .. ")", "Comment"
    end
    return "[" .. kind .. "] " .. path, "Comment"
  end

  tc = tool_call.readToolCall
  if tc then
    local path = rel_path(tc.args and tc.args.path) or ""
    local r = tc.result and tc.result.success
    if r then
      local lines = r.totalLines or 0
      return "[" .. kind .. "] " .. path .. " (" .. lines .. " lines)", "Comment"
    end
    return "[" .. kind .. "] " .. path, "Comment"
  end

  local desc = get_tool_description(tool_call) or "done"
  return "[" .. kind .. "] " .. desc, "Comment"
end

local response_started = false
local last_assistant_text = ""
local last_status_text = ""
local text_idle_timer = nil

local function handle_event(event)
  if not event or not event.type then return end

  if event.type == "thinking" then
    vim.schedule(function()
      if event.subtype == "completed" then
        stop_spinner()
        start_spinner("working")
      else
        start_spinner("thinking")
      end
    end)

  elseif event.type == "tool_call" then
    if event.subtype == "started" then
      local desc = get_tool_description(event.tool_call) or "working..."
      vim.schedule(function()
        stop_spinner()
        start_spinner(desc)
      end)
    elseif event.subtype == "completed" then
      local text, hl = get_tool_result_info(event.tool_call)
      vim.schedule(function()
        stop_spinner()
        if text and text ~= last_status_text then
          append_status_line(text, hl or "Comment")
          last_status_text = text
        end
        start_spinner("working")
      end)
    end

  elseif event.type == "assistant" then
    if event.message and event.message.content then
      local is_final = not event.timestamp_ms
      local full = ""
      for _, part in ipairs(event.message.content) do
        if part.type == "text" and part.text then
          full = full .. part.text
        end
      end
      if is_final then return end
      local trimmed = vim.trim(full)
      if trimmed == "" then return end
      -- skip if this text (or most of it) is already in the accumulator
      if #trimmed > 5 and last_assistant_text:find(trimmed, 1, true) then return end
      -- skip replays: if the accumulator is contained in the new text, it's a repeat
      local last_trimmed = vim.trim(last_assistant_text)
      if #last_trimmed > 10 and trimmed:find(last_trimmed, 1, true) then return end
      last_assistant_text = last_assistant_text .. full
      vim.schedule(function()
        -- kill any active spinner so it doesn't interleave with text
        if spinner_timer then
          spinner_timer:stop()
          spinner_timer:close()
          spinner_timer = nil
          if buf and vim.api.nvim_buf_is_valid(buf) then
            local last = vim.api.nvim_buf_line_count(buf)
            local last_line = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""
            if last_line:match(SPINNER_PAT) then
              buf_set_lines(last - 1, last, false, {})
            end
          end
        end
        if not response_started then
          response_started = true
        end
        append_text(full)
        -- restart spinner after a short idle (no more text chunks)
        if text_idle_timer then
          text_idle_timer:stop()
          text_idle_timer:close()
        end
        text_idle_timer = vim.uv.new_timer()
        text_idle_timer:start(300, 0, vim.schedule_wrap(function()
          text_idle_timer = nil
          if job_id then start_spinner("working") end
        end))
      end)
    end

  elseif event.type == "result" then
    -- final result, text already streamed via assistant deltas
  end
end

function M.send(prompt)
  if not prompt or prompt == "" then
    vim.notify("Usage: :Cursor <prompt>", vim.log.levels.WARN)
    return
  end

  response_started = false
  last_assistant_text = ""
  last_status_text = ""

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

  start_spinner("thinking")

  if job_id then
    vim.fn.jobstop(job_id)
    job_id = nil
  end

  local line_buf = ""

  local function process_stdout(_, data, _)
    if not data then return end
    for _, chunk in ipairs(data) do
      if chunk == "" then
        if line_buf ~= "" then
          local ok, event = pcall(vim.json.decode, line_buf)
          if ok and event then handle_event(event) end
          line_buf = ""
        end
      else
        line_buf = line_buf .. chunk
      end
    end
  end

  ensure_chat_id(function()
    local cmd = {
      "cursor-agent", "--print",
      "--output-format", "stream-json",
      "--stream-partial-output",
    }
    local m = current_mode()
    if m ~= "agent" then
      table.insert(cmd, "--mode")
      table.insert(cmd, m)
    end
    if chat_id then
      table.insert(cmd, "--resume")
      table.insert(cmd, chat_id)
    end
    table.insert(cmd, prompt)

    job_id = vim.fn.jobstart(cmd, {
      stdout_buffered = false,
      on_stdout = process_stdout,
      on_stderr = function() end,
      on_exit = function(_, code, _)
        vim.schedule(function()
          stop_spinner()
          if line_buf ~= "" then
            local ok, event = pcall(vim.json.decode, line_buf)
            if ok and event then handle_event(event) end
            line_buf = ""
          end
          job_id = nil
          if code ~= 0 then
            vim.notify("cursor-agent exited with code " .. code, vim.log.levels.ERROR)
          end
          add_prompt()
        end)
      end,
    })
  end)
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

function M.cycle_mode()
  mode_idx = (mode_idx % #modes) + 1
  vim.notify("Cursor mode: " .. current_mode(), vim.log.levels.INFO)
end

function M.new_chat()
  chat_id = nil
  if buf and vim.api.nvim_buf_is_valid(buf) then
    buf_set_lines(0, -1, false, { "" })
  end
  ensure_buf()
  open_win()
  add_prompt()
  vim.notify("New Cursor chat", vim.log.levels.INFO)
end

local function get_transcripts_dir()
  local cwd = vim.fn.getcwd()
  local slug = cwd:gsub("^/", ""):gsub("/", "-")
  return vim.fn.expand("~/.cursor/projects/" .. slug .. "/agent-transcripts")
end

local MAX_HISTORY = 3

local function extract_text(content)
  if type(content) ~= "table" then return nil end
  local parts = {}
  for _, c in ipairs(content) do
    if c.type == "text" and c.text then
      local t = c.text
      t = t:gsub("<user_query>%s*", ""):gsub("%s*</user_query>", "")
      t = vim.trim(t)
      if t ~= "" then table.insert(parts, t) end
    end
  end
  if #parts == 0 then return nil end
  return table.concat(parts, "\n")
end

local function read_chat_history(jsonl_path)
  local f = io.open(jsonl_path, "r")
  if not f then return {} end

  local exchanges = {}
  local current_user = nil

  for line in f:lines() do
    local ok, data = pcall(vim.json.decode, line)
    if ok and data then
      if data.role == "user" and data.message and data.message.content then
        current_user = extract_text(data.message.content)
      elseif data.role == "assistant" and data.message and data.message.content then
        local text = extract_text(data.message.content)
        if current_user and text then
          table.insert(exchanges, { user = current_user, assistant = text })
          current_user = nil
        end
      end
    end
  end

  f:close()

  local start = math.max(1, #exchanges - MAX_HISTORY + 1)
  local recent = {}
  for i = start, #exchanges do
    table.insert(recent, exchanges[i])
  end
  return recent
end

local function render_history(history)
  local lines = {}
  for _, ex in ipairs(history) do
    table.insert(lines, string.rep("─", 60))
    local user_lines = vim.split(ex.user:sub(1, 200), "\n", { plain = true })
    user_lines[1] = "**you:** " .. (user_lines[1] or "")
    for _, ul in ipairs(user_lines) do
      table.insert(lines, ul)
    end
    table.insert(lines, "")
    local resp = ex.assistant
    if #resp > 500 then
      resp = resp:sub(1, 500) .. "\n\n*(...truncated)*"
    end
    for _, l in ipairs(vim.split(resp, "\n", { plain = true })) do
      table.insert(lines, l)
    end
    table.insert(lines, "")
  end
  return lines
end

local function read_first_prompt(jsonl_path)
  local f = io.open(jsonl_path, "r")
  if not f then return nil end
  local line = f:read("*l")
  f:close()
  if not line then return nil end
  local ok, data = pcall(vim.json.decode, line)
  if not ok or not data or not data.message then return nil end
  local content = data.message.content
  if type(content) == "table" and content[1] and content[1].text then
    local text = content[1].text
    text = text:gsub("<user_query>%s*", ""):gsub("%s*</user_query>", "")
    text = vim.trim(text)
    if #text > 80 then text = text:sub(1, 80) .. "…" end
    return text
  end
  return nil
end

function M.pick_chat()
  local ok, err = pcall(function()
    local dir = get_transcripts_dir()
    if vim.fn.isdirectory(dir) == 0 then
      vim.notify("No transcripts at: " .. dir, vim.log.levels.WARN)
      return
    end

    local entries = {}
    local dirs = vim.fn.globpath(dir, "*", false, true)
    for _, d in ipairs(dirs) do
      if vim.fn.isdirectory(d) == 1 then
        local id = vim.fn.fnamemodify(d, ":t")
        local jsonl = d .. "/" .. id .. ".jsonl"
        if vim.fn.filereadable(jsonl) == 1 then
          local mtime = vim.fn.getftime(jsonl)
          local prompt = read_first_prompt(jsonl) or "(empty)"
          table.insert(entries, { id = id, prompt = prompt, mtime = mtime })
        end
      end
    end

    table.sort(entries, function(a, b) return a.mtime > b.mtime end)

    if #entries == 0 then
      vim.notify("No chat sessions found", vim.log.levels.WARN)
      return
    end

    local tel_pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    tel_pickers.new({}, {
      prompt_title = "Cursor Chats",
      finder = finders.new_table({
        results = entries,
        entry_maker = function(entry)
          local date = os.date("%m/%d %H:%M", entry.mtime)
          local display = date .. "  " .. entry.prompt
          return {
            value = entry,
            display = display,
            ordinal = entry.prompt,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          if entry then
            chat_id = entry.value.id
            if buf and vim.api.nvim_buf_is_valid(buf) then
              buf_set_lines(0, -1, false, { "" })
            end
            ensure_buf()
            open_win()

            local jsonl = dir .. "/" .. chat_id .. "/" .. chat_id .. ".jsonl"
            local history = read_chat_history(jsonl)
            local prompt_safe = entry.value.prompt:gsub("\n", " ")
            local header = { "**Resumed:** " .. prompt_safe, "" }
            local history_lines = render_history(history)
            vim.list_extend(header, history_lines)

            buf_set_lines(0, -1, false, header)
            add_prompt()
          end
        end)
        return true
      end,
    }):find()
  end)
  if not ok then
    vim.notify("CursorPick error: " .. tostring(err), vim.log.levels.ERROR)
  end
end

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

vim.api.nvim_create_user_command("CursorNew", function()
  M.new_chat()
end, { desc = "Start a new Cursor chat" })

vim.api.nvim_create_user_command("CursorPick", function()
  M.pick_chat()
end, { desc = "Pick a previous Cursor chat to resume" })

vim.api.nvim_create_user_command("CursorMode", function()
  M.cycle_mode()
end, { desc = "Cycle Cursor mode: agent/ask/plan" })

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    if ev.buf == buf then set_buf_keymaps() end
  end,
})

return M
