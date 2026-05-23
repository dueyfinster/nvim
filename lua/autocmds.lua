vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    -- Start Treesitter when a parser exists; skip unsupported filetypes quietly.
    pcall(vim.treesitter.start, args.buf)
  end,
})
