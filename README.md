# NixOS Configuration

A flakes-based NixOS configuration managing 6 machines with shared modules and per-host customisation.

## Hosts

| Host | Role | Notes |
|------|------|-------|
| **lovelace** | Personal desktop | NVIDIA, i3, bluetooth, Steam |
| **hopper** | Personal laptop | NVIDIA, i3 — hardware config placeholder |
| **wilson** | Work laptop | LUKS encryption, i3, integrated GPU |
| **perlman** | Home server | Headless, SSH — hardware config placeholder |
| **greene** | WSL2 sandbox | Headless, for testing flake changes |
| **hedy** | QEMU/KVM VM | i3, virtio GPU, SPICE agent |

All machines share user `okt` with fish, neovim, git, lazygit, ripgrep, fd, eza, zoxide, fzf, bat, tmux, opencode, and nixfmt.

## Repository Structure

```
flake.nix                    # Entry point; defines all nixosConfigurations
lib/
  mkHost.nix                 # Builds a NixOS host + Home Manager
  mkHome.nix                 # Builds a standalone Home Manager config
modules/
  common/                    # Imported by every host (packages, settings, users)
  features/                  # Opt-in: nvidia, desktop, desktop-i3, desktop-hyprland, bluetooth, steam, encryption, stlink, vm-guest
  services/                  # Placeholder for future system services
hosts/
  lovelace/                  # Personal desktop
  hopper/                    # Personal laptop
  wilson/                    # Work laptop
  perlman/                   # Home server
  greene/                    # WSL2 test host
  hedy/                      # QEMU/KVM VM
home/okt/                    # Home Manager config (programs, i3, hyprland, rofi, ssh, steam, services)
```

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | nixos-unstable channel |
| `home-manager` | User environment management |
| `nixos-wsl` | WSL2 support (greene only) |
| `nix-index-database` | Pre-built `nix-locate` index |
| `disko` | Disk partitioning (declared but not yet used) |

## Quick Start

### Deploy to an existing host

```bash
nixfmt .                                      # format (required before committing)
nix flake check                               # validate
sudo nixos-rebuild switch --flake .#<hostname>
```

### Test changes safely (greene sandbox)

```bash
nix flake check
sudo nixos-rebuild dry-run --flake .#greene
sudo nixos-rebuild switch --flake .#greene
```

### Adding a new host

1. Create `hosts/<hostname>/default.nix` and `hardware-configuration.nix`
2. Import `../../modules/common` plus any feature modules
3. Set `networking.hostName = "<hostname>"`
4. Register in `flake.nix` via `lib.mkHost`
5. `git add` all new files before building

### Setting up greene (WSL2)

```powershell
# From PowerShell (Admin) — import NixOS-WSL tarball
wsl --import greene . C:\path\to\nixos-wsl.tar.gz --version 2
wsl -d greene
```

```bash
# Inside greene
sudo nixos-rebuild switch --flake .#greene
```

## Common Commands

| Task | Command |
|------|---------|
| Format | `nixfmt .` |
| Validate | `nix flake check` |
| Build (no switch) | `sudo nixos-rebuild build --flake .#<host>` |
| Deploy | `sudo nixos-rebuild switch --flake .#<host>` |
| Dry-run | `sudo nixos-rebuild dry-run --flake .#<host>` |
| Rollback | `sudo nixos-rebuild switch --rollback` |
| Update deps | `nix flake update && git add flake.lock` |

## Home Manager

Managed as a NixOS module via `mkHost`. Configuration lives in `home/okt/`:

| File | Purpose |
|------|---------|
| `default.nix` | Entry point; username, stateVersion, fonts, session vars |
| `programs.nix` | fish, neovim, kitty, git, zoxide, direnv, fzf, starship, brave; imports i3/hyprland configs |
| `services.nix` | picom, dunst, udiskie |
| `i3.nix` | Full i3 config — Dracula theme, vim keybindings, wallpaper |
| `hyprland.nix` | Hyprland config — Dracula theme, vim keybindings, wallpaper |
| `rofi.nix` | Rofi launcher — Dracula theme |
| `ssh.nix` | SSH configuration with Cloudflare tunnel support |
| `steam.nix` | Steam config with shader compilation threading |

The default wallpaper is `home/okt/solar.png`. Override per host:

```nix
lib.mkHost {
  hostname = "lovelace";
  system = "x86_64-linux";
  modules = [ ./hosts/lovelace ];
  wallpaperPath = ../home/okt/custom.png;  # optional
}
```

## Troubleshooting

| Error | Fix |
|-------|-----|
| "path not tracked by git" | `git add <file>` before rebuilding |
| Evaluation / infinite recursion | `nix flake check` to identify the problem |
| Wrong hardware config | Re-run `sudo nixos-generate-config` and copy to `hosts/<hostname>/` |
