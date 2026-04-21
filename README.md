# Ubuntu Bootstrap

This repository prepares a USB-delivered Ubuntu VM for lectures and development use.
It contains the bootstrap launcher, profile scripts, and setup automation for a standard student account.

## Quick start

1. Copy `first-login-setup.sh` into the student VM home directory.
2. Run it once from the student user's account:

```bash
~/first-login-setup.sh
```

3. Log out and log back in.
4. The setup helper will install itself into autostart, fetch the bootstrap repo, install required tools, and configure the bootstrap launcher.

## First-login auto-fetch installer

The VM fetches the bootstrap repo automatically on login using `first-login-setup.sh`. It will reappear after reboot until the student either dismisses it or installs one of the bootstrap profiles.

## What the installer does

- installs `zenity` and `git`
- clones the repository into `~/ubuntu-bootstrap` if needed
- makes `bootstrap.sh` and `profiles/*.sh` executable
- creates the autostart entry at `~/.config/autostart/ubuntu-bootstrap.desktop`

## Repo contents

- `bootstrap.sh` — main launcher and profile selector
- `common.sh` — shared helper functions and network checks
- `profiles/` — lecture profile wrappers
- `docs/how-to-build-vm.md` — VM preparation instructions
- `first-login-setup.sh` — first-login auto-fetch setup helper

> Note: detailed lecture installation scripts are not kept in this bootstrap repo. Lecture repositories should publish their own `scripts/setup.sh` and the bootstrap profiles can link to those external scripts.
