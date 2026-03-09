# AGENTS.md — NixOS Configuration Repository

This file documents conventions and commands for agentic coding agents operating in this NixOS flake repository. A flakes-based NixOS configuration managing 6 machines with shared modules and per-host customisation.

**Hosts:** lovelace (desktop), hopper (laptop), wilson (work laptop), perlman (server), greene (WSL2), hedy (QEMU/KVM)

## Repository Structure

```
flake.nix                    # Entry point; defines all nixosConfigurations
lib/                         # Helper functions (mkHost, mkHome)
modules/common/              # Imported by every host
modules/features/            # Opt-in features (nvidia, desktop, encryption, vm-guest, etc.)
modules/services/            # System services
hosts/                        # Per-machine configs + hardware-configuration.nix
home/okt/                     # Home Manager config
```

## Build & Deploy

### Essential Commands

```bash
# Format all Nix files (REQUIRED before committing)
nixfmt .

# Validate flake syntax and evaluation
nix flake check

# Build specific host config (without switching)
sudo nixos-rebuild build --flake .#<hostname>

# Apply configuration to machine
sudo nixos-rebuild switch --flake .#<hostname>

# Dry-run to preview changes
sudo nixos-rebuild dry-run --flake .#<hostname>

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Update flake inputs
nix flake update && git add flake.lock
```

### Testing Workflow

**Always test in greene (WSL2 sandbox) before production hosts:**
```bash
nix flake check                          # Validate syntax
sudo nixos-rebuild dry-run --flake .#greene
sudo nixos-rebuild switch --flake .#greene
```

## Code Style Guidelines

### File Structure
- Every `.nix` file starts with a single-line comment: `# Brief description`
- Module signature: `{ config, pkgs, lib, ... }:` (always include `...`)
- Lib helpers use: `{ inputs, lib }:`

### Formatting
- Indent 2 spaces (enforced by `nixfmt`)
- Opening brace on same line as construct; closing brace on own line
- Each attribute on its own line
- Use `with pkgs;` inside list expressions only

```nix
hardware.nvidia = {
  modesetting.enable = true;
  open = true;
};
```

### Naming Conventions
- **Files:** `kebab-case.nix` (e.g., `vm-guest.nix`, `mkHost.nix`)
- **Hostnames:** lowercase single-word
- **Identifiers:** `camelCase` for let bindings and function args
- **NixOS options:** follow upstream conventions (dot-separated, camelCase)

### Imports
- Place `imports = [ ... ];` block at top of module
- Use relative paths for local files: `./hardware-configuration.nix`, `../../modules/common`
- Use `inputs.<name>.nixosModules.<module>` for flake modules

### Comments & Options
- Use `#` comments to explain *why*, not *what*
- Place comments above the attribute, not inline (unless very short)
- Mark TODOs clearly: `# TODO: description`
- Use `lib.mkDefault` when value should be overridable by hosts
- Use `inherit` to avoid repetition: `inherit inputs;` not `inputs = inputs;`

### String Interpolation
- Use `${}` for interpolation: `"${pkgs.bash}/bin/bash"`
- Use `''...''` for multi-line strings (shell scripts, configs, etc.)

## Helper Functions

### `lib.mkHost` — Creates NixOS host with Home Manager
```nix
lib.mkHost {
  hostname = "lovelace";
  system = "x86_64-linux";
  modules = [ ./hosts/lovelace ];
  wallpaperPath = ../home/okt/custom.png;  # optional
}
```

### `lib.mkHome` — Standalone Home Manager config
```nix
lib.mkHome {
  username = "okt";
  homeDirectory = "/home/okt";
  system = "x86_64-linux";
}
```

## Structural Conventions

### Adding a New Host
1. Create `hosts/<hostname>/default.nix` and `hardware-configuration.nix`
2. Import `../../modules/common` + relevant feature modules
3. Set `networking.hostName = "<hostname>";`
4. Register in `flake.nix` under `nixosConfigurations`

### Module Organization
- **modules/features/**: Opt-in, reusable features
- **modules/common/**: Always-on system settings
- **modules/services/**: System services
- Keep modules focused on one concern

### Home Manager (`home/okt/`)
- **default.nix**: Entry point; sets username, stateVersion, session vars
- **programs.nix**: All program configs (fish, neovim, git, starship)
- **services.nix**: User-level services
- Never set `nixpkgs.config` in Home Manager modules when `useGlobalPkgs = true`

### Configuration Placement
- Set `allowUnfree` at host level only (`hosts/<hostname>/default.nix`)
- Set `system.stateVersion` once in `modules/common/settings.nix`
- Don't override stateVersion per-host

## Git Workflow

- All referenced paths must be tracked: `git add <file>` before `nixos-rebuild`
- Commit logical units; keep `flake.lock` updates in separate commits
- Always test in greene first before deploying to production

## Error Handling

| Error | Cause |
|-------|-------|
| **Attribute not found** | Module not imported or doesn't exist in nixpkgs version |
| **Infinite recursion** | Circular imports or improper `with` statements |
| **Evaluation errors** | Referenced paths not tracked in git |

## Quick Reference

| Task | Command |
|------|---------|
| Format | `nixfmt .` |
| Validate | `nix flake check` |
| Build host | `sudo nixos-rebuild build --flake .#<host>` |
| Deploy | `sudo nixos-rebuild switch --flake .#<host>` |
| Dry-run | `sudo nixos-rebuild dry-run --flake .#<host>` |
| Rollback | `sudo nixos-rebuild switch --rollback` |
| Update deps | `nix flake update && git add flake.lock` |
| View history | `git log --oneline` |
