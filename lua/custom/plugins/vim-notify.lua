return {
  'rcarriga/nvim-notify',
  lazy = false,
  priority = 1000,
  config = function()
    local notify = require 'notify'

    notify.setup {
      background_colour = '#000000',
      fps = 60,
      icons = {
        DEBUG = '󰒕', -- Bug/debug icon
        ERROR = '󰅚', -- Error icon (cross/x)
        INFO = '󰋽', -- Information icon (i)
        TRACE = '󰥔', -- Trace/footsteps icon
        WARN = '󰀪', -- Warning icon (!)
      },
      level = 2,
      minimum_width = 50,
      render = 'default',
      stages = 'fade',
      timeout = 3000,
      top_down = true,
      merge_duplicates = true,
    }

    vim.notify = notify

    -- Create useful commands
    vim.api.nvim_create_user_command('NotificationHistory', function()
      require('notify').history()
    end, { desc = 'View notification history' })

    vim.api.nvim_create_user_command('NotificationDismiss', function()
      require('notify').dismiss()
    end, { desc = 'Dismiss all notifications' })
  end,
}
