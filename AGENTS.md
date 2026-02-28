# AGENTS.md — NixOS Configuration Repository

This file documents conventions and commands for agentic coding agents operating in this NixOS flake repository.

---

## Repository Overview

A flakes-based NixOS configuration managing 5 machines with shared modules and per-host customisation.

```
flake.nix              # Entry point; defines all nixosConfigurations
flake.lock             # Locked dependency versions (auto-managed)
lib/                   # Helper functions (mkHost, mkHome)
modules/
  common/              # Imported by every host (packages, settings, users)
  features/            # Opt-in feature modules (nvidia, desktop, encryption, vm-guest)
  services/            # System services (SSH, etc.)
hosts/                 # Per-machine configurations + hardware-configuration.nix
home/okt/              # Home Manager config shared by the okt user on all machines
```

Hosts: **lovelace** (desktop), **hopper** (laptop), **wilson** (work laptop), **perlman** (server), **greene** (WSL2 sandbox).

---

## Build & Deploy Commands

### Apply configuration to the current machine
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

### Apply to a specific host
```bash
sudo nixos-rebuild switch --flake .#lovelace
sudo nixos-rebuild switch --flake .#hopper
sudo nixos-rebuild switch --flake .#wilson
sudo nixos-rebuild switch --flake .#perlman
sudo nixos-rebuild switch --flake .#greene   # WSL2
```

### Dry-run (evaluate & show planned changes without building)
```bash
sudo nixos-rebuild dry-run --flake .#<hostname>
```

### Build without switching (useful for checking a config builds)
```bash
sudo nixos-rebuild build --flake .#<hostname>
```

### Check flake syntax and evaluation
```bash
nix flake check
```

### Update flake inputs (nixpkgs, home-manager, etc.)
```bash
nix flake update
git add flake.lock
git commit -m "Update flake dependencies"
```

### Rollback
```bash
sudo nixos-rebuild switch --rollback
```

---

## Nix Evaluation / Linting

There is no separate lint tool. Use these to validate changes:

```bash
# Evaluate flake outputs without building (fast syntax + type check)
nix flake check

# Check a specific nixosConfiguration evaluates
nix eval .#nixosConfigurations.lovelace.config.system.build.toplevel

# Format Nix files (if alejandra or nixpkgs-fmt is available)
alejandra .
# or
nixpkgs-fmt .
```

**Note:** `nix flake check` is the primary validation command. Run it before committing any Nix changes.

---

## Testing Changes

There is no automated test suite. The recommended workflow is:

1. **Validate syntax**: `nix flake check`
2. **Test in greene** (WSL2 sandbox) before applying to production hosts:
   ```bash
   sudo nixos-rebuild dry-run --flake .#greene
   sudo nixos-rebuild switch --flake .#greene
   ```
3. **Deploy to target host** after greene passes.

### Generate hardware configuration for a new machine
```bash
sudo nixos-generate-config --root /
# Copy result to hosts/<hostname>/hardware-configuration.nix
```

---

## Nix Code Style Guidelines

### File header comment
Every `.nix` file starts with a single-line comment describing its purpose:
```nix
# Brief description of what this module does
{ config, pkgs, lib, ... }:
```

### Module function signature
- Use `{ config, pkgs, lib, ... }:` for NixOS/Home Manager modules.
- Use `{ inputs, lib }:` for lib helpers.
- Include `...` in the attribute set to allow forward compatibility.
- Use `@args` only when you need to pass the full argument set through.

### Attribute set formatting
- Opening brace on the same line as the enclosing construct.
- Each attribute on its own line, indented 2 spaces.
- Closing brace on its own line at the same indentation level as the opening construct.

```nix
hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  open = true;
};
```

### `with pkgs;` idiom
Use `with pkgs;` inside list expressions for package lists to avoid repetition:
```nix
environment.systemPackages = with pkgs; [
  git
  ripgrep
  fd
];
```

### `lib.mkDefault` and option precedence
Use `lib.mkDefault` when a value should be overridable by host configs:
```nix
networking.useDHCP = lib.mkDefault true;
```

### Inline comments
- Use `#` comments to explain *why*, not *what*.
- Place comments on the line above the relevant attribute, not inline, unless very short.
- Mark TODOs clearly: `# TODO: Update with your email`

### Imports
- List imports explicitly in an `imports = [ ... ];` block at the top of the module attrset.
- Use relative paths for local files (`./hardware-configuration.nix`, `../../modules/common`).
- Use `inputs.<name>.nixosModules.<module>` for flake-provided modules.

```nix
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    ../../modules/features/desktop.nix
  ];
}
```

### Naming conventions
- **Files**: `kebab-case.nix` (e.g. `vm-guest.nix`, `mkHost.nix`)
- **Hostnames**: lowercase single-word names (lovelace, hopper, wilson, perlman, greene)
- **Nix identifiers**: `camelCase` for local `let` bindings and function arguments
- **NixOS option paths**: follow upstream NixOS conventions (dot-separated, camelCase segments)

### `let ... in` blocks
Use `let` for named intermediate values to avoid repetition:
```nix
let
  system = "x86_64-linux";
  lib = (import ./lib { inherit (nixpkgs) lib; inputs = inputs; });
in
```

### `inherit` keyword
Use `inherit` to avoid repeating names when passing values:
```nix
specialArgs = { inherit inputs; };
# instead of:
specialArgs = { inputs = inputs; };
```

### String interpolation
Use `${}` for Nix string interpolation:
```nix
program = "${nixpkgs.legacyPackages.${system}.bash}/bin/bash -c 'nix flake update'";
```

### Multi-line strings
Use `''...''` for multi-line strings (e.g. shell init scripts):
```nix
interactiveShellInit = ''
  set fish_greeting
  fish_vi_key_bindings
'';
```

---

## Structural Conventions

### Adding a new host
1. Create `hosts/<hostname>/default.nix` and `hosts/<hostname>/hardware-configuration.nix`.
2. Import `../../modules/common` plus any relevant feature modules.
3. Set `networking.hostName = "<hostname>";`.
4. Register in `flake.nix` under `nixosConfigurations`.

### Adding a new module
- Place reusable opt-in features in `modules/features/`.
- Place always-on system settings in `modules/common/`.
- Place service definitions in `modules/services/`.
- Keep modules focused: one concern per file.

### Home Manager
- The single user `okt` is configured in `home/okt/`.
- `home/okt/default.nix` — entry point; sets `home.username`, `home.stateVersion`, session variables.
- `home/okt/programs.nix` — all program configs (fish, neovim, git, starship, etc.).
- `home/okt/services.nix` — user-level services (gpg-agent, ssh-agent, etc.).
- Do **not** set `nixpkgs.config` inside Home Manager modules when `useGlobalPkgs = true`.

### `allowUnfree`
Set at the host level inside `hosts/<hostname>/default.nix`, not in shared modules:
```nix
nixpkgs.config.allowUnfree = true;
```

### `system.stateVersion`
Set once in `modules/common/settings.nix`. Do not override per-host unless intentional.

---

## Git Workflow

- All files referenced by the flake must be tracked by git (`git add`) before `nixos-rebuild` will see them.
- Commit logical units of change; keep flake.lock updates in their own commit.
- Test in greene before deploying to production hosts.
