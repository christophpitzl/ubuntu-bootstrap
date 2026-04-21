#!/usr/bin/env bash
set -euo pipefail

# first-login-setup.sh
# Copy this file into the student VM and add it to the user's autostart.
# On login it will fetch the bootstrap repository, install required tools,
# make the bootstrap files executable, and configure the bootstrap launcher.
# The script will reappear after reboot until the student dismisses it or
# installs a bootstrap profile.

REPO_URL="https://github.com/christophpitzl/ubuntu-bootstrap.git"
DEST_DIR="${HOME}/ubuntu-bootstrap"
AUTOSTART_DIR="${HOME}/.config/autostart"
FIRST_AUTO="${AUTOSTART_DIR}/first-login-setup.desktop"
BOOTSTRAP_AUTO="${AUTOSTART_DIR}/ubuntu-bootstrap.desktop"
BOOTSTRAP_STATE="${HOME}/.ubuntu-bootstrap-state"
SETUP_STATE="${HOME}/.first-login-setup-state"
EXEC_PATH="${DEST_DIR}/bootstrap.sh"
CURRENT_SCRIPT="$(readlink -f "$0")"

log() {
  printf "[first-login-setup] %s\n" "$1"
}

error() {
  printf "[first-login-setup] ERROR: %s\n" "$1" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

create_autostart() {
  mkdir -p "$AUTOSTART_DIR"
  cat > "$FIRST_AUTO" <<EOF
[Desktop Entry]
Type=Application
Name=Ubuntu First Login Setup
Exec=$CURRENT_SCRIPT
Terminal=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
EOF
}

remove_autostart() {
  rm -f "$FIRST_AUTO" || true
}

state_dismissed() {
  [ -f "$SETUP_STATE" ] && grep -q '^dismissed=true$' "$SETUP_STATE"
}

state_profile_installed() {
  [ -f "$BOOTSTRAP_STATE" ]
}

prompt_action() {
  if command_exists zenity; then
    zenity --list --radiolist --title="Ubuntu Bootstrap Setup" --text="Choose how to continue.\n\nThe bootstrap installer will run now, or you can dismiss this prompt and continue later." \
      --column="" --column="Action" FALSE "Run bootstrap now" FALSE "Don't show again" 2>/dev/null
  else
    cat <<EOF
Choose an action:
  1) Run bootstrap now
  2) Don't show again
EOF
    read -r choice
    case "$choice" in
      1) echo "Run bootstrap now" ;;
      2) echo "Don't show again" ;;
      *) echo "Run bootstrap now" ;;
    esac
  fi
}

ensure_packages() {
  log "Installing required packages..."
  sudo apt-get update -qq
  sudo apt-get install -y git zenity
}

install_bootstrap_repo() {
  if [ -d "${DEST_DIR}/.git" ]; then
    log "Bootstrap repository already exists, updating..."
    git -C "$DEST_DIR" pull --ff-only || true
  else
    log "Cloning bootstrap repository into ${DEST_DIR}..."
    git clone "$REPO_URL" "$DEST_DIR"
  fi
}

make_bootstrap_executable() {
  log "Making bootstrap files executable..."
  chmod +x "$DEST_DIR/bootstrap.sh"
  chmod +x "$DEST_DIR/profiles"/*.sh
}

create_bootstrap_autostart() {
  mkdir -p "$AUTOSTART_DIR"
  cat > "$BOOTSTRAP_AUTO" <<EOF
[Desktop Entry]
Type=Application
Name=Ubuntu Bootstrap
Exec=$EXEC_PATH
Terminal=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
EOF
}

if [[ "${USER:-}" == "root" ]]; then
  error "Run this script as the student user, not as root."
fi

if state_dismissed || state_profile_installed; then
  remove_autostart
  exit 0
fi

create_autostart
ensure_packages

log "Preparing bootstrap repo..."
install_bootstrap_repo
make_bootstrap_executable

action="$(prompt_action)"

case "$action" in
  "Run bootstrap now")
    create_bootstrap_autostart
    log "Launching bootstrap launcher..."
    bash "$EXEC_PATH"
    if state_profile_installed; then
      log "Profile installed. Removing first-login setup autostart."
      remove_autostart
    fi
    ;;
  "Don't show again")
    log "Dismissed first-login setup. It will not run again."
    mkdir -p "$(dirname "$SETUP_STATE")"
    printf 'dismissed=true\n' > "$SETUP_STATE"
    remove_autostart
    ;;
  *)
    log "No valid action chosen. This setup will run again on next login."
    ;;
 esac
