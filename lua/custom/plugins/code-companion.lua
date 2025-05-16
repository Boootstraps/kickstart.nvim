return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'folke/which-key.nvim',
  },
  keys = function()
    local function switch_model(adapter, model, message)
      return function()
        local conf = require('codecompanion.config').config
        -- Set the active adapter
        conf.strategies.chat.adapter = adapter
        -- Update the model if the adapter is a function
        if type(conf.adapters[adapter]) == 'function' then
          local adapter_instance = conf.adapters[adapter]()
          if adapter_instance and adapter_instance.set_model then
            adapter_instance:set_model(model)
          end
        end
        -- Notify the user
        vim.notify(message, vim.log.levels.INFO)
      end
    end
    return {
      -- Toggle keymaps
      { '<leader>t', group = '[T]oggle' },
      { '<leader>tc', '<cmd>CodeCompanionChat Toggle<cr>', desc = '[T]oggle [C]hat' },
      { '<leader>ta', '<cmd>CodeCompanionActions<cr>', desc = '[T]oggle [A]ction Palette' },
      { '<leader>tm', group = '[M]odel Selection' },
      {
        '<leader>tmo',
        switch_model('openai', 'gpt-4o', 'Switched to OpenAI GPT-4o'),
        desc = 'Switch to OpenAI GPT-4[o]',
      },
      {
        '<leader>tma',
        switch_model('anthropic', 'claude-3-7-sonnet', 'Switched to Claude 3.7 Sonnet'),
        desc = 'Switch to [A]nthropic Claude',
      },
      {
        '<leader>tmg',
        function()
          require('codecompanion.config').config.strategies.chat.adapter = 'copilot'
          vim.notify('Switched to GitHub Copilot', vim.log.levels.INFO)
        end,
        desc = 'Switch to [G]itHub Copilot',
      },

      -- Code Companion keymaps
      { '<leader>c', group = '[C]ode Companion' },
      { '<leader>ci', '<cmd>CodeCompanion<cr>', desc = '[C]ode Companion [I]nline', mode = { 'v', 'n' } },
      { '<leader>cb', '<cmd>CodeCompanion #buffer<cr>', desc = '[C]ode Companion with [B]uffer context', mode = { 'n' } },

      -- Diff mode keymaps (these are the defaults, but making them explicit)
      { 'ga', desc = 'Accept inline edit' },
      { 'gr', desc = 'Reject inline edit' },
    }
  end,
  config = function()
    -- Setup CodeCompanion
    require('codecompanion').setup {
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = { api_key = os.getenv 'OPENAI_API_KEY' },
            options = { model = 'gpt-4o' },
          })
        end,
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = os.getenv 'ANTHROPIC_API_KEY' },
            options = { model = 'claude-3-7-sonnet' },
          })
        end,
      },
      strategies = {
        chat = { adapter = 'copilot' },
        inline = {
          adapter = 'copilot',
          -- Custom keymaps for diff mode (if you want to change them)
          keymaps = {
            accept_change = {
              modes = { n = 'ga' },
              description = 'Accept change',
            },
            reject_change = {
              modes = { n = 'gr' },
              description = 'Reject change',
            },
          },
        },
      },
      display = {
        chat = {
          position = 'right',
          size = { width = '40%', height = '90%' },
          border = 'rounded',
        },
        action_palette = { provider = 'default' },
        -- Configure diff display options here
        diff = {
          provider = 'default', -- Use 'default' to enable diff mode, or false to disable
          options = {
            ignore_whitespace = false, -- Set to true to ignore whitespace in diff
            algorithm = 'patience', -- Use 'myers' or 'patience' algorithm
          },
        },
      },
      keymaps = {
        chat = { send = { '<C-s>', '<CR>' }, cancel = { '<C-c>' } },
      },
    }
    -- Show current adapter status
    vim.api.nvim_create_user_command('CCStatus', function()
      local conf = require('codecompanion.config').config
      local chat_adapter = conf.strategies.chat.adapter
      local inline_adapter = conf.strategies.inline.adapter
      local model = 'default'
      if type(conf.adapters[chat_adapter]) == 'function' then
        local adapter_instance = conf.adapters[chat_adapter]()
        if adapter_instance and adapter_instance.options and adapter_instance.options.model then
          model = adapter_instance.options.model
        end
      end
      vim.notify(string.format('Chat adapter: %s\nInline adapter: %s\nModel: %s', chat_adapter, inline_adapter, model), vim.log.levels.INFO)
    end, {})
    -- Command-line abbreviation
    vim.cmd 'cab cc CodeCompanion'
    -- Startup notification
    vim.defer_fn(function()
      vim.notify('CodeCompanion has started', vim.log.levels.INFO)
    end, 1000)
  end,
}
