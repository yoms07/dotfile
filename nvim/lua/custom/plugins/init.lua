-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      }
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle [E]xplorer' })
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<c-\]],
        hide_number = true,
        shade_terminal = true,
        close_on_exit = true,
      }
    end,
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- Loads only when you start opening files
    opts = {
      -- This keeps your session files organized in Neovim's state folder
      dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/'),
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    },
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      -- Set header (your existing header or a custom one)
      dashboard.section.header.val = {
        '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
        '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
        '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
        '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
        '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
        '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
      }

      dashboard.section.buttons.val = {
        dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('f', '󰈞  Find file', ':Telescope find_files<CR>'),
        dashboard.button('r', '󰄉  Recent files', ':Telescope oldfiles<CR>'),

        -- SESSION BUTTONS
        dashboard.button('s', '  Restore Current Dir Session', [[<cmd>lua require("persistence").load()<cr>]]),
        dashboard.button('l', '󰚰  Restore Last Session', [[<cmd>lua require("persistence").load({ last = true })<cr>]]),

        dashboard.button('c', '  Config', ':e $MYVIMRC <CR>'),
        dashboard.button('q', '  Quit', ':qa<CR>'),
      }

      alpha.setup(dashboard.opts)
    end,
  },

  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode = 'tabs',
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            padding = 1,
            separator = true,
          },
        },
      },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode…' })
      vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })
      vim.keymap.set({ 'n', 't' }, '<C-.>', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode' })

      vim.keymap.set({ 'n', 'x' }, 'go', function()
        return require('opencode').operator '@this '
      end, { desc = 'Add range to opencode', expr = true })
      vim.keymap.set('n', 'goo', function()
        return require('opencode').operator '@this ' .. '_'
      end, { desc = 'Add line to opencode', expr = true })

      vim.keymap.set('n', '<S-C-u>', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'Scroll opencode up' })
      vim.keymap.set('n', '<S-C-d>', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'Scroll opencode down' })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
      vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment under cursor', noremap = true })
      vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement under cursor', noremap = true })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'ayu_dark',
          globalstatus = true,
        },
      }
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'karb94/neoscroll.nvim',
    opts = {},
    config = function()
      require('neoscroll').setup {
        hide_cursor = true,
        easing = 'quadratic',
      }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup {
        vim.cmd.colorscheme 'kanagawa',
      }
    end,
  },
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require('transparent').setup {
        extra_groups = {
          'NormalFloat', -- plugins like telescope or cmp
          'NvimTreeNormal', -- sidebars
        },
      }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'InsertEnter',
    ft = {
      'html',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'xml',
      'tsx',
      'jsx',
    },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = true, -- Auto close on trailing </
        },
        per_filetype = {
          ['html'] = {
            enable_close = true,
          },
          ['typescriptreact'] = {
            enable_close = true,
          },
          ['javascriptreact'] = {
            enable_close = true,
          },
        },
      }
    end,
  },
  {
    'github/copilot.vim',
    config = function() end,
  },
  { 'wakatime/vim-wakatime', lazy = false },
  {
    'b0o/incline.nvim',
    config = function()
      local helpers = require 'incline.helpers'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
            ' ',
            guibg = '#44406e',
          }
        end,
      }
    end,
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
  },
}
