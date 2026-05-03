current_hostname := `hostname`

check:
    nix flake check

update:
    nix flake update

clean:
    -[ -n "$(find -name '*.qcow2')" ] && trash *.qcow2
    -[ -e result ] && unlink result

nix-clean:
    sudo nix-collect-garbage -d

_rebuild type hostname:
    sudo nixos-rebuild {{type}} --flake .#{{hostname}}

switch hostname=current_hostname: (_rebuild "switch" current_hostname)
boot hostname=current_hostname: (_rebuild "boot" current_hostname)

build-vm hostname=current_hostname:
    nixos-rebuild build-vm --flake .#{{hostname}}

run-vm hostname=current_hostname: (build-vm hostname)
    ./result/bin/run-{{hostname}}-vm
