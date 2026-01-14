--NOTE:   if you use neovide
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h14" -- Replace h14 with your desired font size remove :b for regular font
  -- vim.g.neovide_window_blurred = true
  -- vim.g.neovide_opacity = 0.93
  vim.g.neovide_floating_blur_amount_x = 3.0
  vim.g.neovide_floating_blur_amount_y = 3.0
  vim.g.neovide_refresh_rate = 240
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_hide_titlebar = true
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_floating_shadow = false
  if vim.g.neovide then
    -- Running in Neovide → disable snacks scroll
    vim.g.snacks_scroll = false
  else
    -- Running in terminal → enable snacks scroll
    vim.g.snacks_scroll = true
  end
end
