vim.opt_local.expandtab = false

local function run_go()
  vim.cmd.write()

  local source_win = vim.api.nvim_get_current_win()
  local cwd = vim.fn.expand("%:p:h")

  vim.cmd("botright 12split")

  local term_buf = vim.api.nvim_get_current_buf()
  vim.bo[term_buf].buflisted = false

  vim.fn.termopen({ "go", "run", "." }, {
    cwd = cwd,
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(source_win) then
          vim.api.nvim_set_current_win(source_win)
        end
      end)
    end,
  })
end

vim.api.nvim_buf_create_user_command(0, "GoRun", run_go, {
  desc = "Run go program in a terminal split",
})

vim.keymap.set("n", "<leader>rr", run_go, {
  buffer = true,
  desc = "Run Go program",
})
