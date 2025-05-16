return {
  'github/copilot.vim',
  -- Load when editing a file instead of on Neovim startup
  event = { 'BufReadPost', 'BufNewFile' },
  -- Ensure the command is available when needed
  cmd = { 'Copilot' },
  config = function()
    -- Disable the default Tab mapping
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true

    -- Make sure escape key isn't mapped because this was causing issues
    vim.keymap.set('i', '<Esc>', '<Esc>', { noremap = true, silent = true })

    -- Use Ctrl-j to accept suggestions
    vim.keymap.set('i', '<C-j>', 'copilot#Accept("<CR>")', {
      expr = true,
      silent = true,
      replace_keycodes = false,
    })

    -- Use square brackets with Ctrl for navigation
    vim.keymap.set('i', '<C-[>', '<Plug>(copilot-previous)')
    vim.keymap.set('i', '<C-]>', '<Plug>(copilot-next)')

    -- Dismiss with Ctrl-\
    vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-dismiss)')

    -- Run Copilot setup when the plugin is loaded
    vim.defer_fn(function()
      if vim.fn.exists 'g:copilot_setup_done' ~= 1 then
        vim.cmd 'silent! Copilot setup'
        vim.g.copilot_setup_done = 1
      end
    end, 100)
  end,
}
