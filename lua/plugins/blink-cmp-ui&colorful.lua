return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
  dependencies = {
    "xzbdmw/colorful-menu.nvim",
    "rafamadriz/friendly-snippets",
  },
  opts = {
    sources = {
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      default = { "lazydev", "lsp", "path", "buffer", "snippets" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 1000,
        },
      },
    },
    cmdline = {
      enabled = false,
    },
    completion = {
      menu = {
        scrollbar = true,
        border = "rounded",
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        draw = {
          -- add the new "menu" column
          align_to = "cursor",
          columns = { { "kind_icon" }, { "label", gap = 1 }, { "menu", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
            -- new menu component
            menu = {
              text = function(ctx)
                local menu_labels = {
                  lsp = "[LSP]",
                  buffer = "[Buffer]",
                  snippets = "[LuaSnip]",
                  path = "[Path]",
                  lazydev = "[LazyDev]",
                }
                return menu_labels[ctx.source_name] or ("[" .. ctx.source_name .. "]")
              end,
              highlight = "Comment", -- you can change to match your theme
            },
          },
        },
      },
      documentation = {
        window = {
          border = "rounded",
        },
        auto_show = false,
      },
    },
    signature = {
      window = {
        border = {
          "rounded",
        },
      },
    },
  },
}
