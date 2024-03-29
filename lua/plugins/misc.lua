return {
  --- Git: Improved commits screen
  {
    "rhysd/committia.vim",
    ft = { "gitcommit" },
  },
  --- Apply local patches to plugins installed through lazy.nvim
  {
    "polirritmico/lazy-local-patcher.nvim",
    config = true,
    dev = false,
    ft = "lazy",
  },
}
