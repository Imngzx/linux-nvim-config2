return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    config = function()
      local ok, image = pcall(require, "image")
      if not ok then
        return
      end

      -- Detect OS (works on Windows, WSL, Linux, macOS)
      local uname = vim.uv.os_uname()
      local sysname = (uname and uname.sysname or ""):lower()
      local is_windows = sysname:match("windows") or sysname:match("mingw")
      local is_microsoft = uname.release and uname.release:lower():match("microsoft")

      -- Choose backend: windows -> sixel, linux/mac -> kitty
      local backend = "kitty"
      if is_windows or is_microsoft then
        backend = "sixel"
      end

      image.setup({
        backend = backend,

        -- required method fields (use common/safe defaults)
        -- kitty_method: "normal" works for most kitty installs
        kitty_method = "normal",

        -- sixel_method: "libsixel" is the typical implementation name;
        -- image.nvim accepts a string here, depending on implementation.
        sixel_method = "libsixel",

        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
          },
        },

        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
        editor_only_render_when_focused = false,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
      })
    end,
  },
}
