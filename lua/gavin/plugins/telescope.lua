return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", 
      build = function(plugin)
        local obj = vim.system({'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release'}, {cwd = plugin.dir}):wait()
        if obj.code ~= 0 then error(obj.stderr) end
        obj = vim.system({'cmake', '--build', 'build', '--config', 'Release'}, {cwd = plugin.dir}):wait()
        if obj.code ~= 0 then error(obj.stderr) end
        obj = vim.system({'cmake', '--install', 'build', '--prefix', 'build'}, {cwd = plugin.dir}):wait()
        if obj.code ~= 0 then error(obj.stderr) end
      end 
    },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local actions = require("telescope.actions")
    
    require("telescope").setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })
    require("telescope").load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
  end,
}
