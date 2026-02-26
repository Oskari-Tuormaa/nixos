# Greene WSL2 Setup Guide

This guide walks you through setting up Greene as a WSL2-based NixOS instance for learning, testing, and development work.

## Prerequisites

Before starting, ensure you have:

1. **Windows 11** (Windows 10 can also work but Windows 11 is recommended)
2. **WSL2 installed** and set as default:
   ```powershell
   wsl --install
   wsl --set-default-version 2
   wsl --update
   ```
   Verify with: `wsl -l -v` (should show default as 2)

3. **Hyper-V enabled** (usually enabled with WSL2)

4. **Downloaded NixOS-WSL tarball** from [releases](https://github.com/nix-community/NixOS-WSL/releases/latest)
   - Download `nixos-wsl.tar.gz` (not the installer, the `.tar.gz`)
   - Save it somewhere accessible, e.g., `C:\Users\<username>\Downloads\`

## Installation Steps

### Step 1: Create WSL Installation Directory

Open **PowerShell as Administrator** and run:

```powershell
# Create directory for NixOS installation
mkdir C:\Users\<username>\NixOS
cd C:\Users\<username>\NixOS

# Verify path exists
ls
```

Replace `<username>` with your actual Windows username.

### Step 2: Import NixOS-WSL Distribution

Still in PowerShell as Admin:

```powershell
# Import the WSL distribution
# Adjust path if you saved nixos-wsl.tar.gz elsewhere
wsl --import greene . C:\Users\<username>\Downloads\nixos-wsl.tar.gz --version 2

# Verify it was imported
wsl -l -v
# Should show something like:
# NAME      STATE           VERSION
# greene    Stopped         2
```

### Step 3: Boot Greene and Update

```powershell
# Launch Greene
wsl -d greene

# You're now inside Greene (as root)
# Update system
sudo nixos-rebuild switch

# Set up git (recommended)
nix-shell -p git
```

### Step 4: Clone Your NixOS Repository

Inside Greene (still in the WSL terminal):

```bash
# Navigate to home directory
cd /home

# Clone your repository from Windows file system
git clone /mnt/c/Users/<username>/path/to/your/nixos /home/okt/nixos

# Or if repository is on Windows, copy it
cp -r /mnt/c/Users/<username>/path/to/your/nixos /home/okt/nixos

cd /home/okt/nixos
```

### Step 5: Generate Hardware Configuration for WSL

Inside Greene:

```bash
# Generate hardware configuration for WSL environment
sudo nixos-generate-config --root /

# Output is quite long, save it to a temp file
sudo nixos-generate-config --root / > /tmp/hw.nix

# Copy the generated hardware config
sudo cp /tmp/hw.nix /home/okt/nixos/hosts/greene/hardware-configuration.nix

# Fix permissions so okt can edit it
sudo chown okt:okt /home/okt/nixos/hosts/greene/hardware-configuration.nix
```

### Step 6: Deploy Your NixOS Configuration

Inside Greene:

```bash
cd /home/okt/nixos

# Review what will change (optional but recommended)
sudo nixos-rebuild dry-run --flake .#greene

# Deploy!
sudo nixos-rebuild switch --flake .#greene

# This will build and activate your configuration
# This may take a while on first build (5-15 minutes depending on your system)
```

### Step 7: Verify Setup

After successful deployment:

```bash
# Test your shell
fish --version

# Test your editor
nvim --version

# Test git
git --version

# Test other tools
lazygit --version
ripgrep --version
exa --version
zoxide --version

# Check you're on the right hostname
hostname
# Should output: greene

# Check your user
whoami
# Should output: okt
```

## Accessing Greene

### From PowerShell

```powershell
# Open Greene in PowerShell
wsl -d greene

# Or with a specific user
wsl -d greene --user okt

# Run a single command in Greene
wsl -d greene fish --version
```

### From Windows Terminal

1. Open Windows Terminal
2. Click the dropdown arrow next to the `+` button
3. Select **greene** from the list

### From VS Code

If you have VS Code installed:

1. Install the "Remote - WSL" extension
2. Click the green icon in bottom left
3. Select "Connect to WSL"
4. Choose "greene"

You can now edit files in your repository directly from VS Code, with full Nix/NixOS support.

## File Access

### Accessing Windows Files from Greene

Windows files are available at `/mnt/c/`:

```bash
# Your Windows user home
ls /mnt/c/Users/<username>

# Your Downloads folder
ls /mnt/c/Users/<username>/Downloads

# Your Desktop
ls /mnt/c/Users/<username>/Desktop
```

### Accessing Greene Files from Windows

Greene's filesystem is stored at:
```
C:\Users\<username>\AppData\Local\Packages\Microsoft.VCLibs.140.00_8wekyb3d8bbwe\LocalState\ext4.vhdx
```

Or more easily, open an explorer from Greene:

```bash
# From inside Greene
explorer.exe .
# This opens Windows Explorer showing the current Greene directory
```

## Managing Greene

### Shutdown Greene

```powershell
wsl --shutdown greene
```

Or just close the terminal. Greene will shut down automatically after a timeout.

### List all WSL Distributions

```powershell
wsl -l -v
```

### Backup Greene

Create a tarball backup of your Greene instance:

```powershell
wsl --export greene C:\Users\<username>\NixOS\greene-backup.tar
```

This can be useful before major experiments.

### Restore from Backup

```powershell
# If your current Greene is corrupted
wsl --unregister greene

# Import the backup
wsl --import greene C:\Users\<username>\NixOS\ C:\Users\<username>\NixOS\greene-backup.tar --version 2
```

### Delete Greene (WARNING)

This is destructive and cannot be undone:

```powershell
wsl --unregister greene

# Remove the directory
rmdir /s C:\Users\<username>\NixOS\
```

## Common Tasks

### Building Something with Nix

```bash
cd /home/okt/nixos

# Build your entire configuration (what `nixos-rebuild switch` does)
nix build .#nixosConfigurations.greene.config.system.build.toplevel

# Build just home-manager
nix build .#homeConfigurations.okt@greene

# Build a specific package from nixpkgs
nix build nixpkgs#hello

# Create a development shell with specific tools
nix flake new -t github:nix-community/nix-direnv .
direnv allow
```

### Updating Your Configuration

Edit your config files, then:

```bash
cd /home/okt/nixos

# Review changes
sudo nixos-rebuild dry-run --flake .#greene

# Apply changes
sudo nixos-rebuild switch --flake .#greene
```

### Viewing System Generation History

```bash
# List all previous generations
nixos-rebuild list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Rollback to a specific generation
sudo nixos-rebuild switch --profile /nix/var/nix/profiles/system --switch-generation 42
```

### Testing Changes Before Production

The main workflow:

1. Make changes to your flake in Greene
2. Test with: `sudo nixos-rebuild switch --flake .#greene`
3. Once happy, copy changes to other machines
4. Deploy to production machines the same way

## Troubleshooting

### "wsl.nativeSystemd no longer has any effect" Error

If you see an error about `wsl.nativeSystemd` being deprecated:

```
error: The option definition 'wsl.nativeSystemd' in ... no longer has any effect.
Native systemd is now always enabled...
```

This means your nixos-wsl version has been updated and this option is no longer needed. The repository has been updated to fix this—just pull the latest changes:

```bash
cd /home/okt/nixos
git pull origin main  # or your branch
sudo nixos-rebuild switch --flake .#greene
```

If you're managing the configuration yourself, simply remove the `wsl.nativeSystemd = true;` line from `hosts/greene/default.nix`. Native systemd is now always enabled by default.

### Greene Won't Boot

If you see errors when booting:

```powershell
# Check WSL version
wsl -l -v
# Should show greene with VERSION 2

# Shut down and try again
wsl --shutdown
wsl -d greene

# If still broken, check Windows Event Viewer or try:
wsl -d greene --exec /nix/var/nix/profiles/system/activate
```

### Permission Denied Errors

If you get "Permission denied" errors:

```bash
# Ensure okt user owns the files
sudo chown -R okt:okt /home/okt/nixos

# Or run commands with sudo
sudo nixos-rebuild switch --flake .#greene
```

### Very Slow Builds

Builds in WSL2 may be slower than native, but if extremely slow:

1. Check if you have enough disk space: `df -h`
2. Check memory usage: `free -h`
3. Check CPU usage: `top`

If disk is full, you may need to clean Nix:
```bash
nix-collect-garbage
nix-collect-garbage -d
```

### Can't Access Windows Files

If `/mnt/c` doesn't work:

```bash
# Check mount points
mount | grep -i mnt

# Manually mount Windows drive
mkdir -p /mnt/c
mount -t drvfs C: /mnt/c
```

This usually happens after upgrading WSL. A restart usually fixes it:

```powershell
wsl --shutdown
wsl -d greene
```

### Home Manager Complains About Missing Options

If you see warnings about missing home-manager options, your flake.lock might need updating:

```bash
cd /home/okt/nixos
nix flake update
sudo nixos-rebuild switch --flake .#greene
```

## Next Steps

Once Greene is set up and working:

1. **Learn NixOS** by exploring configuration options and making changes
2. **Test your flake** for all your machines before deploying
3. **Experiment fearlessly** - it's a sandbox! You can always rollback or recreate
4. **Build projects** using `nix develop` and `nix build` with your own flake.nix
5. **Deploy to production** once you're confident in your configuration

## Resources

- [NixOS-WSL GitHub](https://github.com/nix-community/NixOS-WSL)
- [NixOS Manual](https://nixos.org/manual/nixos/unstable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes Documentation](https://wiki.nixos.org/wiki/Flakes)

## Tips

- **Use direnv**: Add a `.envrc` to your project to auto-load development environments
- **Use tmux/screen**: Keep sessions alive across disconnects
- **Backup before experiments**: `wsl --export greene ...` before trying major changes
- **Use VS Code**: Much better experience than editing in terminal
- **Read the logs**: When something fails, check the full output - Nix error messages are usually helpful
