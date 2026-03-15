current_hostname := `hostname`

check:
    nix flake check

clean:
    -[ -n "$(find -name '*.qcow2')" ] && trash *.qcow2
    -[ -e result ] && unlink result

build hostname=current_hostname:
    sudo nixos-rebuild switch --flake .#{{hostname}}

build-vm hostname=current_hostname:
    nixos-rebuild build-vm --flake .#{{hostname}}

run-vm hostname=current_hostname: (build-vm hostname)
    ./result/bin/run-{{hostname}}-vm
