# AGENTS.md — NixOS Configuration Repository

A flakes-based NixOS configuration managing 6 machines with shared modules and per-host customisation.

**Hosts:** lovelace (desktop), hopper (laptop), wilson (work laptop), perlman (server), greene (WSL2), hedy (QEMU/KVM)

## Repository Structure

```
flake.nix                    # Entry point; defines all nixosConfigurations
lib/                         # mkHost and mkHome helpers
modules/common/              # Imported by every host (packages, settings, users)
modules/features/            # Opt-in features (nvidia, desktop, bluetooth, steam, vm-guest, encryption)
modules/services/            # Placeholder for future system services
hosts/                       # Per-machine configs + hardware-configuration.nix
home/okt/                    # Home Manager config (programs, services, i3, rofi)
```

## Build & Deploy

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

**Always test in greene (WSL2 sandbox) before production hosts:**
```bash
nix flake check
sudo nixos-rebuild dry-run --flake .#greene
sudo nixos-rebuild switch --flake .#greene
```

## Code Style

- Every `.nix` file starts with a single-line comment: `# Brief description`
- Module signature: `{ config, pkgs, lib, ... }:` (always include `...`)
- Lib helpers use: `{ inputs, lib }:`
- Indent 2 spaces (enforced by `nixfmt`)
- Opening brace on same line as construct; closing brace on own line
- Use `with pkgs;` inside list expressions only
- `imports = [ ... ];` block at top of module
- Use relative paths for local files: `./hardware-configuration.nix`, `../../modules/common`
- Use `inputs.<name>.nixosModules.<module>` for flake modules
- Use `#` comments to explain *why*, not *what*; place above the attribute
- Mark TODOs clearly: `# TODO: description`
- Use `lib.mkDefault` when a value should be overridable by hosts
- Use `inherit` to avoid repetition

**Naming:**
- Files: `kebab-case.nix`
- Hostnames: lowercase single-word
- Identifiers: `camelCase` for let bindings and function args
- NixOS options: follow upstream conventions (dot-separated, camelCase)

## Helper Functions

### `lib.mkHost` — Creates NixOS host with Home Manager
```nix
lib.mkHost {
  hostname = "lovelace";
  system = "x86_64-linux";
  modules = [ ./hosts/lovelace ];
  wallpaperPath = ../home/okt/solar.png;  # optional; defaults to solar.png
}
```
Automatically adds home-manager and nix-index-database modules to every host.

### `lib.mkHome` — Standalone Home Manager config
```nix
lib.mkHome {
  username = "okt";
  homeDirectory = "/home/okt";
  system = "x86_64-linux";
}
```

## Module Reference

### `modules/common/` — always imported
| File | Purpose |
|------|---------|
| `packages.nix` | Shared CLI tools: fish, neovim, git, lazygit, ripgrep, fd, eza, fzf, bat, tmux, zoxide, opencode, nixfmt, etc. |
| `settings.nix` | Timezone, locale, networkmanager, nix flakes, nix-ld, `stateVersion = "24.05"` |
| `users.nix` | Creates user `okt` with fish shell and wheel group |

### `modules/features/` — opt-in per host
| File | Purpose | Used by |
|------|---------|---------|
| `nvidia.nix` | NVIDIA driver + modesetting | lovelace, hopper |
| `desktop.nix` | X11, i3, ly DM, pipewire, rofi, kitty, Discord, Spotify, etc. | lovelace, hopper, wilson, hedy |
| `bluetooth.nix` | Bluetooth + blueman applet | lovelace |
| `steam.nix` | Steam with firewall rules | lovelace |
| `encryption.nix` | Placeholder — LUKS config lives in `hardware-configuration.nix` | wilson |
| `vm-guest.nix` | VirtualBox guest additions | (unused — hedy uses native QEMU support) |

## Structural Conventions

### Adding a New Host
1. Create `hosts/<hostname>/default.nix` and `hardware-configuration.nix`
2. Import `../../modules/common` + relevant feature modules
3. Set `networking.hostName = "<hostname>"`
4. Register in `flake.nix` under `nixosConfigurations` via `lib.mkHost`

### Home Manager (`home/okt/`)
- `default.nix` — entry point; username, stateVersion, session vars, fonts
- `programs.nix` — fish, neovim, kitty, git, zoxide, direnv, fzf, starship, brave; imports `i3.nix` and `rofi.nix`
- `services.nix` — picom, dunst, udiskie
- `i3.nix` — full i3 config (Dracula theme, vim keybindings, wallpaper via `wallpaperPath`)
- `rofi.nix` — rofi launcher with Dracula theme
- Never set `nixpkgs.config` in Home Manager modules when `useGlobalPkgs = true`

### Configuration Placement
- Set `allowUnfree` at host level only (`hosts/<hostname>/default.nix`)
- `system.stateVersion` is set once in `modules/common/settings.nix` — do not override per-host
- Wallpaper defaults to `home/okt/solar.png`; override per host via `wallpaperPath` in `mkHost`

## Git Workflow

- All referenced paths must be tracked: `git add <file>` before `nixos-rebuild`
- Commit logical units; keep `flake.lock` updates in separate commits
- Always test in greene first before deploying to production hosts

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
