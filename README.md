# NixOS Configuration

A flakes-based NixOS configuration managing 6 machines with shared modules, feature flags, and per-host customization.

## Hosts

| Host | Role | CPU | GPU | Desktop | Modules |
|------|------|-----|-----|---------|---------|
| **lovelace** | Personal desktop | 28 cores | NVIDIA | X11 + i3 | nvidia, desktop, i3, bluetooth, steam, stlink |
| **hopper** | Personal laptop | 8 cores | Integrated | X11 + i3 | desktop, i3 (200 DPI) |
| **wilson** | Work laptop | 8 cores | Integrated | X11 + i3 | encryption, desktop, i3, stlink |
| **perlman** | Home server | 8 cores | — | Headless | — |
| **greene** | WSL2 sandbox | 8 cores | — | Headless | nixos-wsl (testing only) |
| **hedy** | QEMU/KVM VM | 8 cores | Virtio | X11 + i3 | desktop, i3, SPICE agent |

All machines share user `okt` with: fish, neovim, git, lazygit, ripgrep, fd, eza, zoxide, fzf, bat, tmux, nixfmt, opencode.

## Repository Structure

```
flake.nix                    # Entry point; defines all 6 nixosConfigurations
lib/
  mkHost.nix                 # NixOS host + Home Manager builder
  mkHome.nix                 # Standalone Home Manager builder
modules/
  common/                    # Always imported by every host (agenix, packages, settings, users)
  features/                  # Opt-in per-host: nvidia, desktop, desktop-i3, desktop-hyprland,
                             #                   bluetooth, steam, stlink, encryption, vm-guest
  services/                  # Reserved for future services
hosts/
  lovelace/, hopper/, wilson/, perlman/, greene/, hedy/  # Per-host config + hardware
home/okt/                    # Shared Home Manager config (programs, ssh, i3, hyprland, rofi,
                             #                             services, steam, secrets)
secrets/
  secrets.nix                # Define which SSH keys decrypt each secret
  *.age, *.pub               # Encrypted SSH keys + public keys
```

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | nixos-unstable (rolling release) |
| `home-manager` | Declarative user environment |
| `agenix` | Encrypted SSH secrets (age encryption) |
| `nixos-wsl` | WSL2 integration (greene) |
| `nix-index-database` | Pre-built `nix-locate` database |

## Quick Start

### Deploy to a host

```bash
nixfmt .                                      # format (required before committing)
nix flake check                               # validate flake
sudo nixos-rebuild switch --flake .#<hostname>
```

### Test safely first (greene sandbox)

```bash
# Always test in greene before deploying to production
nix flake check
sudo nixos-rebuild dry-run --flake .#greene
sudo nixos-rebuild switch --flake .#greene
```

### Rollback if needed

```bash
sudo nixos-rebuild switch --rollback
```

### Update dependencies

```bash
nix flake update && git add flake.lock
```

## Home Manager

Shared across all 6 hosts. Configuration in `home/okt/`:

| File | Purpose |
|------|---------|
| `programs.nix` | fish, neovim, kitty, git, zoxide, direnv, fzf, starship, brave, opencode |
| `services.nix` | picom (X11), dunst, udiskie, redshift |
| `i3.nix` | i3 config — Dracula theme, vim keybindings (hjkl), workspaces |
| `hyprland.nix` | Hyprland config — Wayland alternative to i3 (WIP) |
| `rofi.nix` | Application launcher — Dracula theme, icons, history |
| `ssh.nix` | SSH config — GitHub, Azure, Cloudflare tunnel, 3 SSH keys |
| `steam.nix` | Steam shader compilation threading (CPU core-aware) |
| `secrets.nix` | Symlink decrypted agenix SSH keys to ~/.ssh |

**Customization:**
- Default wallpaper: `home/okt/solar.png` (override per-host via `wallpaperPath`)
- Theme: Dracula (dark colors, consistent across all programs)
- Keybindings: Vim-style (hjkl for navigation in i3/Hyprland)

## Secrets Management (Agenix)

SSH keys are encrypted with agenix and decrypted using host SSH keys. See `SECRETS.md` for details.

**Three SSH keys available:**
- `github-ssh-key` → GitHub (git operations)
- `mjolnerdev-ssh-key` → Azure/development
- `perlman-ssh-key` → Internal server

**Bootstrap:** Secrets are skipped on fresh installs (hostname `"nixos"`). After first boot, SSH host keys are generated and secrets become available.

## Troubleshooting

| Error | Fix |
|-------|-----|
| "path not tracked by git" | `git add <file>` before rebuilding |
| Evaluation / infinite recursion | Run `nix flake check` to diagnose |
| "no identity matched any of the recipients" | Agenix secret decryption failed — see SECRETS.md |
| Secrets not available | Check hostname != "nixos" (bootstrap detection) |
