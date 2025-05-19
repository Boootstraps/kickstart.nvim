return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = function()
    -- Set up hardtime with notify integration
    require('hardtime').setup {
      disable_mouse = false,
      restriction_mode = 'hint',
      notification = true,
      callback = function(message)
        local icon_options = {
          restrict = '󰁢', -- Lock icon
          disabled = '󰂭', -- Ban/no symbol
          hint = '󰌶', -- Lightbulb/hint
          default = '󰥔', -- Footprints (for tracking/habits)
        }

        -- Determine which icon to use based on message content
        local icon = icon_options.default
        if message:match 'is restricted' then
          icon = icon_options.restrict
        elseif message:match 'is disabled' then
          icon = icon_options.disabled
        elseif message:match 'Try' then
          icon = icon_options.hint
        end

        vim.notify(message, vim.log.levels.INFO, {
          title = 'Hardtime',
          icon = icon,
          timeout = 2000,
        })
      end,
    }

    -- Create keymapping for toggling hardtime using the proper command
    vim.keymap.set('n', '<leader>td', function()
      -- Execute the proper command for toggling
      vim.cmd 'Hardtime toggle'

      -- Get the new status after toggling
      -- We'll use vim.defer_fn to let the toggle complete before checking
      vim.defer_fn(function()
        -- Get hardtime status using module (if available)
        local status
        local hardtime_ok, hardtime = pcall(require, 'hardtime')
        if hardtime_ok and hardtime.is_enabled then
          status = hardtime.is_enabled() and 'enabled' or 'disabled'
        else
          -- Fallback if we can't determine status programmatically
          status = 'toggled'
        end

        -- Show notification about the toggle
        vim.notify('Hardtime ' .. status, vim.log.levels.INFO, {
          title = 'Hardtime',
          icon = status == 'enabled' and '󰁢' or '󰂭', -- Lock if enabled, ban if disabled
          timeout = 2000,
        })
      end, 100) -- Short delay to ensure toggle has completed
    end, { noremap = true, silent = true, desc = '[T]oggle Har[d]time' })
  end,
}
