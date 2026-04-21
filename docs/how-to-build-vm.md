# How to build the USB-delivered Ubuntu VM

This repository provides the bootstrap logic that runs inside the student VM. The VM image itself should be prepared once and distributed via USB or local disk.

## Recommended VM contents

- A minimal Ubuntu desktop installation
- A standard non-root user account for students
- The repository files copied into a known location, for example `/home/student/ubuntu-bootstrap`
- `zenity` installed so the profile selector can run with a GUI
- `sudo` configured for the standard user

## Installation steps inside the VM

1. Copy the script into the student home directory `/home/student`

2. Make it executable:

```bash
chmod +x /home/student/first-login-setup.sh
```

3. Run it once:

```bash
/home/student/first-login-setup.sh
```

The script will create its own autostart entry in `~/.config/autostart/first-login-setup.desktop`.

4. Log out and log back in.

On next login, the helper will run and install the bootstrap repo.

The script performs the following setup:

- installs `zenity` and `git`
- clones the repository into `~/ubuntu-bootstrap` if needed
- makes `bootstrap.sh` and `profiles/*.sh` executable
- creates the autostart entry at `~/.config/autostart/ubuntu-bootstrap.desktop`

If you prefer to prepare the VM manually, use the same repository and autostart conventions described above.

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
