--NOTE:   if you use neovide
-- Check if we are running in Neovide
if vim.g.neovide then
  -----------------------------------------------------------------------------
  -- FONT CONFIGURATION
  -----------------------------------------------------------------------------
  -- We set style=SemiBold.
  -- Neovide will automatically try to find the "Bold" version of SemiBold
  -- (which is usually ExtraBold) for bold text.
  vim.o.guifont = "JetBrainsMono Nerd Font:style=SemiBold:h12.5"

  -----------------------------------------------------------------------------
  -- WINDOW & VISUAL SETTINGS
  -----------------------------------------------------------------------------
  vim.g.neovide_floating_blur_amount_x = 3.0
  vim.g.neovide_floating_blur_amount_y = 3.0
  vim.g.neovide_refresh_rate = 240
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_hide_titlebar = true
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_floating_shadow = false

  -- Running in Neovide → disable snacks scroll
  vim.g.snacks_scroll = false
else
  -- Running in standard Terminal (Kitty/Foot/etc)
  -- Enable snacks scroll here
  vim.g.snacks_scroll = true
end
