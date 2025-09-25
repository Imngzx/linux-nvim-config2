return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      code = {
        sign = true,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = true,
        icons = {},
        width = "block",
        left_pad = 2,
        right_pad = 4,
      },
      checkbox = {
        enabled = true,
      },
      quote = {
        enabled = true,
      },

      latex = {
        enabled = false,
        render_modes = false,
        converter = { "utftex", "latex2text" },
        highlight = "RenderMarkdownMath",
        position = "center",
        top_pad = 0,
        bottom_pad = 0,
      },
      completions = { lsp = { enabled = false } },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.stdpath("config") .. "/lua/plugins/cfg_linters/global.markdownlint-cli2.jsonc",
            "--",
          },
        },
      },
    },
  },
}
