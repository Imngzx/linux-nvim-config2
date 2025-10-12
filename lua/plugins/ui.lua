return {
  --NOTE: configure nvim to load your desired colroschme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin", -- changing this can change the colorscheme
    },
  },

  --NOTE: folke noice config
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  --NOTE: THIS IS FOR THE TABS
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",          --tabs
        separator_style = "slope", --slope, slant
        show_buffer_close_icons = false,
        show_close_icon = false,
        indicator = {
          style = "underline",
        }
      },
    },
  },

  --NOTE: bottom bar configure
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")

      -- ✅ Add your separators config
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        -- theme = "palenight",
        section_separators = { left = "", right = "" }, --
        component_separators = { left = " ", right = " " }, --
        always_divide_middle = true,
        refresh_time = 16,
        -- Seperators :
        --  - default : "" "" Will only work for default Statusline Theme
        --  - "round" : "" "" Will only work for default and minimal Statusline Theme
        --  - "block" : "█" "█" Will only work for default and minimal Statusline Theme
        --  - "arrow" : "" "" Will only work for default Statusline Theme
        -- { left = '', right = '' },
        -- { left = '', right = '' }
      })

      opts.sections.lualine_a = {
        {
          "mode",

          --NOTE: this is for render only the N,V,I and etc
          -- fmt = function(str)
          --   return str:sub(1, 1)
          -- end,

          icon = "", -- 
          icons_enabled = true,
          padding = { left = 1, right = 1 },
        },
      }

      opts.sections.lualine_b = {
        {
          "branch",
        },
      }

      opts.sections.lualine_c = {

        {
          "diff",
          symbols = {
            added = " ",
            modified = " ",
            removed = " ",
          },
        },
      }

      -- keep pretty path
      -- opts.sections.lualine_c[4] = {
      --   LazyVim.lualine.pretty_path({
      --     length = 0,
      --     relative = "cwd",
      --     modified_hl = "MatchParen",
      --     directory_hl = "",
      --     filename_hl = "Bold",
      --     modified_sign = "",
      --     readonly_icon = " 󰌾 ",
      --   }),
      -- }
      --
      -- show filetype in lualine_x
      opts.sections.lualine_x = {
        {
          "diagnostics",

          -- Table of diagnostic sources, available sources are:
          --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
          -- or a function that returns a table as such:
          --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }

          -- Displays diagnostics for the defined severity types
          sections = { "error", "warn", "info", "hint" },

          colored = true,           -- Displays diagnostics status in color if set to true.
          update_in_insert = false, -- Update diagnostics in insert mode.
          always_visible = false,   -- Show diagnostics even if there are none.
        },

        {
          "lsp_status",
          icons_enabled = true,
          icon = " ",
        },
      }
      opts.sections.lualine_y = {
        {
          "location",
          icons_enabled = true,
          icon = " "

        },
      }
      -- show date + 12-hour clock in lualine_z
      opts.sections.lualine_z = {
        function()
          local time = os.date("*t")
          local hour = time.hour
          local suffix = "AM"
          if hour >= 12 then
            suffix = "PM"
            if hour > 12 then
              hour = hour - 12
            end
          elseif hour == 0 then
            hour = 12
          end

          --NOTE:  enable both clock and time
          -- local clock = string.format("%02d:%02d %s", hour, time.min, suffix)
          -- local date = os.date("%d-%m-%Y") -- format: DD-MM-YYYY
          -- return date .. " | " .. clock
          --
          --NOTE: enable clock only
          return string.format("%02d:%02d %s", hour, time.min, suffix) --
        end,
      }
    end,
  },

  --NOTE: top right thingy
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    enabled = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 1 },
        },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold" or "none" },
            modified and { " [+]", guifg = "#ff9e64" } or "",
            " ",
            guibg = "#44406e",
          }
        end,
      })
    end,
  },

  -- NOTE: the top >>> thingy
  {
    "bekaboo/dropbar.nvim",
    event = "VeryLazy",

    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end,
  },

  --NOTE: scrolling config
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    ---@module "snacks",
    ---@type snacks.Config
    opts = {

      picker = {
        hidden = true,
        ignored = true,
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },

      dim = { enabled = true },
      notifier = { enabled = true },
      indent = { enabled = true },
      quickfile = { enabled = true },
      scroll = {
        debug = false,
        -- your scroll configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        animate = {
          duration = { step = 15, total = 90 },
          easing = "inCubic",
          fps = 240,
        },
        animate_repeat = {
          delay = 50, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 90 },
          easing = "inCubic",
          fps = 240,
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    lazy = true,
    enabled = true,
    opts = {
      preset = "helix",
    },
  },

  --NOTE : cmd line appearance change
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("noice").setup({
        presets = {
          bottom_search = true,
          long_message_to_split = true,
        },
      })
    end,
  },

  --NOTE: start screen config and also the key to back to dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    keys = {
      { "<leader>aa", "<cmd>Alpha<cr>", desc = "Dashboard (Alpha)" },
    },
    enabled = true,
    init = false,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
    ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      -- stylua: ignore
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<cmd> lua LazyVim.pick()() <cr>"),
        -- dashboard.button("n", " " .. " New file", [[<cmd> ene <BAR> startinsert <cr>]]),
        dashboard.button("r", " " .. " Recent files", [[<cmd> lua LazyVim.pick("oldfiles")() <cr>]]),
        dashboard.button("g", " " .. " Find text", [[<cmd> lua LazyVim.pick("live_grep")() <cr>]]),
        dashboard.button("c", " " .. " Config", "<cmd> lua LazyVim.pick.config_files()() <cr>"),
        dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
        dashboard.button("x", " " .. " Lazy Extras", "<cmd> LazyExtras <cr>"),
        dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
        dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded "
              .. stats.loaded
              .. "/"
              .. stats.count
              .. " plugins in "
              .. ms
              .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
