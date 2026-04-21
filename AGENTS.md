# Agent notes

This file contains repository-level notes for automation agents, maintainers, and tooling.

## Purpose

- Use minimal Ubuntu base images for student VMs.
- Install required tools and packages through scripted automation.
- Keep the VM bootstrap process reproducible with shell scripts and git sources.

## Workflow

1. Start from a blank Ubuntu desktop image.
2. Copy the repository into the student VM.
3. Run `bash ~/install-vm.sh` from the standard student account.
4. Reboot or relogin so the bootstrap launcher starts automatically.
5. Select the lecture/use-case profile and let the installer fetch packages from the network.

## Design concept

- Deliver the initial VM image locally via USB/disk so students boot a prepared Ubuntu VM.
- Use a standard non-root student account for safety and consistency.
- Launch the bootstrap logic on login to keep the VM image minimal and install only needed components.
- The repository is the single source of truth for bootstrap logic, profiles, and setup steps.

## Implementation status

- `bootstrap.sh` — main launcher and profile selector.
- `common.sh` — shared helper functions and network checks.
- `profiles/` — example lecture and developer setup profiles.
- `docs/how-to-build-vm.md` — VM preparation instructions.
- `install-vm.sh` — automated setup script for the student VM.

## Notes for agents

- Prefer the automated setup script over manual VM configuration whenever possible.
- Keep documentation in `README.md` user-focused and `AGENTS.md` agent/implementation-focused.
