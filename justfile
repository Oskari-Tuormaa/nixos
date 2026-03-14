current_hostname := `hostname`

check:
    nix flake check

clean:
    if [ -n ./*.qcow2 ]; then trash *.qcow2; fi
    if [ -e ./result ]; then unlink result; fi

build hostname=current_hostname:
    sudo nixos-rebuild switch --flake .#{{hostname}}

build-vm hostname=current_hostname:
    nixos-rebuild build-vm --flake .#{{hostname}}

run-vm hostname=current_hostname: (build-vm hostname)
    ./result/bin/run-{{hostname}}-vm
