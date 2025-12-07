-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--NOTE: this is for csv viewving
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.csv",
  callback = function()
    vim.cmd([[CsvViewToggle delimiter=, display_mode=border header_lnum=1]])
  end,
})

--NOTE: Auto-enable spell checking for certain filetypes (useful for md files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "latex" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "ms", "en_us" }
  end,
})

----NOTE: this is for remove space after save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})
