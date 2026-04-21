# Ubuntu Bootstrap

This repository prepares a USB-delivered Ubuntu VM for lectures and development use.
It contains the bootstrap launcher, profile scripts, and setup automation for a standard student account.

## Recommended VM contents

- A minimal Ubuntu desktop installation
- A standard non-root user account for students, named `student`
- Network access for initial repository fetch
- `sudo` configured for the standard user

## Quick start

1. Copy `first-login-setup.sh` into the student VM home directory `/home/student`.

2. Make it executable:

```bash
chmod +x /home/student/first-login-setup.sh
```

3. Run it once from the student user's account:

```bash
/home/student/first-login-setup.sh
```

4. Log out and log back in.

The setup helper will install itself into autostart, fetch the bootstrap repo, install required tools, and configure the bootstrap launcher. It will reappear after reboot until the student either dismisses it or installs one of the bootstrap profiles.

## What the installer does

- installs `zenity` and `git`
- clones the repository into `~/ubuntu-bootstrap` if needed
- makes `bootstrap.sh` and `profiles/*.sh` executable
- creates the autostart entry at `~/.config/autostart/ubuntu-bootstrap.desktop`

## Student flow

1. Boot the VM from USB/disk
2. Log in as the standard student user
3. The bootstrap launcher appears and asks for a lecture/use case
4. The selected profile installs required packages from the network

## Notes

- The student VM image is delivered locally via USB/disk.
- The bootstrap system uses the network only for package installation and script downloads.
- Add new profiles by creating files in `profiles/` with `PROFILE_NAME` and `profile_install()`.
- Detailed installation scripts for each lecture should live in the lecture repositories, for example as `scripts/setup.sh`, rather than in this bootstrap repo.

## Repo contents

- `bootstrap.sh` — main launcher and profile selector
- `common.sh` — shared helper functions and network checks
- `profiles/` — lecture profile wrappers
- `first-login-setup.sh` — first-login auto-fetch setup helper
