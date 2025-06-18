return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    },
  },
  lazy = false,
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = smart_case,
        },
      },
    })

    telescope.load_extension("fzf")
  end,
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files in cwd" },
    { "<leader>fg", "<cmd>Telescope git_files<CR>",   desc = "Find git file cwd" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>",    desc = "Find recent files in cwd" },
    { "<leader>fs", "<cmd>Telescope live_grep<CR>",   desc = "Find string in cwd" },
    { "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Find string under cursor in cwd" },
  },
}
