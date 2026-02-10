-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require 'nvim-autopairs'
      npairs.setup {
        check_ts = true, -- Enable treesitter
        ts_config = {
          lua = { 'string' }, -- Don't add pairs in lua string treesitter nodes
          javascript = { 'template_string' },
          typescript = { 'template_string' },
        },
        fast_wrap = {},
        disable_filetype = { 'TelescopePrompt', 'vim' },
      }

      -- Integration with blink.cmp
      -- Set up CR (Enter) mapping for blink.cmp
      local Rule = require 'nvim-autopairs.rule'
      local cond = require 'nvim-autopairs.conds'

      -- Add spaces between parentheses
      npairs.add_rules {
        Rule(' ', ' '):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ '()', '[]', '{}' }, pair)
        end),
        Rule('( ', ' )')
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match '.%)' ~= nil
          end)
          :use_key ')',
        Rule('{ ', ' }')
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match '.%}' ~= nil
          end)
          :use_key '}',
        Rule('[ ', ' ]')
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match '.%]' ~= nil
          end)
          :use_key ']',
      }
    end,
  },
}
