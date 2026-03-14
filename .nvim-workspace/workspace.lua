local nmap = require("config.utils").nmap

local hostname = vim.fn.hostname()

local clean_vm = "rm "..hostname..".qcow2"
local build_vm = "nixos-rebuild build-vm --flake .\\#"..hostname
local run_vm = "./result/bin/run-"..hostname.."-vm"

nmap("<leader>e", "<cmd>sp term://nix flake check<cr>")
nmap("<leader>vm", "<cmd>sp term://"..clean_vm.."; "..build_vm.." && "..run_vm.."<cr>")
