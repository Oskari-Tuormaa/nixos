# Multi-Machine NixOS Configuration

A reproducible, flakes-based NixOS configuration for managing 5 machines with a shared user environment and machine-specific customizations.

## Overview

This repository contains NixOS configurations for:

- **lovelace** - Personal Desktop (NVIDIA GPU + Desktop Environment)
- **hopper** - Personal Laptop (NVIDIA GPU + Desktop Environment)
- **wilson** - Work Laptop (LUKS Encryption + Desktop Environment)
- **perlman** - Home Server (Headless T480 Laptop, SSH Access)
- **greene** - VM Test Host (VirtualBox VM with Desktop)

All machines share:
- User: `okt`
- Common packages: fish, neovim, kitty, brave, git, lazygit, ripgrep, fd, exa, zoxide
- Common settings and services
- Home Manager configuration

## Quick Start

### Prerequisites

- NixOS installed on your machines (fresh install is fine)
- Git installed
- Access to this repository

### Initial Setup on a New Machine

1. **Install NixOS normally** on the target machine
   - Use the standard NixOS installation process
   - When installing, you can use a minimal configuration

2. **Generate Hardware Configuration**
   ```bash
   sudo nixos-generate-config --root /mnt  # During installation
   # OR
   sudo nixos-generate-config  # On existing NixOS system
   ```
   Copy the generated `hardware-configuration.nix` to the appropriate host directory:
   ```bash
   sudo cp /etc/nixos/hardware-configuration.nix /path/to/nixos/hosts/<hostname>/
   ```

3. **Clone this repository** (if not already done)
   ```bash
   git clone <repository-url> /path/to/nixos
   cd /path/to/nixos
   ```

4. **Deploy the configuration**
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

### Deploying to Each Machine

Replace `<hostname>` with the target machine:

```bash
# Desktop
sudo nixos-rebuild switch --flake .#lovelace

# Personal Laptop
sudo nixos-rebuild switch --flake .#hopper

# Work Laptop (with LUKS encryption)
sudo nixos-rebuild switch --flake .#wilson

# Home Server
sudo nixos-rebuild switch --flake .#perlman

# VM Test Host
sudo nixos-rebuild switch --flake .#greene
```

## Repository Structure

```
.
├── flake.nix                 # Main flake definition
├── flake.lock               # Dependency versions (auto-updated)
├── lib/                     # Helper functions
│   ├── default.nix
│   ├── mkHost.nix          # NixOS configuration helper
│   └── mkHome.nix          # Home Manager configuration helper
├── modules/                 # Reusable configuration modules
│   ├── common/
│   │   ├── default.nix     # Common modules entry point
│   │   ├── packages.nix    # Shared packages
│   │   └── settings.nix    # Common system settings
│   ├── features/
│   │   ├── nvidia.nix      # NVIDIA GPU support (lovelace, hopper)
│   │   ├── desktop.nix     # X11, i3, picom (desktop machines)
│   │   ├── encryption.nix  # LUKS encryption (wilson)
│   │   └── vm-guest.nix    # VirtualBox guest additions (greene)
│   └── services/
│       └── default.nix     # Services (placeholder)
├── hosts/                   # Per-machine configurations
│   ├── lovelace/
│   ├── hopper/
│   ├── wilson/
│   ├── perlman/
│   └── greene/
├── home/                    # Home Manager configuration
│   └── okt/
│       ├── default.nix     # User config entry point
│       ├── programs.nix    # Program configurations
│       └── services.nix    # User services
└── README.md               # This file
```

## Machine Specifications

### lovelace (Desktop)
- **Features**: NVIDIA GPU, Desktop Environment (X11 + i3 + picom)
- **Default**: Full development environment
- **Modules**: `common`, `nvidia`, `desktop`

### hopper (Personal Laptop)
- **Features**: NVIDIA GPU, Desktop Environment (X11 + i3 + picom)
- **Default**: Portable development environment
- **Modules**: `common`, `nvidia`, `desktop`

### wilson (Work Laptop)
- **Features**: LUKS Encryption, Desktop Environment (X11 + i3 + picom), Integrated Graphics
- **Default**: Encrypted work machine
- **Modules**: `common`, `encryption`, `desktop`
- **Note**: Encryption is configured during NixOS installation (standard LUKS setup)

### perlman (Home Server)
- **Features**: Headless (no X11), SSH access, T480 laptop as server
- **Default**: Minimal footprint, remote access only
- **Modules**: `common`, `services` (SSH enabled by default)
- **Deploy**: 
  ```bash
  sudo nixos-rebuild switch --flake .#perlman
  ```

