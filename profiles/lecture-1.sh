#!/usr/bin/env bash

PROFILE_NAME="Lecture 1: Intro to Linux"
PROFILE_DESCRIPTION="Install basic command-line tools and classroom utilities."

profile_install() {
  log "Installing profile: $PROFILE_NAME"
  require_command sudo
  run_as_root apt-get update -qq
  run_as_root DEBIAN_FRONTEND=noninteractive apt-get install -y git curl vim htop tree
  log "Lecture 1 packages installed"
  echo "Installed packages: git, curl, vim, htop, tree"
}
