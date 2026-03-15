# Secrets Management with Agenix

This document explains how secrets are managed in this NixOS configuration using [agenix](https://github.com/ryantm/agenix).

## Overview

Agenix encrypts secrets at rest in git (`.age` files) and decrypts them during `nixos-rebuild` using SSH host keys. Each machine's SSH host key can decrypt secrets that were encrypted for it.

## Current Setup

### Secrets

- **`secrets/github-ssh-key.age`** — GitHub SSH private key (currently a test placeholder)
  - Accessible by: all 6 hosts + your personal machine (for editing)

### Location

- `secrets/secrets.nix` — Defines which SSH public keys can decrypt each secret
- `secrets/*.age` — Encrypted secret files (safe to commit to git)
- `modules/common/agenix.nix` — System-level agenix configuration
- `home/okt/secrets.nix` — Home Manager secrets symlink configuration

## How to Use

### 1. Adding a New Secret

First, add it to `secrets/secrets.nix`:

```nix
{
  "my-new-secret.age".publicKeys = [ lovelace hopper personal ];
  # Or use existing groups:
  "another-secret.age".publicKeys = allHosts ++ [ personal ];
}
```

Then create the secret from your development machine:

```bash
cd /home/okt/nixos/secrets
agenix -e my-new-secret.age
# Editor opens → type secret → save and exit
```

Commit the encrypted file:

```bash
git add secrets/my-new-secret.age secrets/secrets.nix
git commit -m "feat: add encrypted my-new-secret"
```

### 2. Editing an Existing Secret

```bash
cd /home/okt/nixos/secrets
agenix -e github-ssh-key.age
# Make changes → save and exit
git add secrets/github-ssh-key.age
git commit -m "chore: update github ssh key"
```

### 3. Deploying to a Machine

Once your secrets are defined and encrypted:

```bash
# Format, validate, build
nixfmt .
nix flake check

# Deploy to a machine with secrets
sudo nixos-rebuild switch --flake .#lovelace
```

During deployment, agenix:
1. Reads encrypted `.age` file from nix store
2. Uses host's `/etc/ssh/ssh_host_ed25519_key` to decrypt
3. Places plaintext at `/run/secrets/github-ssh-key` (permissions 600)
4. Home Manager symlinks it to `~/.ssh/id_github`

### 4. Accessing Secrets

In Nix configs, reference the path:

```nix
# System config:
environment.variables.MY_SECRET = config.age.secrets.my-secret.path;

# Home Manager:
home.file.".config/app".source = config.lib.file.mkOutOfStoreSymlink
  osConfig.age.secrets.my-secret.path;
```

At runtime on the deployed system:

```bash
# On lovelace after deployment:
cat ~/.ssh/id_github  # GitHub SSH key available here
```

## Bootstrap Process

### On Fresh NixOS Installs

Bootstrap detection uses hostname: fresh installs have hostname `"nixos"` by default.

When `config.networking.hostName == "nixos"`:
- Agenix module skips loading secrets
- First deploy succeeds without SSH keys

After first boot:
1. Hostname is set (e.g., to `"lovelace"`)
2. SSH host keys are generated at `/etc/ssh/ssh_host_*_key`
3. Collect the new key:
   ```bash
   cat /etc/ssh/ssh_host_ed25519_key.pub
   ```

4. Add to `secrets/secrets.nix` (replace placeholder)
5. Rekey existing secrets:
   ```bash
   cd secrets
   agenix -r *.age
   ```

6. Deploy again with secrets now accessible

### Existing Machines

If a machine already has SSH host keys (most of your 6 machines):

1. Collect its public key:
   ```bash
   ssh <hostname> cat /etc/ssh/ssh_host_ed25519_key.pub
   ```

2. Add to `secrets/secrets.nix`

3. Create/rekey secrets:
   ```bash
   agenix -e secrets/github-ssh-key.age
   agenix -r secrets/*.age
   ```

4. Deploy normally:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

## Current Status

### TODO: Complete Host Key Collection

The test placeholder keys in `secrets/secrets.nix` need to be replaced with actual keys from your machines. Run on each host:

```bash
# On lovelace
cat /etc/ssh/ssh_host_ed25519_key.pub
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...actual-key-here

# On hopper
cat /etc/ssh/ssh_host_ed25519_key.pub

# On wilson
cat /etc/ssh/ssh_host_ed25519_key.pub

# ... repeat for perlman, greene, hedy
```

Then update `secrets/secrets.nix` with the actual keys and run:

```bash
agenix -r secrets/*.age
```

### TODO: Add Your Personal SSH Key

Replace the placeholder personal key in `secrets/secrets.nix`:

```bash
# On your dev machine (if you have one)
cat ~/.ssh/id_ed25519.pub
# Or generate one if missing:
ssh-keygen -t ed25519 -C "your-email@example.com"
```

## Troubleshooting

### "Can't find identity to decrypt"

**Problem:** `nixos-rebuild` fails with identity error

**Causes:**
- Machine hostname is still `"nixos"` (bootstrap phase) — expected, run again after first boot
- Host SSH key doesn't match any public key in `secrets/secrets.nix`

**Fix:**
1. Verify host key matches:
   ```bash
   cat /etc/ssh/ssh_host_ed25519_key.pub
   ```
2. Check it's in `secrets/secrets.nix`
3. If not, add it and rekey:
   ```bash
   agenix -r secrets/*.age
   ```

### "Secret file not found in nix store"

**Problem:** Build fails saying `secrets/github-ssh-key.age` not found

**Cause:** Files aren't tracked in git

**Fix:**
```bash
git add secrets/
git status  # verify staged
```

### Decryption works locally but fails on machine

**Problem:** `agenix -e` works on dev machine but deploy fails

**Cause:** Machine's host SSH key not in the encrypted secret's recipients

**Fix:**
1. Add host's public key to `secrets/secrets.nix`
2. Rekey:
   ```bash
   agenix -r secrets/*.age
   ```
3. Commit and redeploy

## References

- [Agenix GitHub](https://github.com/ryantm/agenix)
- [Agenix NixOS Wiki](https://nixos.wiki/wiki/Agenix)
- [Age encryption tool](https://github.com/FiloSottile/age)
- [SSH keys explained](https://en.wikipedia.org/wiki/Public_key_infrastructure)
