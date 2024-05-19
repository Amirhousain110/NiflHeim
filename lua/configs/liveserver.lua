local opts = {
  args = {
    "--port=6000",
    "--browser=$BROWSER",
  },
}

require("liveserver").setup(opts)
