local nmap = require("config.utils").nmap

nmap("<leader>e", "<cmd>sp term://nix flake check<cr>")
