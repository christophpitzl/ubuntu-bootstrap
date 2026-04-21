# How to build the USB-delivered Ubuntu VM

This repository provides the bootstrap logic that runs inside the student VM. The VM image itself should be prepared once and distributed via USB or local disk.

## Recommended VM contents

- A minimal Ubuntu desktop installation
- A standard non-root user account for students
- The repository files copied into a known location, for example `/home/student/ubuntu-bootstrap`
- `zenity` installed so the profile selector can run with a GUI
- `sudo` configured for the standard user

## Installation steps inside the VM

1. Install the required GUI dialog package:

```bash
sudo apt-get update
sudo apt-get install -y zenity
```

2. Clone or copy the repository into the student home directory:

```bash
cd /home/student
git clone https://github.com/<your-org>/ubuntu-bootstrap.git
```

3. Make the bootstrap files executable:

```bash
cd /home/student/ubuntu-bootstrap
chmod +x bootstrap.sh profiles/*.sh
```

4. Add an autostart entry for the student account:

```ini
[Desktop Entry]
Type=Application
Name=Ubuntu Bootstrap
Exec=/home/student/ubuntu-bootstrap/bootstrap.sh
Terminal=false
X-GNOME-Autostart-enabled=true
```

Save this file as `/home/student/.config/autostart/ubuntu-bootstrap.desktop`.

## Student flow

1. Boot the VM from USB/disk
2. Log in as the standard student user
3. The bootstrap launcher appears and asks for a lecture/use case
4. The selected profile installs required packages from the network

## Notes

- The student VM image is delivered locally via USB/disk.
- The bootstrap system uses the network only for package installation and script downloads.
- Add new profiles by creating files in `profiles/` with `PROFILE_NAME` and `profile_install()`.
