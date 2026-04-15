# Cursor agent UI — `configs.cursor`

| | |
|--|--|
| Lua | `lua/configs/cursor.lua` |
| Vim help | `doc/cursor-chat.txt` — `:helptags` your `doc/`, then `:help cursor-chat` |

Neovim starts **`cursor-agent`** with **`--print`**, **`--output-format stream-json`**, and **`--stream-partial-output`**. Stdout is treated as **newline-delimited JSON**; each decoded object is **`handle_event`**, which mutates the scratch buffer **`cursor://chat`**. A UUID from **`cursor-agent create-chat`** is kept and passed as **`--resume`**. **`:CursorPick`** uses Telescope to read **`~/.cursor/projects/<slug>/agent-transcripts`** and set **`chat_id`**.

---

## Dependencies

**`cursor-agent`** (on `PATH`, CLI auth) · **`vim.uv`** — spinner tick **80 ms**, assistant idle **300 ms** · **telescope.nvim** (only for **`:CursorPick`**)

---

## Configuration

There is **no** `setup()`. `require('configs.cursor')` registers **`:Cursor`**, **`:CursorStop`**, **`:CursorToggle`**, **`:CursorClear`**, **`:CursorNew`**, **`:CursorPick`**, **`:CursorMode`**, and a **BufEnter** autocommand that calls **`set_buf_keymaps()`** when the chat buffer is focused.

This dotfiles repo uses `local function cursor() return require('configs.cursor') end` and **space** as `<Leader>` in **`init.lua`**.

---

## Ex commands

- **`:Cursor {text…}`** — **`M.send`**, **`nargs=+`**. All-whitespace → **`vim.notify`**, no subprocess.  
- **`:CursorStop`** — **`jobstop`**, notify, **`add_prompt`**. Does **not** run **`stop_spinner()`** or cancel **`text_idle_timer`**.  
- **`:CursorToggle`** — Close the chat window, or open the split and **`add_prompt`**.  
- **`:CursorClear`** — Clear transcript; **same** **`chat_id`**.  
- **`:CursorNew`** — **`chat_id = nil`**, empty buffer, open + prompt.  
- **`:CursorPick`** — Telescope resume.  
- **`:CursorMode`** — **agent → ask → plan** (`vim.notify`).

**Argv template:** `cursor-agent --print --output-format stream-json --stream-partial-output` · optional **`--mode ask|plan`** (omitted for **agent**) · optional **`--resume`** + id · **prompt last**. **Stderr** is not read.

---

## Split and buffer

**`botright`** vsplit or split at **`floor(0.3 * &columns)`** or **`&lines`**. **`open_vertical` / `open_horizontal`** close an existing chat window, set **`split_mode`**, reopen, **`add_prompt`**.

**`nofile`**, **`bufhidden=hide`**, **`filetype=markdown`**, no number column / sign column, wrap.

**Prompt:** last line **`> `**. **`prompt_ns`** + **`buf_add_highlight`** → **`Question`** on the prefix only. **Insert** **Enter** on that line invokes **`M.send`** with **`vim.trim`** of the suffix when it is non-empty.

---

## Highlighting model

- **`prompt_ns`:** prefix of **`> `** only (`buf_add_highlight`).  
- **`status_ns`:** **tool** lines and the **spinner** line use **`nvim_buf_set_extmark`** with **`line_hl_group`** = **`Comment`** (default tool style) or **`DiagnosticError`** (failed **shell** in **`get_tool_result_info`**), **`priority = 200`**. The highlight covers the **entire logical line**. Spinner updates **`clear_namespace`** on that row in **`status_ns`** before placing a new extmark.  
- **Assistant** text from **`append_text`** has **no** extra extmarks from this module (markdown / Treesitter apply as usual).

---

## `M.send`

Resets **`response_started`**, **`last_assistant_text`**, **`last_status_text`** — not **`text_idle_timer`**. Inserts **`separator(prompt)`** (40× **`─`**, **`you (HH:MM:SS): …`**, two blanks; replaces a lone empty buffer or appends). **`start_spinner("thinking")`**. Stops any previous **`job_id`**. **`ensure_chat_id`** may run **`create-chat`**, then **`jobstart`**. Stdout chunks are merged; embedded newlines delimit JSON lines → **`handle_event`**.

**`on_exit`:** **`stop_spinner`**, flush **`line_buf`**, **`job_id = nil`**, error notify, **`add_prompt`**.

---

## `handle_event`

**thinking** — **`completed`** → **`stop_spinner`**, **`start_spinner("working")`**; else **`start_spinner("thinking")`**.

**tool_call** — **`started`** → **`stop_spinner`**, spinner with tool label; **`completed`** → **`append_status_line`** (line + **`line_hl_group`**) if text ≠ **`last_status_text`**, then **`start_spinner("working")`**.

**assistant** — Concatenate **`text`** → **`full`**. No **`timestamp_ms`** → return. Empty trim → return. Skip if **`#trimmed > 5`** and **`last_assistant_text`** contains **`trimmed`**. Skip if **`#last_trimmed > 10`** and **`trimmed`** contains **`last_trimmed`**. Else **`last_assistant_text ..= full`**, **`vim.schedule`:** if **`spinner_timer`** active, stop/close it and **delete** last line when **`SPINNER_PAT`** matches; **`response_started`** once; **`append_text(full)`**; reset **300 ms** **`text_idle_timer`** → **`start_spinner("working")`** iff **`job_id`**.

**result** — unused for buffer text.

---

## `append_status_line` layout

If the last line is empty and the previous line **starts with `[`**, the blank is **replaced** by the new tool line; otherwise the line is **appended**. Then **`line_hl_group`** extmark on **`status_ns`**.

---

## Spinner

**`SPINNER_PAT`:** **`[`** + one braille character from **`SPINNER`**. **`replace_last_status`** either replaces a trailing blank, appends, or updates the spinner row (after **`clear_namespace`** on that line). **`stop_spinner`** turns a spinner row into an **empty** line. Assistant handling **deletes** the spinner row when it stops the timer inline.

---

## `:CursorPick`

**`~/.cursor/projects/{slug}/agent-transcripts`**, **`slug`** = **`getcwd()`** with leading **`/`** removed and **`/`** → **`-`**. Subdirs (**UUID**) need **`{uuid}/{uuid}.jsonl`**. Sorted by **mtime** desc. Buffer shows **`**Resumed:** …`** and up to **3** Q/A pairs (**`MAX_HISTORY`**, user **200** / assistant **500** chars + truncation, **60× `─`**).

---

## `M` surface

`send` · `stop` · `toggle` · `open_vertical` · `open_horizontal` · `clear` · `new_chat` · `pick_chat` · `cycle_mode`

---

## Caveats

Dedupe rules are lossy. **`:CursorStop`** vs timers/spinner. **`text_idle_timer`** not reset at **`M.send`** start. Resume assumes Cursor **jsonl** layout.

Dotfiles — your license.
