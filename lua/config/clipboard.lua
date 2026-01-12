--clipboard
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    -- Install Neovim on host (Windows) to use faster global clipboard
    copy = {
      ["+"] = {
        "/mnt/c/Program Files/Neovim/bin/win32yank.exe",
        "-i",
        "--crlf",
      },
      ["*"] = {
        "/mnt/c/Program Files/Neovim/bin/win32yank.exe",
        "-i",
        "--crlf",
      },
    },
    paste = {
      ["+"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-o", "--lf" },
      ["*"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-o", "--lf" },
    },
    cache_enabled = 0,
  }
end
vim.opt.clipboard = "unnamedplus"
