# AGENTS.md — NixOS Configuration Repository

A flake-parts-based NixOS configuration managing 6 machines with shared modules and per-host customisation.

**Hosts:** lovelace (desktop), hopper (laptop), wilson (work laptop), perlman (server), greene (WSL2), hedy (QEMU/KVM)

## Repository Structure

```
flake.nix                         # Entry point; mkFlake + recursive auto-import of modules/
modules/
  lib.nix                         # FP module: flake.lib.mkHost and flake.lib.mkHome
  devshell.nix                    # FP module: perSystem.devShells.default
  common/
    packages.nix                  # FP module: flake.nixosModules.packages
    settings.nix                  # FP module: flake.nixosModules.settings
    users.nix                     # FP module: flake.nixosModules.users
    agenix.nix                    # FP module: flake.nixosModules.agenix
  features/
    bluetooth.nix                 # FP module: flake.nixosModules.bluetooth
    desktop.nix                   # FP module: flake.nixosModules.desktop
    desktop-hyprland.nix          # FP module: flake.nixosModules.desktop-hyprland
    desktop-i3.nix                # FP module: flake.nixosModules.desktop-i3
    encryption.nix                # FP module: flake.nixosModules.encryption
    nvidia.nix                    # FP module: flake.nixosModules.nvidia
    secureboot.nix                # FP module: flake.nixosModules.secureboot
    steam.nix                     # FP module: flake.nixosModules.steam
    stlink.nix                    # FP module: flake.nixosModules.stlink
    vm-guest.nix                  # FP module: flake.nixosModules.vm-guest
  services/
    default.nix                   # FP module: flake.nixosModules.services
  hosts/
    lovelace/
      default.nix                 # FP module: flake.nixosConfigurations.lovelace
      hardware-configuration.nix  # FP module: flake.nixosModules.lovelace-hardware
    hopper/
      default.nix                 # FP module: flake.nixosConfigurations.hopper
      hardware-configuration.nix  # FP module: flake.nixosModules.hopper-hardware
    wilson/
      default.nix                 # FP module: flake.nixosConfigurations.wilson
      hardware-configuration.nix  # FP module: flake.nixosModules.wilson-hardware
    perlman/
      default.nix                 # FP module: flake.nixosConfigurations.perlman
      hardware-configuration.nix  # FP module: flake.nixosModules.perlman-hardware
    greene/
      default.nix                 # FP module: flake.nixosConfigurations.greene
      hardware-configuration.nix  # FP module: flake.nixosModules.greene-hardware
    hedy/
      default.nix                 # FP module: flake.nixosConfigurations.hedy
      hardware-configuration.nix  # FP module: flake.nixosModules.hedy-hardware
home/okt/                         # Home Manager config (programs, services, i3, rofi)
secrets/                          # agenix secret declarations
```

Every `.nix` file under `modules/` is a flake-parts module. `flake.nix` auto-discovers them all
via a recursive `builtins.readDir` helper — no manual registration needed when adding new modules.

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
- Flake-parts module signature: `{ self, inputs, ... }:` or `_:` if no args needed
- NixOS module signature (inside `flake.nixosModules.*`): `{ config, pkgs, lib, ... }:`
- Indent 2 spaces (enforced by `nixfmt`)
- Opening brace on same line as construct; closing brace on own line
- Use `with pkgs;` inside list expressions only
- Use `self.nixosModules.<name>` to reference NixOS modules from host FP modules
- Use `inputs.<name>.nixosModules.<module>` for third-party flake modules
- Use `#` comments to explain *why*, not *what*; place above the attribute
- Mark TODOs clearly: `# TODO: description`
- Use `lib.mkDefault` when a value should be overridable by hosts
- Use `inherit` to avoid repetition

**Naming:**
- Files: `kebab-case.nix`
- Hostnames: lowercase single-word
- `nixosModules` keys: kebab-case matching the filename (e.g. `desktop-i3`, `lovelace-hardware`)
- Identifiers: `camelCase` for let bindings and function args
- NixOS options: follow upstream conventions (dot-separated, camelCase)

## Helper Functions

### `self.lib.mkHost` — Creates NixOS host with Home Manager
```nix
self.lib.mkHost {
  hostname = "lovelace";
  system = "x86_64-linux";
  cpuCoreCount = 28;
  modules = [
    self.nixosModules.packages
    self.nixosModules.settings
    self.nixosModules.users
    self.nixosModules.agenix
    self.nixosModules."lovelace-hardware"
    { networking.hostName = "lovelace"; }
  ];
  wallpaperPath = ../home/okt/solar.png;  # optional; defaults to solar.png
}
```
Automatically adds `home-manager` and `nix-index-database` modules to every host.

