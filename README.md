# Ubuntu Bootstrap

This repository prepares a USB-delivered Ubuntu VM for lectures and development use.
It contains the bootstrap launcher, profile scripts, and setup automation for a standard student account.

## Quick start

1. Copy the repository into the student VM.
2. Run the setup script from the standard student account:

```bash
bash ~/install-vm.sh
```

3. Reboot or log out and log back in.
4. The bootstrap launcher will start automatically and prompt for a profile.

## What the installer does

- installs `zenity` and `git`
- clones the repository into `~/ubuntu-bootstrap` if needed
- makes `bootstrap.sh` and `profiles/*.sh` executable
- creates the autostart entry at `~/.config/autostart/ubuntu-bootstrap.desktop`

## Manual setup alternative

If you prefer to set up the VM manually:

- install `zenity`
- clone the repo into `~/ubuntu-bootstrap`
- run `chmod +x bootstrap.sh profiles/*.sh`
- save an autostart desktop entry to `~/.config/autostart/ubuntu-bootstrap.desktop`

## Repo contents

- `bootstrap.sh` — main launcher and profile selector
- `common.sh` — shared helper functions and network checks
- `profiles/` — example lecture and developer setup profiles
- `docs/how-to-build-vm.md` — VM preparation instructions
- `install-vm.sh` — automated VM setup script

> Note: detailed lecture installation scripts are not kept in this bootstrap repo. Lecture repositories should publish their own `scripts/setup.sh` and the bootstrap profiles can link to those external scripts.
