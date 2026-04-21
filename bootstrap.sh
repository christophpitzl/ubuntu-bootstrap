#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

STATE_FILE="$HOME/.ubuntu-bootstrap-state"
LOG_FILE="$HOME/.ubuntu-bootstrap.log"
PROFILE_DIR="$SCRIPT_DIR/profiles"

log "=== ubuntu-bootstrap start ==="
log "Script directory: $SCRIPT_DIR"

if [ ! -d "$PROFILE_DIR" ]; then
  error "Profile directory not found: $PROFILE_DIR"
fi

load_profiles() {
  mapfile -t AVAILABLE_PROFILES < <(find "$PROFILE_DIR" -maxdepth 1 -type f -name '*.sh' | sort)
  if [ ${#AVAILABLE_PROFILES[@]} -eq 0 ]; then
    error "No profiles found in $PROFILE_DIR"
  fi
}

get_profile_metadata() {
  local file="$1"
  PROFILE_NAME="$(grep -m1 '^PROFILE_NAME=' "$file" | cut -d= -f2- | tr -d '"' || true)"
  PROFILE_DESCRIPTION="$(grep -m1 '^PROFILE_DESCRIPTION=' "$file" | cut -d= -f2- | tr -d '"' || true)"
  PROFILE_NAME="${PROFILE_NAME:-$(basename "$file" .sh)}"
  PROFILE_DESCRIPTION="${PROFILE_DESCRIPTION:-No description available.}"
}

show_profile_selector() {
  local dialog_text="Select the lecture or use case to install."
  if [ -f "$STATE_FILE" ]; then
    local current_profile="$(grep '^profile=' "$STATE_FILE" | cut -d= -f2- || true)"
    if [ -n "$current_profile" ]; then
      dialog_text="Current profile: $current_profile\nSelect a profile to install or reinstall."
    fi
  fi

  if command -v zenity >/dev/null 2>&1; then
    local choices=()
    for profile_file in "${AVAILABLE_PROFILES[@]}"; do
      get_profile_metadata "$profile_file"
      choices+=(FALSE "$PROFILE_NAME")
    done
    SELECTED_PROFILE="$(zenity --list --title="Ubuntu Bootstrap" --text="$dialog_text" --radiolist --column="" --column="Profile" "${choices[@]}")" || true
    if [ -z "$SELECTED_PROFILE" ]; then
      log "Profile selection cancelled"
      exit 0
    fi
  else
    echo -e "$dialog_text"
    local idx=1
    for profile_file in "${AVAILABLE_PROFILES[@]}"; do
      get_profile_metadata "$profile_file"
      echo "$idx) $PROFILE_NAME"
      ((idx++))
    done
    printf "Choose a profile [1-%s]: " ${#AVAILABLE_PROFILES[@]}
    local choice
    read -r choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#AVAILABLE_PROFILES[@]} ]; then
      error "Invalid selection"
    fi
    SELECTED_PROFILE="$(basename "${AVAILABLE_PROFILES[$choice-1]}" .sh)"
  fi
}

find_profile_file() {
  local name="$1"
  for profile_file in "${AVAILABLE_PROFILES[@]}"; do
    get_profile_metadata "$profile_file"
    if [ "$PROFILE_NAME" = "$name" ] || [ "$(basename "$profile_file" .sh)" = "$name" ]; then
      echo "$profile_file"
      return
    fi
  done
}

execute_profile() {
  local profile_file="$1"
  log "Executing profile $profile_file"
  source "$profile_file"
  if [ -z "${PROFILE_NAME:-}" ]; then
    error "Profile $profile_file does not define PROFILE_NAME"
  fi
  if ! declare -F profile_install >/dev/null; then
    error "Profile $profile_file does not define profile_install()"
  fi
  if ! network_available; then
    error "Network is required for bootstrap installation."
  fi
  profile_install
  printf 'profile=%s\ntimestamp=%s\n' "$PROFILE_NAME" "$(date -Iseconds)" > "$STATE_FILE"
  log "Profile '$PROFILE_NAME' installed successfully"
}

load_profiles
show_profile_selector
PROFILE_FILE="$(find_profile_file "$SELECTED_PROFILE")"
if [ -z "$PROFILE_FILE" ]; then
  error "Could not resolve profile: $SELECTED_PROFILE"
fi
log "Selected profile: $SELECTED_PROFILE"
execute_profile "$PROFILE_FILE"
log "=== ubuntu-bootstrap completed ==="

echo "Bootstrap complete. Installed profile: $SELECTED_PROFILE"
