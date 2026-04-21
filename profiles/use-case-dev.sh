#!/usr/bin/env bash

PROFILE_NAME="Use Case: Developer Setup"
PROFILE_DESCRIPTION="Install development tools for Python and Git-based workflows."

profile_install() {
  log "Installing profile: $PROFILE_NAME"
  require_command sudo
  run_as_root apt-get update -qq
  run_as_root DEBIAN_FRONTEND=noninteractive apt-get install -y git python3 python3-venv python3-pip build-essential
  log "Developer toolchain installed"
  echo "Installed packages: git, python3, python3-venv, python3-pip, build-essential"
}
