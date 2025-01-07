local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "swells.plugins" },
  {
    dir = vim.fn.stdpath("config") .. "/lua/swells/custom-plugins",
    lazy = false, -- Load immediately
    config = function()
      require("swells.custom-plugins.kustomize-previewer").setup()
    end,
  },
})

