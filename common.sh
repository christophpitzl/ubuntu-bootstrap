#!/usr/bin/env bash
set -euo pipefail

log() {
  local message="$1"
  echo "[ubuntu-bootstrap] $message"
  printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$message" >> "$HOME/.ubuntu-bootstrap.log"
}

error() {
  local message="$1"
  echo "[ubuntu-bootstrap] ERROR: $message" >&2
  log "ERROR: $message"
  exit 1
}

network_available() {
  if command -v ping >/dev/null 2>&1; then
    ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1
    return $?
  fi
  return 1
}

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    error "Required command not found: $cmd"
  fi
}

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

apt_install() {
  local pkg="$1"
  run_as_root apt-get update -qq
  run_as_root DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg"
}
