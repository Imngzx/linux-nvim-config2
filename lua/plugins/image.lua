return {
  "3rd/image.nvim",
  config = function()
    local ok, image = pcall(require, "image")
    if not ok then
      return
    end

    -- Detect OS
    local uname = vim.uv.os_uname()
    local sysname = uname.sysname:lower()

    -- Default backend
    local backend = "kitty"

    -- Windows → sixel
    if sysname:match("windows") or sysname:match("mingw") then
      backend = "sixel"
    end

    image.setup({
      backend = backend,

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
}
