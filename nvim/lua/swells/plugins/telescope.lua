return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make', 
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
      {'nvim-lua/plenary.nvim'},
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      }
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position  = "top",
        },
        sorting_strategy = "ascending",
        winblend = 0,
      }
    }
 },
}

