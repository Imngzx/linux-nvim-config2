return {
  "XXiaoA/atone.nvim",
  event = "VeryLazy",
  cmd = "Atone",
  keys = {
    { "<leader>ac", "<cmd>Atone toggle <cr>", desc = "Open Atone" },
  },
  opts = {
    ui = {
      border = "single",
      compact = "true",
    }

  }, -- your configuration here
}
