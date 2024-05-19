require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map({ "n" }, "<F5>", "<cmd> RunCode <cr>")
map({ "n" }, "<F4>", "<cmd> RunClose <cr>")
map({ "n" }, "<F6>", "<cmd> LiveServerStart <cr>")
map({ "n" }, "<F7>", "<cmd> LiveServerStop <cr>")
map({ "n", "v" }, "<C-c>", '"+y')

map({ "n", "i" }, "<C-a>", "<cmd> %y+ <CR>")

map({ "n" }, "<leader>tt", function()
  require("base46").toggle_transparency()
end)
