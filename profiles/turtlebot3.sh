#!/usr/bin/env bash

PROFILE_NAME="Lecture: TurtleBot3"
PROFILE_DESCRIPTION="Run the TurtleBot3 lecture repo's setup script."

profile_install() {
  log "Installing profile: $PROFILE_NAME"
  require_command curl
  require_command mktemp

  local script_url
  script_url="${LECTURE_SETUP_URL:-https://<your-org>.github.io/turtlebot3-lecture/scripts/setup.sh}"

  local tmp_script
  tmp_script="$(mktemp)"
  trap 'rm -f "$tmp_script"' EXIT

  log "Downloading lecture setup script from $script_url"
  curl -fsSL "$script_url" -o "$tmp_script"

  chmod +x "$tmp_script"
  run_as_root bash "$tmp_script"

  log "TurtleBot3 lecture setup script executed"
  echo "Executed lecture setup script from $script_url"
}
