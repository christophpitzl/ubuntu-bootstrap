#!/usr/bin/env bash
set -euo pipefail

# install-vm.sh
# Copy this script into the VM and run it from the student user's account.

REPO_URL="https://github.com/christophpitzl/ubuntu-bootstrap.git"
DEST_DIR="${HOME}/ubuntu-bootstrap"
AUTOSTART_DIR="${HOME}/.config/autostart"
AUTOSTART_FILE="${AUTOSTART_DIR}/ubuntu-bootstrap.desktop"
EXEC_PATH="${DEST_DIR}/bootstrap.sh"

info() {
  printf "[INFO] %s\n" "$1"
}

error() {
  printf "[ERROR] %s\n" "$1" >&2
  exit 1
}

if [[ "${USER:-}" == "root" ]]; then
  error "Do not run this script as root. Run it as the student user with sudo available."
fi

info "Installing required packages..."
sudo apt-get update
sudo apt-get install -y zenity git

if [[ -d "${DEST_DIR}" ]]; then
  info "Repository already exists at ${DEST_DIR}. Skipping clone."
else
  info "Cloning repository into ${DEST_DIR}..."
  git clone "${REPO_URL}" "${DEST_DIR}"
fi

info "Making bootstrap files executable..."
chmod +x "${DEST_DIR}/bootstrap.sh"
chmod +x "${DEST_DIR}/profiles"/*.sh

info "Creating autostart entry..."
mkdir -p "${AUTOSTART_DIR}"
cat > "${AUTOSTART_FILE}" <<EOF
[Desktop Entry]
Type=Application
Name=Ubuntu Bootstrap
Exec=${EXEC_PATH}
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

info "Installation complete."
info "Verify that ${AUTOSTART_FILE} exists and reboot the VM to test bootstrap startup."