### `self.lib.mkHome` — Standalone Home Manager config
```nix
self.lib.mkHome {
  username = "okt";
  homeDirectory = "/home/okt";
  system = "x86_64-linux";
}
```

## Module Reference

### `modules/common/` — included in every host's module list
| File | `nixosModules` key | Purpose |
|------|-------------------|---------|
| `packages.nix` | `packages` | Shared CLI tools: fish, neovim, git, lazygit, ripgrep, fd, eza, fzf, bat, tmux, zoxide, opencode, nixfmt, etc. |
| `settings.nix` | `settings` | Timezone, locale, networkmanager, nix flakes, nix-ld, `stateVersion = "24.05"` |
| `users.nix` | `users` | Creates user `okt` with fish shell, wheel and dialout groups |
| `agenix.nix` | `agenix` | agenix secret management for SSH keys |

### `modules/features/` — opt-in per host
| File | `nixosModules` key | Purpose | Used by |
|------|-------------------|---------|---------|
| `nvidia.nix` | `nvidia` | NVIDIA driver + modesetting | lovelace, hopper |
| `desktop.nix` | `desktop` | Common desktop: ly DM, pipewire, udisks2, flameshot, rofi, kitty, nemo, pavucontrol | lovelace, hopper, wilson, hedy |
| `desktop-i3.nix` | `desktop-i3` | X11 + i3 window manager with US/Danish keyboard layout | lovelace, hopper, wilson, hedy |
| `desktop-hyprland.nix` | `desktop-hyprland` | Wayland + Hyprland window manager | (optional alternative to i3) |
| `bluetooth.nix` | `bluetooth` | Bluetooth + blueman applet | lovelace |
| `steam.nix` | `steam` | Steam with firewall rules | lovelace |
| `secureboot.nix` | `secureboot` | Secure boot via lanzaboote | lovelace |
| `encryption.nix` | `encryption` | Placeholder — LUKS config lives in hardware module | wilson |
| `stlink.nix` | `stlink` | Udev rules for STMicroelectronics USB devices | lovelace, wilson |
| `vm-guest.nix` | `vm-guest` | VirtualBox guest additions | (unused — hedy uses native QEMU support) |

## Structural Conventions

### Adding a New Host
1. Create `modules/hosts/<hostname>/default.nix` as a FP module declaring `flake.nixosConfigurations.<hostname>`
2. Create `modules/hosts/<hostname>/hardware-configuration.nix` as a FP module declaring `flake.nixosModules.<hostname>-hardware`
3. In `default.nix`, call `self.lib.mkHost` with the desired `self.nixosModules.*` entries
4. No changes to `flake.nix` needed — it auto-imports all files under `modules/`

### Adding a New NixOS Module
1. Create `modules/features/<name>.nix` (or `modules/common/<name>.nix`)
2. Wrap the NixOS config as: `_: { flake.nixosModules.<name> = { pkgs, ... }: { ... }; }`
3. Reference it from host modules as `self.nixosModules.<name>`
4. No changes to `flake.nix` needed

### Home Manager (`home/okt/`)
- `default.nix` — entry point; username, stateVersion, session vars, fonts
- `programs.nix` — fish, neovim, kitty, git, zoxide, direnv, fzf, starship, brave; imports `i3.nix`, `hyprland.nix`, and `rofi.nix`
- `services.nix` — picom, dunst, udiskie
- `i3.nix` — full i3 config (Dracula theme, vim keybindings, wallpaper via `wallpaperPath`)
- `hyprland.nix` — Hyprland window manager config (Dracula theme, vim keybindings, wallpaper via `wallpaperPath`)
- `rofi.nix` — rofi launcher with Dracula theme
- `ssh.nix` — SSH configuration with Cloudflare tunnel support
- `steam.nix` — Steam configuration with shader compilation threading based on CPU core count
- Never set `nixpkgs.config` in Home Manager modules when `useGlobalPkgs = true`

### Configuration Placement
- Set `allowUnfree` in the anonymous host-specific module inside `modules/hosts/<hostname>/default.nix`
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
| **`flake.lib` defined multiple times** | Two FP modules both set `flake.lib`; merge them into one file |

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
