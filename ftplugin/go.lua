vim.opt_local.expandtab = false

local output_buf
local output_win
local job_id

local function output_height()
  return math.max(10, math.floor(vim.o.lines / 3))
end

local function ensure_output_window(source_win)
  if output_win and vim.api.nvim_win_is_valid(output_win) then
    if vim.api.nvim_win_get_tabpage(output_win) == vim.api.nvim_win_get_tabpage(source_win) then
      vim.api.nvim_win_set_height(output_win, output_height())
      return
    end
  end

  vim.cmd("botright split")
  output_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(output_win, output_height())
  vim.wo[output_win].number = false
  vim.wo[output_win].relativenumber = false
  vim.wo[output_win].signcolumn = "no"
  vim.wo[output_win].winfixheight = true
  vim.api.nvim_set_current_win(source_win)
end

local function ensure_output_buffer()
  if output_buf and vim.api.nvim_buf_is_valid(output_buf) then
    return
  end

  output_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[output_buf].bufhidden = "wipe"
  vim.bo[output_buf].buflisted = false
  vim.bo[output_buf].filetype = "log"
  vim.bo[output_buf].swapfile = false
end

local function set_output(lines)
  ensure_output_buffer()
  vim.bo[output_buf].modifiable = true
  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, lines)
  vim.bo[output_buf].modifiable = false
end

local function append_output(lines)
  if not lines or vim.tbl_isempty(lines) then
    return
  end

  if #lines == 1 and lines[1] == "" then
    return
  end

  ensure_output_buffer()
  vim.bo[output_buf].modifiable = true
  vim.api.nvim_buf_set_lines(output_buf, -1, -1, false, lines)
  vim.bo[output_buf].modifiable = false
end

local function close_go_output()
  if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
    vim.fn.jobstop(job_id)
  end

  job_id = nil

  if output_win and vim.api.nvim_win_is_valid(output_win) then
    vim.api.nvim_win_close(output_win, true)
  end

  output_win = nil
end

local function run_go()
  vim.cmd.write()

  local source_win = vim.api.nvim_get_current_win()
  local cwd = vim.fn.expand("%:p:h")

  ensure_output_window(source_win)
  ensure_output_buffer()
  vim.api.nvim_win_set_buf(output_win, output_buf)

  if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
    vim.fn.jobstop(job_id)
  end

  set_output({ "$ go run ." })

  job_id = vim.fn.jobstart({ "go", "run", "." }, {
    cwd = cwd,
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      vim.schedule(function()
        append_output(data)
      end)
    end,
    on_stderr = function(_, data)
      vim.schedule(function()
        append_output(data)
      end)
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          append_output({ "", string.format("[go run exited with code %d]", code) })
        end
      end)
    end,
  })

  if source_win and vim.api.nvim_win_is_valid(source_win) then
    vim.api.nvim_set_current_win(source_win)
  end
end

vim.api.nvim_buf_create_user_command(0, "GoRun", run_go, {
  desc = "Run go program in an output split",
})

vim.keymap.set("n", "<leader>rr", run_go, {
  buffer = true,
  desc = "Run Go program",
})

vim.keymap.set("n", "<leader>rc", close_go_output, {
  buffer = true,
  desc = "Close Go output",
})
