# Ubuntu 24.04 Dev Environment (WSL2-Friendly)

This repo bootstraps a development environment with `just`, `fish`, and `mise`.
Tool installs are pinned to major/minor version lines in `Justfile` for repeatable bootstraps.

## What Gets Installed

- Core packages: `build-essential`, `git`, `curl`, `wget`, `unzip`, `fzf`, `yq`, `jq`, `ripgrep`, `fd-find`
- Shell/runtime manager: `fish`, `mise`
- Languages/tools: `go`, `python`, `nodejs`, `terraform`, `terragrunt`, `kubectl`, `awscli`, `task`, `helm`, `kustomize`, `starship`
- Kubernetes extras: `krew`, `kubectl-ns`, `kubectl-ctx`, `node-shell`

## Quick Start (Inside an Existing Ubuntu WSL)

1. Install `just`.
```bash
sudo apt update
sudo apt install -y just
```

2. Run bootstrap from this repo.
```bash
just bootstrap "Full Name" "email@example.com"
```

3. Optional: install only managed tools.
```bash
just install_tools
```

4. Optional: run full OS package upgrade.
```bash
just apt_full_upgrade
```

## WSL Provisioning (Windows Host)

Use this section only if you want to create a fresh distro/profile.

### 1. Choose a Base Tar

Option A: Download Ubuntu 24.04 cloud image.

Run in `Windows PowerShell`:
```powershell
wsl --shutdown
```

Run in `Ubuntu/WSL shell` or any Linux shell:
```bash
wget https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64-root.tar.xz -O ubuntu-24.04.tar.xz
```

Option B: Export an existing distro.

Run in `Windows PowerShell`:
```powershell
wsl --export Ubuntu-24.04 existing-ubuntu-24.04.tar
```

### 2. Import as a New Distro

Run in `Windows PowerShell`:
```powershell
wsl --import dev-box C:\WSL\dev-box ubuntu-24.04.tar.xz
```

### 3. First Boot and User Setup

Run in `Windows PowerShell`:
```powershell
wsl -d dev-box -u root
```

Then run inside that Linux shell:
```bash
USERNAME=admin
PASSWORD=password

useradd -m -s /bin/bash -g admin "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG sudo "$USERNAME"

printf "[user]\ndefault=%s\n" "$USERNAME" > /etc/wsl.conf
exit
```

### 4. Re-open as the New User

Run in `Windows PowerShell`:
```powershell
wsl --terminate dev-box
wsl -d dev-box
```

Optional: set as default distro.
```powershell
wsl --set-default dev-box
```

### 5. Bootstrap This Repo

```powershell
wsl -d dev-box
```

Inside `dev-box`:

```bash
cd /mnt/c/Projects/dev-os
sudo apt update && sudo apt install -y just
just bootstrap "Full Name" "email@example.com"
```