### greene (VM Test Host)
- **Features**: VirtualBox guest additions, Desktop Environment (X11 + i3 + picom)
- **Default**: Testing environment for configuration changes
- **Modules**: `common`, `desktop`, `vm-guest`
- **Usage**: Test changes here before deploying to production machines

## Common Tools

All machines come with these tools pre-installed:

- **Shell**: fish
- **Editor**: neovim
- **Terminal**: kitty
- **Browser**: brave
- **Git**: git, lazygit
- **CLI Tools**: ripgrep, fd, exa, zoxide, tmux, curl, wget

## Home Manager Configuration

Home Manager is integrated as a NixOS module, managed at the system level. The user `okt` configuration is in `home/okt/`.

### Customizing Programs

Edit `home/okt/programs.nix` to customize:
- Fish shell settings
- Neovim configuration
- Kitty terminal settings
- Git configuration (username, email)
- Directory navigation (zoxide)
- Environment loading (direnv)

### Adding User Services

Add services to `home/okt/services.nix` for user-level services like:
- SSH agent
- GPG agent
- Custom systemd user services

## Customizing Per-Machine

Each machine can have custom configuration in its `hosts/<hostname>/default.nix`:

```nix
# Example: adding machine-specific packages
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common
    # ... feature modules ...
  ];

  networking.hostName = "lovelace";

  # Machine-specific configuration
  environment.systemPackages = with pkgs; [
    # Add machine-specific packages here
  ];
}
```

## Adding LUKS Encryption (wilson)

Wilson (work laptop) supports LUKS encryption. During NixOS installation:

1. Partition your disks
2. Create LUKS volume:
   ```bash
   cryptsetup luksFormat /dev/sda2
   cryptsetup luksOpen /dev/sda2 enc-pv
   ```
3. Format and mount the encrypted partition
4. Install NixOS normally
5. Run `nixos-generate-config --root /mnt` to capture encryption settings

The hardware configuration will automatically include LUKS settings.

## Updating Dependencies

Update to the latest versions of inputs:

```bash
nix flake update
git add flake.lock
git commit -m "Update flake dependencies"
```

## Dry-Run / Testing Changes

Before applying changes to a system:

```bash
sudo nixos-rebuild dry-run --flake .#<hostname>
```

This will show you what will change without actually building.

## Rollback

If something goes wrong, rollback to the previous generation:

```bash
sudo nixos-rebuild switch --rollback
```

Or select a specific generation:

```bash
nix-env --list-generations  # List available generations
sudo nixos-rebuild switch --profile /nix/var/nix/profiles/system --switch-generation 42
```

## Future Enhancements

### Adding Secrets (agenix)

When you need to manage secrets (WiFi passwords, SSH keys, etc.), this repository can be extended with agenix:

1. Install agenix in flake inputs
2. Add `agenix.nixosModules.default` to modules
3. Create `secrets/secrets.nix` to define secrets
4. Encrypt secrets with your host public keys
5. Reference encrypted secrets in configuration

See [agenix documentation](https://github.com/ryantm/agenix) for details.

### Adding More Machines

To add a new machine:

1. Create `hosts/<new-hostname>/default.nix`
2. Create `hosts/<new-hostname>/hardware-configuration.nix` (empty initially)
3. Add to `flake.nix` outputs:
   ```nix
   <new-hostname> = mkHost "<new-hostname>" [
     ./hosts/<new-hostname>
   ];
   ```
4. Generate hardware config on the new machine
5. Deploy with `nixos-rebuild switch --flake .#<new-hostname>`

## Troubleshooting

### "Path in the repository is not tracked by Git"

Ensure all modified files are added to git:
```bash
git add .
git commit -m "Your message"
```

### Flake evaluation errors

Check for syntax errors:
```bash
nix flake check
```

### Hardware configuration issues

If hardware detection doesn't work correctly:
```bash
sudo nixos-generate-config --root /  # In running system
# Or
nixos-generate-config --root /mnt    # During installation
```

Then update the relevant `hardware-configuration.nix` file.

## Contributing

When making changes:

1. Test in greene (VM test host) first
2. Review changes with `nixos-rebuild dry-run`
3. Commit logical groups of changes
4. Push to your git remote

## References

- [NixOS Manual](https://nixos.org/manual/nixos/unstable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes Documentation](https://wiki.nixos.org/wiki/Flakes)
- [agenix - Secrets Management](https://github.com/ryantm/agenix)

## License

This configuration is provided as-is. Customize as needed for your setup.
