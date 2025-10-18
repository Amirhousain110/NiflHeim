-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>th", function()
  local fzf = require("fzf-lua")
  fzf.colorschemes({
    actions = {
      ["default"] = function(selected)
        local colorscheme = selected[1]
        vim.cmd.colorscheme(colorscheme)

        -- Update the config file directly
        local config_file = vim.fn.stdpath("config") .. "/lua/plugins/core.lua"
        local content = vim.fn.readfile(config_file)

        -- Find and replace the colorscheme line
        for i, line in ipairs(content) do
          if line:match("colorscheme%s*=") then
            content[i] = string.format('      colorscheme = "%s"', colorscheme)
            break
          end
        end

        vim.fn.writefile(content, config_file)
      end,
    },
  })
end, { desc = "Colorscheme with preview" })
vim.keymap.set({ "n", "v", "i" }, "<C-c>", '"+y')
vim.keymap.set({ "n", "i" }, "<C-a>", "<cmd> %y+ <CR>")
vim.keymap.set({ "n", "i", "v" }, "<C-n>", "<cmd> Neotree <CR>")
