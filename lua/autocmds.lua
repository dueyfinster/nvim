vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    -- Start Treesitter when a parser exists; skip unsupported filetypes quietly.
    pcall(vim.treesitter.start, args.buf)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
